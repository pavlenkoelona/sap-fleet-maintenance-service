"""Zero-dependency demo server for an OData-style maintenance API."""

from __future__ import annotations

import json
import re
import sqlite3
from contextlib import closing
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse

ROOT = Path(__file__).resolve().parent
DATABASE = ROOT / "fleet_maintenance.db"
SAFE_FIELDS = {
    "work_order_id", "vehicle_code", "vehicle_type", "depot", "fault_category",
    "fault_description", "safety_critical", "workshop_name", "opened_date",
    "planned_end_date", "actual_end_date", "status", "priority",
    "estimated_cost", "actual_cost", "is_late", "cost_variance",
}


def build_database(path: Path = DATABASE) -> None:
    path.unlink(missing_ok=True)
    with closing(sqlite3.connect(path)) as connection:
        for filename in ("01_schema.sql", "02_seed_data.sql", "03_analytics.sql"):
            connection.executescript((ROOT / "sql" / filename).read_text(encoding="utf-8"))


def query_work_orders(params: dict[str, list[str]], path: Path = DATABASE) -> list[dict]:
    selected = params.get("$select", ["*"])[0].split(",")
    if selected != ["*"] and any(field not in SAFE_FIELDS for field in selected):
        raise ValueError("Unsupported field in $select")
    columns = "*" if selected == ["*"] else ", ".join(selected)
    sql = f"SELECT {columns} FROM vw_work_order_monitor"
    values: list[object] = []

    filter_value = params.get("$filter", [""])[0]
    if filter_value:
        match = re.fullmatch(r"(status|priority|depot) eq '([^']+)'", filter_value)
        if not match:
            raise ValueError("Supported $filter fields: status, priority, depot")
        sql += f" WHERE {match.group(1)} = ?"
        values.append(match.group(2))

    order_value = params.get("$orderby", ["work_order_id asc"])[0]
    order_match = re.fullmatch(r"([a-z_]+)(?: (asc|desc))?", order_value, re.I)
    if not order_match or order_match.group(1) not in SAFE_FIELDS:
        raise ValueError("Unsupported $orderby")
    sql += f" ORDER BY {order_match.group(1)} {order_match.group(2) or 'asc'}"

    top = min(max(int(params.get("$top", ["100"])[0]), 1), 100)
    sql += " LIMIT ?"
    values.append(top)
    with closing(sqlite3.connect(path)) as connection:
        connection.row_factory = sqlite3.Row
        return [dict(row) for row in connection.execute(sql, values)]


def get_kpis(path: Path = DATABASE) -> dict:
    with closing(sqlite3.connect(path)) as connection:
        connection.row_factory = sqlite3.Row
        row = connection.execute("""
            SELECT COUNT(*) AS total_orders,
                   SUM(CASE WHEN status IN ('OPEN','IN_PROGRESS') THEN 1 ELSE 0 END) AS active_orders,
                   SUM(is_late) AS late_orders,
                   ROUND(SUM(COALESCE(actual_cost, estimated_cost)), 2) AS managed_cost
            FROM vw_work_order_monitor
        """).fetchone()
        return dict(row)


class Handler(SimpleHTTPRequestHandler):
    def translate_path(self, path: str) -> str:
        relative = urlparse(path).path.lstrip("/") or "index.html"
        return str(ROOT / "web" / relative)

    def do_GET(self) -> None:  # noqa: N802
        parsed = urlparse(self.path)
        try:
            if parsed.path == "/api/WorkOrders":
                self.send_json({"value": query_work_orders(parse_qs(parsed.query))})
            elif parsed.path == "/api/KPIs":
                self.send_json(get_kpis())
            else:
                super().do_GET()
        except (ValueError, sqlite3.Error) as error:
            self.send_json({"error": str(error)}, status=400)

    def send_json(self, payload: object, status: int = 200) -> None:
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    build_database()
    print("Fleet Maintenance Service: http://localhost:8000")
    ThreadingHTTPServer(("127.0.0.1", 8000), Handler).serve_forever()


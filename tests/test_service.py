import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from app import build_database, get_kpis, query_work_orders  # noqa: E402


class MaintenanceServiceTests(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.database = Path(self.temp_dir.name) / "test.db"
        build_database(self.database)

    def tearDown(self):
        self.temp_dir.cleanup()

    def test_database_contains_all_work_orders(self):
        self.assertEqual(get_kpis(self.database)["total_orders"], 12)

    def test_open_filter(self):
        rows = query_work_orders({"$filter": ["status eq 'OPEN'"]}, self.database)
        self.assertEqual(len(rows), 3)
        self.assertTrue(all(row["status"] == "OPEN" for row in rows))

    def test_select_and_top(self):
        rows = query_work_orders(
            {"$select": ["work_order_id,vehicle_code"], "$top": ["2"]},
            self.database,
        )
        self.assertEqual(len(rows), 2)
        self.assertEqual(set(rows[0]), {"work_order_id", "vehicle_code"})

    def test_rejects_unknown_select_field(self):
        with self.assertRaises(ValueError):
            query_work_orders({"$select": ["password"]}, self.database)


if __name__ == "__main__":
    unittest.main()


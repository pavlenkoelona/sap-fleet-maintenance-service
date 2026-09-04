-- Operational work-order view
CREATE VIEW vw_work_order_monitor AS
SELECT
    wo.work_order_id,
    v.vehicle_code,
    v.vehicle_type,
    v.depot,
    fc.fault_category,
    fc.fault_description,
    fc.safety_critical,
    w.workshop_name,
    wo.opened_date,
    wo.planned_end_date,
    wo.actual_end_date,
    wo.status,
    wo.priority,
    wo.estimated_cost,
    wo.actual_cost,
    CASE
        WHEN wo.status <> 'COMPLETED' AND wo.planned_end_date < date('now') THEN 1
        WHEN wo.actual_end_date > wo.planned_end_date THEN 1
        ELSE 0
    END AS is_late,
    CASE
        WHEN wo.actual_cost IS NULL THEN NULL
        ELSE ROUND(wo.actual_cost - wo.estimated_cost, 2)
    END AS cost_variance
FROM work_orders AS wo
JOIN vehicles AS v ON v.vehicle_id = wo.vehicle_id
JOIN workshops AS w ON w.workshop_id = wo.workshop_id
JOIN fault_catalog AS fc ON fc.fault_code = wo.fault_code;

-- Workshop performance
CREATE VIEW vw_workshop_performance AS
SELECT
    w.workshop_name,
    COUNT(wo.work_order_id) AS total_orders,
    SUM(CASE WHEN wo.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_orders,
    SUM(CASE WHEN wo.actual_end_date > wo.planned_end_date THEN 1 ELSE 0 END) AS late_completed_orders,
    ROUND(AVG(CASE WHEN wo.actual_cost IS NOT NULL THEN wo.actual_cost END), 2) AS average_actual_cost
FROM workshops AS w
LEFT JOIN work_orders AS wo ON wo.workshop_id = w.workshop_id
GROUP BY w.workshop_id, w.workshop_name;

-- Recurring faults by vehicle
CREATE VIEW vw_recurring_faults AS
SELECT
    v.vehicle_code,
    fc.fault_category,
    COUNT(*) AS occurrence_count,
    ROUND(SUM(COALESCE(wo.actual_cost, wo.estimated_cost)), 2) AS total_or_estimated_cost,
    RANK() OVER (
        PARTITION BY v.vehicle_code
        ORDER BY COUNT(*) DESC
    ) AS fault_rank
FROM work_orders AS wo
JOIN vehicles AS v ON v.vehicle_id = wo.vehicle_id
JOIN fault_catalog AS fc ON fc.fault_code = wo.fault_code
GROUP BY v.vehicle_code, fc.fault_category;

-- Data-quality control: completed tasks must have actual hours
CREATE VIEW vw_task_quality_issues AS
SELECT work_order_id, task_number, task_description, task_status, actual_hours
FROM maintenance_tasks
WHERE task_status = 'COMPLETED' AND actual_hours IS NULL;


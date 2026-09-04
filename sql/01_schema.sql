PRAGMA foreign_keys = ON;

CREATE TABLE vehicles (
    vehicle_id       INTEGER PRIMARY KEY,
    vehicle_code     VARCHAR(20) NOT NULL UNIQUE,
    vehicle_type     VARCHAR(30) NOT NULL,
    depot            VARCHAR(50) NOT NULL,
    commissioning_date DATE NOT NULL,
    odometer_km      INTEGER NOT NULL CHECK (odometer_km >= 0),
    operational_status VARCHAR(20) NOT NULL
);

CREATE TABLE workshops (
    workshop_id      INTEGER PRIMARY KEY,
    workshop_name    VARCHAR(100) NOT NULL,
    city             VARCHAR(50) NOT NULL,
    hourly_rate      DECIMAL(10, 2) NOT NULL CHECK (hourly_rate > 0)
);

CREATE TABLE fault_catalog (
    fault_code       VARCHAR(10) PRIMARY KEY,
    fault_category   VARCHAR(40) NOT NULL,
    fault_description VARCHAR(120) NOT NULL,
    safety_critical  INTEGER NOT NULL CHECK (safety_critical IN (0, 1))
);

CREATE TABLE work_orders (
    work_order_id    INTEGER PRIMARY KEY,
    vehicle_id       INTEGER NOT NULL,
    workshop_id      INTEGER NOT NULL,
    fault_code       VARCHAR(10) NOT NULL,
    opened_date      DATE NOT NULL,
    planned_end_date DATE NOT NULL,
    actual_end_date  DATE,
    status           VARCHAR(20) NOT NULL,
    priority         VARCHAR(10) NOT NULL,
    estimated_cost   DECIMAL(12, 2) NOT NULL,
    actual_cost      DECIMAL(12, 2),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (workshop_id) REFERENCES workshops(workshop_id),
    FOREIGN KEY (fault_code) REFERENCES fault_catalog(fault_code),
    CHECK (status IN ('OPEN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL'))
);

CREATE TABLE maintenance_tasks (
    work_order_id    INTEGER NOT NULL,
    task_number      INTEGER NOT NULL,
    task_description VARCHAR(150) NOT NULL,
    planned_hours    DECIMAL(8, 2) NOT NULL,
    actual_hours     DECIMAL(8, 2),
    task_status      VARCHAR(20) NOT NULL,
    PRIMARY KEY (work_order_id, task_number),
    FOREIGN KEY (work_order_id) REFERENCES work_orders(work_order_id)
);

CREATE INDEX idx_work_orders_status ON work_orders(status);
CREATE INDEX idx_work_orders_vehicle ON work_orders(vehicle_id);
CREATE INDEX idx_work_orders_dates ON work_orders(opened_date, planned_end_date);


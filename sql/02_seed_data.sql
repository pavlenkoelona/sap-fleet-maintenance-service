-- All organisations, vehicles and transactions are fictional.
INSERT INTO vehicles VALUES
 (1, 'BUS-1001', 'City Bus', 'Rheine',   '2020-03-12', 184200, 'MAINTENANCE'),
 (2, 'BUS-1002', 'City Bus', 'Rheine',   '2021-07-08', 142800, 'ACTIVE'),
 (3, 'BUS-1003', 'Electric Bus', 'Muenster', '2023-02-17', 68500, 'MAINTENANCE'),
 (4, 'TRAM-201', 'Tram', 'Muenster',     '2018-11-21', 310400, 'ACTIVE'),
 (5, 'VAN-301',  'Service Van', 'Essen', '2022-06-05', 97300, 'ACTIVE'),
 (6, 'BUS-1004', 'Electric Bus', 'Essen','2024-01-15', 42100, 'MAINTENANCE');

INSERT INTO workshops VALUES
 (10, 'Westfalen Mobility Workshop', 'Rheine', 92.00),
 (20, 'Muenster Transit Technik', 'Muenster', 105.00),
 (30, 'Ruhr Fleet Services', 'Essen', 98.50);

INSERT INTO fault_catalog VALUES
 ('BRK01', 'BRAKES',     'Brake pad wear above limit', 1),
 ('BAT02', 'ELECTRICAL', 'Traction battery imbalance', 1),
 ('DOR03', 'BODY',       'Passenger door sensor error', 1),
 ('HVAC1', 'CLIMATE',    'Passenger HVAC performance loss', 0),
 ('LGT04', 'ELECTRICAL', 'Exterior lighting malfunction', 1),
 ('SRV00', 'SERVICE',    'Scheduled preventive inspection', 0);

INSERT INTO work_orders VALUES
 (700001, 1, 10, 'BRK01', '2026-07-02', '2026-07-05', '2026-07-06', 'COMPLETED',   'CRITICAL', 1800.00, 1940.00),
 (700002, 2, 10, 'HVAC1', '2026-07-11', '2026-07-15', '2026-07-14', 'COMPLETED',   'MEDIUM',    950.00,  880.00),
 (700003, 3, 20, 'BAT02', '2026-07-19', '2026-07-23', '2026-07-27', 'COMPLETED',   'CRITICAL', 4200.00, 4750.00),
 (700004, 4, 20, 'SRV00', '2026-08-01', '2026-08-06', '2026-08-05', 'COMPLETED',   'LOW',      1300.00, 1280.00),
 (700005, 5, 30, 'LGT04', '2026-08-09', '2026-08-11', '2026-08-11', 'COMPLETED',   'HIGH',      620.00,  610.00),
 (700006, 1, 10, 'DOR03', '2026-08-20', '2026-08-23', NULL,         'IN_PROGRESS', 'HIGH',     1150.00, NULL),
 (700007, 3, 20, 'BAT02', '2026-08-25', '2026-08-30', NULL,         'IN_PROGRESS', 'CRITICAL', 3800.00, NULL),
 (700008, 6, 30, 'DOR03', '2026-08-28', '2026-09-02', NULL,         'OPEN',        'HIGH',      980.00, NULL),
 (700009, 2, 10, 'SRV00', '2026-09-01', '2026-09-07', NULL,         'OPEN',        'LOW',       750.00, NULL),
 (700010, 6, 30, 'BAT02', '2026-09-03', '2026-09-08', NULL,         'OPEN',        'CRITICAL', 4500.00, NULL),
 (700011, 4, 20, 'HVAC1', '2026-06-15', '2026-06-20', '2026-06-20', 'COMPLETED',  'MEDIUM',   1600.00, 1710.00),
 (700012, 5, 30, 'SRV00', '2026-06-24', '2026-06-28', '2026-06-27', 'COMPLETED',  'LOW',       680.00,  665.00);

INSERT INTO maintenance_tasks VALUES
 (700001, 10, 'Inspect braking system', 2.0, 2.5, 'COMPLETED'),
 (700001, 20, 'Replace brake pads', 4.0, 4.5, 'COMPLETED'),
 (700002, 10, 'Run HVAC diagnostics', 2.0, 1.5, 'COMPLETED'),
 (700002, 20, 'Replace cabin filter', 1.0, 1.0, 'COMPLETED'),
 (700003, 10, 'Analyse battery cells', 5.0, 6.0, 'COMPLETED'),
 (700003, 20, 'Balance battery modules', 8.0, 9.5, 'COMPLETED'),
 (700004, 10, 'Perform scheduled inspection', 8.0, 7.5, 'COMPLETED'),
 (700005, 10, 'Diagnose lighting circuit', 2.0, 2.0, 'COMPLETED'),
 (700006, 10, 'Test door control unit', 3.0, 3.5, 'COMPLETED'),
 (700006, 20, 'Replace door sensor', 2.0, NULL, 'IN_PROGRESS'),
 (700007, 10, 'Run high-voltage diagnostics', 6.0, 7.0, 'COMPLETED'),
 (700007, 20, 'Replace battery controller', 5.0, NULL, 'IN_PROGRESS'),
 (700008, 10, 'Inspect passenger door', 2.0, NULL, 'OPEN'),
 (700009, 10, 'Perform scheduled inspection', 6.0, NULL, 'OPEN'),
 (700010, 10, 'Analyse battery warning', 5.0, NULL, 'OPEN'),
 (700011, 10, 'Repair HVAC compressor', 7.0, 8.0, 'COMPLETED'),
 (700012, 10, 'Perform van inspection', 4.0, 3.5, 'COMPLETED');


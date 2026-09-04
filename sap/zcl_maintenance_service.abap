" Illustrative ABAP OO service class. Requires an SAP ABAP environment.
CLASS zcl_maintenance_service DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES tt_orders TYPE STANDARD TABLE OF zi_maintenanceorder
      WITH EMPTY KEY.
    METHODS get_open_orders
      IMPORTING iv_depot TYPE string OPTIONAL
      RETURNING VALUE(rt_orders) TYPE tt_orders.
ENDCLASS.

CLASS zcl_maintenance_service IMPLEMENTATION.
  METHOD get_open_orders.
    SELECT FROM zi_maintenanceorder
      FIELDS *
      WHERE Status IN ( 'OPEN', 'IN_PROGRESS' )
        AND ( @iv_depot IS INITIAL OR _Vehicle.depot = @iv_depot )
      ORDER BY PlannedEndDate ASCENDING
      INTO TABLE @rt_orders.
  ENDMETHOD.
ENDCLASS.


@EndUserText.label: 'Maintenance Order Interface View'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_MaintenanceOrder
  as select from zmaint_order as MaintenanceOrder
    association [1..1] to zvehicle as _Vehicle
      on $projection.VehicleId = _Vehicle.vehicle_id
    association [1..1] to zfault_catalog as _Fault
      on $projection.FaultCode = _Fault.fault_code
{
  key MaintenanceOrder.work_order_id     as WorkOrderId,
      MaintenanceOrder.vehicle_id        as VehicleId,
      MaintenanceOrder.fault_code        as FaultCode,
      MaintenanceOrder.opened_date       as OpenedDate,
      MaintenanceOrder.planned_end_date  as PlannedEndDate,
      MaintenanceOrder.actual_end_date   as ActualEndDate,
      MaintenanceOrder.status            as Status,
      MaintenanceOrder.priority          as Priority,
      MaintenanceOrder.estimated_cost    as EstimatedCost,
      MaintenanceOrder.actual_cost       as ActualCost,
      _Vehicle,
      _Fault
}


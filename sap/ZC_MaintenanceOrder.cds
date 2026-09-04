@EndUserText.label: 'Maintenance Order Consumption View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@UI.headerInfo: {
  typeName: 'Maintenance Order',
  typeNamePlural: 'Maintenance Orders',
  title: { value: 'WorkOrderId' }
}
define view entity ZC_MaintenanceOrder
  as projection on ZI_MaintenanceOrder
{
  key WorkOrderId,
      VehicleId,
      FaultCode,
      OpenedDate,
      PlannedEndDate,
      ActualEndDate,
      Status,
      Priority,
      EstimatedCost,
      ActualCost
}


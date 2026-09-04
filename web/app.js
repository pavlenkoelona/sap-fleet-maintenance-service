const euro = new Intl.NumberFormat('de-DE', { style: 'currency', currency: 'EUR' });

async function loadKPIs() {
  const data = await fetch('/api/KPIs').then(response => response.json());
  const cards = [
    ['Total orders', data.total_orders], ['Active orders', data.active_orders],
    ['Late orders', data.late_orders], ['Managed cost', euro.format(data.managed_cost)]
  ];
  document.querySelector('#kpis').innerHTML = cards.map(([label, value]) =>
    `<article class="card"><span>${label}</span><strong>${value}</strong></article>`).join('');
}

async function loadOrders(status = '') {
  const filter = status ? `&$filter=${encodeURIComponent(`status eq '${status}'`)}` : '';
  const data = await fetch(`/api/WorkOrders?$orderby=planned_end_date desc${filter}`).then(r => r.json());
  document.querySelector('#orders').innerHTML = data.value.map(order => `
    <tr class="${order.is_late ? 'late' : ''}">
      <td>${order.work_order_id}</td><td>${order.vehicle_code}</td><td>${order.depot}</td>
      <td>${order.fault_category}</td><td class="${order.priority === 'CRITICAL' ? 'critical' : ''}">${order.priority}</td>
      <td>${order.status}</td><td>${order.planned_end_date}</td>
      <td>${euro.format(order.actual_cost ?? order.estimated_cost)}</td>
    </tr>`).join('');
}

document.querySelector('#statusFilter').addEventListener('change', event => loadOrders(event.target.value));
Promise.all([loadKPIs(), loadOrders()]);


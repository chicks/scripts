select 
  f.*, 
  d.*, 
  j.*,
  o.result_code, 
  o.message 
from 
  transaction_facts f, 
  transaction_fact_details d, 
  outcome_dimensions o, 
  message_dimensions m,
  jobs j
where 
  f.transaction_fact_detail_id = d.id and 
  f.job_id = j.id and
  f.outcome_dimension_id = o.id and 
  f.message_dimension_id = m.id and 
  m.protocol = 'TPSP' and 
  f.transaction_id = '291597663' and 
  f.started_on between '2009-05-01 03:00:00' and '2009-05-01 03:10:00'
\G;

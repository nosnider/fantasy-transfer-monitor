-- take the newest row in events table
create or replace view `fantasy-transfer-monitor.analytics.dim_players` as (
    select * from `fantasy-transfer-monitor.analytics.elements_raw`
    qualify row_number() over (partition by id order by timestamp desc) = 1 
)
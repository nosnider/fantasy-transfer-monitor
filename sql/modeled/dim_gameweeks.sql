-- take the newest row in events table
create or replace view `fantasy-transfer-monitor.analytics.dim_gameweeks` as (
    select * from `fantasy-transfer-monitor.analytics.events_raw`
    qualify row_number() over (partition by id order by timestamp desc) = 1 
)
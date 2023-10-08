
create or replace table fantasy-transfer-monitor.analytics.fct_player_transfers_hourly as (
    with player_transfers_hourly as (
        select 
            --keys
            md5(concat(
                cast(id as string),
                cast(timestamp as string)
                )) as id,
            id as fk_player_id,
            timestamp, 
            
            --metrics
            transfers_in, 
            transfers_in_event, 
            transfers_out, 
            transfers_out_event
            from fantasy-transfer-monitor.analytics.elements_raw
    ),

    dim_gameweeks as (
        select 
            id as fk_gameweek_id,
            lag(deadline_time, -1) over (order by id desc) as start_time, 
            deadline_time as end_time
        from fantasy-transfer-monitor.analytics.dim_gameweeks
    )

    select
        player_transfers_hourly.id,
        player_transfers_hourly.fk_player_id,
        dim_gameweeks.fk_gameweek_id,
        player_transfers_hourly.timestamp,

        -- audit
        player_transfers_hourly.transfers_in, 
        player_transfers_hourly.transfers_in_event, 
        player_transfers_hourly.transfers_out, 
        player_transfers_hourly.transfers_out_event



    from player_transfers_hourly
    left join dim_gameweeks
    on player_transfers_hourly.timestamp 
        between dim_gameweeks.start_time and dim_gameweeks.end_time
)

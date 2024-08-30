with
    hist_rb_catch as (
        select player as player, rec as receptions, yds as yards, td as tds
        from {{ ref("c_receiving") }}
        where pos = 'RB'
    ),
    rb_rel as (
        select
            r.rk as rank,
            r.player as player,
            r.yds as yards,
            r.att as rushes,
            r.td as tds,
            h.receptions as receptions,
            h.yards as receiving_yards,
            h.tds as receiving_tds,
            rank() over (order by r.att desc) as rush_based_rank,
            rank() over (order by r.yds desc) as yard_based_rank,
            rank() over (order by r.td desc) as td_based_rank,
            rank() over (order by h.yards desc) as rec_yard_based_rank,
            rank() over (order by h.receptions desc) as rec_based_rank,
            rush_based_rank - rank as rush_rel,
            yard_based_rank - rank as yard_rel,
            td_based_rank - rank as td_rel,
            rec_yard_based_rank - rank as rec_yard_rel,
            rec_based_rank - rank as rec_rel
        from {{ ref("c_rushing") }} r
        left join hist_rb_catch h on r.player = h.player
        where r.pos = 'RB'
    )

select
    (
        rush_based_rank
        + yard_based_rank
        + td_based_rank
        + rec_yard_based_rank
        + rec_based_rank
    ) as composite_rank,
    *
from rb_rel
order by rank

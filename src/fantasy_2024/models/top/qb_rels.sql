with
    hist_qb_rush as (
        select player as player, yds as yards, td as tds, y_a as yards_averaged
        from {{ ref("c_rushing") }}
        where pos = 'QB'
    ),
    qb_rels as (
        select
            p.rk as rank,
            p.player as player,
            p.cmp as completions,
            p.cmp_pct as completion_pct,
            p.td as passing_tds,
            h.yards as rushing_yards,
            h.tds as rushing_tds,
            rank() over (order by p.cmp desc) as completions_rank,
            rank() over (order by p.cmp_pct desc) as completion_pc_rank,
            rank() over (order by p.td desc) as passing_td_rank,
            rank() over (order by h.tds desc) as rushing_td_rank,
            rank() over (order by h.yards desc) as rushing_yard_rank,
            completions_rank - rank as cmp_rel,
            completion_pc_rank - rank as pct_rel,
            passing_td_rank - rank as passing_tds_rel,
            rushing_td_rank - rank as rushing_tds_rel,
            rushing_yard_rank - rank as rushing_yards_rel
        from {{ ref("c_passing") }} p
        left join hist_qb_rush h on p.player = h.player
        where p.pos = 'QB'
    )

select
    (
        completions_rank
        + completion_pc_rank
        + passing_td_rank
        + rushing_td_rank
        + rushing_yard_rank
    ) as composite_rank,
    *
from qb_rels
order by rank

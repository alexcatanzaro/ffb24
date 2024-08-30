with
    wr_composite as (
        select composite_rank, rank as hist_rank, player from {{ ref("wr_rels") }}
    ),
    wr_rank as (
        select player, rank as current_rank
        from {{ ref("current_ranks") }}
        where position = 'WR'
    )

select
    c.composite_rank,
    c.hist_rank,
    r.current_rank,
    c.player
from wr_composite c
join wr_rank r on c.player = r.player
order by c.composite_rank asc

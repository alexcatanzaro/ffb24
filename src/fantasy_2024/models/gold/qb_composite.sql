with
    qb_composite as (
        select composite_rank, rank as hist_rank, player from {{ ref("qb_rels") }}
    ),
    qb_rank as (
        select player, rank as current_rank
        from {{ ref("current_ranks") }}
        where position = 'QB'
    )

select
    c.composite_rank,
    c.hist_rank,
    r.current_rank,
    c.player
from qb_composite c
join qb_rank r on c.player = r.player
order by c.composite_rank asc

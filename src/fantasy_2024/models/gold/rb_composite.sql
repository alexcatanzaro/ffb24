with
    rb_composite as (
        select composite_rank, rank as hist_rank, player from {{ ref("rb_rels") }}
    ),
    rb_rank as (
        select player, rank as current_rank
        from {{ ref("current_ranks") }}
        where position = 'RB'
    )

select
    c.composite_rank,
    c.hist_rank,
    r.current_rank,
    c.player
from rb_composite c
join rb_rank r on c.player = r.player
order by c.composite_rank asc

with
    qb_ranks as (select * from {{ ref("rankings_qb") }}),
    rb_ranks as (select * from {{ ref("rankings_rb") }}),
    wr_ranks as (select * from {{ ref("rankings_wr") }}),
    te_ranks as (select * from {{ ref("rankings_te") }}),
    final as (
        select *
        from qb_ranks
        union
        select *
        from rb_ranks
        union
        select *
        from wr_ranks
        union
        select *
        from te_ranks
    )

select *
from final

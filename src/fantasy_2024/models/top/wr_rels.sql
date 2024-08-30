with
    wr_rels as (
        select
            rk as rank,
            player as player,
            rec as catches,
            td as tds,
            succ as catch_success_percentage,
            y_tgt as yards_per_target,
            rank() over (order by catches desc) as catch_based_rank,
            rank() over (order by tds desc) as td_based_rank,
            rank() over (order by catch_success_percentage desc) as succ_based_rank,
            rank() over (order by y_tgt desc) as y_tgt_based_rank,
            catch_based_rank - rank as relative_rank,
            td_based_rank - rank as td_rel,
            succ_based_rank - rank as catch_succ_rel,
            y_tgt_based_rank - rank as y_tgt_rel
        from {{ ref("c_receiving") }}

    )

select
    (
        catch_based_rank + td_based_rank + succ_based_rank + y_tgt_based_rank
    ) as composite_rank,
    *
from wr_rels
order by rank

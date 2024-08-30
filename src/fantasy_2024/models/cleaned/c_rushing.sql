with
    c_rushing as (
        select rtrim(rtrim(player, '+'), '*') as player, * from {{ ref("rushing") }}
    )

select *
from c_rushing

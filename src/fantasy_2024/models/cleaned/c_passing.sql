with
    c_passing as (
        select rtrim(rtrim(player, '+'), '*') as player, * from {{ ref("passing") }}
    )

select *
from c_passing

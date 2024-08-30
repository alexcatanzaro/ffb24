with
    c_receiving as (
        select rtrim(rtrim(player, '+'), '*') as player, * from {{ ref("receiving") }}
    )

select *
from c_receiving

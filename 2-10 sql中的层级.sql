-- 小组中年龄最大的成员之一
select team, max(age),
	(select max(member) from teams2 where team = t1.team and age = max(t1.age)) as oldest
from teams2 t1
group by team

-- 列出全部,exists的好处,能列出全部信息
select * from teams2 t1 where not exists (
	select * from teams2 where team = t1.team
		and member <> t1.member
		and age > t1.age
)
order by team

select * from teams2 order by team
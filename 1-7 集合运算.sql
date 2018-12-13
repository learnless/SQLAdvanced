-- 比较两张表是否相等
-- 看记录数
select count(*)
from (
	select * from tbl_a
	union
	select * from tbl_b
)t

-- mysql不支持
select case when count(*) = 0 then '相等' else '不相等' end as result
from ((select * from tbl_a
union 
select * from tbl_b)
except
(select * from tbl_a
intersect
select * from tbl_b
))t

-- 求差集
select * from skills sk 
left join empskills ek on sk.skill = ek.skill 
group by ek.emp having count(ek.skill) = (select count(*) from skills)

select * from skills
select * from empskills

-- 寻找相等的子集
select s1.sup,s2.sup from supparts s1,supparts s2 
where s1.sup < s2.sup 
	and s1.part = s2.part -- 同种类型
group by s1.sup,s2.sup
having count(*) = (select count(*) from supparts where sup = s1.sup)
	and count(*) = (select count(*) from supparts where sup = s2.sup)

select * from supparts








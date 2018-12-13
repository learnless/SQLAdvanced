-- 将行转换为列
-- 方法1
select c0.name,
case when c1.name is not null then 'o' else null end as 'SQL入门',
case when c2.name is not null then 'o' else null end as 'UNIX基础',
case when c3.name is not null then 'o' else null end as 'Java中级'
from (select distinct name from courses)c0
left join (select name from courses where course='SQL入门')c1 on c0.name = c1.name
left join (select name from courses where course='UNIX基础')c2 on c0.name = c2.name
left join (select name from courses where course='Java中级')c3 on c0.name = c3.name

-- 方法2，用标量子查询替代
select name,
(select 'o' from courses where course='SQL入门' and name = c0.name) as 'SQL入门',
(select 'o' from courses where course='UNIX基础' and name = c0.name) as 'UNIX基础',
(select 'o' from courses where course='Java中级' and name = c0.name) as 'Java中级'
from (select distinct name from courses)c0

-- 方法3，case
select name,
case when sum(case when course='SQL入门' then 1 else null end) = 1 then 'o' else null end as 'SQL入门',
case when sum(case when course='UNIX基础' then 1 else null end) = 1 then 'o' else null end as 'UNIX基础',
case when sum(case when course='Java中级' then 1 else null end) = 1 then 'o' else null end as 'Java中级'
from courses group by name

-- 将列转换为行
select employee,child_1 from personnel
union all
select employee,child_2 from personnel
union all
select employee,child_3 from personnel

-- 改进版本,为简化语句创建视图
create view children(child) as 
select child_1 from personnel
union
select child_2 from personnel
union
select child_3 from personnel

select employee,child
from personnel
left join children on child in (child_1,child_2,child_3)

-- 交叉表制作嵌套式表侧栏
-- 完美展示方法
select age_range,sex,pop_1 as '东北',pop_2 as '关东'
from (select age_class,age_range,sex,sex_cd from TblAge,TblSex)master
left join (
	select age_class,sex_cd,
		sum(case when pref_name in ('秋田','青森') then population else null end) as pop_1,
		sum(case when pref_name in ('千叶','东京') then population else null end) as pop_2
	from TblPop pop group by age_class, sex_cd
)p
	on p.age_class = master.age_class and p.sex_cd = master.sex_cd
	
-- 对以上进行优化，先连接再聚合
select age_range,sex
	,sum(case when pref_name in ('秋田','青森') then population else null end) as pop_1
	,sum(case when pref_name in ('千叶','东京') then population else null end) as pop_2
from (select age_class,age_range,sex,sex_cd from TblAge,TblSex)master
left join TblPop pop on pop.age_class = master.age_class and pop.sex_cd = master.sex_cd
group by master.age_class, master.sex_cd

-- 其他方法，不够完善
select age_range,sex,pop_1 as '东北',pop_2 as '关东'
from (select *,
	sum(case when pref_name in ('秋田','青森') then population else null end) as pop_1,
	sum(case when pref_name in ('千叶','东京') then population else null end) as pop_2
from TblPop
group by age_class,sex_cd)master
right join TblAge age on age.age_class = master.age_class
right join TblSex sex on sex.sex_cd = master.sex_cd


select * from TblAge
select * from TblSex
select * from TblPop

-- 一对多的乘法运算,一的那张表可以直接左连接到多那张表进行分组，生成的记录数不变
select items2.item_no,sum(quantity) as 'total_qty'
from items2
left join saleshistory on saleshistory.item_no = items2.item_no
group by items2.item_no

select * from items2
select * from salesHistory

-- 全连接,mysql暂时还未实现full join，可用union替代
select class_c.id,class_c.name from class_c left join class_d on class_c.id = class_d.id
union
select class_d.id,class_d.name from class_c right join class_d on class_c.id = class_d.id

-- 集合思想
-- 求差集,class_c不与class_d相交的部分,使用外连接，性能比not in/not exists高
select class_c.id,class_c.name from class_c
left join class_d on class_c.id = class_d.id
where class_d.id is null

-- 使用not exsts实现
select * from class_c where
not exists (select * from class_d where id = class_c.id)

-- 求异或集
select class_c.id,class_c.name from class_c
left join class_d on class_d.id = class_c.id
where class_d.id is null
union
select class_d.id,class_d.name from class_c
right join class_d on class_d.id = class_c.id
where class_c.id is null

-- 练习
-- 统计孩子个数
select employee,count(child) as child_cnt from personnel 
left join children on child in (child_1,child_2,child_3)
group by employee
order by child_cnt desc

-- merge用法，mysql用不了，用如下语句期待
update class_c c,class_d d set c.name = d.name
	where c.id = d.id
insert into class_c 
	select class_d.id,class_d.name from class_c 
		right join class_d on class_d.id = class_c.id 
	where class_c.id is null



-- 按地区统计总人数
select case pref_name
	when '德岛' then '四国'
	when '香川' then '四国'
	when '爱媛' then '四国'
	when '高知' then '四国'
	when '福冈' then '九州'
	when '佐贺' then '九州'
	when '长崎' then '九州'
else '其他' end as '地区名',
sum(population) as '人口'
from poptbl
group by
case pref_name
	when '德岛' then '四国'
	when '香川' then '四国'
	when '爱媛' then '四国'
	when '高知' then '四国'
	when '福冈' then '九州'
	when '佐贺' then '九州'
	when '长崎' then '九州'
else '其他' end;
	when '高知' then '四国'
	when '福冈' then '九州'
	when '佐贺' then '九州'
	when '长崎' then '九州'
else '其他' end;

-- 按照人口数量等级统计
select 
case 
	when population < 100 then '01'
	when population < 200 and population >= 100 then '02'
	when population < 300 and population >= 200 then '03'
	when population >= 300 then '04'
else NULL end as '分类',
count(*) as '数量'
from poptbl 
group by
case 
	when population < 100 then '01'
	when population < 200 and population >= 100 then '02'
	when population < 300 and population >= 200 then '03'
	when population >= 300 then '04'
else NULL end;

-- 统计同地区性别不同人数，类似于sum,count,avg聚合函数将行转换成列结构
select pref_name,
sum(case when sex='1' then population else 0 end) as '男',
sum(case when sex='2' then population else 0 end) as '女'
from poptbl2
group by pref_name;

-- update使用case
-- 有这样需要，需满足1.工资高于30W，降薪10%,2.工资在【25W,28W )，加薪20%
-- 如何满足一个字段多个分支条件进行更新，使用case在合适不过
update salaries set salary=
case 
	when salary >= 300000 then salary*0.9
	when salary >= 250000 and salary < 280000 then salary*1.2
else salary end;

-- 主键值之间的替换，不使用case语句繁杂，得独立执行3次update操作，使用case只需一次update
-- 由于mysql唯一键会在更新检测唯一键重复发生错误，所以将p_key字段更新换成col_1，而oracle在更新后才检测，故可以更新主键/唯一键
update sometable set col_1=
case 
	when col_1=1 then 2
	when col_1=2 then 1
else col_1 end
where col_1 in (1,2);

-- 表之间的关联
--  1.使用in
select a.course_name,
case when a.course_id in (select b.course_id from opencourses b where b.month='200706') then '√'
else 'x' end as '六月',
case when a.course_id in (select b.course_id from opencourses b where b.month='200707') then '√'
else 'x' end as '七月',
case when a.course_id in (select b.course_id from opencourses b where b.month='200708') then '√'
else 'x' end as '八月'
from coursemaster a

-- 2.使用exists，性能比in好
select a.course_name,
case when exists (select b.course_id from opencourses b where b.month='200706' and a.course_id=b.course_id) then '√'
else 'x' end as '六月',
case when exists (select b.course_id from opencourses b where b.month='200707' and a.course_id=b.course_id) then '√'
else 'x' end as '七月',
case when exists (select b.course_id from opencourses b where b.month='200708' and a.course_id=b.course_id) then '√'
else 'x' end as '八月'
from coursemaster a

-- 获取只加入一个社团的学生社团id
select std_id,max(club_id)
from studentclub
group by std_id having count(*)=1 union
-- 获取加入多个社团的学生的主社团id
select std_id, club_id
from studentclub where main_club_flg='Y'
-- 同时满足两个条件
select std_id,
case
	when count(*) = 1 then max(club_id)
	else max(
		case
			when main_club_flg='y' then club_id
			else null
		end)
end as club_id
from studentclub
group by std_id


-- 练习题
-- 1.多列求最大值
select greatests.key,
case 
	when x>=y then 
		case 
			when x>=z then x
			when y>=z then y
		else z end
else 
	case
		when y>=z then y
	else z end
end as greatest
from greatests

-- 更简化sql
select greatests.key,
case 
	when case when x<y then y else x end < z
	then z
else case when x<y then y else x end 
end as greatest
from greatests

-- 2.行结构数据转换为列结构
select 
case when sex='1' then '男' when sex='2' then '女' else null end as '性别',
sum(population) as '全国',
sum(case when pref_name='东京' then population else 0 end) as '东京',
sum(case when pref_name='佐贺' then population else 0 end) as '佐贺',
sum(case when pref_name='德岛' then population else 0 end) as '德岛',
sum(case when pref_name='爱媛' then population else 0 end) as '爱媛',
sum(case when pref_name='福冈' then population else 0 end) as '福冈',
sum(case when pref_name='长崎' then population else 0 end) as '长崎',
sum(case when pref_name='香川' then population else 0 end) as '香川',
sum(case when pref_name='高知' then population else 0 end) as '高知'	
from poptbl2
group by sex

-- 3.自定义指定排序列
select *
from greatests a
order by case a.key
	when 'B' then 1
	when 'A' then 2
	when 'D' then 3
	when 'C' then 4
else null end


select * from greatests














-- 不参加会议名单
select distinct m1.meeting,m2.person from meetings m1,meetings m2
where not exists (
	select * from meetings m3 where m3.meeting = m1.meeting and m3.person = m2.person
)
order by m1.meeting

-- except,mysql暂不支持
select m1.meeting,m2.person from meetings m1,meetings m2
except
select * from meetings

select * from meetings

-- 双重否定，exists
-- 查询所有的科目都在50以上，用双重否定即是：没有一门科目在50分以下
select distinct student_id from testscores s1
where not exists (
	select * from testscores where student_id = s1.student_id and score < 50
)

-- 1.数学分数80以上,2.语文分数50以上
select student_id from testscores s1
where subject in ('数学','语文') 
	and not exists (
		select * from testscores 
		where student_id = s1.student_id
			and 1 = case when subject = '数学' and score < 80 then 1
				when subject = '语文' and score < 50 then 1
				else 0 end
	)
group by student_id having count(*) = 2

select * from testscores

-- 集合跟谓语使用比较，集合效率高强大，返回数据全，但不易阅读，通常两者能互相转换
-- 查询刚好完成工程编号step_nbr的项目
-- 使用谓语group by
select project_id from projects
group by project_id having
	count(*) = sum(
		case when step_nbr <= 1 and status = '完成' then 1
		when step_nbr > 1 and status = '等待' then 1
		else 0 end
	)
	
-- 使用集合二阶谓语，not exists，一行条件满足立即终止，还能使用索引
select * from projects p1
where not exists (
	select * from projects where project_id = p1.project_id
-- 		and (step_nbr <= 1 and status <> '完成' or step_nbr > 1 and status <> '等待')
		and status <> case when step_nbr <= 1 then '完成' else '等待' end 
)

select * from projects

-- 1.都为1的行，2.至少有一个9的行,不能执行,TODO
select * from arraytbl a 
where 1 = all (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10)
	or 9 = any (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10)
	
-- 全为null
select * from arraytbl where coalesce(col1, col2, col3, col4, col5, col6, col7, col8, col9, col10) is null

select * from arraytbl

-- 练习
-- 行结构数组表，选出全为1
select distinct `key` from arraytbl2 a1 
where not exists (
	select * from arraytbl2 where `key` = a1.`key`
		and (val is null or val <> 1)
)

-- 其他解法
select * from arraytbl2 a1 where 1 = ALL(select val from arraytbl2 where `key` = a1.`key`)

-- having解法
select `key` from arraytbl2
group by `key` having sum(case when val = 1 then 1 else null end) = 10

select * from arraytbl2

-- 求质数
select * from numbers n1
where not exists(
	select * from numbers -- 除数
	where 
		num <> 1		
	and 
		num <= n1.num/2
	and
		mod(n1.num,num) = 0
)
 and num > 1

select * from numbers;

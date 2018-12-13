-- 查询年龄时20岁或者不是20岁的同学
select * from students where age = 20 or age <> 20 or age is NULL

-- 与B班住在东京A班年龄不同的学生
-- 使用in,查询异常，没有数据
select * from class_a a where a.age not in 
		(select b.age from class_b b where b.city = '东京')
-- 使用exists完美替换in
select * from class_a a where not exists 
	(select * from class_b b where a.age = b.age and b.city = '东京')
	
-- 都小于,查询异常
select * from class_a a where a.age <
	all(select b.age from class_b b where b.city = '东京')
-- 使用极值函数
select * from class_a a where age < (select min(age) from class_b where city = '东京')


select * from class_a 
union all
select * from class_b
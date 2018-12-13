-- 全队待命
SELECT team_id FROM teams
GROUP BY team_id 
HAVING COUNT(*) = SUM(CASE WHEN status = '待命' THEN 1 ELSE 0 END)
-- HAVING MAX(status) = '待命' and MIN(status) = '待命' -- 技巧，子集合某属性最大值和最小值相等，则只有一个值

-- exists
SELECT * FROM teams t1
WHERE NOT EXISTS (
	SELECT * FROM teams WHERE team_id = t1.team_id AND status <> '待命'
)

select * from teams order by team_id

-- 查询同个生产地入库相同材料
SELECT center FROM materials
GROUP BY center HAVING COUNT(material) <> COUNT(DISTINCT material)

SELECT center,
	CASE WHEN COUNT(material) = COUNT(DISTINCT material) then '不存在重复'
	ELSE '存在重复' END as result
FROM materials
GROUP BY center

-- 使用exists
SELECT * FROM materials m1 WHERE EXISTS (
	SELECT * FROM materials 
	WHERE center = m1.center 
		AND receive_date <> m1.receive_date
		AND material = m1.material
)

SELECT * FROM materials

-- 缺失编号升级版
SELECT CASE WHEN COUNT(*) = 0 THEN 0
						WHEN MIN(seq) > 1 THEN 1
			 ELSE (
				SELECT MIN(seq+1) FROM seqtbl s1 WHERE NOT EXISTS (
					SELECT * FROM seqtbl WHERE seq = s1.seq+1
				)
			 ) END AS result
FROM seqtbl

SELECT * FROM seqtbl

-- 75%以上分数在80分以上的班级
SELECT class FROM testresults
GROUP BY class HAVING COUNT(*) * 0.75 <= SUM(CASE WHEN score >= 80 then 1 ELSE 0 END)

-- 50分以上男生比50分女生人数多的班级
SELECT class FROM testresults 
GROUP BY class 
HAVING SUM(CASE WHEN sex = '男' AND score >= 50 THEN 1 ELSE 0 END) > SUM(CASE WHEN sex = '女' AND score >= 50 THEN 1 ELSE 0 END)

-- 平均分女生比男生高的班级
SELECT class FROM testresults
GROUP BY class 
HAVING AVG(CASE WHEN sex = '女' THEN score ELSE NULL END) > AVG(CASE WHEN sex = '男' THEN score ELSE NULL END)

select * from testresults

-- 练习题
-- 1.材料和原产国都有重复
-- mysql不支持
SELECT center FROM Materials2
GROUP BY center
HAVING COUNT(material || orgland) <> COUNT(DISTINCT material || orgland)

-- 能运行
select center,material,count(*) from materials2
group by center, material, orgland having count(material) > 1 and count(orgland) > 1

SELECT * FROM materials2

-- 1.数学分数在80以上 2.语文50以上
select student_id from testscores
group by student_id having sum(case when subject = '数学' and score >= 80 then 1
																		when subject = '语文' and score >= 50 then 1
															 else 0 end) = 2

select * from testscores
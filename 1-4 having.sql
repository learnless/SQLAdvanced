-- 是否连续编号
select * from seqtbl having count(*) <> max(seq)
-- 查找缺失最小的编号, 不健全，seq如何不从1开始，结果就错误
select min(seq+1) from seqtbl where (seq+1) not in 
	(select seq from seqtbl)
-- 完善
selectcase when count(*) = 0 or min(seq) > 1 then 1
else (select min(seq+1) from seqtbl a where not exists 
				(select * from seqtbl b where a.seq+1 = b.seq)
			) end
from seqtbl

-- 求众数
select *,count(*) from graduates group by income having count(*) >=
	all(select count(*) from graduates group by income)
-- 方式二，极值
select *,count(*) from graduates group by income having count(*) >=
	(select max(cnt) from (select count(*) as cnt from graduates group by income)t)

-- 中位数
select avg(t.income) from 
	(select a.* from graduates a, graduates b group by a.income
		having sum(case when a.income <= b.income then 1 else 0 end) >= count(*)/2
			and sum(case when a.income >= b.income then 1 else 0 end) >= count(*)/2)t

select *,count(*) from graduates group by income

-- 哪些学院都提交了报告
select dpt from students2 group by dpt having dpt not in 
	(select distinct dpt from students2 where sbmt_date is null)
-- 也可以这样
select dpt from students2 group by dpt having count(*) = count(sbmt_date)
-- 也能用case
select dpt from students2 group by dpt having count(*) = sum(case when sbmt_date is not null then 1 else 0 end)

-- 购物篮分析：店铺包含指定折扣所有商品
select a.shop from shopitems a, items b
	where a.item = b.item 
	group by a.shop having count(distinct a.item) = (select count(distinct item) from items)
	
-- 在以上基础上，排除出现多余的商品
select a.shop from shopitems a 
	left join items b on a.item = b.item
	group by a.shop
	having count(a.item) = (select count(item) from items)
		and count(b.item) = (select count(item) from items)

-- 练习题
-- 有缺失行输出自定义信息
select case when count(seq) <> max(seq) then '缺失' else '不缺失' end as msg
from seqtbl

-- 找出指定时间全部提交的学院
select * from students2 group by dpt having count(dpt) = 
	sum(case when sbmt_date between '2005-09-01' and '2005-09-30' then 1 else 0 end)
-- 或者使用extract函数
select * from students2 group by dpt having count(dpt) = 
	sum(case when EXTRACT(YEAR FROM sbmt_date) = 2005 and EXTRACT(MONTH FROM sbmt_date) = 09 then 1 else 0 end)

-- 展示缺失购物的个数
select a.shop, count(a.item) as item_cnt, (select count(distinct item) from items) - count(b.item) as diff_cnt
from shopitems a, items b
where a.item = b.item
group by a.shop

select * from shopitems, items








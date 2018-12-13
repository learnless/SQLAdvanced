-- 与上一年相等的营业额
-- 使用关联子查询
select * from sales s1
where sale = (select sale from sales where year = s1.year - 1)
-- 使用自连接
select s1.* from sales s1,sales s2
where s2.year = s1.year-1 and s1.sale = s2.sale
-- 使用exists
select * from sales s1
where exists (select * from sales where year = s1.year-1 and sale = s1.sale)

-- 子关联查询
SELECT S1.YEAR, S1.SALE,
       CASE WHEN SALE =
             (SELECT SALE
                FROM SALES S2
               WHERE S2.YEAR = S1.YEAR - 1) THEN '→' /* 持平 */
            WHEN SALE >
             (SELECT SALE
                FROM SALES S2
               WHERE S2.YEAR = S1.YEAR - 1) THEN '↑' /* 增长 */
            WHEN SALE <
             (SELECT SALE
                FROM SALES S2
               WHERE S2.YEAR = S1.YEAR - 1) THEN '↓' /* 减少 */
       ELSE '—' END AS VAR
  FROM SALES S1
 ORDER BY YEAR
 
-- 对以上语句优化,sign函数使用
select s1.*,
	case sign(sale - (select sale from sales where year  = s1.year-1)) when 0 then '→'
	when 1 then '↑'
	when -1 then '↓'
	else '—' end as var
from sales s1
 
-- 自连接查询效率高
select s1.year,s1.sale,
	case when s1.sale = s2.sale then '→'
			 when s1.sale > s2.sale then '↑'
			 when s1.sale < s2.sale then '↓'
	else '—' end as var
from sales s1 
left join sales s2 on s2.year = s1.year -1

-- 某些年份丢失，使用更通用的sql
select s1.year,s1.sale from sales2 s1,sales2 s2
where s2.year = (select max(year) from sales2 where year < s1.year) and s2.sale = s1.sale

select s1.year,s1.sale,
	case when s1.sale = s2.sale then '→'
			 when s1.sale > s2.sale then '↑'
			 when s1.sale < s2.sale then '↓'
	else '—' end as var
from sales2 s1
left join sales2 s2 on s2.year = (select max(year) from sales2 where year < s1.year)

select * from sales2

-- 累计移动值
-- 关联子查询
select prc_date,prc_amt,
	(select sum(prc_amt) from accounts where prc_date <= a1.prc_date) as total
from accounts a1

-- 子连接效率更高
select a1.*,sum(a2.prc_amt) as total
from accounts a1,accounts a2 
where a2.prc_date <= a1.prc_date
group by a1.prc_date

-- 以单位为n进行累算
select a1.*,
	(select sum(prc_amt) from accounts a2 where a2.prc_date <= a1.prc_date and 
		(select count(*) from accounts a3 where prc_date between a2.prc_date and a1.prc_date) <= 3
	) as mvg_sum
from accounts a1

select * from accounts

-- 查询重叠时间区间
select * from  reservations r1
where exists (
	select * from reservations 
	where reserver <> r1.reserver 
		and (
			(start_date between r1.start_date and r1.end_date or end_date between r1.start_date and r1.end_date)
			or 
			(r1.start_date between start_date and end_date or r1.end_date between start_date and end_date)
		)
	)
order by start_date,end_date

select * from reservations order by start_date,end_date


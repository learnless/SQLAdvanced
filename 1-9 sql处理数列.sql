-- 用表生成数列
-- 0-99
select d1.digit*10 + d2.digit as num from digits d1,digits d2 order by num

-- 1-542
select d1.digit*100 + d2.digit*10 + d3.digit as num from digits d1,digits d2,digits d3 
where d1.digit*100 + d2.digit*10 + d3.digit between 1 and 542
order by num

-- 生成视图，这里生成0-999
create view Sequence(seq) as select d1.digit*100 + d2.digit*10 + d3.digit from digits d1,digits d2,digits d3

-- 从视图中获取数值，1-99
select seq from sequence where seq between 1 and 99 order by seq

select * from digits

-- 求全部的缺失编号
select * from sequence s1 where seq between (select min(seq) from seqtbl) and (select max(seq) from seqtbl) and not exists(
	select * from seqtbl where seq = s1.seq
)

select * from seqtbl

-- 三个人能坐得下吗，求所有的三连坐号码
select s1.seat as start_seat,'~',s2.seat as end_seat from seats s1,seats s2 where s2.seat = s1.seat+2 and not exists (
	select * from seats where (seat between s1.seat and s2.seat) and status <> '未预订'
)

-- 使用group by
select s1.seat as start_seat,'~',s2.seat as end_seat from seats s1,seats s2,seats s3
where s2.seat = s1.seat+2
	and s3.seat between s1.seat and s2.seat
group by s1.seat,s2.seat having count(*) = sum(case when s3.status = '未预订' then 1 else 0 end)

select * from seats

-- 考虑换排
select s1.seat as start_seat,'~',s2.seat as end_seat from seats2 s1,seats2 s2 
where s2.seat = s1.seat+2 and s2.row_id = s1.row_id and not exists (
	select * from seats2
	where row_id = s1.row_id
		and seat between s1.seat and s2.seat 
		and status <> '未预订'
)

-- group by实现
select s1.seat as start_seat,'~',s2.seat as end_seat from seats2 s1,seats2 s2,seats2 s3
where s2.seat  = s1.seat+2 and s2.row_id = s1.row_id
	and s3.row_id = s1.row_id
	and s3.seat between s1.seat and s2.seat
group by s1.seat,s2.seat having count(*) = sum(case when s3.status = '未预订' then 1 else 0 end)

select * from seats2

-- 最多能坐下多少人,否定1.连接之间有'预订'，2.连接能向前延伸，3.连接能向后延伸
-- 创建视图简单点
create view view_seats(start_seat,end_seat,cnt) as 
select s1.seat as start_seat,s2.seat as end_seat,s2.seat-s1.seat+1 as cnt from seats3 s1,seats3 s2
	where s1.seat <= s2.seat and not exists (
		select * from seats3
		where (seat between s1.seat and s2.seat and status <> '未预订')
			or (seat = s1.seat-1 and status = '未预订')
			or (seat = s2.seat+1 and status = '未预订')
)

-- 查询
select start_seat,'-',end_seat from view_seats where cnt = (select max(cnt) from view_seats)

-- group by实现,不使用视图
select s1.seat as start_seat,s2.seat as end_seat,s2.seat-s1.seat+1 as cnt from seats3 s1,seats3 s2,seats3 s3
where s1.seat <= s2.seat
	and s3.seat between s1.seat-1 and s2.seat+1
group by s1.seat,s2.seat 
having count(*) = sum(case when s3.seat between s1.seat and s2.seat and s3.status = '未预订' then 1
													 when s3.seat = s1.seat-1 and s3.status = '已预订' then 1
													 when s3.seat = s2.seat+1 and s3.status = '已预订' then 1
											else 0 end)

select * from seats3

-- 单调递增区间
select min(start_date) as start_date, end_date
from (
	select m1.deal_date as start_date,  max(m2.deal_date) as end_date
	from mystock m1, mystock m2 
	where m1.deal_date < m2.deal_date and not exists (
		select * from mystock m3, mystock m4 
		where m3.deal_date < m4.deal_date
			and m3.deal_date between m1.deal_date and m2.deal_date
			and m4.deal_date between m1.deal_date and m2.deal_date
			and m3.price >= m4.price
	)
	group by m1.deal_date
)t 
group by end_date

-- group by实现
select * from mystock m1, mystock m2, mystock m3, mystock m4
where m1.deal_date < m2.deal_date
	and m3.deal_date < m4.deal_date	
	and m3.deal_date between m1.deal_date and m2.deal_date
	and m4.deal_date between m1.deal_date and m2.deal_date
group by m1.deal_date, m2.deal_date
having count(*) = sum(case when m3.price < m4.price then 1 else 0 end)
	
select * from mystock






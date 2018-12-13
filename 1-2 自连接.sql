select * from products as a,products as b
 
-- 排除相同元素组合
select * from products a, products b where a.name <> b.name

select * from products a, products b where a.name > b.name

select * from products a, products b, products c where a.name > b.name and b.name > c.name

-- 查找局部不一样的列
select a.*
from addresses a, addresses b 
where a.family_id = b.family_id and a.address <> b.address
order by a.family_id

-- 找出相同价格不同商品的组合
select a.name,b.name,a.price
from products2 a, products2 b
where a.price = b.price and a.name > b.name

-- 排名编号,oracle已经实现了rank，mysql没有,故自己来实现跨数据库函数
-- 跳过相同排名,rank
select a.name, a.price,
(select count(b.price) from products2 b where a.price < b.price) + 1 as ran
from products2 a
order by ran

-- 不跳过相同排名，相当于dense_rank
select a.name, a.price,
(select count(distinct b.price) from products2 b where a.price < b.price) + 1 as ran
from products2 a
order by ran

-- 也能这样写成外连接
select a.name, a.price,
count(b.price) + 1 as ran
from products2 a left join products2 b 
on a.price < b.price 
group by a.name
order by ran

-- 练习题
-- 按地区排名
select a.district, a.name, a.price,
(select count(b.price) from districtproducts b where a.district = b.district and a.price < b.price) + 1 as ran
from districtproducts a
order by a.district, ran

-- 更新ranking字段，写入排名
update districtproducts2 set ranking = null
update districtproducts2 a 
	set ranking = (select count(b.price)+1 from 
									(select * from districtproducts2) b 
								where a.district = b.district and a.price < b.price)

UPDATE DistrictProducts2 P1
   SET ranking = (SELECT COUNT(P2.price) + 1
                    FROM DistrictProducts2 P2
                   WHERE P1.district = P2.district
                     AND P2.price > P1.price);




















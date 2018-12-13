-- mysql不支持
SELECT member, team, age ,
       RANK() OVER(PARTITION BY team ORDER BY age DESC) rn,
       DENSE_RANK() OVER(PARTITION BY team ORDER BY age DESC) dense_rn,
       ROW_NUMBER() OVER(PARTITION BY team ORDER BY age DESC) row_num
FROM Teams
ORDER BY team, rn
 
select * from teams2 group by team

select mod(num,3) as modulo, num from natura order by modulo,num


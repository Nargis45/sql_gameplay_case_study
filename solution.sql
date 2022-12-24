#understanding the data
USE vindiata_case_study;
select * from user_gameplay;
select * from deposit_data;
select * from withdrawal_data;

 ##creating tables to put data together
 ###finding total deposit of each user and storing inside deposit_amt 
drop table deposit_amt;

create table deposit_amt as SELECT 
    `USER ID`,SUM(amount) as amount
FROM
    deposit_data dd
GROUP BY `USER ID`;

select * from deposit_amt;

###finding total withdraw of each user and storing inside withdraw_amt table
drop table withdraw_amt;
create table withdraw_amt as SELECT 
    `USER ID`,SUM(amount) as amount
FROM
    withdrawal_data dd
GROUP BY `USER ID`;
select * from withdraw_amt;

##storing deposit and withdraw together in table dep_wit
drop table dep_wit;
create table dep_wit as
 select wd.`USER ID`,
    da.amount AS deposit,
    wd.amount AS withdraw
FROM
    deposit_amt da
        JOIN
    withdraw_amt wd ON da.`USER ID` = wd.`USER ID`;
select * from dep_wit;  
##storing game count of each player and storing in player_games table
drop table player_games;
create table player_games as select `USER ID`,count(`Games Played`) from user_gameplay group by `USER ID`;
select * from player_games;

##Making a new table all_in_one to store required information
drop table all_in_one;
create table all_in_one as SELECT 
    ug.`USER ID`,
    ug.datetime,
    ug.`Games Played`,
    dw.deposit,
    dw.withdraw
FROM
    user_gameplay ug
        JOIN
    dep_wit dw ON ug.`User Id` = dw.`User Id`;
    
select  * from all_in_one;

#PART A: Calculating Loyalty Points
##1
###a.  player wise loyalty points on 2nd oct slot s1
SELECT 
    `USER ID`,
    (0.01 * deposit) + (0.005 * withdraw) + (0.001 * greatest((deposit - withdraw) , 0)) + (0.2 * count(`Games Played`)) AS loyalty_points
FROM
    all_in_one
where datetime between '02-10-2022 00:00' and '02-10-2022 12:00'
group by `USER ID`
order by loyalty_points desc;


###b.  player wise loyalty points on 16th oct slot s2

SELECT 
    `USER ID`,
    (0.01 * deposit) + (0.005 * withdraw) + (0.001 * greatest((deposit - withdraw) , 0)) + (0.2 * count(`Games Played`)) AS loyalty_points
FROM
    all_in_one
where datetime between '16-10-2022 12:00' and '16-10-2022 23:59'
group by `USER ID`
order by loyalty_points desc;


###c.  player wise loyalty points on 18th oct slot s1
SELECT 
    `USER ID`,
    (0.01 * deposit) + (0.005 * withdraw) + (0.001 * greatest((deposit - withdraw) , 0)) + (0.2 * count(`Games Played`)) AS loyalty_points
FROM
    all_in_one
where datetime between '18-10-2022 00:00' and '18-10-2022 12:00'
group by `USER ID`
order by loyalty_points desc;

###d.  player wise loyalty points on 26th oct slot s2
SELECT 
    `USER ID`,
    (0.01 * deposit) + (0.005 * withdraw) + (0.001 * greatest((deposit - withdraw) , 0)) + (0.2 * count(`Games Played`)) AS loyalty_points
FROM
    all_in_one
where datetime between '26-10-2022 12:00' and '26-10-2022 23:59'
group by `USER ID`
order by loyalty_points desc;


##2 Overall loyalty points earned by the players and their rank in the month of october
drop table loyalty_count_rank;
create table loyalty_count_rank as SELECT 
    `USER ID`,count(`Games Played`) as games_played,
    (0.01 * deposit) + (0.005 * withdraw) + (0.001 * greatest((deposit - withdraw) , 0)) + (0.2 * count(`Games Played`)) AS loyalty_points
FROM
    all_in_one
group by `USER ID`
order by loyalty_points desc;
select * from loyalty_count_rank;

select loyalty_count_rank.*,row_number() over(order by loyalty_points desc, games_played desc) as ranking  
from loyalty_count_rank;

##3 Average deposit amount
SELECT 
    AVG(Amount) AS avg_deposit_amount
FROM
    deposit_data;
    
##4 Average deposit amount per user in a month
SELECT 
    `User Id`, AVG(Amount) AS avg_amount
FROM
    deposit_data
GROUP BY `User Id`
ORDER BY `User Id`;

##5 Average number of games played per user
SELECT 
    `USER ID`, avg(`Games Played`) AS avg_games
FROM
    all_in_one
    group by `USER ID`;
    
#PART B: Top 50 players and their loyalty points in the month of october
select loyalty_count_rank.*,row_number() over(order by loyalty_points desc, games_played desc) as ranking  
from loyalty_count_rank limit 50;


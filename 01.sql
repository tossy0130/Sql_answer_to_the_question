---------------- ポスグレで記述 -------------------
--- サッカー Q1 GROUP BY
select group_name as グループ, MAX(ranking) as ランキング最上位, MIN(ranking) as ランキング最下位 
	from countries
	group by group_name;

--- COUNT 出場選手　数
select COUNT(name) from players;

--- 出場選手　FW の　総数
select COUNT(name) as ポジションFW from players
	group by position  
	having position = 'FW';


---

--------------------------- サッカー Q1 ---------------------------
--- 各グループの中でFIFAランクが最も高い国と低い国のランキング番号を表示してください。
--- グループ, ランキング最上位, ラインキング最下位
select * from countries;
select * from players;
select * from pairings;
select * from goals;

--- Q1 答え
select group_name, MAX(ranking) as ランキング最上位, MIN(ranking) as ランキング最下位 from countries
GROUP by group_name;

--------------------------- サッカー Q2 position ---------------------------
--- 全ゴールキーパーの平均身長、平均体重を表示してください
--- 平均身長, 平均体重
select AVG(height) as 平均身長, AVG(weight) as 平均体重 
from players
where position = 'GK';

select AVG(height) as 平均身長, AVG(weight) as 平均体重 
from players
where position like 'GK%';

--------------------------- サッカー Q3 position ---------------------------
---------- 各国の平均身長を高い方から順に表示してください。ただし、FROM句はcountriesテーブルとしてください。
--- 国名, 平均身長
select countries.name as 国名,AVG(players.height) as 平均身長 
from players left outer join countries on players.country_id = countries.id  
group by countries.name
order by 平均身長 DESC;

--------------------------- サッカー Q4 position 副問い合わせ サブクエリー ---------------------------
--- 各国の平均身長を高い方から順に表示してください。ただし、FROM句はplayersテーブルとして、
--- テーブル結合を使わず副問合せを用いてください。
select (select c.name from countries c where p.country_id = c.id) as 国名, 
	AVG(p.height) as 平均身長
	from players p 
	GROUP by p.country_id 
	order by AVG(p.height) desc;


------------------ スペシャル Q1
--- 別別のテーブルにある　国ごとの　平均身長　を　降順に　並べる
--
SELECT countries.name AS 国名, AVG(players.height) AS 平均身長 FROM countries
LEFT OUTER JOIN players on countries.id = players.country_id 
GROUP BY countries.name 
ORDER BY 平均身長 DESC;

--- キーワード　サブクエリ
select * from players 
where 20 < (select weight / POW(height / 100, 2));

--- q37
SELECT *
FROM players
WHERE weight / POW(height / 100, 2) >= 20 AND weight / POW(height / 100, 2) < 21;

--- q37
SELECT *
FROM players
WHERE weight / POW(height / 100, 2) >= 20 and weight / POW(height / 90, 2) < 21;

--- ============== pl/pgsql  function test 作成 基礎 01
create or replace function test(in name text)
returns text as $$
	declare res text := name;
begin
	return res;
end;
$$ language plpgsql;

--- ストアド function 実行　
select test('tossy');

--- ============== pl/pgsql  function test_02 作成 基礎 02
create or replace function test_02(in name text)
returns text as $$ 
	declare tmp text := name;
begin 
	select '文字列結合' || tmp || '.' into tmp;
	return tmp;
end;
$$ language plpgsql;

--- ====== test_02 実行
select test_02('tossy');

--- ====== 

/*
 *　スキーマ作成
 */
create schema test_plpgsql;


/*
 *　DDL作成
 */
create table test_plpgsql.dept(
	deptno char(5)  primary key,
    deptname varchar(40)    unique not null
);

---
--------------------------- Q5----------------------------------------------------------
---サッカー Q4 キックオフ日時と対戦国の国名をキックオフ日時の
--早いものから順に表示してください。 ---------------------------
select p.kickoff as キックオフ日時, c.name as 国名1, 
	c2.name as 国名2
	from pairings p 
	left outer join countries c on c.id = p.my_country_id
	left outer join countries c2 on c2.id = p.enemy_country_id 
	order by キックオフ日時 asc;
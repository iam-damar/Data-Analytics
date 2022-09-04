
-- **
--
-- AirBnb Data Preparation - Cleaning - and Analysis Query SQL
--
-- by Damar Djati Wahyu Kemala
--
-- Data Source : RevouID - Introduction to Data Analytic Case Study
--
-- **



-- Explorasi Data, Preparation & Cleaning Data

use Airbnb
select * from Airbnb.dbo.nyc_airbnb;
select COLUMN_NAME,IS_NULLABLE,DATA_TYPE from INFORMATION_SCHEMA.COLUMNS;

-- ---------------------------------------------------------------------------------------------

-- Mengubah Harga Price (Change Price Format)

select * from Airbnb.dbo.nyc_airbnb;

select price from Airbnb.dbo.nyc_airbnb;

select price,
	PARSENAME(REPLACE(price, ' ', '.'),2)
from Airbnb.dbo.nyc_airbnb;

-- Membuat table Price_dollars
Alter table dbo.nyc_airbnb
	ADD price_dollar int;

-- Update Columns data
UPDATE dbo.nyc_airbnb
SET price_dollar = PARSENAME(REPLACE(price, ' ', '.'),2);

select * from dbo.nyc_airbnb;

-- ---------------------------------------------------------------------------------------------

-- Mengubah Format Room Type

select room_type from dbo.nyc_airbnb;

UPDATE dbo.nyc_airbnb
SET room_type = lower(room_type)


-- ---------------------------------------------------------------------------------------------

-- Memisahkan kolom neighborhood_full (Split Neighbourhood_full field)

select * from dbo.nycdata;
select neighborhood_full  from dbo.nyc_airbnb;

select neighborhood_full, 
		case when CHARINDEX(',',neighborhood_full)>0 
			then SUBSTRING(neighborhood_full,1,CHARINDEX(',',neighborhood_full)-1) 
			else neighborhood_full end as County, 
		CASE WHEN CHARINDEX(',',neighborhood_full)>0 
			THEN SUBSTRING(neighborhood_full,CHARINDEX(',',neighborhood_full)+1,len(neighborhood_full))  
			ELSE NULL END as City
		from dbo.nyc_airbnb;

-- Membuat 2 kolom table neighborhood_county_group, neighborhood

alter table dbo.nyc_airbnb
	add neighborhood_county_group nvarchar(100);

alter table dbo.nyc_airbnb
	add neighborhood nvarchar(100);

-- Update table
Update dbo.nyc_airbnb
SET neighborhood_county_group = case when CHARINDEX(',',neighborhood_full)>0 
									then SUBSTRING(neighborhood_full,1,CHARINDEX(',',neighborhood_full)-1) 
									else neighborhood_full end;

Update dbo.nyc_airbnb
SET neighborhood = case when CHARINDEX(',',neighborhood_full)>0 
						then SUBSTRING(neighborhood_full,CHARINDEX(',',neighborhood_full)+1,len(neighborhood_full))  
						else NULL end;

select neighborhood_full, neighborhood_county_group, neighborhood from dbo.nyc_airbnb;


-- ---------------------------------------------------------------------------------------------

-- Menghapus Kolom (Delete Column)

Alter table dbo.nyc_airbnb
	DROP COLUMN price, neighborhood_full,description;

select * from dbo.nyc_airbnb;



-- ---------------------------------------------------------------------------------------------

-- Hasil Bahan yang digunakan untuk analisa dalam bentuk visualisasi grafik.


-- 1.
-- Menampilkan Top Host/ Pemesan Kamar yang paling banyak memesan kamar di AirBnb NYC
-- Kita Akan mengambil beberapa data host_count dengan total pesan >= 90.

select TOP 15 host_name, COUNT(host_name) as Host_Count 
	from dbo.nyc_airbnb
		group by host_name
			order by Host_Count DESC;


-- 2.
-- Menampilkan Hubungan antara tipe kamar Airbnb terhadap harga di masing-masing daerah di New York

select neighborhood_county_group, price_dollar, room_type from dbo.nyc_airbnb;


-- 3.
-- Melihat Hubungan antara Harga dengan tipe kamar (Hanya mengambil harga tidak lebih dari 400 dollar)

select room_type, price_dollar from dbo.nyc_airbnb where price_dollar < 400;


-- 4.
-- Melihat Tingkat banyaknya sewa kamar di AirBnb berdasarkan jenis kamarnya

select room_type, count(room_type) as Count_Room_Type from dbo.nyc_airbnb 
	group by room_type
		order by Count_Room_Type;


-- 5.
-- Melihat persentase tingkat sewa kamar di masing-masing wilayah di new york

select neighborhood_county_group, 
	COUNT(neighborhood_county_group) as Count_neighborhood_county,
		CAST(ROUND(COUNT(neighborhood_county_group) * 100.0 / (select COUNT(neighborhood_county_group) from dbo.nyc_airbnb), 2) AS float) as Percentage_neighborhood_county
			from dbo.nyc_airbnb 
				group by neighborhood_county_group;





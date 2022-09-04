
-- **
--
-- AirBnb Analysis Query SQL
--
-- Crafted by Damar Djati Wahyu Kemala
--
-- **



-- Explorasi Data

select COLUMN_NAME,IS_NULLABLE,DATA_TYPE from INFORMATION_SCHEMA.COLUMNS;


-- ---------------------------------------------------------------------------------------------

-- Mengubah Harga Price (Change Price Format)

select * from Airbnb.dbo.nycdata;

select price from Airbnb.dbo.nycdata;

select price,
	PARSENAME(REPLACE(price, ' ', '.'),2)
from Airbnb.dbo.nycdata;

-- Membuat table Price_dollars
Alter table dbo.nycdata
	ADD price_dollar int;

-- Update Columns data
UPDATE dbo.nycdata
SET price_dollar = PARSENAME(REPLACE(price, ' ', '.'),2);

select * from dbo.nycdata;


-- ---------------------------------------------------------------------------------------------

-- Memisahkan kolom neighborhood_full (Split Neighbourhood_full field)

select * from dbo.nycdata;
select neighborhood_full from dbo.nycdata;

select neighborhood_full, 
		PARSENAME(REPLACE(neighborhood_full, ',', '.'), 2) as County,
		PARSENAME(REPLACE(neighborhood_full, ',', '.'), 1) as city
		from dbo.nycdata;

-- Membuat 2 kolom table neighborhood_county_group, neighborhood

alter table dbo.nycdata
	add neighborhood_county_group nvarchar(100), neighborhood nvarchar(20);

alter table dbo.nycdata
	alter column neighborhood nvarchar(100);

-- Update table
Update dbo.nycdata
SET neighborhood_county_group = PARSENAME(REPLACE(neighborhood_full, ',', '.'), 2);

Update dbo.nycdata
SET neighborhood = PARSENAME(REPLACE(neighborhood_full, ',', '.'), 1);

select neighborhood_county_group, neighborhood from dbo.nycdata;


-- ---------------------------------------------------------------------------------------------

-- Menghapus Kolom (Delete Column)

Alter table dbo.nycdata
	DROP COLUMN price, neighborhood_full,description;

select * from dbo.nycdata;


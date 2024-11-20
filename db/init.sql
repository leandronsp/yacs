CREATE EXTENSION pg_trgm;

CREATE TABLE geonames (geoname_id integer PRIMARY KEY, name varchar(200), ascii_name varchar(200), alternate_names varchar(10000), latitude float8, longitude float8, feature_class char(1),
feature_code varchar(10), country_code varchar(2), cc2 varchar(200), admin1_code varchar(20), admin2_code varchar(80), admin3_code varchar(20), admin4_code varchar(20), population bigint, elevation
varchar(100), dem varchar(200), timezone varchar(40), modification_date date);

CREATE TABLE admin_codes (code varchar(50), name varchar(200), ascii_name varchar(200), geoname_id integer);
CREATE TABLE feature_codes (code varchar(50), feature_code_description varchar(1000), feature_class_description varchar(1000));

CREATE TABLE countries_info (isocode varchar(5), isocode3 varchar(5), iso_numeric varchar(10), fips varchar(5), country varchar(200), capital varchar(200), area varchar(50), population bigint,
continent varchar(10), tld varchar(10), currency_code varchar(20), currency_name varchar(50), phone varchar(20), postal_code_format varchar(200), postal_code_regex varchar(300), languages
varchar(100), geoname_id integer, neighbours varchar(80), equivalent_fips_code varchar(50));

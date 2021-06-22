## Yacs

Yet another City search.

### Development

Console:
```
make console
```

Testing:
```
make utest
```
Notes:
```
- make db (database up)
- docker exec -it yacs-db bash (enter db container)
- apt-get update && apt-get install unzip wget
- wget https://download.geonames.org/export/dump/allCountries.zip
- wget https://download.geonames.org/export/dump/admin1CodesASCII.txt
- wget https://download.geonames.org/export/dump/admin2Codes.txt
- wget https://download.geonames.org/export/dump/featureCodes_en.txt
- wget https://download.geonames.org/export/dump/countryInfo.txt
- unzip allCountries.zip
- psql -U yacsdev yacs

------

CREATE TABLE geonames (geoname_id integer PRIMARY KEY, name varchar(200), ascii_name varchar(200), alternate_names varchar(10000), latitude float8, longitude float8, feature_class char(1),
feature_code varchar(10), country_code varchar(2), cc2 varchar(200), admin1_code varchar(20), admin2_code varchar(80), admin3_code varchar(20), admin4_code varchar(20), population bigint, elevation
varchar(100), dem varchar(200), timezone varchar(40), modification_date date);

CREATE TABLE admin_codes (code varchar(50), name varchar(200), ascii_name varchar(200), geoname_id integer);
CREATE TABLE feature_codes (code varchar(50), feature_code_description varchar(1000), feature_class_description varchar(1000));

CREATE TABLE countries_info (isocode varchar(5), isocode3 varchar(5), iso_numeric varchar(10), fips varchar(5), country varchar(200), capital varchar(200), area varchar(50), population bigint,
continent varchar(10), tld varchar(10), currency_code varchar(20), currency_name varchar(50), phone varchar(20), postal_code_format varchar(200), postal_code_regex varchar(300), languages
varchar(100), geoname_id integer, neighbours varchar(80), equivalent_fips_code varchar(50));

CREATE EXTENSION pg_trgm;

COPY geonames FROM '/allCountries.txt';
COPY admin_codes FROM '/admin1CodesASCII.txt';
COPY admin_codes FROM '/admin2Codes.txt';
COPY feature_codes FROM '/featureCodes_en.txt';
COPY countries_info FROM '/countryInfo.txt';

CREATE INDEX geonames_search_idx ON geonames USING GIN (to_tsvector('simple', name || ' ' || alternate_names));
```

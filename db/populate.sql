COPY geonames FROM '/db/allCountries.txt';
COPY admin_codes FROM '/db/admin1CodesASCII.txt';
COPY admin_codes FROM '/db/admin2Codes.txt';
COPY feature_codes FROM '/db/featureCodes_en.txt';
COPY countries_info FROM '/db/countryInfo.txt';
CREATE INDEX geonames_search_idx ON geonames USING GIN (to_tsvector('simple', name || ' ' || alternate_names));

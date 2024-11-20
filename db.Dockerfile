FROM postgres:14 AS build
WORKDIR /db

RUN apt update && apt install -y unzip wget
RUN wget https://download.geonames.org/export/dump/allCountries.zip
RUN wget https://download.geonames.org/export/dump/admin1CodesASCII.txt
RUN wget https://download.geonames.org/export/dump/admin2Codes.txt
RUN wget https://download.geonames.org/export/dump/featureCodes_en.txt
RUN wget https://download.geonames.org/export/dump/countryInfo.txt
RUN sed -i '/^#/d' /db/countryInfo.txt
RUN unzip /db/allCountries.zip

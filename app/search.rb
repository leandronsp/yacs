require 'json'
require_relative './database'

class Search
  def self.call(term) 
    new(term).call
  end

  def initialize(term)
    @term = term
    @conn = Database.connection
  end

  def call
    result = @conn.exec(query)

    result.entries.map do |entry|
      entry.each_with_object({}) do |(key, value), acc|
        acc[key.to_sym] = value
      end
    end
  end

  def query
    """
    SELECT
      DISTINCT(geonames.geoname_id),
      geonames.geoname_id,
      geonames.name,
      geonames.feature_class,
      geonames.feature_code,
      geonames.country_code,
      geonames.admin1_code,
      geonames.admin2_code,
      geonames.population,
      geonames.timezone,
      feature_codes.feature_class_description,
      feature_codes.feature_code_description,
      admin_codes.name AS admin_code_name,
      countries_info.country,
      ts_rank(
        to_tsvector('simple', geonames.name || ' ' || geonames.alternate_names),
        plainto_tsquery('simple', '#{@term}')
      ) * LOG(COALESCE(NULLIF(geonames.population, 0), 1)) AS rank_score
    FROM
      geonames
    JOIN
      feature_codes ON feature_codes.code = geonames.feature_class || '.' || geonames.feature_code
    LEFT JOIN
      admin_codes ON admin_codes.code = geonames.country_code || '.' || geonames.admin1_code
    JOIN
      countries_info ON countries_info.isocode = geonames.country_code
    WHERE
      to_tsvector('simple', geonames.name || ' ' || geonames.alternate_names) @@ plainto_tsquery('simple', '#{@term}')
    ORDER BY 
      rank_score DESC
    LIMIT 5
    """
  end
end

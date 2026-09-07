module Geo
  DATA = {
    "Europe" => {
      "Switzerland" => {
        "Basel-Stadt" => [ "Basel", "Riehen", "Bettingen" ],
        "Zürich" => [ "Zürich", "Winterthur", "Uster" ]
      },
      "Germany" => {
        "Bavaria" => [ "Munich", "Nuremberg" ],
        "Berlin" => [ "Berlin" ]
      }
    },
    "North America" => {
      "USA" => {
        "California" => [ "San Francisco", "Los Angeles", "San Diego" ],
        "New York" => [ "New York City", "Buffalo" ]
      },
      "Canada" => {
        "Ontario" => [ "Toronto", "Ottawa" ],
        "Quebec" => [ "Montreal", "Quebec City" ]
      }
    },
    "Asia" => {
      "Japan" => {
        "Kantō" => [ "Tokyo", "Yokohama" ],
        "Kansai" => [ "Osaka", "Kyoto" ]
      }
    }
  }.freeze

  def self.continents
    DATA.keys
  end

  def self.countries(continent)
    DATA.fetch(continent, {}).keys
  end

  def self.states(continent, country)
    DATA.dig(continent, country)&.keys || []
  end

  def self.cities(continent, country, state)
    DATA.dig(continent, country, state) || []
  end

  def self.all_cities
    DATA.values.flat_map { |countries| countries.values.flat_map { |states| states.values.flatten } }
  end

  def self.continent_city_counts
    counts = DATA.transform_values { |countries| countries.values.flat_map(&:values).flatten.size }
    most = counts.values.max

    counts.map do |continent, count|
      { name: continent, count: count, percent: (count * 100.0 / most).round }
    end
  end

  def self.slow_stats
    sleep 0.6

    cities = all_cities.size
    countries = DATA.values.flat_map(&:keys).uniq.size

    "#{cities} cities across #{countries} countries on #{DATA.size} continents."
  end

  def self.slow_facts
    sleep 0.6

    largest = DATA.max_by { |_, countries| countries.values.flat_map(&:values).flatten.size }

    "#{largest[0]} holds the most cities in this data set."
  end

  def self.locate(city)
    return "" if city.to_s.empty?

    DATA.each do |continent, countries|
      countries.each do |country, states|
        states.each do |state, cities|
          return "#{city} is in #{state}, #{country} (#{continent})" if cities.include?(city)
        end
      end
    end

    "Nowhere to be found"
  end
end

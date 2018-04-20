class IMDB
  BASE_URL = 'https://www.imdb.com/'.freeze
  @cache = WebCache.new

  def self.birthday_search(month: 0, day: 0)
    raise(ArgumentError, 'Invalid Date') if invalid_date?(month.to_i, day.to_i)

    people_divs = birthday_request(month, day)

    Parallel.map(people_divs, in_processes: 50) do |person_div|
      {
        name:          extract_name(person_div),
        photoUrl:      extract_photo(person_div),
        profileUrl:    extract_profile_url(person_div),
        mostKnownWork: movie_data(extract_movie_url(person_div))
      }
    end
  end

  class << self
    private

    def invalid_date?(month, day)
      # 2016 was the last leap year, used to check if month + day actually exist
      !Date.valid_date?(2016, month, day)
    end

    def birthday_request(month, day)
      response = @cache.get(search_url(month, day))
      Nokogiri::HTML(response.content).css('.lister-item')
    end

    def search_url(month, day)
      BASE_URL + "/search/name?birth_monthday=#{month}-#{day}"
    end

    def extract_name(person_element)
      person_element.css('.lister-item-header a').first.children.text.strip
    end

    def extract_photo(person_element)
      person_element.css('.lister-item-image img').first.attributes['src'].value
    end

    def extract_profile_url(person_element)
      BASE_URL + person_element.css('.lister-item-header a')
                               .first.attributes['href']
                               .value
    end

    def extract_movie_url(person_element)
      BASE_URL + person_element.css('p a').first['href']
    end

    def movie_data(movie_url)
      response = Nokogiri::HTML(@cache.get(movie_url).content)

      {
        title:    title(response),
        url:      movie_url,
        rating:   rating(response),
        director: director(response)
      }
    end

    def title(movie_data)
      movie_data.css('h1').children.first.to_s.gsub('\u00A0', '').strip
    end

    def rating(movie_data)
      movie_data.css('span[itemprop=ratingValue]').text.to_f
    end

    def director(movie_data)
      movie_data.css('span[itemprop=director]').text.strip
    end
  end
end

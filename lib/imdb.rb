class IMDB
  BASE_URL = 'https://www.imdb.com/'

  def self.people_by_birthday(month: nil, day: nil)
    raise(ArgumentError, 'Invalid Date') if !Date.valid_date?(2016, month.to_i, day.to_i)

    response    = open(search_url(month, day))
    people_divs = Nokogiri::HTML(response).css('.lister-item').first(10)

    people = people_divs.map do |person_div|
               {
                 name:       extract_name(person_div),
                 photoUrl:   extract_photo(person_div),
                 profileUrl: profile_url(person_div),
                 mostKnownWork: movie_data(movie_url(person_div))
               }
             end
  end

  private

  def self.search_url(month, day)
    BASE_URL + "/search/name?birth_monthday=#{month}-#{day}"
  end

  def self.extract_name(person_element)
    person_element.css('.lister-item-header a').first.children.text.strip
  end

  def self.extract_photo(person_element)
    person_element.css('.lister-item-image img').first.attributes["src"].value
  end

  def self.profile_url(person_element)
    BASE_URL + person_element.css('.lister-item-header a').first.attributes['href'].value
  end

  def self.movie_url(person_element)
    BASE_URL + person_element.css("p a").first["href"]
  end

  def self.movie_data(movie_url)
    response = Nokogiri(open(movie_url))

    {
      title:    title(response),
      url:      movie_url,
      rating:   rating(response),
      director: director(response)
    }
  end

  def self.title(movie_data)
    movie_data.css("h1").children.first.to_s.gsub("\u00A0", "").strip
  end

  def self.rating(movie_data)
    movie_data.css("span[itemprop=ratingValue]").text.to_f
  end

  def self.director(movie_data)
    movie_data.css("span[itemprop=director]").text.strip
  end
end

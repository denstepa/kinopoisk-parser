class KinopoiskWorker

  require 'open-uri'
  require 'mechanize'
  require './kinopoisk_page_parser.rb'
  require './models/film.rb'

  URL = "http://www.kinopoisk.ru/"
  FORMNAME = "searchForm"

  def initialize
    @agent = Mechanize.new { |a|
      a.user_agent_alias = 'Mac Safari'
    }
  end

  def process_film(film_title)
    page = search_film(film_title)
    film = retreive_data(page)
    save_poster(film)
    save_table(film)
    film.save
  end

  def search_film(film)
    @agent.get(URL) do |page|
      search_result = page.form_with(:name => FORMNAME) do |search|
        search.kp_query film
        search.first = 'yes'
      end.submit 
      return search_result
    end
  end

  def retreive_data(page)
    kfp = KinopoiskPageParser.new(page)
    film = Film.new
    KinopoiskPageParser.instance_methods(false).each do |method|
      film[method] = kfp.send(method)
    end
    film.kinopoisk_id = get_page_id(page)
    set_page_local_path(film, page)
    return film
  end

  def get_page_id(page)
    page.canonical_uri.to_s.split('/').last
  end

  def set_page_local_path(film, page)
    film.page_url = page.save("data/pages/#{film.kinopoisk_id}.html")
  end

  def save_poster(film)
    local_url = @agent.get(film.poster_url).save!("data/posters/#{film.kinopoisk_id}.jpg")
    film.poster_url = local_url
  end

  def save_table(film)
    File.open("data/additional_data/#{film.kinopoisk_id}.html", File::CREAT|File::TRUNC|File::RDWR) do |file|
      file.write film.info_table.to_html
      film.info_table = file.path
    end
    
  end
end

film_title = "Good Year"
kp = KinopoiskWorker.new
film = kp.process_film film_title
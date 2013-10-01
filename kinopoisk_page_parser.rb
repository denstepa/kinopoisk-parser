class KinopoiskPageParser

  require 'nokogiri'
 
  def initialize(page)
    @page = page.parser
    @main_container = @page.css('#viewFilmInfoWrapper')
  end

  def russian_title
    @main_container.css('h1.moviename-big').text
  end

  def english_title
    @main_container.xpath('//span[@itemprop="alternativeHeadline"]').text
  end

  def poster_url
    image_url = @main_container.css('a.popupBigImage').first['onclick'].split("'")[1]
  end
  
  def description
    @main_container.xpath('//div[@itemprop="description"]').text
  end

  def raiting
    @main_container.xpath('//meta[@itemprop="ratingValue"]').first['content'].to_f
  end

  def triller_url
    script = @page.xpath('//script').select { |script| script.to_s.include?('trailerFile') }.first
    line = script.to_s.split(' ').select { |line| line =~ /.mov/ }.first
    return 'http://tr.kinopoisk.ru/' + line.split('"')[1]
  end

  def info_table
    @main_container.css('#infoTable')
  end

  def release_year
    info_table.css('td a')[0].text.to_i
  end

  def countries
    info_table.css('td')[3].css('a').to_a.map{ |country| country.text}.join(",")
  end

  def director
    @main_container.xpath('//td[@itemprop="director"]').text
  end

  def producer
    @main_container.xpath('//td[@itemprop="producer"]').text
  end

  def genres
    @main_container.xpath('//span[@itemprop="genre"]').text
  end

  def actors
    actors_list = @main_container.xpath('//li[@itemprop="actors"]').to_a.map{ |item| item.text }
    actors_list.split("...").first.join(",")
  end

end
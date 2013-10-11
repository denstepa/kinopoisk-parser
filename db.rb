require "sequel"
require 'yaml'

class Db

  def self.create_tables
    dbconf = YAML::load(File.open('config/database.yml'))
    @db = Sequel.connect(dbconf)

    unless @db.table_exists? :films
      @db.create_table :films do
        primary_key  :id
        String   :file_path
        String   :file_name
        String   :russian_title
        String   :english_title
        String   :kinopoisk_id
        String   :release_year
        String   :poster_url
        Text     :description
        Double   :raiting
        String   :triller_url
        String   :info_table
        String   :countries
        String   :director
        String   :producer
        String   :genres
        String   :actors
        String   :page_url
        DateTime :updated_at
	Boolean  :isparsed
      end
    end

  end

  def self.drop_tables
    dbconf = YAML::load(File.open('config/database.yml'))
    @db = Sequel.connect(dbconf)

    @db.drop_table(:films)
  end
end

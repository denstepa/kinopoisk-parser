require 'rubygems'  
require 'active_record'  
require 'yaml'

ActiveRecord::Base.establish_connection(  
  YAML::load(File.open('config/database.yml'))
)  
  
class Film < ActiveRecord::Base  

end  
require 'rubygems'
require 'active_record'
require 'yaml'
 
# Загружаем файл настройки соединения с БД
dbconfig = YAML::load(File.open(File.join(File.dirname(__FILE__), 'database.yml')))
 
# Ошибки работы с БД направим в стандартный поток (консоль)
ActiveRecord::Base.logger = Logger.new(STDERR) # Simple logging utility. logger.rb -- standart lib
 
# Соединяемся с БД
ActiveRecord::Base.establish_connection(dbconfig)
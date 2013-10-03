
class FilesScanner

  VALID_EXTENSIONS = %w{.mpeg .avi .mov}

  @directories = []

  def add_dir(dir_name)
    @directories << dir_name
  end

  def scan
    curent_dir = @directories.first
    Dir.entries(curent_dir).each do |dir_entry|
      puts dir_entry if is_movie?(curent_dir + '/' + dir_entry) 
    end
  end

  def is_movie?(filename)
    puts filename
    return false unless File.file?(filename)
    return true if File.size?(filename)
    return true if VALID_EXTENSIONS.include?(File.extname(filename))
    return false
  end

end

fs = FilesScanner.new

if ARGV.size > 0
  ARGV.each  do |dir_name|
    fs.add_dir(dir_name)
  end
else
  fs.add_dir("/home/denis/films")
end

fs.scan
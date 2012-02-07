require "digest"
require "pathname"

@root = Pathname.new(File.expand_path(File.dirname(__FILE__) + "/../../../.."))

task :default => :resourceful

desc "Generate world config (default)"
task :resourceful do
  load File.join(File.dirname(__FILE__), "resourceful", "init.rb")
end

desc "Generate world config and run server"
task :server => :resourceful do
  server_script = @root.join("script", "server")
  Dir.chdir(@root.to_s)
  system server_script.to_s
end

desc "Remove generated world"
task :clean do
  clean_script = @root.join("script", "clean")
  Dir.chdir(@root.to_s)
  system clean_script.to_s
end

desc "Set a random level seed"
task :reseed do
  properties_path = @root.join("server.properties")
  if !properties_path.exist?
    $stderr.puts "Error: #{properties} does not exist"
    exit 1
  end
  
  seed = Time.new.to_i.to_s
  white_list = @root.join("white-list.txt")
  seed << white_list.read if white_list.exist?
  seed = Digest::MD5.hexdigest(seed)
  
  properties = properties_path.read.split(/[\r\n]+/).inject({}) do |hash, line|
    key, value = line.split("=")
    hash[key] = value || ""
    hash
  end
  
  properties["level-seed"] = seed
  
  properties_path.open("w") do |f|
    properties.each do |key, value|
      f.puts "#{key}=#{value}"
    end
  end
end

desc "Generate world config, run server and clean up afterward"
task :test => [:reseed, :server, :clean]

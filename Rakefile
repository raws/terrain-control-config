task :default => :resourceful

desc "Generate world config (default)"
task :resourceful do
  load File.join(File.dirname(__FILE__), "resourceful", "init.rb")
end

desc "Generate world config and run server"
task :server => :resourceful do
  server_script_path = File.join(File.dirname(__FILE__), "..", "..", "..", "..", "server")
  system server_script_path
end

desc "Remove generated world"
task :clean do
  clean_script_path = File.join(File.dirname(__FILE__), "..", "..", "..", "..", "clean")
  Dir.chdir(File.dirname(clean_script_path))
  system clean_script_path
end

desc "Generate world config, run server and clean up afterward"
task :test => [:server, :clean]

task :default => :resourceful

desc "Generate world config (default)"
task :resourceful do
  load File.join(File.dirname(__FILE__), "resourceful", "init.rb")
end

desc "Generate world config and run server"
task :server => :resourceful do
  server_script_path = File.join(File.dirname(__FILE__), "..", "..", "..", "..", "server")
  exec server_script_path
end

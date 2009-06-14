require 'yard'

desc "Creates documentation for the application's RESTful routes"
task :restdoc => :environment do
  require 'rest_doc'
  
  controller_files = Dir.glob(File.join(RAILS_ROOT, "app", "controllers", "*"))
  RestDoc::RestYardoc.run(*controller_files)  
end

desc "Creates documentation for the application's RESTful routes"
task :restdoc => :environment do
  # def template_exists_for(controller, action)
  #   not Dir.glob(File.join(RAILS_ROOT, "app", "views", controller, "#{action}.*")).empty?
  # end

  # ActionController::Routing::Routes.routes.each do |route|
  #   puts route.pretty_inspect
  #   if route.defaults.has_key?(:controller) && route.defaults.has_key?(:action)
  #     puts "\n\n\nRoute with controller and action:"
  #     puts process_route(route)
  #   end
  # end

  # def process_route(route)
  #   controller_class = (route.defaults[:controller] + "Controller").camelize
  #   return controller_class if controller_class.constantize.new.respond_to?(route.defaults[:action])
  # 
  #   puts "#{controller_class.to_s} does not respond to '#{route.defaults[:action]}' as needed for #{route.defaults.inspect}"
  # rescue NameError => error
  #   puts "#{controller_class.to_s} does not exist, it is needed for #{route.defaults.inspect}"
  # end

  puts "Hola Cholo\n\n\n"
  
  controller_files = Dir.glob(File.join(RAILS_ROOT, "app", "controllers", "*")).join(" ")
  
  puts controller_files.pretty_inspect

  require 'restdoc/restdoc'
  
  rest_doc = RestDoc::RestDoc.new
  rest_doc.document(controller_files)
end
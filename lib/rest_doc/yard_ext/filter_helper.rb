module YARD::Generators::Helpers::FilterHelper
  def is_restful_action?(object)
    route_hash = routes
    route_hash.has_key?(object.parent.to_s) && route_hash[object.parent.to_s].include?(object.name.to_s)
  end

  def routes
    route_hash = {}
    ActionController::Routing::Routes.routes.each do |route|
      if route.defaults.has_key?(:controller) && route.defaults.has_key?(:action)
        controller_class = (route.defaults[:controller] + "Controller").camelize
        route_hash[controller_class] = [] if !route_hash.has_key?(controller_class) 
        route_hash[controller_class] << route.defaults[:action]
      end
    end
    route_hash
  end
  
end
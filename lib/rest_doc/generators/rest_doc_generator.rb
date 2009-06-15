require 'erb'

module RestDoc
  module Generators
    class RestDocGenerator < YARD::Generators::FullDocGenerator
      attr_reader :controller_list
      attr_reader :route_hash
      
      before_generate :is_namespace?
      before_list :setup_options
      before_list :generate_assets
      before_list :generate_index
      before_list :generate_files
      before_list :generate_rest_index

      def sections_for(object) 
        case object    
        when YARD::CodeObjects::ClassObject
          [:header, [G(RestClassGenerator)]]
        else
          super
        end
      end
  
      def generator_name
        'fulldoc'
      end
  
      protected

      def extra_files
        ["rest_index"] + super
      end

      def methods_to_show(namespaces)
        super.select{|object| is_restful_action?(object)}
      end

      def generate_rest_index(all_objects)
        @route_hash = load_routes_hash
        @controller_list = route_hash.keys.sort
        
        template = File.read(TEMPLATE_ROOT + "/rest_doc/routes_index.erb")
        rhtml = ERB.new(template)
        serializer.serialize 'rest_index.html', rhtml.result(binding)
        true
      end

      def load_routes_hash
        route_hash = {}
        ActionController::Routing::Routes.routes.each do |route|
          controller = route.requirements[:controller]
          controller ||= "default"
          action = route.requirements[:action]
          action ||= "default"
          route_hash[controller] ||= {}
          route_hash[controller][action] = route
        end
        route_hash
      end

=begin
      Route: 
      <ActionController::Routing::Route:0x120be20 
        @optimise=false, 
        @conditions={:method=>:get}, 
        @action_requirement="edit", 
        @defaults={:controller=>"poinky_things", :action=>"edit"}, 
        @requirements={:controller=>"poinky_things", :action=>"edit"}, 
        @controller_requirement="poinky_things", 
        @matching_prepared=true, 
        @significant_keys=[:id, :format, :controller, :action], 
        @parameter_shell={:controller=>"poinky_things", :action=>"edit"}, 
        @segments=[
          <ActionController::Routing::DividerSegment:0x120ca8c @value="/", @raw=true, @is_optional=false>, 
          <ActionController::Routing::StaticSegment:0x120c9d8 @value="poinky_things", @is_optional=false>, 
          <ActionController::Routing::DividerSegment:0x120c910 @value="/", @raw=true, @is_optional=false>, 
          <ActionController::Routing::DynamicSegment:0x120c834 @regexp=/[^\/.?]+/, @key=:id, @is_optional=false>, 
          <ActionController::Routing::DividerSegment:0x120c758 @value="/", @raw=true, @is_optional=false>, 
          <ActionController::Routing::StaticSegment:0x120c6b8 @value="edit", @is_optional=false>, 
          <ActionController::Routing::OptionalFormatSegment:0x120c640 @key=:format, @is_optional=true>], 
        @to_s="GET    /poinky_things/:id/edit(.:format)?       {:controller=>\"poinky_things\", :action=>\"edit\"}">


  Route Hash: {
    nil => {
      nil => #<ActionController::Routing::Route:0x1197f20 @parameter_shell={}, @to_s="ANY    /:controller/:action/:id(.:format)?      {}", @optimise=false, @conditions={}, @requirements={}, @action_requirement=nil, @defaults={:action=>"index"}, @controller_requirement=nil, @matching_prepared=true, @significant_keys=[:controller, :action, :id, :format], @segments=[
            #<ActionController::Routing::DividerSegment:0x119ac20 @is_optional=false, @value="/", @raw=true>, 
            #<ActionController::Routing::ControllerSegment:0x119a6bc @is_optional=false, @key=:controller>, 
            #<ActionController::Routing::DividerSegment:0x119a3d8 @is_optional=true, @value="/", @raw=true>, 
            #<ActionController::Routing::DynamicSegment:0x1199dfc @is_optional=true, @key=:action, @default="index">, 
            #<ActionController::Routing::DividerSegment:0x119994c @is_optional=true, @value="/", @raw=true>, 
            #<ActionController::Routing::DynamicSegment:0x11995f0 @is_optional=true, @key=:id>, 
            #<ActionController::Routing::OptionalFormatSegment:0x1199334 @is_optional=true, @key=:format>]>
        }, 
      "poinky_things" => {
          "new" => #<ActionController::Routing::Route:0x122c88c @parameter_shell={:controller=>"poinky_things", :action=>"new"}, @to_s="GET    /poinky_things/new(.:format)?            {:controller=>\"poinky_things\", :action=>\"new\"}", @optimise=true, @conditions={:method=>:get}, @requirements={:controller=>"poinky_things", :action=>"new"}, @action_requirement="new", @defaults={:controller=>"poinky_things", :action=>"new"}, @controller_requirement="poinky_things", @matching_prepared=true, @significant_keys=[:format, :controller, :action], @segments=[#<ActionController::Routing::DividerSegment:0x1230644 @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::StaticSegment:0x12303c4 @is_optional=false, @value="poinky_things">, #<ActionController::Routing::DividerSegment:0x122fde8 @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::StaticSegment:0x122fc80 @is_optional=false, @value="new">, #<ActionController::Routing::OptionalFormatSegment:0x122fc08 @is_optional=true, @key=:format>]>, 
          "edit" => #<ActionController::Routing::Route:0x120b588 @parameter_shell={:controller=>"poinky_things", :action=>"edit"}, @to_s="GET    /poinky_things/:id/edit(.:format)?       {:controller=>\"poinky_things\", :action=>\"edit\"}", @optimise=false, @conditions={:method=>:get}, @requirements={:controller=>"poinky_things", :action=>"edit"}, @action_requirement="edit", @defaults={:controller=>"poinky_things", :action=>"edit"}, @controller_requirement="poinky_things", @matching_prepared=true, @significant_keys=[:id, :format, :controller, :action], @segments=[#<ActionController::Routing::DividerSegment:0x120c35c @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::StaticSegment:0x120c140 @is_optional=false, @value="poinky_things">, #<ActionController::Routing::DividerSegment:0x120bf9c @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::DynamicSegment:0x120befc @is_optional=false, @regexp=/[^\/.?]+/, @key=:id>, #<ActionController::Routing::DividerSegment:0x120be48 @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::StaticSegment:0x120bda8 @is_optional=false, @value="edit">, #<ActionController::Routing::OptionalFormatSegment:0x120bd30 @is_optional=true, @key=:format>]>, 
          "destroy"=>#<ActionController::Routing::Route:0x11e142c @parameter_shell={:controller=>"poinky_things", :action=>"destroy"}, @to_s="DELETE /poinky_things/:id(.:format)?            {:controller=>\"poinky_things\", :action=>\"destroy\"}", @optimise=false, @conditions={:method=>:delete}, @requirements={:controller=>"poinky_things", :action=>"destroy"}, @action_requirement="destroy", @defaults={:controller=>"poinky_things", :action=>"destroy"}, @controller_requirement="poinky_things", @matching_prepared=true, @significant_keys=[:id, :format, :controller, :action], @segments=[#<ActionController::Routing::DividerSegment:0x11e340c @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::StaticSegment:0x11e3308 @is_optional=false, @value="poinky_things">, #<ActionController::Routing::DividerSegment:0x11e31dc @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::DynamicSegment:0x11e30ec @is_optional=false, @regexp=/[^\/.?]+/, @key=:id>, #<ActionController::Routing::OptionalFormatSegment:0x11e3038 @is_optional=true, @key=:format>]>, 
          "show"=>#<ActionController::Routing::Route:0x11fa60c @parameter_shell={:controller=>"poinky_things", :action=>"show"}, @to_s="GET    /poinky_things/:id(.:format)?            {:controller=>\"poinky_things\", :action=>\"show\"}", @optimise=false, @conditions={:method=>:get}, @requirements={:controller=>"poinky_things", :action=>"show"}, @action_requirement="show", @defaults={:controller=>"poinky_things", :action=>"show"}, @controller_requirement="poinky_things", @matching_prepared=true, @significant_keys=[:id, :format, :controller, :action], @segments=[#<ActionController::Routing::DividerSegment:0x11fd1f4 @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::StaticSegment:0x11fd0c8 @is_optional=false, @value="poinky_things">, #<ActionController::Routing::DividerSegment:0x11fcce0 @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::DynamicSegment:0x11fcc40 @is_optional=false, @regexp=/[^\/.?]+/, @key=:id>, #<ActionController::Routing::OptionalFormatSegment:0x11fca9c @is_optional=true, @key=:format>]>, 
          "index"=>#<ActionController::Routing::Route:0x127a280 @parameter_shell={:controller=>"poinky_things", :action=>"index"}, @to_s="GET    /poinky_things(.:format)?                {:controller=>\"poinky_things\", :action=>\"index\"}", @optimise=true, @conditions={:method=>:get}, @requirements={:controller=>"poinky_things", :action=>"index"}, @action_requirement="index", @defaults={:controller=>"poinky_things", :action=>"index"}, @controller_requirement="poinky_things", @matching_prepared=true, @significant_keys=[:format, :controller, :action], @segments=[#<ActionController::Routing::DividerSegment:0x127b02c @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::StaticSegment:0x127af3c @is_optional=false, @value="poinky_things">, #<ActionController::Routing::OptionalFormatSegment:0x127add4 @is_optional=true, @key=:format>]>, 
          "create"=>#<ActionController::Routing::Route:0x123ba6c @parameter_shell={:controller=>"poinky_things", :action=>"create"}, @to_s="POST   /poinky_things(.:format)?                {:controller=>\"poinky_things\", :action=>\"create\"}", @optimise=true, @conditions={:method=>:post}, @requirements={:controller=>"poinky_things", :action=>"create"}, @action_requirement="create", @defaults={:controller=>"poinky_things", :action=>"create"}, @controller_requirement="poinky_things", @matching_prepared=true, @significant_keys=[:format, :controller, :action], @segments=[#<ActionController::Routing::DividerSegment:0x123ca34 @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::StaticSegment:0x123c96c @is_optional=false, @value="poinky_things">, #<ActionController::Routing::OptionalFormatSegment:0x123c8a4 @is_optional=true, @key=:format>]>, 
          "update"=>#<ActionController::Routing::Route:0x11ec228 @parameter_shell={:controller=>"poinky_things", :action=>"update"}, @to_s="PUT    /poinky_things/:id(.:format)?            {:controller=>\"poinky_things\", :action=>\"update\"}", @optimise=false, @conditions={:method=>:put}, @requirements={:controller=>"poinky_things", :action=>"update"}, @action_requirement="update", @defaults={:controller=>"poinky_things", :action=>"update"}, @controller_requirement="poinky_things", @matching_prepared=true, @significant_keys=[:id, :format, :controller, :action], @segments=[#<ActionController::Routing::DividerSegment:0x11ed510 @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::StaticSegment:0x11ed164 @is_optional=false, @value="poinky_things">, #<ActionController::Routing::DividerSegment:0x11ed060 @is_optional=false, @value="/", @raw=true>, #<ActionController::Routing::DynamicSegment:0x11ecf70 @is_optional=false, @regexp=/[^\/.?]+/, @key=:id>, #<ActionController::Routing::OptionalFormatSegment:0x11ecca0 @is_optional=true, @key=:format>]>
        }
      }

=end

    end
  end
end
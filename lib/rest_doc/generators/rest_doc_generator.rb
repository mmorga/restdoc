module RestDoc
  module Generators
    class RestDocGenerator < YARD::Generators::FullDocGenerator
      before_generate :is_namespace?
      before_list :setup_options
      before_list :generate_assets
      before_list :generate_index
      before_list :generate_files

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

      def methods_to_show(namespaces)
        super.select{|object| is_restful_action?(object)}
      end

    end
  end
end
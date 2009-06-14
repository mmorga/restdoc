require 'yard'

module RestDoc
  module Generators
    class RestDocGenerator < YARD::Generators::FullDocGenerator
      def sections_for(object) 
        case object    
        when CodeObjects::ClassObject
          [:header, [G(RestClassGenerator)]]
        else
          super
        end
      end
  
      private

      def is_method?(object)
        object.is_a?(MethodObject)
      end
    end
  end
end
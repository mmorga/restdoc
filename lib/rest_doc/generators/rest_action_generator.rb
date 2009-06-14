require 'yard'

module RestDoc
  module Generators
    class RestActionGenerator < YARD::Generators::MethodGenerator
      # include Helpers::MethodHelper

      before_generate :is_rest_action?
  
      def sections_for(object) 
        [
          :header,
          [
            :title,
            G(MethodSignatureGenerator),
            G(DeprecatedGenerator), 
            G(DocstringGenerator), 
            G(TagsGenerator), 
            G(OverloadsGenerator),
          ]
        ]
      end
  
      protected

      # def isnt_overload?(object)
      #   !object.is_a?(Tags::OverloadTag)
      # end
  
      def is_rest_action?(object)
        puts "Is Rest Action #{object.pretty_inspect}\n\n\n"
        true
      end
    end
  end
end

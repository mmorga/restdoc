module RestDoc
  module Generators
    class RestClassGenerator < YARD::Generators::ClassGenerator
  
      def sections_for(object) 
        [
          :header,
          [
            G(YARD::Generators::InheritanceGenerator), 
            G(YARD::Generators::MixinsGenerator, :scope => :class),
            G(YARD::Generators::MixinsGenerator, :scope => :instance),
            G(YARD::Generators::DocstringGenerator), 
            G(YARD::Generators::TagsGenerator),
            G(YARD::Generators::MethodDetailsGenerator, :visibility => :public, :scope => :instance)
          ]
        ]
      end
      
      def generator_name
        'class'
      end
      
    end
  end
end


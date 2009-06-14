require 'yard'

module RestDoc
  module Generators
    class RestClassGenerator < YARD::Generators::ClassGenerator
      before_section :foo, :is_method?
      # before_generate :is_class?
  
      def sections_for(object) 
        [
          :header,
          [
            G(InheritanceGenerator), 
            G(MixinsGenerator, :scope => :class),
            G(MixinsGenerator, :scope => :instance),
            G(DocstringGenerator), 
            G(TagsGenerator),
            # G(AttributesGenerator), 
            # G(ConstantsGenerator),
            # G(ConstructorGenerator),
            # G(MethodMissingGenerator),
            G(RestActionGenerator),
            # G(VisibilityGroupGenerator, :visibility => :protected),
            # G(VisibilityGroupGenerator, :visibility => :private)
          ]
        ]
      end
    end
  end
end


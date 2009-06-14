# require 'rest_doc/rest_doc'
# require 'rest_doc/generators/rest_doc_generator'
# require 'rest_doc/generators/rest_class_generator'
# require 'rest_doc/generators/rest_action_generator'
# require 'rdoc/rdoc'
# require 'rdoc/options'
# require 'rdoc/generators/html_generator'


# class RestDoc::RestDoc
#   GENERATOR = Struct.new(:file_name, :class_name, :key)
#   GENERATORS = {'html' => GENERATOR.new("rdoc/generators/html_generator",
#                                    "HtmlGenerator".intern,
#                                    "html")}
#   
#   def document(args)
#     top_level = RDoc::TopLevel.new(args)
# 
#     context = RDoc::Context.new
# 
#     @stats = RDoc::Stats.new
# 
#     content = File.open(fn, "r") {|f| f.read}
# 
#     options = Options.instance
# 
# 
#     options.parse([], GENERATORS)
#                                  
#     parser = RDoc::ParserFactory.parser_for(top_level, fn, content, options, @stats)
# 
#     scanned = parser.scan
#     puts "\n\nPublic Methods:"
#     puts scanned.public_methods.sort
#     puts "\n\n\nClass Modules:"
#     scanned.each_classmodule do |classmodule| 
#       puts "\nClass Module:"
#       puts classmodule 
#       puts "\nMethods:"
#       classmodule.each_method do |method|
#         puts method
#       end
#     end
# 
#     file_info = [scanned]
# 
# 
#     gen = Generators::HTMLGenerator.for(options)
# 
#     gen.generate(file_info)
#   end
# end

require 'rubygems'
require 'yard'
require 'optparse'
# require File.dirname(__FILE__) + '/generators/rest_doc_generator'
module RestDoc
  class RestDoc < YARD::CLI::Yardoc
    def initialize
      super
      @options_file = '.yardoc_rest'
    end
    
    def run(*args)
      args += support_rdoc_document_file!
      optparse(*yardopts)
      optparse(*args)
      YARD::Registry.load(files, reload)
      
      if generate
        RestDoc::Generators::RestDocGenerator.new(options).generate(all_objects)
      end
    end

  end
end

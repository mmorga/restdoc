require 'optparse'

module RestDoc
  class RestYardoc < YARD::CLI::Yardoc
    def initialize
      super
      @options_file = '.yardoc_rest'
    end
    
    def run(*args)
      args += support_rdoc_document_file!
      args += ["-b.yardoc_rest", "-orestdoc"]
      optparse(*yardopts)
      optparse(*args)
      YARD::Registry.load(files, reload)
      
      if generate
        RestDoc::Generators::RestDocGenerator.new(options).generate(all_objects)
      end
    end

  end
end

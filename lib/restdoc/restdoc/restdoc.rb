require 'restdoc'
require 'rdoc/rdoc'
require 'rdoc/options'
require 'rdoc/generators/html_generator'

class RestDoc::RestDoc
  def document(args)
    fn = "something.rb"
    top_level = RDoc::TopLevel.new(fn)

    context = RDoc::Context.new

    @stats = RDoc::Stats.new

    content = File.open(fn, "r") {|f| f.read}

    options = Options.instance

    Generator = Struct.new(:file_name, :class_name, :key)
    GENERATORS = {'html' => Generator.new("rdoc/generators/html_generator",
                                     "HtmlGenerator".intern,
                                     "html")}

    options.parse([], GENERATORS)
                                 
    parser = RDoc::ParserFactory.parser_for(top_level, fn, content, options, @stats)

    scanned = parser.scan
    puts "\n\nPublic Methods:"
    puts scanned.public_methods.sort
    puts "\n\n\nClass Modules:"
    scanned.each_classmodule do |classmodule| 
      puts "\nClass Module:"
      puts classmodule 
      puts "\nMethods:"
      classmodule.each_method do |method|
        puts method
      end
    end

    file_info = [scanned]


    gen = Generators::HTMLGenerator.for(options)

    gen.generate(file_info)
  end
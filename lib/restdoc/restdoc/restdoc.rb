require 'restdoc'
require 'rdoc/rdoc'
require 'rdoc/options'
require 'rdoc/generators/html_generator'

class RestDoc::RestDoc

  def template_exists_for(controller, action)
    not Dir.glob(File.join(RAILS_ROOT, "app", "views", controller, "#{action}.*")).empty?
  end

  def process_route(route)
    controller_class = (route.defaults[:controller] + "Controller").camelize
    return nil if controller_class.constantize.new.respond_to?(route.defaults[:action])
    return nil if template_exists_for(route.defaults[:controller], route.defaults[:action])

    "#{controller_class.to_s} does not respond to '#{route.defaults[:action]}' as needed for #{route.defaults.inspect}"
  rescue NameError => error
    "#{controller_class.to_s} does not exist, it is needed for #{route.defaults.inspect}"
  end

    problems = {}

    ActionController::Routing::Routes.routes.each do |route|
      if route.defaults.has_key?(:controller) && route.defaults.has_key?(:action)

        result = process_route(route)

        if result
          problems[route.defaults[:controller]] ||= []
          problems[route.defaults[:controller]] << result
        end
      end
    end

    unless problems.empty?
      puts "***** Routes which correspond to missing actions on controller methods *****"
      problems.each { |key, problem| puts problem.uniq.sort }
      puts "***** PLEASE FIX THESE ROUTES BY MAY 15 2009 *****"
    end
  end

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
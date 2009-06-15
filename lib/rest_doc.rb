$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module RestDoc
  VERSION = '0.0.1'
  ROOT = File.dirname(__FILE__)
  TEMPLATE_ROOT = File.join(File.dirname(__FILE__), '..', 'templates')
end

require 'yard'
require 'rest_doc/rest_yardoc'
require 'rest_doc/generators/rest_class_generator'
require 'rest_doc/generators/rest_doc_generator'
require 'tasks/rest_doc'

files = Dir.glob File.join(RestDoc::ROOT, 'rest_doc/yard_ext/*')
files.each {|file| require file.gsub(/\.rb$/, '') }

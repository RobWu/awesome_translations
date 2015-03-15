require "haml"
require "string-cases"
require "array_enumerator"

module AwesomeTranslations
  autoload :CacheDatabaseGenerator, "#{File.dirname(__FILE__)}/awesome_translations/cache_database_generator"
  autoload :Config, "#{File.dirname(__FILE__)}/awesome_translations/config"
  autoload :ErbInspector, "#{File.dirname(__FILE__)}/awesome_translations/erb_inspector"
  autoload :Handlers, "#{File.dirname(__FILE__)}/awesome_translations/handlers"
  autoload :ObjectExtensions, "awesome_translations/object_extensions"
  autoload :ModelInspector, "awesome_translations/model_inspector"

  def self.config
    @config ||= AwesomeTranslations::Config.new
  end
end

require_relative "awesome_translations/engine"
Object.__send__(:include, AwesomeTranslations::ObjectExtensions)

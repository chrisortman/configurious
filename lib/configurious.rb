require 'yaml'
require 'commander'

require "configurious/version"
require "configurious/transformer"

module Configurious
  # Your code goes here...
  def self.transform(file)
    contents = YAML.load_file file
    transformer = Transformer.new
    yield transformer
    transformer.apply(contents)
    contents.to_yaml
  end

  class CLI

    include Commander::Methods
    # include whatever modules you need

    def run
      program :name, 'configurious'
      program :version, '0.0.1'
      program :description, 'Allows scripting of changes to yaml files'

      command :apply do |c|
        c.syntax = 'configurious apply [options]'
        c.summary = ''
        c.description = ''
        c.example 'description', 'command example'
        c.action do |args, options|
          puts "APPLYING"

          # Do something or c.when_called Configurious::Commands::Apply
          tfile = args.first
          ifile = args[1]

          transformer = Configurious::Transformer.new
          transformer.instance_eval File.read(tfile)
          result = transformer.apply ifile
          puts result
        end
      end

      run!
    end
  end

end

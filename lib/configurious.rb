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

  def self.apply(ifile, script)
    Configurious.transform(ifile) do |t|
      t.instance_eval script
    end
  end

  class CLI

    include Commander::Methods
    # include whatever modules you need

    def run
      program :name, 'configurious'
      program :version, Configurious::VERSION
      program :description, 'Allows scripting of changes to yaml files'

      command :poop do |c|
        c.syntax = "configurious poop"
        c.summary = "It's poopy"
        c.action do |args, options|
          puts "I have #{args.inspect}"

        end
      end

      command :apply do |c|
        c.syntax = 'configurious apply [options]'
        c.summary = ''
        c.description = ''
        c.example 'description', 'command example'
        c.action do |args, options|

          tfile, ifile = args
          result = Configurious.apply(ifile,File.read(tfile))
          puts result
        end
      end

      run!
    end
  end

end

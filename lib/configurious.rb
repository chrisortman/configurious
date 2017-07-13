require "configurious/version"
require 'yaml'
require 'configurious/operations'

module Configurious
  # Your code goes here...
  def self.transform(file)
    contents = YAML.load_file file
    contents['hashish'] = {'b' => 'B'}
    contents.to_yaml
  end
end

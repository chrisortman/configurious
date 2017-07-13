require 'byebug'

module Configurious
  module Operations
    class Replace
      attr_accessor :key, :new_content

      def apply(content)

        if simple_key?
          content[@key] = @new_content
        else
          parts = @key.split('.')

          piece = nil
          parts[0..-2].each{ |key| piece = content[key] }
          piece[parts.last] = @new_content
        end
      end

      def simple_key?
        !@key.include?('.')
      end
    end
  end
end

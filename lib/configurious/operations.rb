require 'byebug'
require 'active_support/core_ext/hash'

module Configurious
  module Operations
    class OperationBase

      attr_accessor :key, :content

      def simple_key?
        !@key.include?('.')
      end

      def normalize_content!
        if @content.is_a? Hash
          @content.stringify_keys!
        end
      end

    end

    class Replace < OperationBase


      def apply(content)

        self.normalize_content!

        if simple_key?
          content[@key] = @content
        else
          parts = @key.split('.')

          piece = nil
          parts[0..-2].each{ |key| piece = content[key] }
          piece[parts.last] = @content
        end
      end


    end

    class Add < OperationBase

      def apply(content)

        self.normalize_content!
        raise "Cannot add element, key already exists: #{@key}" if content.has_key?(@key)

        content[@key] = @content
      end
    end

    class Update < OperationBase

      def applies
        @transform = Configurious::Transformer.new
        yield @transform
      end

      def apply(content)
        child = content[@key]
        @transform.apply(child)
      end
    end

    class Remove < OperationBase
      def apply(content)
        content.delete(@key)
      end
    end

    class ChangeKey < OperationBase
      def apply(content)
        v = content.delete(@key)
        content[@content] = v
      end
    end
  end
end

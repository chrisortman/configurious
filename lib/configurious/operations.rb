require 'byebug'
require 'active_support/core_ext/hash'

module Configurious
  module Operations
    class OperationBase

      attr_accessor :path, :content

      def simple_path?
        !@path.include?('.')
      end

      def normalize_content!
        if @content.is_a? Hash
          @content.stringify_keys!
        end
      end

      # Handles retrieving the content
      # we really want to update from the
      # content that is passed in
      #
      # It's expected that the outer most
      # node comes in and then we need to
      # look at our key and if we have a
      # path we need to traverse it
      def select_node(dict)
        if simple_path?
          [path, dict]
        else
          parts = path.split('.')
          piece = dict
          parts[0..-2].each{ |key| piece = dict[key] }
          [parts.last, piece]
        end

      end

      def apply(existing_content)
        self.normalize_content!
        key, dict = select_node(existing_content)
        do_operation(dict, key)
      end

      # Performs the actual transform
      # Is given the dictionary to transform
      # and the key that should be transformed
      def do_operation(dict, key)

      end
    end

    class Replace < OperationBase

      attr_accessor :part

      def do_operation(dict, key)
        if @part
          old = dict[key]
          dict[key] = old.gsub(@part,@content)
        else
          dict[key] = @content
        end
      end

    end

    class Add < OperationBase

      def do_operation(dict, key)

        raise "Cannot add element, key already exists: #{key}" if dict.has_key?(key)

        dict[key] = self.content
      end
    end

    class Update < OperationBase

      def applies(&block)
        @transform = Configurious::Transformer.new
        case block.arity
        when 0
          @transform.instance_eval(&block)
        else
          yield @transform
        end
      end

      def do_operation(dict, key)
        @transform.apply(dict[key])
      end

    end

    class Remove < OperationBase

      def do_operation(dict, key)
        dict.delete(key)
      end

    end

    class ChangeKey < OperationBase

      def do_operation(dict, key)
        v = dict.delete(key)
        dict[content] = v
      end
    end
  end
end

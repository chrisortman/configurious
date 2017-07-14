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
          traverse_path(path,dict)
        end

      end

      def traverse_path(path, dict)
        @traverse_messages = ["Traversing path #{path}"]

        path_parts = path.split('.')
        piece = dict

        path_parts[0..-2].each do |key|

          case
          when piece.is_a?(Hash) && piece.has_key?(key)
            @traverse_messages << "Traversed path part #{key}"
            piece = piece[key]
          when piece.is_a?(String)
            @traverse_messages << "Tried traversing to #{key} but the current piece #{piece} is not a hash"
            return [key, nil]
          else
            @traverse_messages << "Could not find #{key} in current piece. Existing Keys: #{piece.keys.join(',')}"
            return [key, nil]
          end
        end

        [path_parts.last, piece]

      end

      def apply(existing_content)
        self.normalize_content!

        key, dict = select_node(existing_content)
        if dict && dict.is_a?(Hash)
          do_operation(dict, key)
        elsif dict.is_a?(String)
          raise "It looks like you selected a value when you meant to select a dictionary. Path #{path} resolves to #{dict}"
        else
          extra = @traverse_messages&.join("\n") || ""
          raise "No node at path '#{path}'\n #{extra}"
        end
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

        raise "Cannot replace key '#{key}' because it does not already exist" unless dict.has_key?(key)

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

require 'configurious/operations'

module Configurious

  class Transformer

    def initialize
      @steps = []
    end

    def add(key, value)
      op = Configurious::Operations::Add.new
      op.key = key
      op.content = value
      @steps << op
    end

    def replace(key, with:)
      r = Configurious::Operations::Replace.new
      r.key = key
      r.content = with
      @steps << r
    end

    def update(key, &block)
      r = Configurious::Operations::Update.new
      r.key = key
      r.applies(&block)
      @steps << r
    end

    def remove(key)
      r = Configurious::Operations::Remove.new
      r.key = key
      @steps << r
    end

    def change_key(key, to:)
      r = Configurious::Operations::ChangeKey.new
      r.key = key
      r.content = to
      @steps << r
    end

    def apply(content)
      @steps.each do |t|
        t.apply(content)
      end
      content
    end
  end
end

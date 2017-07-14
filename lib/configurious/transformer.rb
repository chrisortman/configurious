require 'configurious/operations'

module Configurious

  class Transformer

    def initialize
      @steps = []
    end

    def add(path, value)
      op = Configurious::Operations::Add.new
      op.path = path
      op.content = value
      @steps << op
    end

    def replace(path, with:)
      r = Configurious::Operations::Replace.new
      r.path = path
      r.content = with
      @steps << r
    end

    def change(path, to:)
      r = Configurious::Operations::Replace.new
      r.path = path
      r.content = to
      @steps << r
    end

    def update(path, &block)
      r = Configurious::Operations::Update.new
      r.path = path
      r.applies(&block)
      @steps << r
    end

    def remove(path)
      r = Configurious::Operations::Remove.new
      r.path = path
      @steps << r
    end

    def change_key(path, to:)
      r = Configurious::Operations::ChangeKey.new
      r.path = path
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

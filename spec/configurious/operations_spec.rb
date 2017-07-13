require "spec_helper"

RSpec.describe 'Operations' do
  describe 'Replace' do

    subject { Configurious::Operations::Replace.new }

    it 'should replace simple content' do
      content = {'a' => 'A'}
      subject.key = 'a'
      subject.new_content = 'foo'
      subject.apply content
      expect(content).to include('a' => 'foo')
    end

    it 'can replace nested content' do

      content = {'top' => {'a' => 'A'}}
      subject.key = 'top.a'
      subject.new_content = 'foo'
      subject.apply content
      expect(content).to include({'top' => {'a' => 'foo'}})
    end
  end
end

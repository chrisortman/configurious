require "spec_helper"

RSpec.describe 'Operations' do
  describe 'Replace' do

    subject { Configurious::Operations::Replace.new }

    it 'should replace simple content' do
      content = {'a' => 'A'}
      subject.key = 'a'
      subject.content = 'foo'
      subject.apply content
      expect(content).to include('a' => 'foo')
    end

    it 'can replace nested content' do

      content = {'top' => {'a' => 'A'}}
      subject.key = 'top.a'
      subject.content = 'foo'
      subject.apply content
      expect(content).to include({'top' => {'a' => 'foo'}})
    end

    it 'converts keys from symbols to strings' do

      content = {'top' => {'a' => 'A'}}
      subject.key = 'top'
      subject.content = {'b': 'B'}
      subject.apply content
      expect(content).to include({'top' => {'b' => 'B'}})
    end
  end

  describe 'Add' do
    subject { Configurious::Operations::Add.new }
    it 'can add to an existing hash' do
      content = {'a' => 'A'}
      subject.key = 'b'
      subject.content = 'B'
      subject.apply content
      expect(content).to include({
        'a' => 'A',
        'b' => 'B'
      })
    end
  end

  describe 'Update' do
    subject { Configurious::Operations::Update.new }
    it 'applies operations to selected node' do
      content = { 'top' => {'a' => 'A', 'c' => 'POOP'} }
      subject.key = 'top'
      subject.applies do |t|
        t.add 'b', 'B'
        t.replace 'c', with: 'C'
      end
      subject.apply content
      expect(content['top']).to include({
        'a' => 'A',
        'b' => 'B',
        'c' => 'C'
      })
    end
  end

  describe 'Remove' do

    subject { Configurious::Operations::Remove.new }
    it 'removes node at key' do
      content = {'a' => 'A', 'c' => 'POOP'}
      subject.key = 'c'
      subject.apply content
      expect(content).to match({
        'a' => 'A'
      })
    end
  end

  describe 'Change Key' do

    subject { Configurious::Operations::ChangeKey.new }
    it 'changes the key of a node' do
      content = {'a' => 'A'}
      subject.key = 'a'
      subject.content = 'AWESOME'
      subject.apply content
      expect(content).to match({
        'AWESOME' => 'A'
      })
    end
  end
end

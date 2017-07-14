require "spec_helper"

RSpec.describe 'Operations' do
  describe 'Replace' do

    subject { Configurious::Operations::Replace.new }

    it 'should replace simple content' do
      content = {'a' => 'A'}
      subject.path = 'a'
      subject.content = 'foo'
      subject.apply content
      expect(content).to include('a' => 'foo')
    end

    it 'can replace nested content' do

      content = {'top' => {'a' => 'A'}}
      subject.path = 'top.a'
      subject.content = 'foo'
      subject.apply content
      expect(content).to include({'top' => {'a' => 'foo'}})
    end

    it 'converts keys from symbols to strings' do

      content = {'top' => {'a' => 'A'}}
      subject.path = 'top'
      subject.content = {'b': 'B'}
      subject.apply content
      expect(content).to include({'top' => {'b' => 'B'}})
    end

    it 'can replace a part of a key' do
      content = {'top' => {'a' => 'A nasty word'}}
      subject.path = 'top.a'
      subject.part = 'nasty'
      subject.content = 'awesome'
      subject.apply content
      expect(content).to include({'top' => {'a' => 'A awesome word'}})

    end
    it 'raises an error if the key does not exist' do

      content = {'a' => 'A nasty word'}
      subject.path = 'b'
      subject.content = 'nada'
      expect { subject.apply content }.to raise_error("Cannot replace key 'b' because it does not already exist")
    end
  end

  describe 'Add' do
    subject { Configurious::Operations::Add.new }
    it 'can add to an existing hash' do
      content = {'a' => 'A'}
      subject.path = 'b'
      subject.content = 'B'
      subject.apply content
      expect(content).to include({
        'a' => 'A',
        'b' => 'B'
      })
    end

    it 'raises error if key already exists' do
      content = {'a' => 'A'}
      subject.path = 'a'
      subject.content = 'B'
      expect { subject.apply content }.to raise_error("Cannot add element, key already exists: a")
    end
  end

  describe 'Update' do
    subject { Configurious::Operations::Update.new }
    it 'applies operations to selected node' do
      content = { 'top' => {'a' => 'A', 'c' => 'POOP'} }
      subject.path = 'top'
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

    it 'handles nodes with . paths' do

      content = {
        'top' => {
          'a' => {
            'c' => 'POOP'
          }
        }
      }
      subject.path = 'top.a'
      subject.applies do |t|
        t.replace 'c', with: 'C'
      end
      subject.apply content
      expect(content).to match({
        'top' => {
          'a' => {
            'c' => 'C'
          }
        }
      })
    end
  end

  describe 'Remove' do

    subject { Configurious::Operations::Remove.new }
    it 'removes node at key' do
      content = {'a' => 'A', 'c' => 'POOP'}
      subject.path = 'c'
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
      subject.path = 'a'
      subject.content = 'AWESOME'
      subject.apply content
      expect(content).to match({
        'AWESOME' => 'A'
      })
    end
  end
end

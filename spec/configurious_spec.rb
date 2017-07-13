require "spec_helper"

RSpec.describe Configurious do
  it "has a version number" do
    expect(Configurious::VERSION).not_to be nil
  end

  it "can transform a file" do
    result = Configurious.transform('spec/fixtures/tconfig.yml') do |t|
      t.replace 'hashish', with: {'b': 'B'}
      t.update('vowels') do |v|
        v.add 'i', 'I'
        v.remove 'a'
        v.change_key 'o', to: 'Y'
      end
    end

    expect(result).to eq(<<EXPECTED)
---
hashish:
  b: B
vowels:
  i: I
  Y: O
EXPECTED
  end
end

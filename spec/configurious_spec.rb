require "spec_helper"

RSpec.describe Configurious do
  it "has a version number" do
    expect(Configurious::VERSION).not_to be nil
  end

  it "can transform a file" do
    result = Configurious.transform('spec/fixtures/tconfig.yml') do
      replace 'hashish', with: {'b': 'B'}
    end

    expect(result).to eq(<<EXPECTED)
---
hashish:
  b: B
EXPECTED
  end
end

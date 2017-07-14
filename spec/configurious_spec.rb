require "spec_helper"

RSpec.describe Configurious do
  it "has a version number" do
    expect(Configurious::VERSION).not_to be nil
  end

  it "can transform a file" do
    script = <<SCRIPT
replace 'hashish', with: {'b': 'B'}
update('vowels') do
  add 'i', 'I'
  remove 'a'
  change_key 'o', to: 'Y'
end
replace 'words.happy', part: 'sad', with: 'happy'
SCRIPT
    result = Configurious.apply('spec/fixtures/tconfig.yml', script)
    expect(result).to eq(<<EXPECTED)
---
hashish:
  b: B
vowels:
  i: I
  Y: O
words:
  happy: A happy place
EXPECTED
  end
end

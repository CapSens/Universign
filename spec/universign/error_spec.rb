require 'spec_helper'

describe Universign::DocumentURLInvalid do
  subject(:error) { described_class.new('https://files.example/missing.pdf') }

  it 'exposes the offending url' do
    expect(error.url).to eq('https://files.example/missing.pdf')
  end

  it 'renders a helpful message' do
    expect(error.to_s).to eq("Can't find document at 'https://files.example/missing.pdf'")
  end
end

describe Universign::Error do
  describe '.match_class' do
    it 'returns the mapped exception for a known code' do
      expect(described_class.match_class(73010)).to eq(Universign::InvalidCredentials)
    end

    it 'returns nil for an unknown code' do
      expect(described_class.match_class(0)).to be_nil
    end
  end
end

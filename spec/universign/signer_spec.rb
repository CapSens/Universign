require 'spec_helper'

describe Universign::Signer do
  describe '#first_name / #last_name' do
    it 'reads back the values written through the setters' do
      signer = described_class.new(first_name: 'Ada', last_name: 'Lovelace')

      expect(signer.first_name).to eq('Ada')
      expect(signer.last_name).to eq('Lovelace')
      expect(signer.params[:firstname]).to eq('Ada')
      expect(signer.params[:lastname]).to eq('Lovelace')
    end
  end

  describe '.from_data' do
    let(:data) { {'firstName' => 'Ada', 'status' => 'ready'} }

    it 'returns a new Signer (not a shared class-level state)' do
      first  = described_class.from_data(data)
      second = described_class.from_data('firstName' => 'Grace')

      expect(first).to be_instance_of(described_class)
      expect(first.params).not_to equal(second.params)
      expect(first.first_name).to eq('Ada')
    end

    it 'is thread-safe across concurrent builds' do
      threads = Array.new(5) do |i|
        Thread.new { described_class.from_data('firstName' => "name-#{i}").first_name }
      end

      expect(threads.map(&:value).sort).to eq(%w[name-0 name-1 name-2 name-3 name-4])
    end
  end
end

describe Universign::TransactionSigner do
  describe '#birthdate=' do
    it 'sets the birthDate param' do
      signer = described_class.new(birthdate: Date.new(1990, 1, 1))

      expect(signer.params[:birthDate]).to eq(Date.new(1990, 1, 1))
    end
  end
end

require 'spec_helper'

describe Universign::Client do
  it "can be initiated with new" do
    expect(described_class.new).to be_instance_of(described_class)
  end

  describe '#respond_to?' do
    subject(:client) { described_class.new }

    it 'is true for methods delegated to the XML-RPC client' do
      expect(client).to respond_to(:call)
    end

    it 'is false for unknown methods' do
      expect(client).not_to respond_to(:definitely_not_a_method)
    end
  end

  describe '.call' do
    it 'forwards to a fresh client instance' do
      rpc = double('Universign::Client')
      allow(described_class).to receive(:new).and_return(rpc)
      allow(rpc).to receive(:call).with('a.method', 1).and_return('ok')

      expect(described_class.call('a.method', 1)).to eq('ok')
    end
  end
end

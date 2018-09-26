require 'spec_helper'

describe Universign::Client do
  describe 'it is a singleton' do
    it "can't be initiated with new" do
      expect {
        described_class.new
      }.to raise_error(NoMethodError)
    end
  end
end

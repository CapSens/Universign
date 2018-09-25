require 'spec_helper'

describe Universign::Transaction do
  describe "#signed?" do
    it 'is signed with status == completed' do
      transaction = VCR.use_cassette('transaction/signed/signed') do
        Universign::Transaction.new('14088c20-5af5-31e5-8f82-25de2ec46eb0')
      end

      expect(transaction.signed?).to be true
    end

    it 'is not signed otherwise' do
      transaction = VCR.use_cassette('transaction/signed/not_signed') do
        Universign::Transaction.new('14088c20-5af5-31e5-8f82-25de2ec46eb0')
      end

      expect(transaction.signed?).to be false
    end
  end
end

require "spec_helper"

describe Universign::TransactionSigner do
  describe "setters map to Universign params" do
    it "maps each attribute to its Universign key" do
      signer = described_class.new(
        first_name: "Ada",
        last_name: "Lovelace",
        organization: "Analytical Engine",
        email: "ada@example.com",
        phone_number: "+33600000000",
        role: "signer",
        success_url: "https://success.test/",
        cancel_url: "https://cancel.test/",
        fail_url: "https://fail.test/",
        identification_type: "sms"
      )

      expect(signer.params).to include(
        firstname: "Ada",
        lastname: "Lovelace",
        organisation: "Analytical Engine",
        emailAddress: "ada@example.com",
        phoneNum: "+33600000000",
        role: "signer",
        successURL: "https://success.test/",
        cancelURL: "https://cancel.test/",
        failURL: "https://fail.test/",
        identificationType: "sms"
      )
    end
  end

  describe "#signature_field=" do
    it "stores the field params when given a SignatureField" do
      field  = Universign::SignatureField.new(coordinate: [10, 10], page: 1)
      signer = described_class.new(signature_field: field)

      expect(signer.params[:signatureField]).to eq(field.params)
    end

    it "raises when given anything else" do
      expect do
        described_class.new(signature_field: "not-a-field")
      end.to raise_error(Universign::InvalidSignatureField)
    end
  end
end

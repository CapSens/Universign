require "spec_helper"

describe Universign::Transaction do
  let(:client) { double("Universign::Client") }

  before { allow(Universign::Client).to receive(:new).and_return(client) }

  let(:sign_url) { "https://sign.test.universign.eu/fr/signature/?id=signer-id" }

  let(:document) do
    Universign::Document.new(
      name: "original_contract.pdf",
      content: File.read("spec/fixtures/universign-guide-8.8.pdf")
    )
  end

  let(:signer) do
    Universign::TransactionSigner.new(
      first_name: "Signer's first name",
      last_name: "Signer's last name",
      email: "test@gmail.com",
      success_url: "http://success-url.com/",
      signature_field: Universign::SignatureField.new(coordinate: [20, 20], page: 1)
    )
  end

  describe ".create" do
    subject(:transaction) do
      Universign::Transaction.create(
        documents: [document],
        signers: [signer],
        options: {profile: "default", final_doc_sent: true}
      )
    end

    before do
      allow(client).to receive(:call)
        .with("requester.requestTransaction", anything)
        .and_return("id" => "tx-id", "url" => sign_url)
    end

    it "exposes the sign_url" do
      expect(transaction.sign_url).to eq(sign_url)
    end

    it "exposes the signer_id parsed from the sign_url" do
      expect(transaction.signer_id).to eq("signer-id")
    end

    context "when Universign returns the id in the URL fragment" do
      let(:sign_url) { "https://app.universign.com/sig/#/?id=signer-id" }

      it "parses the signer_id from the fragment" do
        expect(transaction.signer_id).to eq("signer-id")
      end
    end

    it "does not make an extra getTransactionInfo call" do
      expect(client).not_to receive(:call).with("requester.getTransactionInfo", anything)

      transaction.sign_url
      transaction.signer_id
    end

    context "with an unknown option" do
      it "raises UnknownOption before calling the API" do
        expect(client).not_to receive(:call)

        expect do
          Universign::Transaction.create(
            documents: [document],
            signers: [signer],
            options: {not_a_real_option: true}
          )
        end.to raise_error(Universign::UnknownOption, /not_a_real_option/)
      end
    end

    context "with a document referenced by URL" do
      let(:document) do
        Universign::Document.new(name: "contract.pdf", url: "https://files.example/contract.pdf")
      end

      it "sends the document URL instead of base64 content" do
        expect(client).to receive(:call) do |method, options|
          expect(method).to eq("requester.requestTransaction")

          sent_document = options[:documents].first
          expect(sent_document["url"]).to eq("https://files.example/contract.pdf")
          expect(sent_document).not_to have_key("content")

          {"id" => "tx-id", "url" => sign_url}
        end

        expect(transaction.sign_url).to eq(sign_url)
      end
    end
  end

  describe "reloaded via .new" do
    subject(:transaction) { Universign::Transaction.new("tx-id") }

    before do
      allow(client).to receive(:call)
        .with("requester.getTransactionInfo", "tx-id")
        .and_return(
          "signerInfos" => [{"id" => "signer-id", "url" => sign_url, "status" => "ready"}],
          "currentSigner" => 0,
          "status" => "ready"
        )
    end

    it "fetches the sign_url from the signer infos" do
      expect(transaction.sign_url).to eq(sign_url)
    end

    it "exposes the signer_id" do
      expect(transaction.signer_id).to eq("signer-id")
    end
  end

  describe "#signed?" do
    subject(:transaction) { Universign::Transaction.new("tx-id") }

    it "is signed when status is completed" do
      allow(client).to receive(:call)
        .with("requester.getTransactionInfo", "tx-id")
        .and_return("status" => "completed")

      expect(transaction.signed?).to be true
    end

    it "is not signed otherwise" do
      allow(client).to receive(:call)
        .with("requester.getTransactionInfo", "tx-id")
        .and_return("status" => "ready")

      expect(transaction.signed?).to be false
    end
  end

  describe "lazy data accessors" do
    subject(:transaction) { Universign::Transaction.new("tx-id") }

    before do
      allow(client).to receive(:call)
        .with("requester.getTransactionInfo", "tx-id")
        .and_return(
          "description" => "My contract",
          "eachField" => true,
          "initiatorInfo" => {"email" => "requester@example.com"},
          "creationDate" => Date.new(2026, 6, 1),
          "currentSigner" => 0,
          "signerInfos" => [{"url" => "https://sign.test/without-query"}]
        )
    end

    it "exposes the description and eachField" do
      expect(transaction.description).to eq("My contract")
      expect(transaction.each_field).to be(true)
    end

    it "exposes the initiator and creation date" do
      expect(transaction.initiator).to eq("email" => "requester@example.com")
      expect(transaction.created_at).to eq(Date.new(2026, 6, 1))
      expect(transaction.current_signer).to eq(0)
    end

    it "returns a nil signer_id when the sign_url has no query" do
      expect(transaction.signer_id).to be_nil
    end
  end

  describe "#signers" do
    subject(:transaction) { Universign::Transaction.new("tx-id") }

    before do
      allow(client).to receive(:call)
        .with("requester.getTransactionInfo", "tx-id")
        .and_return(
          "signerInfos" => [
            {"status" => "signed", "url" => sign_url, "email" => "a@test.com"},
            {"status" => "ready", "url" => sign_url, "email" => "b@test.com"},
          ]
        )
    end

    it "maps signerInfos to SignerInfos beans" do
      expect(transaction.signers).to all(be_a(Universign::SignerInfos))
      expect(transaction.signers.map(&:status)).to eq(["signed", "ready"])
      expect(transaction.signers.map(&:email)).to eq(["a@test.com", "b@test.com"])
    end

    context "without signerInfos in the data" do
      before do
        allow(client).to receive(:call)
          .with("requester.getTransactionInfo", "tx-id")
          .and_return("status" => "ready")
      end

      it "returns an empty array" do
        expect(transaction.signers).to eq([])
      end
    end
  end

  describe "#documents" do
    subject(:transaction) { Universign::Transaction.new("tx-id") }

    before do
      allow(client).to receive(:call)
        .with("requester.getDocuments", "tx-id")
        .and_return([{"content" => "pdf-bytes", "name" => "doc.pdf"}])
    end

    it "supports parallel access" do
      threads = Array.new(2) { Thread.new { transaction.documents.first.content } }

      expect { threads.each(&:join) }.not_to raise_error
    end
  end
end

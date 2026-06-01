require 'spec_helper'

describe Universign::Transaction do
  let(:client) { double('Universign::Client') }

  before { allow(Universign::Client).to receive(:new).and_return(client) }

  let(:sign_url) { 'https://sign.test.universign.eu/fr/signature/?id=signer-id' }

  let(:document) do
    Universign::Document.new(
      name:    'original_contract.pdf',
      content: File.open('spec/fixtures/universign-guide-8.8.pdf').read
    )
  end

  let(:signer) do
    Universign::TransactionSigner.new(
      first_name:      "Signer's first name",
      last_name:       "Signer's last name",
      email:           'test@gmail.com',
      success_url:     'http://success-url.com/',
      signature_field: Universign::SignatureField.new(coordinate: [20, 20], page: 1)
    )
  end

  describe '.create' do
    subject(:transaction) do
      Universign::Transaction.create(
        documents: [document],
        signers:   [signer],
        options:   {profile: 'default', final_doc_sent: true}
      )
    end

    before do
      allow(client).to receive(:call)
        .with('requester.requestTransaction', anything)
        .and_return('id' => 'tx-id', 'url' => sign_url)
    end

    it 'exposes the sign_url' do
      expect(transaction.sign_url).to eq(sign_url)
    end

    it 'exposes the signer_id parsed from the sign_url' do
      expect(transaction.signer_id).to eq('signer-id')
    end

    it 'does not make an extra getTransactionInfo call' do
      expect(client).not_to receive(:call).with('requester.getTransactionInfo', anything)

      transaction.sign_url
      transaction.signer_id
    end
  end

  describe 'reloaded via .new' do
    subject(:transaction) { Universign::Transaction.new('tx-id') }

    before do
      allow(client).to receive(:call)
        .with('requester.getTransactionInfo', 'tx-id')
        .and_return(
          'signerInfos'   => [{'id' => 'signer-id', 'url' => sign_url, 'status' => 'ready'}],
          'currentSigner' => 0,
          'status'        => 'ready'
        )
    end

    it 'fetches the sign_url from the signer infos' do
      expect(transaction.sign_url).to eq(sign_url)
    end

    it 'exposes the signer_id' do
      expect(transaction.signer_id).to eq('signer-id')
    end
  end

  describe '#signed?' do
    subject(:transaction) { Universign::Transaction.new('tx-id') }

    it 'is signed when status is completed' do
      allow(client).to receive(:call)
        .with('requester.getTransactionInfo', 'tx-id')
        .and_return('status' => 'completed')

      expect(transaction.signed?).to be true
    end

    it 'is not signed otherwise' do
      allow(client).to receive(:call)
        .with('requester.getTransactionInfo', 'tx-id')
        .and_return('status' => 'ready')

      expect(transaction.signed?).to be false
    end
  end

  describe '#documents' do
    subject(:transaction) { Universign::Transaction.new('tx-id') }

    before do
      allow(client).to receive(:call)
        .with('requester.getDocuments', 'tx-id')
        .and_return([{'content' => 'pdf-bytes', 'name' => 'doc.pdf'}])
    end

    it 'supports parallel access' do
      threads = Array.new(2) { Thread.new { transaction.documents.first.content } }

      expect { threads.each(&:join) }.not_to raise_error
    end
  end
end

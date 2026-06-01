require 'spec_helper'

describe Universign::Document do
  describe '.new' do
    it 'sets a variable + a params in Universign format' do
      [
        # VARIABLE    # UNIVERSIGN  # VALUE
        ['name',      'name',       'DocumentName'],
        ['url',       'url',        'DocumentUrl'],
        ['meta_data', 'metaData',   { data: 1 }],
      ].each do |field|
        document = described_class.new(field[0] => field[2])

        expect(document.params).to have_key(field[1])
        expect(document.send(field[0])).to eql(field[2])
      end
    end

    context 'meta_data is not a hash' do
      it 'raises an exception' do
        expect {
          described_class.new(meta_data: 1)
        }.to raise_error(Universign::MetaDataMustBeAHash)
      end
    end

    context 'content is set' do
      it 'convert the content to XMLRPC::Base64 on params' do
        file = File.dirname(__FILE__) + '/../fixtures/png_file.png'
        document = described_class.new(content: File.open(file).read)

        expect(document.params[:content]).to be_instance_of(XMLRPC::Base64)
      end
    end
  end

  describe '#signature_fields=' do
    it 'maps SignatureField instances to their params' do
      field    = Universign::SignatureField.new(coordinate: [10, 20], page: 1)
      document = described_class.new(name: 'doc.pdf', signature_fields: [field])

      expect(document.params['signatureFields']).to eq([field.params.stringify_keys])
    end

    it 'raises when not given an array' do
      expect {
        described_class.new(signature_fields: 'nope')
      }.to raise_error(Universign::SignatureFieldsMustBeAnArray)
    end

    it 'raises when an element is not a SignatureField' do
      expect {
        described_class.new(signature_fields: ['nope'])
      }.to raise_error(Universign::InvalidSignatureField)
    end
  end

  describe '#check_box_texts=' do
    it 'stores the texts' do
      document = described_class.new(check_box_texts: ['a', 'b', ''])

      expect(document.check_box_texts).to eq(['a', 'b', ''])
    end

    it 'raises when not given an array' do
      expect {
        described_class.new(check_box_texts: 'nope')
      }.to raise_error(Universign::CheckBoxTextsMustBeAnArray)
    end
  end

  describe '#document_type' do
    it 'reads the documentType from params' do
      document = described_class.from_data('documentType' => 'application/pdf')

      expect(document.document_type).to eq('application/pdf')
    end
  end

  describe '.from_data' do
    let(:data) { {
      documentType: 'application/pdf',
      content:      'AAA...',
      metaData: { data: 1 }
    } }

    it 'returns a new Document' do
      document = described_class.from_data(data)
      expect(document).to be_instance_of(described_class)
    end

    it 'sets param = data' do
      document = described_class.from_data(data)

      expect(document.params).to eql(HashWithIndifferentAccess.new(data))
    end

    it 'keep the HashWithIndifferentAccess' do
      document = described_class.from_data(data)

      expect(document.params.class).to eql HashWithIndifferentAccess
    end
  end
end

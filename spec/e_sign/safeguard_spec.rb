require 'spec_helper'

describe ESign::Safeguard do
  let(:dummy_class) { Class.new { include ESign::Safeguard } }

  context 'exception is RuntimeError' do
    context "The message include 'Authorization failed'" do
      it 'raises the known exception' do
        expect {
          dummy_class.safeguard do
            raise RuntimeError, 'Authorization failed'
          end
        }.to raise_error ESign::Client::InvalidCredentials
      end
    end

    context 'The message is unknown' do
      it 're-raises the exception' do
        expect {
          dummy_class.safeguard do
            raise RuntimeError
          end
        }.to raise_error RuntimeError
      end
    end
  end

  context 'exception is XMLRPC::FaultException' do
    context 'faultCode is 73020' do
      it 're-raises the exception' do
        expect {
          dummy_class.safeguard do
            raise XMLRPC::FaultException.new(73020, '')
          end
        }.to raise_error XMLRPC::FaultException
      end
    end

    context 'faultCode is known' do
      it 'raises the known exception' do
        [
          # faultCode    # Exception
          [73002,        ESign::Client::ErrorWhenSigningPDF],
          [73010,        ESign::Client::InvalidCredentials],
          [73025,        ESign::Document::UnknownDocument],
          [73027,        ESign::Document::NotSigned]
        ].each do |error|
          expect {
            dummy_class.safeguard do
              raise XMLRPC::FaultException.new(error[0], '')
            end
          }.to raise_error error[1]
        end
      end
    end

    context 'faultString is known' do
      it 'raises the known exception' do
        [
          # faultString                               # Exception
          ['Error on document download for this URL', ESign::Document::DocumentURLInvalid],
          ['Invalid document URL',                    ESign::Document::DocumentURLInvalid],
          ['Not enough tokens',                       ESign::NotEnoughTokens],
          ['ID is unknown',                           ESign::Document::UnknownDocument]
        ].each do |error|
          expect {
            dummy_class.safeguard do
              raise XMLRPC::FaultException.new(007, error[0])
            end
          }.to raise_error error[1]
        end
      end
    end

    context 'the error is unknown' do
      let(:block_called) { spy('invitation') }

      it 'calls the yield block' do
        dummy_class.safeguard(block_called) do
          raise XMLRPC::FaultException.new(007, '')
        end

        expect(block_called).to have_received(:call)
      end
    end
  end
end

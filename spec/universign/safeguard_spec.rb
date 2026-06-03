require "spec_helper"

describe Universign::Safeguard do
  let(:dummy_class) { Class.new { include Universign::Safeguard } }

  context "exception is RuntimeError" do
    context "The message include 'Authorization failed'" do
      it "raises the known exception" do
        expect do
          dummy_class.safeguard do
            raise "Authorization failed"
          end
        end.to raise_error Universign::InvalidCredentials
      end
    end

    context "The message is unknown" do
      it "re-raises the exception" do
        expect do
          dummy_class.safeguard do
            raise RuntimeError
          end
        end.to raise_error RuntimeError
      end
    end
  end

  context "exception is XMLRPC::FaultException" do
    context "faultCode is 73020" do
      it "re-raises the exception" do
        expect do
          dummy_class.safeguard do
            raise XMLRPC::FaultException.new(73020, "")
          end
        end.to raise_error XMLRPC::FaultException
      end
    end

    context "faultCode is known" do
      it "raises the known exception" do
        [
          # faultCode    # Exception
          [73002, Universign::ErrorWhenSigningPDF],
          [73010, Universign::InvalidCredentials],
          [73025, Universign::UnknownDocument],
          [73027, Universign::DocumentNotSigned],
        ].each do |error|
          expect do
            dummy_class.safeguard do
              raise XMLRPC::FaultException.new(error[0], "")
            end
          end.to raise_error error[1]
        end
      end
    end

    context "faultString is known" do
      it "raises the known exception" do
        [
          # faultString                               # Exception
          ["Error on document download for this URL", Universign::DocumentURLInvalid],
          ["Invalid document URL", Universign::DocumentURLInvalid],
          ["Not enough tokens", Universign::NotEnoughTokens],
          ["ID is unknown", Universign::UnknownDocument],
        ].each do |error|
          expect do
            dummy_class.safeguard do
              raise XMLRPC::FaultException.new(0o07, error[0])
            end
          end.to raise_error error[1]
        end
      end
    end

    context "the error is unknown" do
      it "re-raises the original fault exception" do
        expect do
          dummy_class.safeguard do
            raise XMLRPC::FaultException.new(0o07, "totally unknown fault")
          end
        end.to raise_error(XMLRPC::FaultException)
      end
    end
  end
end

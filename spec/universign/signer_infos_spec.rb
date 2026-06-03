require "spec_helper"

describe Universign::SignerInfos do
  subject(:signer_infos) { described_class.from_data(data) }

  let(:data) do
    {
      "status" => "failed",
      "error" => "Something went wrong",
      "url" => "https://sign.test/?id=abc",
      "actionDate" => "2026-06-01",
      "refusedDocs" => [0, 2],
      "email" => "signer@example.com",
    }
  end

  it "exposes every signer info field from the data" do
    expect(signer_infos.status).to eq("failed")
    expect(signer_infos.error).to eq("Something went wrong")
    expect(signer_infos.url).to eq("https://sign.test/?id=abc")
    expect(signer_infos.action_date).to eq("2026-06-01")
    expect(signer_infos.refused_docs).to eq([0, 2])
    expect(signer_infos.email).to eq("signer@example.com")
  end
end

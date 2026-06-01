require "spec_helper"

describe Universign::SignatureField do
  it "builds the params from coordinates" do
    field = described_class.new(coordinate: [20, 40], page: 2, signer_index: 1)

    expect(field.params).to eq(
      page: 2,
      x: 20,
      y: 40,
      signerIndex: 1
    )
  end

  it "defaults the signer index to 0 and omits the name" do
    field = described_class.new(coordinate: [0, 0], page: 1)

    expect(field.params[:signerIndex]).to eq(0)
    expect(field.params).not_to have_key(:name)
  end

  it "includes the name when given (named field)" do
    field = described_class.new(coordinate: [0, 0], page: 1, name: "signature_1")

    expect(field.params[:name]).to eq("signature_1")
  end

  it "falls back to [0, 0] when coordinate is nil" do
    field = described_class.new(coordinate: nil, page: 1)

    expect(field.params[:x]).to eq(0)
    expect(field.params[:y]).to eq(0)
  end
end

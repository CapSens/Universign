require 'spec_helper'

describe Universign::Client do
  it "can be initiated with new" do
    expect(described_class.new).to be_instance_of(described_class)
  end
end

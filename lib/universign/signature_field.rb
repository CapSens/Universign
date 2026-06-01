# frozen_string_literal: true

module Universign
  class SignatureField
    attr_reader :params

    def initialize(coordinate:, page:, name: nil, signer_index: 0)
      coordinate ||= [0, 0]

      @params = {
        page:        page,
        x:           coordinate[0],
        y:           coordinate[1],
        signerIndex: signer_index,
      }
      @params[:name] = name unless name.nil?
    end
  end
end

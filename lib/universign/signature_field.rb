module Universign
  class SignatureField
    attr_reader :params

    def initialize(coordinate:, name:, page:, signer_index:)
      @coordinate   = coordinate || [0, 0]
      @name         = name
      @page         = page
      @signer_index = signer_index

      @params = {
        page:          @page,
        name:          @name,
        x:             @coordinate[0],
        y:             @coordinate[1],
        'signerIndex': @signer_index
      }
    end
  end
end

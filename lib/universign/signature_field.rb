module Universign
  class SignatureField
    attr_reader :params

    def initialize(coordinate:, name: nil, page:, signer_index: 0)
      @coordinate   = coordinate || [0, 0]
      @name         = name
      @page         = page
      @signer_index = signer_index

      @params = {
        page:          @page,
        x:             @coordinate[0],
        y:             @coordinate[1],
        'signerIndex': @signer_index
      }

      @params[:name] = @name unless @name.nil?

      @params
    end
  end
end

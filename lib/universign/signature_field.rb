module Universign
  class SignatureField
    attr_reader :params

    def initialize(coordinate:, name:, page:)
      @coordinate   = coordinate || [0, 0]
      @name         = name
      @page         = page

      @params = {
        page: @page,
        name: @name,
        x:    @coordinate[0],
        y:    @coordinate[1]
      }
    end
  end
end

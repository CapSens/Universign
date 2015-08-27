module ESign
  class SignatureField
    attr_reader :params

    def initialize(coordinate:, page:)
      @coordinate   = coordinate
      @page         = page

      @params = {
        page: @page,
        x:    @coordinate[0],
        y:    @coordinate[1]
      }
    end
  end
end

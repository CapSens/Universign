module Universign
  class SignatureField
    attr_reader :params

    def initialize(coordinate:, name: nil, page:)
      @coordinate   = coordinate || [0, 0]
      @name         = name
      @page         = page

      @params = {
        page: @page,
        x:    @coordinate[0],
        y:    @coordinate[1]
      }

      @params[:name] = @name if @name.present?

      @params
    end
  end
end

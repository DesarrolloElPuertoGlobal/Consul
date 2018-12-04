require 'logger'
include DocumentParser
class CensusApi

  # doc: NIF sin letra.
  # letra_doc. Letra NIF.
  # URL: "http://172.30.0.26:9440/datos_padron.php?doc=xxxx&letra_doc=xxxx

  def call(doc)
    response = nil
    get_document_number_variants(doc).each do |variant|
      # Por cada variante de DNI hay que sacar el número y la letra
      data = split_letter_from(variant)
      response = Response.new(get_response_body(data[0], data[1]))
      return response if response.valid?
    end
    response
  end

  class Response
    def initialize(body)
      @body = body
    end

    def valid?
      data["empadronado"].present?
    end

    def empadronado
      data["empadronado"]
    end

    def distrito
      data["distrito"]
    end

    def seccion
      data["seccion"]
    end

    def calle
      data["calle"]
    end

    def domicilio
      data["domicilio"]
    end

    private

      def data
        @body
      end
  end

  private

    def get_response_body(doc, letra_doc)
      logger = Logger.new(STDOUT)
      if end_point_available?
        url = "http://172.30.0.26:9440/datos_padron.php?doc=#{doc}&letra_doc=#{letra_doc}"
        data = JSON.parse(Net::HTTP.get_response(URI.parse(url)).body)
        data
        #good
      else
        stubbed_response_body
      end
    end

    def end_point_available?
      true
    end

    def stubbed_response_body
      {
        empadronado: "true/false",
        distrito: "",
        seccion: "",    
        calle: "",    
        domicilio: ""    
      }
    end

    def good
      {
        empadronado: true,
        distrito: "12345",
        seccion: "01",    
        calle: "Explorador",    
        domicilio: "Segundo"    
      }
    end

end

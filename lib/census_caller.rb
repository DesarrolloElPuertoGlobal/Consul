class CensusCaller

  def call(doc)
    response = CensusApi.new.call(doc)
    #response = LocalCensus.new.call(document_type, document_number) unless response.valid?

    response
  end
end

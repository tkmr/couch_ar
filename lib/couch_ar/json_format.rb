module CouchAr::JsonFormat
  extend self

  def extension
    'json'
  end

  def mime_type
    "application/json"
  end

  def encode(hash, options = nil)
    ActiveSupport::JSON.encode(hash, options)
  end

  def decode(json)
    ActiveSupport::JSON.decode(json)
  end

  def filter(str)
    str.gsub(/\.json/, '')
  end
end

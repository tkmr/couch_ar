class CouchAr::View
  attr_accessor :map, :reduce, :name, :design_doc

  def initialize(name, designdoc, params)
    self.design_doc = designdoc
    self.name   = name
    self.map    = params["map"]
    self.reduce = params["reduce"]
  end

  def serializable_hash(options = {})
    {"map" => map, "reduce" => reduce}
  end

  def get(options = {})
    p options[:key] = encode_key(options[:key]) if options[:key]
    design_doc.get("_view/#{name}", options)
  end

  def encode_key(str)
    ActiveSupport::JSON.encode(str)
  end
end


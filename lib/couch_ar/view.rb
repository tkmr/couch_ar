# -*- coding: utf-8 -*-
class CouchAr::View
  attr_accessor :map, :reduce, :name

  def initialize(name, design_doc, params)
    @design_doc = proc { design_doc } # serialize のため

    if params.class == CouchAr::View
      params = params.serializable_hash
    end

    self.name   = name
    self.map    = params["map"]
    self.reduce = params["reduce"]
  end

  def get(options = {})
    @design_doc.call().get("_view/#{self.name}", options)
  end

  def serializable_hash(options = {})
    {"map" => map, "reduce" => reduce}
  end
end


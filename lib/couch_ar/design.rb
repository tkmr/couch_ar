class CouchAr::Design < CouchAr::Base
  class << self
    attr_accessor :db

    def database(dbklass)
      self.db              = dbklass
      self.site            = db.base_url
      self.element_name    = db.element_name
      self.collection_name = db.element_name
      self.primary_key     = "_id"
    end

    def find_by_name(name)
      find("_design/#{name}")
    end
  end

  def views
    hash = {}
    attributes["views"].each do |key, map_reduce|
      hash[key] = CouchAr::View.new(key, self, map_reduce)
    end
    hash
  end
end

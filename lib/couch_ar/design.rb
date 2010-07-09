class CouchAr::Design < CouchAr::Base
  after_load :hash_to_views

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

  def hash_to_views
    unless @attributes["views"]
      @attributes["views"] = {}
    else
      @attributes["views"].each do |key, map_reduce|
        @attributes["views"][key] = CouchAr::View.new(key, self, map_reduce)
      end
    end
  end

  def create
    raise 'no name or id error'   unless self.name
    self.id = "_design/#{self.name}"

    raise 'this name or id exist' if self.exists?

    default_attr = {
      'language' => 'javascript',
      'views' => { },
    }
    self.attributes = default_attr.merge(self.attributes)
    self.update
  end
end

#
# MainDB = CouchAr::Database.setup('main', :host => 'localhost', :port => 9999)
# instance = MainDB.open
# instance.db_name    #=> 'main'
# instance.doc_count  #=> 93
class CouchAr::Database < CouchAr::Base
  class << self
    attr_accessor :conf, :name

    def setup(name, config = {})
      returning Class.new(CouchAr::Database) do |klass|
        default = {
          :host => 'localhost',
          :port => 5984,
          :path => '/'
        }
        klass.conf = default.merge(config)
        klass.site = klass.base_url
        klass.element_name = name
        klass.collection_name = name
      end
    end

    def base_url
      # TODO: refine
      "http://#{conf[:host]}:#{conf[:port]}#{conf[:path]}"
    end

    def open
      self.find(:one, :from => "/#{element_name}")
    end

    def exists?(id = nil, options = {})
      id ||= "" # HEAD http://example.com/dbname/
      super(id, options)
    end

    def create
      connection.put(element_path("")) # PUT http://example.com/dbname/
    end
  end

  schema do
    string "db_name", "compact_running"
    integer "doc_count", "doc_del_count", "update_seq", "disk_format_version"
    integer "purge_seq", "disk_size", "instance_start_time"
  end
end

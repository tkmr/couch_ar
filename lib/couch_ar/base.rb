class CouchAr::Base < ActiveResource::Base
  self.logger = Logger.new(STDOUT)
  self.format = CouchAr::HideFormat

  class << self
    def custom_method_collection_url(method_name, options = {})
      url_path_filter CouchAr::HideFormat.filter(super)
    end

    def element_path(id, prefix_options = {}, query_options = nil)
      url_path_filter CouchAr::HideFormat.filter(super)
    end

    def new_element_path(prefix_options = {})
      url_path_filter CouchAr::HideFormat.filter(super)
    end

    def collection_path(prefix_options = {}, query_options = nil)
      url_path_filter CouchAr::HideFormat.filter(super)
    end

    def add_parameter(url, params)
      base = (url =~ /\?/) ? (url + "&") : (url + "?")
      base + params.map{|k, v| "#{k}=#{v}" }.join("&")
    end

    private
    def url_path_filter(url)
      get_rev_info? ? add_parameter(url, 'revs_info' => 'true') : url
    end

    def get_rev_info?
      false # default false
    end
  end

  def custom_method_element_url(method_name, options = {})
    CouchAr::HideFormat.filter(super)
  end

  def custom_method_new_element_url(method_name, options = {})
    CouchAr::HideFormat.filter(super)
  end

  def destroy
    path = self.class.add_parameter(element_path, 'rev' => self.revision)
    connection.delete(path, self.class.headers)
  end

  def encode(options={})
    CouchAr::HideFormat.encode(self.serializable_hash.merge(options))
  end

  class DummyResource < Hash
    def initialize(hash)
      hash = hash.dup
      hash.each do |k, v|
        self[k] = v
      end
    end
  end

  def find_or_create_resource_for(name)
    DummyResource
  end
end

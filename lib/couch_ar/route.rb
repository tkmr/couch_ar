module CouchAr::Route
  module ClassMethods
    def custom_method_collection_url(method_name, options = {})
      url_path_filter(super)
    end

    def element_path(id, prefix_options = {}, query_options = nil)
      url_path_filter(super)
    end

    def new_element_path(prefix_options = {})
      url_path_filter(super)
    end

    def collection_path(prefix_options = {}, query_options = nil)
      url_path_filter(super)
    end

    def add_parameter(url, params)
      base = (url =~ /\?/) ? (url + "&") : (url + "?")
      base + params.map{|k, v| "#{k}=#{v}" }.join("&")
    end

    def url_path_filter(url)
      sub_urlpath_filter(CouchAr::JsonFormat.filter(url))
    end

    def sub_urlpath_filter(url)
      url
    end
  end

  module InstanceMethods
    def custom_method_element_url(method_name, options = {})
      self.class.url_path_filter(super)
    end

    def custom_method_new_element_url(method_name, options = {})
      self.class.url_path_filter(super)
    end
  end
end

# -*- coding: utf-8 -*-
class CouchAr::Document < CouchAr::Base
  after_load :check_metadata

  class << self
    attr_accessor :db

    def database(dbklass)
      self.db = dbklass
      self.site         = db.base_url
      self.element_name = db.element_name
      self.collection_name = db.collection_name
      self.primary_key  = CouchAr::KEYS[:id]
    end

    # get id list -------------------------
    def find_all(options = {})
      # options[:limit]        = 50
      # options[:startkey]     = 1
      # options[:endkey]       = 1
      # options[:descending]   = true
      # options[:include_docs] = true
      options[:include_docs] = true
      all_doc_ids(options)['rows'].map do |e|
        if d = e['doc']
          instantiate_record d
        else
          nil
        end
      end.compact
      #instantiate_collection rows # .map{|e| e['doc'] }
    end

    def find_by_view(view, options = {})
      # options[:key] = "test"
      options[:include_docs] = true
      options[:reduce] = false
      rows = view.get(options)['rows']

      docs = Hash.new {|h, k| h[k] = [] }
      rows.each do |row|
        d = instantiate_record(row['doc'])
        docs[row['key']] << d if d
      end
      docs
    end

    def find_by_view_as_array(view, options = {})
      find_by_view(view, options).values.flatten
    end

    def instantiate_record(record, prefix_options = {})
      if record[CouchAr::KEYS[:type]] == self.name # get class name
        super
      else
        nil
      end
    end

    def all_doc_ids(options = {})
      self.get('_all_docs_by_seq', options)
    end
  end

  def check_metadata
    key = (CouchAr::KEYS[:type] + "=").to_sym
    self.send(key, self.class.to_s) unless self.respond_to?(key)
  end

  def revision
    self.send(CouchAr::KEYS[:rev])
  end

  def revisions
    # def get_rev_info?
    #  true
    # end
    # でreload?
    self._revs_info || []
  end

  def attachments
    self._attachments
  end

  # url filter /////////////////////////////
  def sub_urlpath_filter(url)
    get_rev_info? ? add_parameter(url, 'revs_info' => 'true') : url
  end

  def get_rev_info?
    true
  end
end

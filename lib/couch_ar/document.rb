# -*- coding: utf-8 -*-
class CouchAr::Document < CouchAr::Base
  class << self
    attr_accessor :db

    def database(dbklass)
      self.db = dbklass
      self.site         = db.base_url
      self.element_name = db.element_name
      self.collection_name = db.collection_name
      self.primary_key  = '_id'
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
      rows = view.get(options)['rows']

      docs = Hash.new {|h, k| h[k] = [] }
      rows.each do |row|
        docs[row['key']] << instantiate_record(row['doc'])
      end
      docs
    end

    def find_by_view_as_array(view, options = {})
      find_by_view(view, options).values.flatten
    end

    def all_doc_ids(options = {})
      self.get('_all_docs_by_seq', options)
    end
  end

  def revision
    self._rev
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
end

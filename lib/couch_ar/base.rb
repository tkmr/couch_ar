class CouchAr::Base < ActiveResource::Base
  extend  ActiveModel::Callbacks
  define_model_callbacks :validations, :create, :save, :load

  extend  CouchAr::Route::ClassMethods
  include CouchAr::Route::InstanceMethods

  self.logger = Logger.new(STDOUT)
  self.format = CouchAr::HideFormat

  def destroy
    path = self.class.add_parameter(element_path, 'rev' => self.revision)
    connection.delete(path, self.class.headers)
  end

  def create
    _run_create_callbacks { super }
  end

  def save
    _run_save_callbacks { super }
  end

  def load(attributes)
    _run_load_callbacks { super }
  end

  def encode(options={})
    CouchAr::HideFormat.encode(self.serializable_hash(options))
  end

  def serializable_hash(options={})
    h = super
    h.each do |k, v|
      h[k] = v.serializable_hash(options) if v.respond_to?(:serializable_hash)
    end
    h.merge(options)
  end

  # for hash
  class DummyResource
    def self.new(hash)
      if hash['type'] && self.class.const_defined?(hash['type'])
        self.class.const_get(hash['type']).new(hash)
      else
        hash.dup
      end
    end
  end

  def find_or_create_resource_for(name)
    DummyResource
  end
end

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

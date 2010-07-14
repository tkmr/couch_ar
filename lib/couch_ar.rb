require 'active_resource'
require 'logger'

module CouchAr
  KEYS = {
    :type => 'type', # please replace any key, i.e... 'couchrest-type'
    :id   => '_id',
    :rev  => '_rev'
  }

  require 'couch_ar/route.rb'
  require 'couch_ar/json_format.rb'
  require 'couch_ar/view.rb'
  require 'couch_ar/base.rb'
  require 'couch_ar/database.rb'
  require 'couch_ar/document.rb'
  require 'couch_ar/design.rb'
end

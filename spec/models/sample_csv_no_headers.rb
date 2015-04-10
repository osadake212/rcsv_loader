require 'rcsv_loader'

class SampleCsvNoHeaders < RCsvLoader::Base
  insert_headers ['id', 'file_name', 'extension', 'url']
end

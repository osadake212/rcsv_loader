require 'rcsv_loader'

class SampleCsv < RCsvLoader::Base
  column 'id'
  column 'file name', :file_name
  column 'extension'
  column 'url'
end

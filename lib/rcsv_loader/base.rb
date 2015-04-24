require 'csv'
require "rcsv_loader/version"
require 'rcsv_loader/class_macros'
require 'rcsv_loader/core'
require 'rcsv_loader/loader'
require 'rcsv_loader/where'

module RCsvLoader

  class Base
    extend ClassMacros
    extend Loader

    include Core
    include Where
  end

end

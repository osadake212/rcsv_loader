require "rcsv_loader/version"
require 'rcsv_loader/class_macros'
require 'rcsv_loader/where'
require 'csv'

module RCsvLoader

  class Base
    extend Forwardable
    extend ClassMacros
    include Where

    #
    # Laod a csv file
    #
    #   options: The options for 'csv' which is Ruby's built-in library.
    #
    def self.load_csv file, options = {}

      rows = CSV.readlines file, options

      rows = yield rows if block_given?

      self.new rows.map { |row| self::Row.new row }
    end

    def_delegators :@rows, :+, :<<

    def initialize rows = []
      @rows = rows
    end

    def all
      @rows
    end

    #
    # Convert to csv string
    #
    # options: {
    #   headers: boolean
    # }
    #
    def to_csv options = {}
      csv = ""
      csv += CSV.generate_line(self.class.headers.map { |k, v| v } ) if options[:headers]
      csv += @rows.map(&:to_csv).join
    end

  end

end

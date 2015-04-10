require "rcsv_loader/version"
require 'csv'

module RCsvLoader

  attr_reader :headers

  #
  # Define accessor names for csv column.
  #
  def column column_name, alias_name = nil
    alias_name = column_name.to_sym unless alias_name
    @headers = all_headers
    @headers.merge!(alias_name => column_name)
    define_row(@headers)
  end

  #
  # Define headers for no headers csv.
  #
  def insert_headers headers = []
    @headers = Hash[headers.map.with_index { |e, i| [e, i] }]
    define_row(@headers)
  end

  class Base
    extend RCsvLoader
    extend Forwardable

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
    # params = {
    #   :#{accessor_name} => expected_value,
    #   ...
    # }
    #
    # compare with '=='
    #
    # return empty array if the condition is invalid or couldn't find any rows.
    #
    def where params = {}
      return @rows if params.empty?

      # filter the conditions.
      params.select! do |k, v|
        self.class.headers.keys.any? { |key| key.to_s == k.to_s }
      end

      return [] if params.empty?

      @rows.select do |row|
        params.all? { |attr, con| (row.send attr) == con }
      end

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

  private
  #
  # Get headers that include super class's one.
  #
  def all_headers current_class = nil
    current_class ||= self
    return {} if current_class == Base
    current_header = current_class.headers || {}
    return current_header.merge all_headers(current_class.superclass)
  end

  #
  # Define a class which represent a row of csv.
  #
  def define_row headers
    headers ||= {}

    # get the superclass for Row
    baseclass = if superclass.const_defined? :Row
                  superclass::Row
                else
                  Object
                end

    # remove class definition
    if const_defined? :Row and baseclass != self::Row
      self.send :remove_const, :Row
    end

    # define Row class
    const_set :Row, (Class.new(baseclass) do

      attr_accessor *headers.keys

      define_method :initialize do |line = {}|
        headers.each do |k, v|
          instance_variable_set "@#{k.to_s}", line[v]
        end
      end

      define_method :to_csv do
        CSV.generate_line headers.map { |k, v| self.send k }
      end

    end)
  end
end

module RCsvLoader

  module Loader

    #
    # Laod a csv file
    #
    #   options: The options for 'csv' which is Ruby's built-in library.
    #
    def load_csv file, options = {}

      rows = CSV.readlines file, options

      rows = yield rows if block_given?

      self.new rows.map { |row| self::Row.new row }
    end

  end
end

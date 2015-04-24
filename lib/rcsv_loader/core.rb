module RCsvLoader
  module Core
    extend Forwardable

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
      csv += CSV.generate_line(self.class.headers.map { |k, v| v } ) unless options[:headers]
      csv += @rows.map(&:to_csv).join
    end

  end
end

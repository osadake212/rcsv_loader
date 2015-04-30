module RCsvLoader
  module Where

    #
    # params = {
    #   :#{accessor_name} => expected_value,
    #   ...
    # }
    #
    # compare with '=='
    #
    # options = {
    #   :regexp => true
    # }
    #
    # return empty array if the condition is invalid or couldn't find any rows.
    #
    def where conditions = {}, options = {}
      rows = @rows || []
      return rows if conditions.empty?

      # filter the conditions.
      c = conditions.select do |k, v|
            self.class.headers.keys.any? { |key| key.to_s == k.to_s }
          end

      return [] if c.empty?

      if options[:regexp]
        where_with_regexp c
      else
        rows.select { |row| c.all? { |attr, con| (row.send attr) == con } }
      end

    end

    private

    #
    # evaluate expression with #match
    #
    def where_with_regexp conditions = {}
      rows = @rows || []
      return rows if conditions.empty?
      rows.select { |row| conditions.all? { |attr, con| (row.send attr).match con } }
    end

  end
end


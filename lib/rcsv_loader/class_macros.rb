module ClassMacros

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

  private
  #
  # Get headers that include super class's one.
  #
  def all_headers current_class = nil
    current_class ||= self
    return {} if current_class == Object
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

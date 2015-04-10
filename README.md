# RCsvLoader

Mange a csv file more easily.

## Usage

Only 3 steps to start.

### 0. Prepare a csv file.

```

"id","file name"
"1","file_01.zip"

```

### 1. Define a class that represent csv schema.

```ruby

require 'rcsv_loader'

class SampleCsv < RCsvLoader::Base
  column 'id'
  column 'file name', :file_name
end

```

### 2. Load csv file with options.

```ruby

sample = SampleCsv.load_file csv_file_path, encoding: 'utf-8', headers: true

```

### 3. Get values with the accessor that is previously defined.

```ruby

rows = sample.where({ :id => "1" })
p rows.first.file_name # => "file_01.zip"

```

### More

[More information](https://github.com/osadake212/rcsv_loader/wiki).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rcsv_loader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rcsv_loader

## Contributing

1. Fork it ( https://github.com/osadake212/rcsv_loader/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

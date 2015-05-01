require 'spec_helper'
require 'pathname'

require 'models/sample_csv'
require 'models/sample_csv_no_headers'

describe RCsvLoader do

  describe RCsvLoader::Core do

    shared_examples 'to_csv' do |expected|
      subject { data.to_csv }
      it { is_expected.to eq expected }
    end

    shared_examples 'to_csv without headers' do |expected|
      subject { data.to_csv headers: false }
      it { is_expected.to eq expected }
    end

    context "sample"do
      let(:path) { File.join Pathname(__FILE__).dirname, "fixtures/sample.csv" }
      let(:data) { SampleCsv.load_csv path, headers: true }

      expected_with_headers = [
        'id,file name,extension,url',
        '1,file_01.zip,zip,https://example.com/file_01.zip',
        '2,file_02.zip,zip,https://example.com/file_02.zip',
        ''
      ].join($/)
      it_behaves_like 'to_csv', expected_with_headers

      expected_without_headers = [
        '1,file_01.zip,zip,https://example.com/file_01.zip',
        '2,file_02.zip,zip,https://example.com/file_02.zip',
        ''
      ].join($/)
      it_behaves_like 'to_csv without headers', expected_without_headers
    end

    context "sample_without_headers" do
      let(:path) { File.join Pathname(__FILE__).dirname, "fixtures/no_headers_sample.csv" }
      let(:data) { SampleCsvNoHeaders.load_csv path, headers: false }

      expected_with_headers = [
        'id,file_name,extension,url',
        '1,file_01.zip,zip,https://example.com/file_01.zip',
        '2,file_02.zip,zip,https://example.com/file_02.zip',
        ''
      ].join($/)
      it_behaves_like 'to_csv', expected_with_headers

      expected_without_headers = [
        '1,file_01.zip,zip,https://example.com/file_01.zip',
        '2,file_02.zip,zip,https://example.com/file_02.zip',
        ''
      ].join($/)
      it_behaves_like 'to_csv without headers', expected_without_headers
    end

  end

end

require 'spec_helper'
require 'pathname'

require 'models/sample_csv'
require 'models/sample_csv_no_headers'

describe RCsvLoader do
  it 'has a version number' do
    expect(RCsvLoader::VERSION).not_to be nil
  end

  context "sample" do

    shared_examples 'Row attributes' do |expected|
      expected.each do |attr_name|
        it { is_expected.to respond_to attr_name }
      end
    end

    shared_examples "where" do |expected|
      describe "data count" do
        subject { results.count }
        it { is_expected.to eq expected[:data_count] }
      end

      context "first row" do
        subject(:row) { results.first }
        describe "file name" do
          subject { row.file_name }
          it { is_expected.to eq expected[:first_row][:file_name] }
        end
        describe "url" do
          subject { row.url }
          it { is_expected.to eq expected[:first_row][:url] }
        end
      end
    end


    context "with headers" do
      let(:sample) do
        path = File.join(Pathname(__FILE__).dirname, "fixtures/sample.csv")
        SampleCsv.load_csv(path, :headers => true)
      end

      describe "data count" do
        subject { sample.all.count }
        it { is_expected.to eq 2 }
      end

      context "first row" do
        subject { sample.all.first }
        expected = [:id, :file_name, :extension, :url]
        it_behaves_like 'Row attributes', expected
      end

      describe "where" do
        context ':id => "2"' do
          let(:results) { sample.where({ :id => "2" }) }
          expected = {
            :data_count => 1,
            :first_row  => {
              :file_name => "file_02.zip",
              :url       => "https://example.com/file_02.zip"
            }
          }
          it_behaves_like "where", expected
        end

        context ':id => "1", :extension => "zip"' do
          let(:results) { sample.where({ :id => "1", :extension => "zip" }) }
          expected = {
            :data_count => 1,
            :first_row  => {
              :file_name => "file_01.zip",
              :url       => "https://example.com/file_01.zip"
            }
          }
          it_behaves_like "where", expected
        end
      end
    end

    context "with no_headers" do
      let(:sample) do
        path = File.join(Pathname(__FILE__).dirname, "fixtures/no_headers_sample.csv")
        SampleCsvNoHeaders.load_csv path
      end

      describe "data count" do
        subject { sample.all.count }
        it { is_expected.to eq 2 }
      end

      context "first row" do
        subject { sample.all.first }
        expected = [:id, :file_name, :extension, :url]
        it_behaves_like 'Row attributes', expected
      end

      describe "where" do
        context ':extension => "zip"' do
          let(:results) { sample.where({ :extension => "zip" }) }
          expected = {
            :data_count => 2,
            :first_row  => {
              :file_name => "file_01.zip",
              :url       => "https://example.com/file_01.zip"
            }
          }
          it_behaves_like "where", expected
        end

        context ':id => "1", :extension => "zip"' do
          let(:results) { sample.where({ :id => "1", :extension => "zip" }) }
          expected = {
            :data_count => 1,
            :first_row  => {
              :file_name => "file_01.zip",
              :url       => "https://example.com/file_01.zip"
            }
          }
          it_behaves_like "where", expected
        end
      end

    end
  end

end

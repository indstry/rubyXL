require 'rubygems'
require 'rubyXL'

describe RubyXL::Parser do
  before do
    @workbook = (RubyXL::Workbook.new)
    @time_str = Time.now.to_s
    @file = @time_str + '.xlsx'
    @workbook.write(@file)
  end

  describe '.convert_to_index' do
    it 'should convert a well-formed Excel index into a pair of array indices' do
      RubyXL::Parser.convert_to_index('AA1').should == [0, 26]
    end

    it 'should return [-1, -1] if the Excel index is not well-formed' do
      RubyXL::Parser.convert_to_index('A1B').should == [-1, -1]
    end
  end

  describe '.parse' do
    it 'should parse a valid Excel xlsx or xlsm workbook correctly' do
      @workbook2 = RubyXL::Parser.parse(@file)

      @workbook2.worksheets.size.should == @workbook.worksheets.size
      @workbook2[0].sheet_data.should == @workbook[0].sheet_data
      @workbook2[0].sheet_name.should == @workbook[0].sheet_name
    end

    it 'should cause an error if an xlsx or xlsm workbook is not passed' do
      lambda {@workbook2 = RubyXL::Parser.parse(@time_str+".xls")}.should raise_error
    end

    it 'should only read the data and not any of the styles (for the sake of speed) when passed true' do
      @workbook2 = RubyXL::Parser.parse(@file, true)

      @workbook2.worksheets.size.should == @workbook.worksheets.size
      @workbook2[0].sheet_data.should == @workbook[0].sheet_data
      @workbook2[0].sheet_name.should == @workbook[0].sheet_name
    end
  end

  after do
    if File.exist?(@file)
      File.delete(@file)
    end
  end
end

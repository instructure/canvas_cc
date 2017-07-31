require 'spec_helper'

module CanvasCc::CanvasCC
  describe GradingStandardWriter do
    let(:grading_standard) { CanvasCc::CanvasCC::Models::GradingStandard.new }
    let(:tmpdir) { Dir.mktmpdir }

    before :each do
      Dir.mkdir(File.join(tmpdir, CartridgeCreator::COURSE_SETTINGS_DIR))
    end

    after :each do
      FileUtils.rm_r tmpdir
    end

    it 'adds the grading standard' do
      grading_data = [["A", 0.9], ["B", 0.8], ["C", 0.7], ["D", 0.6], ["E", 0.0]]
      grading_standard.identifier = '123'
      grading_standard.title = 'my title'
      grading_standard.data = grading_data
      grading_standard.version = '2'
      xml = write_xml(grading_standard)
      expect(xml.at_xpath('/xmlns:gradingStandards/xmlns:gradingStandard/@identifier').text).to eq '123'
      expect(xml.at_xpath('/xmlns:gradingStandards/xmlns:gradingStandard/@version').text).to eq '2'
      expect(xml.at_xpath('/xmlns:gradingStandards/xmlns:gradingStandard/xmlns:title').text).to eq 'my title'
      expect(xml.at_xpath('/xmlns:gradingStandards/xmlns:gradingStandard/xmlns:data').text).to eq grading_data.to_s
    end

    private

    def write_xml(grading_standard)
      GradingStandardWriter.new(tmpdir, [grading_standard]).write
      path = File.join(tmpdir,
                       CartridgeCreator::COURSE_SETTINGS_DIR,
                       GradingStandardWriter::GRADING_STANDARD_FILE)
      Nokogiri::XML(File.read(path))
    end

  end
end
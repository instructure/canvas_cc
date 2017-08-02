require 'spec_helper'

describe CanvasCc::CanvasCC::OutcomeWriter do
  let(:outcome) do
    outcome = CanvasCc::CanvasCC::Models::Outcome.new
    outcome.identifier = SecureRandom.hex
    outcome.points_possible = 5
    outcome.mastery_points = 5
    outcome.is_global_outcome = false
    outcome
  end
  let(:tmpdir) { Dir.mktmpdir }

  before :each do
    Dir.mkdir(File.join(tmpdir, CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR))
  end

  after :each do
    FileUtils.rm_r tmpdir
  end

  it 'xml contains the correct schema' do
    xml = write_xml(outcome)

    valid_schema = File.read(fixture_path(File.join('common_cartridge', 'schema', 'cccv1p0.xsd')))
    xsd = Nokogiri::XML::Schema(valid_schema)
    expect(xsd.validate(xml)).to be_truthy
  end

  it 'writes an outcome' do
    xml = write_xml(outcome)
    node = xml.at_xpath('//xmlns:learningOutcomes/xmlns:learningOutcome')
    expect(node.attr(:identifier)).to eql outcome.identifier
    expect(node.at_xpath('xmlns:points_possible').text).to eql '5'
    expect(node.at_xpath('xmlns:mastery_points').text).to eql '5'
    expect(node.at_xpath('xmlns:is_global_outcome').text).to eql 'false'
    expect(node.at_xpath('xmlns:calculation_method')).to eql nil
    expect(node.at_xpath('xmlns:calculation_int')).to eql nil
  end

  it 'adds calculation_int if calculation_method is set to "decaying_average"' do
    outcome.calculation_method = 'decaying_average'
    xml = write_xml(outcome)
    node = xml.at_xpath('//xmlns:learningOutcomes/xmlns:learningOutcome')
    expect(node.at_xpath('xmlns:calculation_method').text).to eql 'decaying_average'
    expect(node.at_xpath('xmlns:calculation_int').text).to eql '65'
  end

  private
  def write_xml(outcome)
    CanvasCc::CanvasCC::OutcomeWriter.new(tmpdir, outcome).write
    path = File.join(tmpdir, CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR,
      CanvasCc::CanvasCC::OutcomeWriter::LEARNING_OUTCOMES_FILE)
    Nokogiri::XML(File.read(path))
  end
end

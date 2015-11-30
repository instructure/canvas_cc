require 'spec_helper'

describe CanvasCc::CanvasCC::RubricWriter do
  let!(:rubric) do
    rubric = CanvasCc::CanvasCC::Models::Rubric.new
    rubric.identifier = SecureRandom.hex
    rubric.title = 'some rubric'
    rubric
  end

  let!(:criterion) do
    criterion = CanvasCc::CanvasCC::Models::RubricCriterion.new
    criterion.id = SecureRandom.hex
    criterion.description = 'some criterion'
    rubric.criteria << criterion
    criterion
  end

  let!(:rating) do
    tmp_rating = CanvasCc::CanvasCC::Models::Rating.new
    tmp_rating.id = '123'
    tmp_rating.description = 'a rating'
    tmp_rating.points = 5
    tmp_rating.criterion_id = '123'
    tmp_rating.long_description = 'a longer description'
    criterion.ratings << tmp_rating
    tmp_rating
  end

  let(:tmpdir) { Dir.mktmpdir }

  before :each do
    Dir.mkdir(File.join(tmpdir, CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR))
  end

  after :each do
    FileUtils.rm_r tmpdir
  end

  it 'xml contains the correct schema' do
    xml = write_xml(rubric)

    valid_schema = File.read(fixture_path(File.join('common_cartridge', 'schema', 'cccv1p0.xsd')))
    xsd = Nokogiri::XML::Schema(valid_schema)
    expect(xsd.validate(xml)).to be_truthy
  end

  it 'writes a rubric' do
    xml = write_xml(rubric)
    node = xml.at_xpath('//xmlns:rubrics/xmlns:rubric')
    expect(node.attr('identifier')).to eql rubric.identifier
    expect(node.at_xpath('xmlns:title').text).to eql rubric.title
    criterion_node = node.at_xpath('./xmlns:criteria/xmlns:criterion')
    expect(criterion_node.at_xpath('xmlns:criterion_id').text).to eql criterion.id
    expect(criterion_node.at_xpath('xmlns:description').text).to eql criterion.description
    rating_node = criterion_node.at_xpath('./xmlns:ratings/xmlns:rating')
    expect(rating_node.at_xpath('xmlns:id').text).to eql rating.id
    expect(rating_node.at_xpath('xmlns:description').text).to eql rating.description
  end

  private
  def write_xml(rubric)
    CanvasCc::CanvasCC::RubricWriter.new(tmpdir, rubric).write
    path = File.join(tmpdir, CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR,
      CanvasCc::CanvasCC::RubricWriter::RUBRICS_FILE)
    Nokogiri::XML(File.read(path))
  end
end

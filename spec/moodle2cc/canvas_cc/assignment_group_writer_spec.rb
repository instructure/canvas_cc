require 'spec_helper'

module CanvasCc::CanvasCC
  describe AssignmentGroupWriter do

    let(:assignment_group) { CanvasCc::CanvasCC::Models::AssignmentGroup.new }
    let(:tmpdir) { Dir.mktmpdir }

    before :each do
      Dir.mkdir(File.join(tmpdir, CartridgeCreator::COURSE_SETTINGS_DIR))
    end

    after :each do
      FileUtils.rm_r tmpdir
    end

    it 'xml contains the correct schema' do
      xml = write_xml(assignment_group)

      valid_schema = File.read(fixture_path(File.join('common_cartridge', 'schema', 'cccv1p0.xsd')))
      xsd = Nokogiri::XML::Schema(valid_schema)
      expect(xsd.validate(xml)).to be_true
    end

    it 'adds assignment group' do
      assignment_group.identifier = 'identifier'
      assignment_group.title = 'title'
      assignment_group.position = '1'
      assignment_group.group_weight = '1'
      assignment_group.rules << {b:2, c:3}
      xml = write_xml(assignment_group)
      expect(xml.at_xpath('/xmlns:assignmentGroups/xmlns:assignmentGroup/@identifier').text).to eq(assignment_group.identifier)
      expect(xml.at_xpath('/xmlns:assignmentGroups/xmlns:assignmentGroup/xmlns:title').text).to eq(assignment_group.title)
      expect(xml.at_xpath('/xmlns:assignmentGroups/xmlns:assignmentGroup/xmlns:position').text).to eq(assignment_group.position)
      expect(xml.at_xpath('/xmlns:assignmentGroups/xmlns:assignmentGroup/xmlns:group_weight').text).to eq(assignment_group.group_weight)
      expect(xml.at_xpath('/xmlns:assignmentGroups/xmlns:assignmentGroup/xmlns:rules/xmlns:rule/xmlns:b').text).to eq "2"
      expect(xml.at_xpath('/xmlns:assignmentGroups/xmlns:assignmentGroup/xmlns:rules/xmlns:rule/xmlns:c').text).to eq "3"
    end

    private

    def write_xml(assignment_group)
      AssignmentGroupWriter.new(tmpdir, [assignment_group]).write
      path = File.join(tmpdir,
                       CartridgeCreator::COURSE_SETTINGS_DIR,
                       AssignmentGroupWriter::ASSIGNMENT_GROUP_FILE)
      Nokogiri::XML(File.read(path))
    end

  end
end

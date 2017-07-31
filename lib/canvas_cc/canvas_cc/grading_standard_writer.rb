module CanvasCc::CanvasCC
  class GradingStandardWriter
    GRADING_STANDARD_FILE = 'grading_standards.xml'

    def initialize(work_dir, grading_standards)
      @work_dir = work_dir
      @grading_standards = grading_standards
    end

    def write
      xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        write_grading_standards(xml) do |xml|
          @grading_standards.each do |gs|
            xml.gradingStandard(identifier: gs.identifier, version: gs.version){
              xml.title gs.title
              xml.data gs.data
            }
          end
        end
      end.to_xml
      File.open(File.join(@work_dir, CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, GRADING_STANDARD_FILE), 'w') { |f| f.write(xml) }
    end

    private

    def write_grading_standards(xml)
      xml.gradingStandards(
        'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
      ) {
        yield xml
      }
    end
  end
end

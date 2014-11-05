module CanvasCc::CanvasCC
  class AssignmentGroupWriter
    ASSIGNMENT_GROUP_FILE = 'assignment_groups.xml'

    def initialize(work_dir, assignment_groups)
      @work_dir = work_dir
      @assignment_groups = assignment_groups
    end

    def write
      xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        write_assignment_groups(xml) do |xml|
          @assignment_groups.each do |ag|
            xml.assignmentGroup(:identifier => ag.identifier){
              xml.title ag.title
              xml.position ag.position
              xml.group_weight ag.group_weight
              write_rules(ag, xml)
            }
          end
        end
      end.to_xml
      File.open(File.join(@work_dir, CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, ASSIGNMENT_GROUP_FILE), 'w') { |f| f.write(xml) }
    end

    private

    def write_rules(assignment_group, xml)
      xml.rules{
        assignment_group.rules.each do |rule|
          xml.rule{
            rule.each { |k, v| xml.send(k, v) }
          }
        end
      }
    end

    def write_assignment_groups(xml)
      xml.assignmentGroups(
        'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
      ) {
        yield xml
      }
    end
  end
end

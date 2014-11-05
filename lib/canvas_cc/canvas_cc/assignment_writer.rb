module CanvasCc::CanvasCC
  class AssignmentWriter
    include AssignmentHelper

    def initialize(work_dir, *assignments)
      @work_dir = work_dir
      @assignments = assignments
    end

    def write
      @assignments.each do |assignment|
        assignment_dir = File.join(@work_dir, assignment.assignment_resource.identifier)
        Dir.mkdir(assignment_dir)
        write_html(assignment_dir, assignment)
        write_settings(assignment_dir, assignment)
      end
    end

    private

    def write_settings(assignment_dir, assignment)
      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.assignment('identifier' => assignment.assignment_resource.identifier,
                       'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
                       'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                       'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
        ) { |xml|
          assignment_xml(assignment, xml)
        }
      end.to_xml
      File.open(File.join(assignment_dir, CanvasCc::CanvasCC::Models::Assignment::ASSIGNMENT_SETTINGS_FILE), 'w') { |f| f.write(xml) }
    end


    def write_html(assignment_dir, assignment)
      builder = Nokogiri::HTML::Builder.new(:encoding => 'UTF-8') do |doc|
        doc.html { |html|
          html.head { |head|
            head.meta('http-equiv' => 'Content-Type', content: 'text/html; charset=utf-8')
            head.title "Assignment: #{assignment.title}"
          }
          html.body { |body|
            body << Nokogiri::HTML::fragment(assignment.body)
          }
        }
      end
      File.open(File.join(@work_dir, assignment.assignment_resource.href), 'w') { |f| f.write(builder.to_html) }
    end

  end
end

module CanvasCc::CanvasCC
  class RubricWriter
    RUBRICS_FILE = 'rubrics.xml'

    def initialize(work_dir, *rubrics)
      @work_dir = work_dir
      @rubrics = rubrics
    end

    def write
      xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        write_rubrics(xml) do |xml|
          @rubrics.each do |rubric|
            xml.rubric(identifier: rubric.identifier) do
              CanvasCc::CanvasCC::Models::Rubric::META_ATTRIBUTES.each do |attr|
                xml.send(attr, rubric.send(attr)) unless rubric.send(attr).nil?
              end
              write_criteria xml, rubric
            end
          end
        end
      end.to_xml
      File.open(File.join(@work_dir, CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, RUBRICS_FILE), 'w') { |f| f.write(xml) }
    end

    def write_criteria(xml, rubric)
      xml.criteria do
        rubric.criteria.each do |criterion|
          xml.criterion do
            xml.criterion_id criterion.id
            CanvasCc::CanvasCC::Models::RubricCriterion::META_ATTRIBUTES.each do |attr|
              xml.send(attr, criterion.send(attr)) unless criterion.send(attr).nil?
            end
            xml.learning_outcome_identifierref criterion.learning_outcome.identifier if criterion.learning_outcome
            xml << CanvasCc::CanvasCC::RatingWriter.new(*criterion.ratings).write
          end
        end
      end
    end

    private
    def write_rubrics(xml)
      xml.rubrics(
        'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
      ) {
        yield xml
      }
    end
  end
end

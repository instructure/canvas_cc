module CanvasCc::CanvasCC
  class OutcomeWriter
    LEARNING_OUTCOMES_FILE = 'learning_outcomes.xml'

    def initialize(work_dir, *outcomes)
      @work_dir = work_dir
      @outcomes = outcomes
    end

    def write
      xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        write_outcomes(xml) do |xml|
          @outcomes.each do |outcome|
            xml.learningOutcome(identifier: outcome.identifier) do
              xml.title outcome.title
              xml.description outcome.description
              xml.points_possible outcome.points_possible
              xml.mastery_points outcome.mastery_points
              xml << CanvasCc::CanvasCC::RatingWriter.new(*outcome.ratings).write
              xml.is_global_outcome outcome.is_global_outcome
              xml.external_identifier outcome.external_identifier if outcome.external_identifier
            end
          end
        end
      end.to_xml
      File.open(File.join(@work_dir, CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, LEARNING_OUTCOMES_FILE), 'w') { |f| f.write(xml) }
    end

    private
    def write_outcomes(xml)
      xml.learningOutcomes(
        'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
      ) {
        yield xml
      }
    end
  end
end

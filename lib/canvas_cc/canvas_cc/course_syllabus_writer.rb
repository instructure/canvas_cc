module CanvasCc::CanvasCC
  class CourseSyllabusWriter

    COURSE_SYLLABUS_FILE = 'syllabus.html'

    def initialize(work_dir, syllabus)
      @work_dir = work_dir
      @syllabus = syllabus
    end

    def write
      return if @syllabus == nil

      builder = build_syllabus_html

      syllabus_directory = File.join(@work_dir, CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR)
      FileUtils.mkdir_p(syllabus_directory)
      syllabus_file = File.join(syllabus_directory, COURSE_SYLLABUS_FILE)
      File.open(syllabus_file, 'w') do |f|
        f.write(builder.to_html)
      end
    end

    private

    def build_syllabus_html
      Nokogiri::HTML::Builder.new(:encoding => 'UTF-8') do |doc|
        doc.html { |html|
          html.head { |head|
            head.meta('http-equiv' => 'Content-Type', content: 'text/html; charset=utf-8')
            head.title 'Syllabus'
          }

          html.body { |body|
            body << Nokogiri::HTML::fragment(@syllabus.html)
          }
        }
      end
    end

  end
end
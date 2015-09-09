module CanvasCc::CanvasCC
  class FileMetaWriter

    FILE_META_FILE = 'files_meta.xml'

    def initialize(work_dir, canvas_files, canvas_folders)
      @work_dir = work_dir
      @canvas_files = [canvas_files].flatten.compact
      @canvas_folders = [canvas_folders].flatten.compact
    end

    def write
      copy_files unless @canvas_files.nil?
      write_xml do |xml|
        write_folders(xml) unless @canvas_folders.empty?
        write_files(xml) unless @canvas_files.empty?
      end
    end

    private

    def write_folders(xml)
      xml.folders{
        @canvas_folders.each do |folder|
          xml.folder('path' => folder.folder_location){
            xml.hidden folder.hidden unless folder.hidden.nil?
            xml.locked folder.locked unless folder.locked.nil?
          }
        end
      }
    end

    def write_files(xml)
      xml.files{
        @canvas_files.each do |file|
          xml.file('identifier' => file.identifier){
            xml.hidden file.hidden unless file.hidden.nil?
            xml.locked file.locked unless file.locked.nil?
            unless file.usage_rights.nil?
              xml.usage_rights('use_justification' => file.usage_rights) {
                xml.license file.license
              }
            end
          }
        end
      }
    end

    def copy_files
      @canvas_files.each do |canvas_file|
        FileUtils.mkdir_p(File.dirname(File.join(@work_dir, canvas_file.href)))
        FileUtils.cp(canvas_file.file_location, File.join(@work_dir, canvas_file.href))
      end
    end

    def write_xml
      xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.fileMeta(
          'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
          'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
          'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
        ){
          yield xml
        }
      end.to_xml
      File.open(File.join(@work_dir, CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, FILE_META_FILE), 'w') { |f| f.write(xml) }
    end

  end
end

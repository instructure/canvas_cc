module CanvasCc::CanvasCC
  class ModuleMetaWriter
    MODULE_META_FILE = 'module_meta.xml'

    def initialize(work_dir, *canvas_modules)
      @work_dir = work_dir
      @canvas_modules = canvas_modules
    end

    def write
      xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.modules(
            'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
            'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
            'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
        ) { |xml|
          @canvas_modules.each_with_index { |mod, position| canvas_module(mod, xml, position) }
        }
      end.to_xml
      File.open(File.join(@work_dir, CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, MODULE_META_FILE), 'w') { |f| f.write(xml) }
    end

    private

    def canvas_module(mod, xml, position)
      xml.module('identifier' => mod.identifier) {
        xml.title mod.title
        xml.workflow_state mod.workflow_state
        xml.require_sequential_progress mod.require_sequential_progress unless mod.require_sequential_progress.nil?
        xml.start_at CanvasCc::CC::CCHelper.ims_datetime(mod.start_at) if mod.start_at
        xml.end_at CanvasCc::CC::CCHelper.ims_datetime(mod.end_at) if mod.end_at
        xml.unlock_at CanvasCc::CC::CCHelper.ims_datetime(mod.unlock_at) if mod.unlock_at
        xml.position(position)
        xml.items { |xml|
          add_module_items_to_xml(mod.module_items, xml)
        }
        xml.prerequisites { |xml|
          add_prerequisites_to_xml(mod.prerequisites, xml)
        }

        xml.completionRequirements {|xml|
          add_completion_requirements_to_xml(mod.completion_requirements, xml)
        }
      }
    end

    def add_module_items_to_xml(module_items, xml)
      module_items.each_with_index do |item, position|
        xml.item('identifier' => item.identifier) { |xml|
          xml.content_type(item.content_type)
          xml.workflow_state(item.workflow_state)
          xml.title(item.title)
          xml.position(position)
          xml.new_tab(item.new_tab) if item.new_tab
          xml.indent(item.indent)
          xml.identifierref(item.identifierref) if item.identifierref
          xml.url(item.url) if item.url
          xml.external_tool_url(item.external_tool_url) if item.external_tool_url
        }
      end
    end

    def add_prerequisites_to_xml(prerequisites, xml)
      prerequisites.each do |pre|
        xml.prerequisite('type' => pre.type) { |xml|
          xml.title pre.title
          xml.identifierref pre.identifierref
        }
      end
    end

    def add_completion_requirements_to_xml(completion_requirements, xml)
      completion_requirements.each do |comp_req|
        xml.completionRequirement('type' => comp_req.type){|xml|
          xml.identifierref comp_req.identifierref
          xml.min_score comp_req.min_score
          xml.max_score comp_req.max_score
        }
      end
    end

  end
end

module CanvasCc::Canvas
  class Label < CanvasCc::CC::Label
    include Resource
    def create_module_meta_item_elements(item_node)
      item_node.content_type 'ContextModuleSubHeader'
    end
  end
end

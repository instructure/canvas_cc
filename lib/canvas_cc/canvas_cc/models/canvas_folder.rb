module CanvasCc::CanvasCC::Models
  class CanvasFolder < CanvasCc::CanvasCC::Models::Resource

    WEB_RESOURCES = 'web_resources'

    attr_accessor :folder_location, :hidden, :locked

    def initialize
      super
      @type = WEB_CONTENT_TYPE
    end


  end
end

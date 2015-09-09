module CanvasCc::CanvasCC::Models
  class CanvasFile < CanvasCc::CanvasCC::Models::Resource

    WEB_RESOURCES = 'web_resources'

    attr_reader :file_path
    attr_accessor :file_location, :hidden, :locked, :usage_rights

    def initialize
      super
      @type = WEB_CONTENT_TYPE
    end

    def file_path=(file_path)
      @href = File.join(WEB_RESOURCES, file_path)
      @files << self.href
      @file_path = file_path
    end

    def license
      case usage_rights
      when 'own_copyright', 'used_by_permission', 'fair_use'
        'private'
      else
        usage_rights
      end
    end
  end
end

module CanvasCc::CanvasCC::Models
  class GradingStandard
    attr_accessor :identifier, :title, :data, :version

    def initialize
      @data = []
    end
  end
end
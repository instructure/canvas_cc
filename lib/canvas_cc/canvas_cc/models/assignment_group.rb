module CanvasCc::CanvasCC::Models
  class AssignmentGroup
    attr_accessor :identifier, :title, :position, :group_weight, :rules

    def initialize
      @rules = []
    end
  end
end

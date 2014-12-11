module CanvasCc::CanvasCC::Models
  class QuestionGroup

    attr_accessor :identifier, :title, :questions, :group_type, :selection_number, :points_per_item, :sourcebank_ref

    def initialize
      @questions = []
    end
  end
end

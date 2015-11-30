module CanvasCc::CanvasCC::Models
  class RubricCriterion
    META_ATTRIBUTES = %i(description long_description points mastery_points ignore_for_sorting)
    attr_accessor :id, :learning_outcome, :ratings, *META_ATTRIBUTES

    def initialize
      @ratings = []
    end
  end
end

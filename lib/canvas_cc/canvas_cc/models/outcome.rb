module CanvasCc::CanvasCC::Models
  class Outcome
    DEFAULT_CALCULATION_INT = 65

    attr_accessor :identifier, :title, :description, :points_possible, :mastery_points,
      :ratings, :is_global_outcome, :ratings, :external_identifier, :calculation_method,
      :calculation_int, :alignments

    def initialize
      @ratings = []
      @alignments = []
      @calculation_int = DEFAULT_CALCULATION_INT
    end

  end
end

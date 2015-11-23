module CanvasCc::CanvasCC::Models
  class Outcome
    attr_accessor :identifier, :title, :description, :points_possible, :mastery_points,
      :ratings, :is_global_outcome, :ratings, :external_identifier

    def initialize
      @ratings = []
    end

  end
end

module CanvasCc::CanvasCC::Models
  class Rubric
    META_ATTRIBUTES = %i(external_identifier title description read_only
      reusable public points_possible free_form_criterion_comments)
    attr_accessor :identifier, :criteria, *META_ATTRIBUTES

    def initialize
      @criteria = []
    end
  end
end

module CanvasCc::CanvasCC::Models
  class ModuleCompletionRequirement
    attr_accessor :identifierref, :min_score, :max_score, :type
    CONTENT_TYPE_MUST_VIEW = 'must_view'
    CONTENT_TYPE_MUST_SUBMIT = 'must_submit'
    CONTENT_TYPE_MIN_SCORE = 'min_score'
    CONTENT_TYPE_MUST_CONTRIBUTE = 'must_contribute'
    CONTENT_TYPE_MARK_AS_DONE = 'must_mark_done'
  end
end

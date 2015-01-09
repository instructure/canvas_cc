module CanvasCc::CanvasCC::Models
  class CanvasModule

    attr_accessor :identifier, :title, :workflow_state, :module_items,
    :unlock_at, :start_at, :end_at, :require_sequential_progress, :prerequisites

    def initialize
      @module_items = []
      @prerequisites = []
    end
  end
end

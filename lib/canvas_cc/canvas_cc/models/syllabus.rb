module CanvasCc::CanvasCC::Models
  class Syllabus < CanvasCc::CanvasCC::Models::Resource

    DIR = '/syllabus'

    attr_accessor :html

    def initialize
      super
    end
  end
end

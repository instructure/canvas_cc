module CanvasCc::CanvasCC::Models
  class Course

    attr_accessor :format, :identifier, :copyright, :settings, :resources, :canvas_modules, :files, :pages, :discussions,
                  :assignments, :assessments, :question_banks, :assignment_groups, :folders, :syllabus, :outcomes, :rubrics

    def initialize
      @settings = {}
      @resources = []
      @canvas_modules = []
      @files = []
      @folders = []
      @pages = []
      @discussions = []
      @assignments = []
      @assessments = []
      @question_banks = []
      @assignment_groups = []
      @outcomes = []
      @rubrics = []
    end

    def start_at
      CanvasCc::CC::CCHelper.ims_datetime(@settings[:start_at]) if @settings[:start_at]
    end


    def conclude_at
      CanvasCc::CC::CCHelper.ims_datetime(@settings[:conclude_at]) if @settings[:conclude_at]
    end

    def all_resources
      @resources + @files + @pages + @discussions.map(&:resources).flatten + @assignments.map(&:resources).flatten + @assessments.map(&:resources).flatten
    end

    def method_missing(m, *args, &block)
      method = m.to_s
      if method[-1, 1] == '='
        method.chomp!('=')
        @settings[method.to_sym] = args.first
      end
      @settings[method.to_sym]
    end

    def resolve_question_references!
      return unless @assessments && @question_banks
      @assessments.each{|a| a.resolve_question_references!(@question_banks)}
    end

    def mute_assignments!
      @assignments.each do |assignment|
        assignment.muted = true
      end
    end
  end
end

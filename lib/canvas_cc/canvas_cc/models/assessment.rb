module CanvasCc::CanvasCC::Models
  class Assessment
    META_ATTRIBUTES = [:title, :description, :allowed_attempts, :points_possible,
                       :scoring_policy, :access_code, :ip_filter, :shuffle_answers, :time_limit,
                       :quiz_type, :hide_results, :require_lockdown_browser, :require_lockdown_browser_for_results,
                       :require_lockdown_browser_monitor, :lockdown_browser_monitor_data,
                       :show_correct_answers, :anonymous_submissions, :could_be_locked,
                       :available, :allowed_attempts, :one_question_at_a_time, :cant_go_back,
                       :assignment_group_identifierref, :one_time_results]
    DATETIME_ATTRIBUTES = [:lock_at, :unlock_at, :due_at, :show_correct_answers_at]

    ASSESSMENT_TYPE = 'imsqti_xmlv1p2/imscc_xmlv1p1/assessment'
    LAR_TYPE = 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
    ASSESSMENT_NON_CC_FOLDER = 'non_cc_assessments'

    attr_accessor :identifier, :workflow_state, :question_references, :items, :assignment, *META_ATTRIBUTES, *DATETIME_ATTRIBUTES

    def initialize
      @question_references = []
    end

    def resources
      [cc_assessment_resource, canvas_assessment_resource]
    end

    def cc_assessment_resource
      resource = CanvasCc::CanvasCC::Models::Resource.new
      resource.identifier = @identifier
      resource.type = ASSESSMENT_TYPE
      resource.dependencies = ["#{@identifier}_meta"]
      resource.files = [] # TODO: export cc qti file
      resource
    end

    def canvas_assessment_resource
      resource = CanvasCc::CanvasCC::Models::Resource.new
      resource.identifier = "#{@identifier}_meta"
      resource.href = meta_file_path
      resource.type = LAR_TYPE
      resource.files = [meta_file_path, qti_file_path]
      resource
    end

    def meta_file_path
      "#{@identifier}/assessment_meta.xml"
    end

    def qti_file_path
      "#{ASSESSMENT_NON_CC_FOLDER}/#{@identifier}.xml.qti"
    end

    def resolve_question_references!(question_banks)
      @items ||= []

      # keep track of each time a bank is referenced through a random question reference
      random_bank_counts = {}

      @question_references.each do |ref|
        question = nil
        group = nil
        question_banks.each do |bank|
          break if (question = bank.questions.detect{|q| q.original_identifier.to_s == ref[:question]}) ||
            (group = bank.question_groups.detect{|g| g.identifier.to_s == ref[:question]})

          if bank.random_question_references.any?{|r| r.to_s == ref[:question]}
            random_bank_counts[bank] ||= 0
            random_bank_counts[bank] += 1
            break
          end
        end

        if question
          question.assessment_question_identifierref ||= "question_#{question.identifier}"
          copy = question.dup
          copy.points_possible = ref[:grade] if ref[:grade]
          @items << copy
        elsif group
          copy = group.dup
          if ref[:grade] && copy.selection_number.to_i != 0
            copy.points_per_item = ref[:grade].to_f / copy.selection_number.to_i
          end
          @items << copy
        end
      end

      random_bank_counts.each do |bank, count|
        new_group = CanvasCc::CanvasCC::Models::QuestionGroup.new
        new_group.identifier = "#{@identifier}#{bank.identifier}_random_group"
        new_group.selection_number = count

        new_group.questions = bank.questions.map(&:dup)
        child_banks = bank.find_children_banks(question_banks)
        child_banks.each do |child|
          new_group.questions += child.questions.map(&:dup)
        end

        @items << new_group
      end

      @items.select{|i| i.is_a?(CanvasCc::CanvasCC::Models::QuestionGroup)}.each do |group|
        group.questions.each do |q|
          @items.delete_if{|i| i.respond_to?(:original_identifier) && i.original_identifier == q.original_identifier}
        end
      end
    end
  end
end

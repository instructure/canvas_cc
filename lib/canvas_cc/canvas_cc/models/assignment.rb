module CanvasCc::CanvasCC::Models
  class Assignment
    attr_accessor :identifier, :title, :body, :due_at, :lock_at, :unlock_at, :all_day_date, :peer_reviews_due_at,
                  :assignment_group_identifier_ref, :workflow_state, :points_possible, :grading_type, :all_day,
                  :submission_types, :position, :peer_review_count, :peer_reviews_assigned, :peer_reviews,
                  :automatic_peer_reviews, :grade_group_students_individually, :muted, :turnitin_enabled,
                  :anonymous_peer_reviews, :quiz_identifierref, :rubric, :rubric_use_for_grading, :rubric_hide_score_total,
                  :grading_standard_identifier_ref, :omit_from_final_grade, :external_tool_url, :external_tool_new_tab

    LAR_TYPE = 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
    ASSIGNMENT_SETTINGS_FILE = 'assignment_settings.xml'

    def initialize
      @submission_types = []
    end

    def resources
      [assignment_resource]
    end

    def assignment_resource
      resource = CanvasCc::CanvasCC::Models::Resource.new
      resource.identifier = @identifier
      resource.href = "#{resource.identifier}/assignment-#{CGI::escape(title.downcase.gsub(/\s/, '-'))}.html"
      resource.type = LAR_TYPE
      resource.files = [resource.href, "#{resource.identifier}/#{ASSIGNMENT_SETTINGS_FILE}"]

      resource
    end

  end
end

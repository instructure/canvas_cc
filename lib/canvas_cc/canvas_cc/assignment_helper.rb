module CanvasCc::CanvasCC::AssignmentHelper
  def assignment_xml(assignment, xml)
    xml.title assignment.title
    xml.due_at CanvasCc::CC::CCHelper.ims_datetime(assignment.due_at) if assignment.due_at
    xml.lock_at CanvasCc::CC::CCHelper.ims_datetime(assignment.lock_at) if assignment.lock_at
    xml.unlock_at CanvasCc::CC::CCHelper.ims_datetime(assignment.unlock_at) if assignment.unlock_at
    xml.all_day_date CanvasCc::CC::CCHelper.ims_datetime(assignment.all_day_date) if assignment.all_day_date
    xml.peer_reviews_due_at CanvasCc::CC::CCHelper.ims_datetime(assignment.peer_reviews_due_at) if assignment.peer_reviews_due_at
    xml.assignment_group_identifierref assignment.assignment_group_identifier_ref if assignment.assignment_group_identifier_ref
    xml.grading_standard_identifierref assignment.grading_standard_identifier_ref if assignment.grading_standard_identifier_ref
    xml.omit_from_final_grade assignment.omit_from_final_grade if assignment.omit_from_final_grade
    xml.workflow_state assignment.workflow_state if assignment.workflow_state
    xml.points_possible assignment.points_possible if assignment.points_possible
    xml.grading_type assignment.grading_type if assignment.grading_type
    xml.all_day assignment.all_day unless assignment.all_day.nil?
    xml.submission_types assignment.submission_types.join(',') unless assignment.submission_types.empty?
    xml.position assignment.position if assignment.position
    xml.peer_review_count assignment.peer_review_count if assignment.peer_review_count
    xml.peer_reviews_assigned assignment.peer_reviews_assigned unless assignment.peer_reviews_assigned.nil?
    xml.peer_reviews assignment.peer_reviews unless assignment.peer_reviews.nil?
    xml.automatic_peer_reviews assignment.automatic_peer_reviews unless assignment.automatic_peer_reviews.nil?
    xml.grade_group_students_individually assignment.grade_group_students_individually unless assignment.grade_group_students_individually.nil?
    xml.muted assignment.muted unless assignment.muted.nil?
    xml.turnitin_enabled assignment.turnitin_enabled unless assignment.turnitin_enabled.nil?
    xml.peer_review_count assignment.peer_review_count unless assignment.peer_review_count.nil?
    xml.peer_reviews_assigned assignment.peer_reviews_assigned unless assignment.peer_reviews_assigned.nil?
    xml.peer_reviews assignment.peer_reviews unless assignment.peer_reviews.nil?
    xml.automatic_peer_reviews assignment.automatic_peer_reviews unless assignment.automatic_peer_reviews.nil?
    xml.anonymous_peer_reviews assignment.anonymous_peer_reviews unless assignment.anonymous_peer_reviews.nil?
    xml.quiz_identifierref assignment.quiz_identifierref unless assignment.quiz_identifierref.nil?
    unless assignment.rubric.nil?
      xml.rubric_identifierref assignment.rubric.identifier
      xml.rubric_external_identifier assignment.rubric.external_identifier
    end
    xml.rubric_use_for_grading assignment.rubric_use_for_grading unless assignment.rubric_use_for_grading.nil?
    xml.rubric_hide_score_total assignment.rubric_hide_score_total unless assignment.rubric_hide_score_total.nil?
    xml.external_tool_url assignment.external_tool_url if assignment.external_tool_url
    xml.external_tool_new_tab assignment.external_tool_new_tab if assignment.external_tool_new_tab
  end
end

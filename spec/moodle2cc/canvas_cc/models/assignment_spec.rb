require 'spec_helper'

describe CanvasCc::CanvasCC::Models::Assignment do

  it_behaves_like 'it has an attribute for', :title
  it_behaves_like 'it has an attribute for', :body
  it_behaves_like 'it has an attribute for', :due_at
  it_behaves_like 'it has an attribute for', :position
  it_behaves_like 'it has an attribute for', :identifier
  it_behaves_like 'it has an attribute for', :lock_at
  it_behaves_like 'it has an attribute for', :unlock_at
  it_behaves_like 'it has an attribute for', :all_day_date
  it_behaves_like 'it has an attribute for', :peer_reviews_due_at
  it_behaves_like 'it has an attribute for', :assignment_group_identifier_ref
  it_behaves_like 'it has an attribute for', :grading_standard_identifier_ref
  it_behaves_like 'it has an attribute for', :workflow_state
  it_behaves_like 'it has an attribute for', :points_possible
  it_behaves_like 'it has an attribute for', :grading_type
  it_behaves_like 'it has an attribute for', :all_day
  it_behaves_like 'it has an attribute for', :submission_types, []
  it_behaves_like 'it has an attribute for', :peer_review_count
  it_behaves_like 'it has an attribute for', :peer_reviews_assigned
  it_behaves_like 'it has an attribute for', :peer_reviews
  it_behaves_like 'it has an attribute for', :automatic_peer_reviews
  it_behaves_like 'it has an attribute for', :grade_group_students_individually
  it_behaves_like 'it has an attribute for', :omit_from_final_grade

  it 'creates a resource' do
    allow(subject).to receive(:assignment_resource) {:assignment_resource}
    expect(subject.resources).to eq [:assignment_resource]
  end

  it 'generates an assignment resource' do
    subject.identifier = 'assignment_id'
    subject.title = 'My Assignment'

    resource = subject.assignment_resource
    expect(resource).to be_a_kind_of CanvasCc::CanvasCC::Models::Resource
    expect(resource.files.count).to eq 2
    expect(resource.identifier).to eq 'assignment_id'
    expect(resource.type).to eq 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
    expect(resource.href).to eq 'assignment_id/assignment-my-assignment.html'
    expect(resource.files).to include 'assignment_id/assignment-my-assignment.html'
    expect(resource.files).to include 'assignment_id/assignment_settings.xml'
  end

end
require 'spec_helper'

describe CanvasCc::CanvasCC::Models::Outcome do
  it_behaves_like 'it has an attribute for', :identifier
  it_behaves_like 'it has an attribute for', :title
  it_behaves_like 'it has an attribute for', :description
  it_behaves_like 'it has an attribute for', :points_possible
  it_behaves_like 'it has an attribute for', :mastery_points
  it('has an attribute for ratings') { expect(subject.ratings).to eql [] }
  it_behaves_like 'it has an attribute for', :is_global_outcome
  it_behaves_like 'it has an attribute for', :external_identifier
end

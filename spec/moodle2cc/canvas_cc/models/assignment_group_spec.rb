require 'spec_helper'

describe CanvasCc::CanvasCC::Models::AssignmentGroup do

  it_behaves_like 'it has an attribute for', :title
  it_behaves_like 'it has an attribute for', :position
  it_behaves_like 'it has an attribute for', :group_weight
  it_behaves_like 'it has an attribute for', :identifier
end

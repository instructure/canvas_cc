require 'spec_helper'

describe CanvasCc::CanvasCC::Models::Rating do
  it_behaves_like 'it has an attribute for', :id
  it_behaves_like 'it has an attribute for', :description
  it_behaves_like 'it has an attribute for', :points
  it_behaves_like 'it has an attribute for', :criterion_id
  it_behaves_like 'it has an attribute for', :long_description
end

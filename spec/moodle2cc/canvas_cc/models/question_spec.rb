require 'spec_helper'

module CanvasCc::CanvasCC::Models
  describe Question do
    it_behaves_like 'it has an attribute for', :identifier
    it_behaves_like 'it has an attribute for', :title
  end
end
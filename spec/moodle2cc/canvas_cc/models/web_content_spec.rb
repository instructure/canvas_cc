require 'spec_helper'

module CanvasCc::CanvasCC::Models
  describe WebContent do
    it_behaves_like 'it has an attribute for', :body
  end
end
require 'spec_helper'

module CanvasCc::CanvasCC::Models
  describe WebLink do
    it_behaves_like 'it has an attribute for', :url
    it_behaves_like 'it has an attribute for', :external_link
    it_behaves_like 'it has an attribute for', :href
  end
end
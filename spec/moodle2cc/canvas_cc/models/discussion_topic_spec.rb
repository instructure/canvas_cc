require 'spec_helper'

module CanvasCc::CanvasCC::Models
  describe DiscussionTopic do
    it_behaves_like 'it has an attribute for', :text
  end
end
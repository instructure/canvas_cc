require 'spec_helper'

module CanvasCc::CanvasCC::Models
  describe Page do
    subject(:page) { Page.new }

    it_behaves_like 'a CanvasCc::CanvasCC::Models::Resource'

    it_behaves_like 'it has an attribute for', :workflow_state
    it_behaves_like 'it has an attribute for', :editing_roles
    it_behaves_like 'it has an attribute for', :body
    it_behaves_like 'it has an attribute for', :title

    it "hashes the identifier" do
      page.identifier = 3
      expect(page.identifier).to eq 3
    end

    it "sets the wiki_dir, and title" do
      page.page_name = 'My Page Name'
      expect(page.href).to eq 'wiki_content/my-page-name.html'
      expect(page.title).to eq 'My Page Name'
    end

    it "truncates urls that are too long" do
      page.page_name = 'a' * 500
      expected = "wiki_content/#{'a' * CanvasCc::CanvasCC::Models::Page::MAX_URL_LENGTH}.html"
      expect(page.href).to eq expected
    end

    it "generates urls from page name" do
      name = '2.1_nutrition(mythbustercarbohydrates).html'
      url = Page.convert_name_to_url(name)
      expect(url).to eq '2-dot-1-nutrition-mythbustercarbohydrates-dot-html'
    end

  end
end

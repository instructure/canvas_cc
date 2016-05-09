require 'spec_helper'

module CanvasCc::CanvasCC::Models
  describe CanvasFile do

    it_behaves_like 'a CanvasCc::CanvasCC::Models::Resource'
    it_behaves_like 'it has an attribute for', :file_location
    it_behaves_like 'it has an attribute for', :hidden
    it_behaves_like 'it has an attribute for', :locked
    it_behaves_like 'it has an attribute for', :unlock_at
    it_behaves_like 'it has an attribute for', :lock_at

    it 'has a type to webcontent' do
      expect(subject.type).to eq(Resource::WEB_CONTENT_TYPE)
    end

    it 'sets up href, file_path and files on #file_path=' do
      filename = 'myfile.txt'
      subject.file_path = filename
      expect(subject.href).to eq('web_resources/myfile.txt')
      expect(subject.file_path).to eq(filename)
      expect(subject.files.count).to eq(1)
      expect(subject.files.first).to eq('web_resources/myfile.txt')
    end

  end
end

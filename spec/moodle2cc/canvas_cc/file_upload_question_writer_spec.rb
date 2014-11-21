require 'spec_helper'

module CanvasCc::CanvasCC
  describe FileUploadQuestionWriter do

    let(:question) { CanvasCc::CanvasCC::Models::Question.create('file_upload_question')}

    it 'creates the question item xml for a file upload question' do
      question.identifier = 4200
      question.title = 'hello title'
      question.general_feedback = 'feedbacks'
      question.material = 'this is the material'

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      expect(xml.at_xpath('item/@ident').value).to eq question.identifier.to_s
      expect(xml.at_xpath('item/@title').value).to eq question.title
      expect(xml.at_xpath("item/itemmetadata/qtimetadata/qtimetadatafield[fieldlabel=\"question_type\" and fieldentry=\"#{question.question_type}\"]")).to_not be_nil
    end
  end
end

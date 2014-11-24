module CanvasCc::CanvasCC
  class FileUploadQuestionWriter < QuestionWriter

    register_writer_type 'file_upload_question'

    private

    def self.write_question_item_xml(node, question)
      super(node, question)
    end

    def self.write_responses(presentation_node, question)
    end

    def self.write_response_conditions(processing_node, question)
    end
  end
end

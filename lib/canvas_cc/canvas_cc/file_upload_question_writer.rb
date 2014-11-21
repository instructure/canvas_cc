module CanvasCc::CanvasCC
  class FileUploadQuestionWriter < QuestionWriter

    register_writer_type 'file_upload_question'

    private

    def self.write_question_item_xml(node, question)
      node.item(:title => question.title, :ident => question.identifier) do |item_node|
        write_qti_metadata(item_node, question)
        item_node.presentation do |presentation_node|
          presentation_node.material do |material_node|
            material_node.mattext(question.material, :texttype => 'text/html')
          end
        end
      end
    end
  end
end

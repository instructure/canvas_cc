module CanvasCc::CanvasCC
  class MatchingQuestionWriter < QuestionWriter
    register_writer_type 'matching_question'

    private

    def self.write_responses(presentation_node, question)
      question.matches.each do |match|
        presentation_node.response_lid(:ident => "response_#{match[:id]}") do |response_node|
          next unless match[:question_text].length > 0
          response_node.material do |material_node|
            material_node.mattext(match[:question_text], :texttype => 'text/plain')
          end
          response_node.render_choice do |choice_node|
            question.matches.each do |possible_match|
              choice_node.response_label(:ident => possible_match[:id]) do |label_node|
                label_node.material do |material_node|
                  material_node.mattext(possible_match[:answer_text], :texttype => 'text/plain')
                end
              end
            end

            next unless question.distractors
            question.distractors.each do |distractor|
              choice_node.response_label(:ident => Digest::MD5.hexdigest(distractor)) do |label_node|
                label_node.material do |material_node|
                  material_node.mattext(distractor, :texttype => 'text/plain')
                end
              end
            end
          end
        end
      end
    end

    def self.write_response_conditions(processing_node, question)
      real_matches = question.matches.select{|m| m[:question_text].length > 0}
      score = 100.0 / real_matches.length.to_i
      real_matches.each do |match|
        processing_node.respcondition do |condition_node|
          condition_node.conditionvar do |var_node|
            var_node.varequal match[:id], :respident => "response_#{match[:id]}"
          end
          condition_node.setvar "%.2f" % score, :varname => 'SCORE', :action => 'Add'
        end

        next unless match.has_key?(:answer_feedback) && match[:answer_feedback].length > 0
        processing_node.respcondition do |condition_node|
          condition_node.conditionvar do |var_node|
            var_node.not do |not_node|
              not_node.varequal match[:id], :respident => "response_#{match[:id]}"
            end
          end
          condition_node.displayfeedback :linkrefid => "#{match[:id]}_fb", :feedbacktype => 'Response'
        end
      end
    end

    def self.write_additional_nodes(item_node, question)
      question.matches.each do |match|
        next unless match.has_key?(:answer_feedback) && match[:answer_feedback].length > 0
        item_node.itemfeedback(:ident => "#{match[:id]}_fb") do |feedback_node|
          feedback_node.flow_mat do |flow_node|
            flow_node.material do |material_node|
              material_node.mattext match[:answer_feedback], :texttype => 'text/plain'
            end
          end
        end
      end
    end
  end
end

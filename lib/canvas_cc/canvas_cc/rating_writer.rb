module CanvasCc::CanvasCC
  class RatingWriter

    def initialize(*ratings)
      @ratings = ratings
    end

    # It is assumed that ratings will be written only within the context of another object,
    # such as learning outcomes or rubrics
    def write
      Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.ratings do |xml|
          @ratings.each do |rating|
            xml.rating do
              xml.id rating.id
              xml.description rating.description
              xml.points rating.points
              xml.criterion_id rating.criterion_id
              xml.long_description rating.long_description
            end
          end
        end
      end.to_xml
    end
  end

end

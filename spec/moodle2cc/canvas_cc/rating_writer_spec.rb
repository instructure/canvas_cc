require 'spec_helper'

describe CanvasCc::CanvasCC::RatingWriter do
  let(:rating) do
    tmp_rating = CanvasCc::CanvasCC::Models::Rating.new
    tmp_rating.id = '123'
    tmp_rating.description = 'a rating'
    tmp_rating.points = 5
    tmp_rating.criterion_id = '123'
    tmp_rating.long_description = 'a longer description'
    tmp_rating
  end

  it 'writes ratings' do
    xml = write_xml rating
    node = xml.at_xpath('//ratings/rating')
    expect(node.at_xpath('id').text).to eql rating.id
    expect(node.at_xpath('description').text).to eql rating.description
    expect(node.at_xpath('points').text).to eql rating.points.to_s
    expect(node.at_xpath('criterion_id').text).to eql rating.criterion_id
    expect(node.at_xpath('long_description').text).to eql rating.long_description
  end

  it 'does not include xml header' do
    writer = CanvasCc::CanvasCC::RatingWriter.new rating
    xml = writer.write
    expect(xml.match(/<\?xml/)).to eq nil
  end

  private
  def write_xml(rating)
    writer = CanvasCc::CanvasCC::RatingWriter.new rating
    Nokogiri::XML(writer.write)
  end
end

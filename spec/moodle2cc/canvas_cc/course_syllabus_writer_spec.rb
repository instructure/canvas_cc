require 'spec_helper'

describe CanvasCc::CanvasCC::CourseSyllabusWriter do
  subject(:writer) { CanvasCc::CanvasCC::CourseSyllabusWriter.new(work_dir, syllabus) }
  let(:work_dir) { Dir.mktmpdir }
  let(:syllabus) { CanvasCc::CanvasCC::Models::Syllabus.new }

  after(:each) do
    FileUtils.rm_r work_dir
  end

  it 'it writes the syllabus html file' do
    syllabus.html = '<h2>This is the body</h2>'
    writer.write
    html = Nokogiri::HTML(File.read(File.join(work_dir,
                                              CanvasCc::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR,
                                              CanvasCc::CanvasCC::CourseSyllabusWriter::COURSE_SYLLABUS_FILE)))
    expect(html.at_css('meta[http-equiv]')[:'http-equiv']).to eq 'Content-Type'
    expect(html.at_css('meta[http-equiv]')[:content]).to eq 'text/html; charset=utf-8'
    expect(html.at_css('title').text).to eq 'Syllabus'
    expect(html.at_css('body').inner_html.to_s).to eq '<h2>This is the body</h2>'
  end
end

require 'spec_helper'

describe CanvasCc::CanvasCC::DiscussionWriter do
  subject(:writer) { CanvasCc::CanvasCC::DiscussionWriter.new(work_dir, discussion) }
  let(:work_dir) { Dir.mktmpdir }
  let(:discussion) {CanvasCc::CanvasCC::Models::Discussion.new}
  let(:assignment) {CanvasCc::CanvasCC::Models::Assignment.new}

  after(:each) do
    FileUtils.rm_r work_dir
  end

  it 'creates the discussion xml' do
    discussion.identifier = 'discussion_id'
    discussion.title = 'Discussion Title'
    discussion.text = '<p>discussion_text</p>'
    writer.write
    xml = Nokogiri::XML(File.read(File.join(work_dir, discussion.discussion_resource.files.first)))
    expect(xml.%('topic/title').text).to eq 'Discussion Title'
    expect(xml.%('topic/text').text).to eq '<p>discussion_text</p>'
    expect(xml.at_xpath('xmlns:topic/xmlns:text/@texttype').value).to eq('text/html')
  end

  it 'creates the meta xml' do
    time = Time.now
    discussion.identifier = 'discussion_id'
    discussion.title = 'Discussion Title'
    discussion.text = '<p>discussion_text</p>'
    discussion.discussion_type = 'threaded'
    discussion.position = '1'
    discussion.pinned = true
    discussion.delayed_post_at = time
    discussion.lock_at = time
    writer.write
    xml = Nokogiri::XML(File.read(File.join(work_dir, discussion.meta_resource.href)))
    expect(xml.at_xpath('xmlns:topicMeta/@identifier').value).to eq('discussion_id_meta')
    expect(xml.%('topicMeta/topic_id').text).to eq 'discussion_id'
    expect(xml.%('topicMeta/title').text).to eq 'Discussion Title'
    expect(xml.%('topicMeta/type').text).to eq 'topic'
    expect(xml.%('topicMeta/position').text).to eq '1'
    expect(xml.%('topicMeta/discussion_type').text).to eq 'threaded'
    expect(xml.%('topicMeta/pinned').text).to eq 'true'
    expect(xml.%('topicMeta/delayed_post_at').text).to eq time.to_s
    expect(xml.%('topicMeta/lock_at').text).to eq time.to_s

  end

  it 'creates assignment meta' do
    discussion.identifier = 'discussion_id'
    discussion.title = 'Discussion Title'
    discussion.text = '<p>discussion_text</p>'
    discussion.discussion_type = 'threaded'
    discussion.assignment = assignment
    assignment.identifier = discussion.identifier
    assignment.title = discussion.title
    writer.write
    xml = Nokogiri::XML(File.read(File.join(work_dir, discussion.meta_resource.href)))
    expect(xml.at_xpath('xmlns:topicMeta/xmlns:assignment/@identifier').value).to eq('discussion_id')
    expect(xml.%('topicMeta/assignment/title').text).to eq 'Discussion Title'
  end

end

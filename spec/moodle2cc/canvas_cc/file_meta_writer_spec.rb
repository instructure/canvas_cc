require 'spec_helper'

module CanvasCc::CanvasCC
  describe FileMetaWriter do

    let(:file) { Models::CanvasFile.new }
    let(:folder) { Models::CanvasFolder.new }
    let(:tmpdir) { Dir.mktmpdir }

    before :each do
      Dir.mkdir(File.join(tmpdir, CartridgeCreator::COURSE_SETTINGS_DIR))
    end

    after :each do
      FileUtils.rm_r tmpdir
    end

    it 'xml contains the correct schema' do
      meta_writer = writer(file, nil)
      allow(meta_writer).to receive(:copy_files) { nil }
      xml = write_xml(meta_writer)
      assert_xml_schema(xml)
    end

    it '#write' do
      create_file('sample.txt') do |source_file|
        file.file_location = source_file
        file.file_path = 'sample.txt'
        write_xml(writer(file, nil))
        path = File.join(tmpdir, Models::CanvasFile::WEB_RESOURCES, 'sample.txt')
        expect(File.exist?(path)).to be_truthy
      end
    end

    it 'writes files' do
      file.hidden = true
      file.locked = true
      file.identifier = 'abc123'
      time_now = DateTime.now.iso8601
      file.unlock_at = time_now
      file.lock_at = time_now
      create_file('sample.txt') do |source_file|
        file.file_location = source_file
        file.file_path = 'sample.txt'
        xml = write_xml(writer(file, nil))
        expect(xml.at_xpath('xmlns:fileMeta/xmlns:files/xmlns:file/@identifier').text).to eq 'abc123'
        expect(xml.at_xpath('xmlns:fileMeta/xmlns:files/xmlns:file/xmlns:locked').text).to eq 'true'
        expect(xml.at_xpath('xmlns:fileMeta/xmlns:files/xmlns:file/xmlns:hidden').text).to eq 'true'
        expect(xml.at_xpath('xmlns:fileMeta/xmlns:files/xmlns:file/xmlns:unlock_at').text).to eq time_now
        expect(xml.at_xpath('xmlns:fileMeta/xmlns:files/xmlns:file/xmlns:lock_at').text).to eq time_now
      end
    end

    it 'writes copyright information' do
      file.identifier = 'abc123'
      file.usage_rights = 'public_domain'
      create_file('sample.txt') do |source_file|
        file.file_location = source_file
        file.file_path = 'sample.txt'
        xml = write_xml(writer(file, nil))
        expect(xml.at_xpath('xmlns:fileMeta/xmlns:files/xmlns:file/xmlns:usage_rights/@use_justification').text).to eql 'public_domain'
        expect(xml.at_xpath('xmlns:fileMeta/xmlns:files/xmlns:file/xmlns:usage_rights/xmlns:license').text).to eql 'public_domain'
      end
    end

    it 'writes folders' do
      folder.hidden = true
      folder.locked = true
      folder.folder_location = '/folder1'
      xml = write_xml(writer(nil, folder))
      expect(xml.at_xpath('xmlns:fileMeta/xmlns:folders/xmlns:folder/@path').text).to eq '/folder1'
      expect(xml.at_xpath('xmlns:fileMeta/xmlns:folders/xmlns:folder/xmlns:locked').text).to eq 'true'
      expect(xml.at_xpath('xmlns:fileMeta/xmlns:folders/xmlns:folder/xmlns:hidden').text).to eq 'true'

    end

    private

    def create_file(name)
      Dir.mktmpdir do |dir|
        source_file = File.join(dir, name)
        FileUtils.touch(source_file)
        yield source_file
      end
    end

    def writer(file, folder)
      FileMetaWriter.new(tmpdir, file, folder)
    end

    def write_xml(writer)
      writer.write
      path = File.join(tmpdir,
                       CartridgeCreator::COURSE_SETTINGS_DIR,
                       FileMetaWriter::FILE_META_FILE)
      Nokogiri::XML(File.read(path))
    end

    def assert_xml_schema(xml)
      valid_schema = File.read(fixture_path(File.join('common_cartridge', 'schema', 'cccv1p0.xsd')))
      xsd = Nokogiri::XML::Schema(valid_schema)
      expect(xsd.validate(xml)).to be_empty
    end

  end
end

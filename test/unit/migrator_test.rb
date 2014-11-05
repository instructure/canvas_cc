require 'minitest/autorun'
require 'test_helper'
require 'moodle2cc'

class TestUnitMigrator < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @valid_source = create_moodle_backup_zip
    @valid_destination = File.expand_path("../../tmp", __FILE__)
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_accepts_a_source_and_destination
    migrator = CanvasCc::Migrator.new @valid_source, @valid_destination
    assert migrator
  end

  def test_source_must_exist
    assert_raises CanvasCc::Error, "'does_not_exist' does not exist" do
      CanvasCc::Migrator.new 'does_not_exist', 'there'
    end
  end

  def test_destination_must_be_a_directory
    assert_raises CanvasCc::Error, "'is_not_a_directory' is not a directory" do
      CanvasCc::Migrator.new @valid_source, 'is_not_a_directory'
    end
  end

  def test_it_allows_cc_format
    migrator = CanvasCc::Migrator.new @valid_source, @valid_destination, 'format' => 'cc'
    assert_equal CanvasCc::CC::Converter, migrator.instance_variable_get(:@converter_class)
  end

  def test_it_allows_canvas_format
    migrator = CanvasCc::Migrator.new @valid_source, @valid_destination, 'format' => 'canvas'
    assert_equal CanvasCc::Canvas::Converter, migrator.instance_variable_get(:@converter_class)
  end

  def test_it_does_not_allow_any_other_format
    assert_raises CanvasCc::Error, "'angel' is not a valid format. Please use 'cc' or 'canvas'." do
      CanvasCc::Migrator.new @valid_source, @valid_destination, 'format' => 'angel'
    end
  end

  def test_it_converts_moodle_backup
    migrator = CanvasCc::Migrator.new @valid_source, @valid_destination
    migrator.migrate
    imscc_file = File.join(@valid_destination, "my-course.imscc")
    assert File.exists?(imscc_file), "#{imscc_file} does not exist"
  end

  def test_it_detects_moodle2_package
    migrator = CanvasCc::Migrator.new(fixture_path(File.join('moodle2', 'moodle2_shell.mbz')), @valid_destination)
    expect(migrator, :migrate_moodle_2) { migrator.migrate }
  end

  def test_it_detects_moodle_1_9_package
    migrator = CanvasCc::Migrator.new(@valid_source, @valid_destination)
    expect(migrator, :migrate_moodle_1_9) { migrator.migrate }
  end

end

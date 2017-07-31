require 'spec_helper'

module CanvasCc::CanvasCC
  describe CartridgeCreator do
    subject { CartridgeCreator.new(course) }

    let(:tmpdir) { Dir.mktmpdir }
    let(:course) { Models::Course.new }

    before :each do
      course.identifier = 'setting'
      course.title = 'My Course'
      course.canvas_modules << Models::CanvasModule.new

      CanvasExportWriter.any_instance.stub(:write)
      CourseSyllabusWriter.any_instance.stub(:write)
      GradingStandardWriter.any_instance.stub(:write)
      CourseSettingWriter.any_instance.stub(:write)
      ModuleMetaWriter.any_instance.stub(:write)
      ImsManifestGenerator.any_instance.stub(:write)
      FileMetaWriter.any_instance.stub(:write)
      PageWriter.any_instance.stub(:write)
      DiscussionWriter.any_instance.stub(:write)
      AssignmentWriter.any_instance.stub(:write)
      QuestionBankWriter.any_instance.stub(:write)
      OutcomeWriter.any_instance.stub(:write)
      RubricWriter.any_instance.stub(:write)
    end

    after :each do
      FileUtils.rm_r tmpdir
    end

    [CanvasExportWriter, CourseSyllabusWriter, GradingStandardWriter, CourseSettingWriter, ModuleMetaWriter, ImsManifestGenerator,
     FileMetaWriter, PageWriter, DiscussionWriter, AssignmentWriter, QuestionBankWriter, OutcomeWriter, RubricWriter].each do |klass|
      it "writes #{klass}" do
        writer_double = double(write: nil)
        klass.stub(:new).and_return(writer_double)
        subject.create(tmpdir)
        expect(writer_double).to have_received(:write)
      end
    end

    describe 'filename' do
      ['My Stuff', 'my/stuff', 'my.stuff', 'my-stuff', 'my--stuff', 'my---stuff', 'my-./stuff'].each do |title|
        it "with course title: #{title}" do
          course.title = title
          expect(subject.filename).to eq('my_stuff.imscc')
        end
      end
    end

  end
end

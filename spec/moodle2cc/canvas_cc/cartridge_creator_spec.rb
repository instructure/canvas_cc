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

      allow_any_instance_of(CanvasExportWriter).to receive(:write)
      allow_any_instance_of(CourseSyllabusWriter).to receive(:write)
      allow_any_instance_of(GradingStandardWriter).to receive(:write)
      allow_any_instance_of(CourseSettingWriter).to receive(:write)
      allow_any_instance_of(ModuleMetaWriter).to receive(:write)
      allow_any_instance_of(ImsManifestGenerator).to receive(:write)
      allow_any_instance_of(FileMetaWriter).to receive(:write)
      allow_any_instance_of(PageWriter).to receive(:write)
      allow_any_instance_of(DiscussionWriter).to receive(:write)
      allow_any_instance_of(AssignmentWriter).to receive(:write)
      allow_any_instance_of(QuestionBankWriter).to receive(:write)
      allow_any_instance_of(OutcomeWriter).to receive(:write)
      allow_any_instance_of(RubricWriter).to receive(:write)
    end

    after :each do
      FileUtils.rm_r tmpdir
    end

    [CanvasExportWriter, CourseSyllabusWriter, GradingStandardWriter, CourseSettingWriter, ModuleMetaWriter, ImsManifestGenerator,
     FileMetaWriter, PageWriter, DiscussionWriter, AssignmentWriter, QuestionBankWriter, OutcomeWriter, RubricWriter].each do |klass|
      it "writes #{klass}" do
        writer_double = double(write: nil)
        allow(klass).to receive(:new).and_return(writer_double)
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

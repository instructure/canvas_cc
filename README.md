# CanvasCc

This Gem allows for converting content to Canvas Common Cartridge format.  The Gem allows building up Canvas objects(Courses, Assignments, Quizzes, Terms, etc.), without having to think about the xml format, and then will correctly build the .imscc file.  The xsd for the CanvasCC format can be found [here](https://github.com/instructure/canvas-lms/blob/stable/lib/cc/xsd/cccv1p0.xsd).  **NOTE: not all settings are currently supported by the gem, supported settings are documented**


## Installation

Add this line to your application's Gemfile:

    gem 'canvas_cc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install canvas_cc

## Usage
The Gem will convert content to a Canvas course, so a Course should be the first object created.

###Course

     course = CanvasCc::CanvasCC::Models::Course.new

Once a course is created it can be converted to an .imscc file as follows:

    dir = Dir.mktmpdir
    output_dir = CanvasCc::CanvasCC::CartridgeCreator.new(course).create(dir)

The output_dir will contain the .imscc file.  This file can then be uploaded to Canvas.

The following are attributes available on the Course object.
* **identifier** - unique identifier for the course
* **title** - the title of the course
* **course_code** - the course_code for the course
* **start_at** - the start at date for the course
* **conclude_at** - the conclude at date for the course
* **is_public** - whether the course is public or no
* **allow_student_wiki_edits** - Allow students to edit wiki pages
* **allow_student_forum_attachments** -Allow the student to attach files to discussion topics
* **default_wiki_editing_roles** - default value for who can edit wiki pages one of the following('teachers', 'teachers,students', 'anyone')
* **allow_student_organized_groups** - Allow students to create their own groups
* **show_all_discussion_entries** -
* **open_enrollment** - allow open enrollment in this course
* **allow_wiki_comments** - allow comments on wiki posts
* **self_enrollment** - Allow self enrollments in the course
* **turnitin_comments** - Allow turnitin comments
* **locale** - the locale of the course
* **hide_final_grade** - hide final grade from students
* **storage_quota** - the storage quota of the course in MB, for example 5000 is 5GB

###Assignments
    assignment = CanvasCc::CanvasCC::Models::Assignment.new
    #set attributes
    course.assignments << assignment

The following are attributes available on the Assignment object.
* **identifier** - unique identifier for the Assignment
* **title** - title of assignment
* **body** - details of assignment
* **due_at** - due_date of assignment
* **lock_at** - lock at date of assignment
* **unlock_at** - unlock date of assignment
* **workflow_state** - initial workflow state of assignment('active', 'unpublished')
* **points_possible** - points possible for assignment
* **assignment_group_identifier_ref** - identifier from AssignmentGroup, that this assignment should be grouped in.
* **muted** - whether or not the assignment is muted
* **turnitin_enabled** - whether or not turn it in is enabled for this assignment
* **submission_types** - valid submissions types for this assignment, this is an array of the following values('online_text_entry', 'online_upload', 'on_paper', 'discussion_topic', 'online_quiz')

        assignment.submission_types << 'online_quiz'
* **grading_type** - the grading type for the assignment, one of the following: ('letter_grade', 'points', 'percentage', 'pass_fail')

###Assessments
     assessment = CanvasCc::CanvasCC::Models::Assessment.new
     #set assessment attributes
     course.assessments << assessment
The following are attributes associated with the Assessment object.
* **identifier** - unique identifier for the Assessment
* **title** - the title of the quiz
* **description** - the description of the quiz
* **workflow_state** -  initial workflow state of the quiz ('active', 'unpublished')
* **assignment** - the assignment this quiz is associated with
* **lock_at** - lock at date of quiz
* **unlock_at** - unlock at date of quiz
* **due_at** - due at date for quiz
* **allowed_attempts** - allowed attempts on the quiz
* **access_code** - access code to unlock quiz
* **ip_filter** - ip filter to restrict quiz access
* **quiz_type** - the type of the quiz, one of the following('practice_quiz', 'assignment', 'survey', 'graded_survey')
* **shuffle_answers** - true to shuffle quiz answers
* **items** - items associated with the quiz such as questions or question banks.  See Questions below
* **time_limit** - The time limit for the quiz in minutes
* **anonymous_submissions** - allow anonymous submissions for the quiz
* **one_question_at_a_time** - show one question at a time for the quiz
* **cant_go_back** - allow the user to go back to previous questions on the quiz
* **hide_results** - hide quiz results
* **show_correct_answers** - show correct answers to quiz
* **show_correct_answers_at** - show correct answers on the following date
* **points_possible** - points possible on the quiz

###Questions
    question = CanvasCc::CanvasCC::Models::Question.create('<QUESTION_TYPE>')
    assessment.items << question

The following are attributes associated with the Question object.
* **question_type** - the type of question, passed into constructor when creating question.  One of the following('text_only_question', 'true_false_question', 'numerical_question', 'multiple_choice_question', 'multiple_answers_question', 'matching_question', 'fill_in_multiple_blanks_question, 'file_upload_question', 'essay_question')
* **identifier** - unique identifier for question
* **original_identifier** - foreign id for question
* **points_possible** - points possible for question
* **title** - the title of the question
* **material** - the question material
* **general_feedback** - the general feedback to be shown on the question
* **general_correct_feedback** - the feedback to show when answer is correct
* **general_incorrect_feedback** - the feedback to show when the answer is incorrect
* **answers** - array of answers for question.  See Answers section below

Some question types have additional attributes as noted below
* **matching_question**
  * **matches** - the matches for the question, this is a hash as follows:

        question.matches << {
          :id => unique_id,
          :question_text => the text for the question,
          :question_text_format => '1',
          :answer_text => the text for the answer,
          :answer_feedback => feedback for the question
        }
  * **distractors** - the distractors for the question, this is an array of answers to use as distractors
* **numerical_question**
  * **ranges** - the range of acceptable answers for this question.  Ranges are set as follows:
        range = CanvasCc::CanvasCC::Models::Range.new
        range.low_range = 5
        range.high_range = 10
        question.ranges[answer.id] = range

###Answers
    answer = CanvasCc::CanvasCC::Models::Answer.new(<ANSWER>)
    question.answers << answer

The following are attributes associated with Answer object.
* **id** - unique id for answer
* **answer_text** - the text for the answer
* **resp_ident** - used as a response identifier on some question types.
* **fraction** - the fraction this answer contributes to question points(0.0 - 1.0)
* **feedback** - feedback or answer

Depending on the type of question the answer_text will be formatted as follows:
* **true_false_question** - 'True' or 'False'
* **fill_in_multiple_blanks_question**
  * **answer_text** - the answer text for this blank
  * **resp_ident** - this attribute should be set to a unique_id for this answer.  In addition the material or the question should have blanks setup with the value of resp_ident in brackets.  For example 'the dog was [answer_1]', and the value of the answer resp_ident would be 'answer_1' and the answer text could be 'brown'.
* **multiple_choice_question**
  * **fraction** - this is set to 1.0 if it is the correct answer, 0.0 if incorrect answer.

###Question Banks
Question bank allow for creating a pool of questions that can be pulled from for a quiz.  They can be created as follows.

    question_bank = CanvasCc::CanvasCC::Models::QuestionBank.new
    question_bank.identifier = identifier # unique identifier for the bank
    question_bank.title = title # title of the question bank
    question_bank.questions = questions # array of questions in the question bank
    course.question_banks << question_bank

Once a question bank is setup a quiz can be set to pull questions from the bank by using QuestionGroups.  Question groups have the following attributes and can be created as follows
* **selection_number** - the number fo questions to select from the pool.
* **points_per_item** - the number of points to give each question selected.
* **identifier** - unique identifier for the Question Group
* **sourcebank_ref** - the identifier for the QuestionBank to associate with this group


    question_group = CanvasCc::CanvasCC::Models::QuestionGroup.new
    question_bank.question_groups << question_group # associate this group with the bank
    assessment.items << question_group # add gropu to assesment items

###Canvas Modules
A Canvas Module can be created as follows
    module = CanvasCc::CanvasCC::Models::CanvasModule.new
    course.canvas_modules << module

The following attributes are associated with the Module object.
* **identifier** - the unique identifier for the module object
* **title** - the title for the module
* **unlock_at** - the unlock at date for the module
* **workflow_state** - the initial workflow state for the module, either 'active' or 'unpublished'
* **module_items** - array of ModuleItems for the module.

###Module Item
A Module Item represents an item within a module, this can be one of serveral types as described below.  A ModuleItem can be crated as follows

    module_item = CanvasCc::CanvasCC::Models::ModuleItem.new
    module.items << module_item

The following attributes are associated with a ModuleItem
* **title** - the title of the ModuleItem
* **identifier** - unique identifier for the ModuleItem
* **workflow_state** - the initial workflow state for the module, either 'active' or 'unpublished'
* **content_type** - one of the following based on the content this ModuleItem contains
  * **WikiPage** - when using a page
  * **Attachment** - when referencing a file
  * **ContextModuleSubHeader** - when referencing a submodule
  * **DiscussionTopic** - when referencing a Discussion
  * **Assignment** - when referencing an Assignment
  * **Quizzes::Quiz** - when referencing an Assessment
  * **ExternalUrl** - when referencing an external url

###Module Completion Requirements
In Canvas modules can have completion req. associated with them, these can be setup in the content package as follows

    completion_requirement = CanvasCc::CanvasCC::Models::ModuleCompletionRequirement.new
    module.completion_requirements << completion_requirment

The following attributes are associated with the ModuleCompletionRequirement object.
* **identifierref** - the identifier for the module item that this completion req. is associated with
* **type** - the type of completion requirement, can be one of the following
  * **must_view** - user must view the content
  * **must_submit** - user must submit the content
  * **min_score** - user must achieve a minimum score on the content **note the following attribute must also be set when using min_score 'min_score', with a value of the minimum score**
  * **must_contribute** - user must contribute to the content

###Module Prerequisites
In Canvas modules can have prerequisites as requirements, these can be setup in the content package as follows

    module_pre_requisite = CanvasCc::CanvasCC::Models::ModulePrerequisite.new
    module.prerequisites << module_pre_requisite

The following attributes are associated with the ModulePrerequisite object
* **identifierref** - the identifier of the prerequisite object(currently should be set to another module)
* **title** - the title of the prerequisite
* **type** - should be set to 'context_module'

###Folders
A folders used to group files under the files section in Canvas, a folder can be created as follows

    folder = CanvasCc::CanvasCC::Models::CanvasFolder.new
    course.folders << folder

A Folder can have the following attributes
* **folder_location** - The location of the folder, this is a path to the folder such as '/assignments/files'
* **hidden** - whether or not the folder should be hidden.  true or false
* **locked** - whether or not the folder should be locked.  true or false

###Files
A file is a resource that is placed in the Canvas files section.  A File can be created as follows

    file = CanvasCc::CanvasCC::Models::CanvasFile.new
    course.files << file

A File can have the following attributes
* **identifier** - a unique identifier for this file
* **file_path** - the path of the file including the file name, for example '/assignments/files/test.png'
* **file_location** - the location on the filesystem for the file, for example '/tmp/files/assignments/files/test.png'
* **hidden** - whether or not this file is hidden.  true or false

To reference a file inside of html content within pages, quizzes, assignments, discussions or other html content, the link can be written in the following format.  When imported the references will be correctly updated to the file path of the content within Canvas.

    <a href="$IMS_CC_FILEBASE$/files/test.png">Cool Image</a>

**NOTE: to place a file in a folder, make sure the file_path is the same as the folder_location**

###Pages
A Page can be created in Canvas as follows
    page = CanvasCc::CanvasCC::Models::Page.new
    course.pages << page

A Page can have the following attributes
* **identifier** - a unique identifier for the page
* **workflow_state** - the initial workflow state for the page, either 'active' or 'unpublished'
* **page_name** - the name of the page
* **body** - the content of the page



###Discussions
A Discussion can be created in Canvas as follows

    discussion = CanvasCc::CanvasCC::Models::Discussion.new
    course.discussions << discussion

A Discussion can have the following attributes
* **identifier** - a unique identifier for the discussion
* **title** - the title of the discussion
* **text** - the text of the discussion
* **require_initial_post** - whether an initial post is required on this discussion
* **discussion_type** - the type of discussion 'threaded' or 'side_comment'
* **position** - used to control the ordering of discussions

###Assignment_groups
An AssignmentGroup can be created in Canvas as follows

    assignment_group = CanvasCc::CanvasCC::Models::AssignmentGroup.new
    course.assignment_groups << assignment_group

An AssignmentGroup can have the following attributes
* **identifier** - unique identifier for the AssignmentGroup
* **title** - the title of the AssignmentGroup
* **position** - the position of the AssignmentGroup in relation to other AssignmentGroups, used for ordering
* **group_weight** - the weight of this AssignmentGroup if weighting is desired
* **rules** - This is a hash of rules that can be applied to the AssignmentGroup.  The following rules are available
  * **drop_type** - this can be 'drop_highest', or 'drop_lowest'
  * **drop_count** - the number to drop.

        assignment_group.rules << {drop_type: 'drop_lowest', drop_count: 2}


## Contributing

1. Fork it ( http://github.com/<my-github-username>/canvas_cc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

module CanvasCc::CanvasCC::Models
  class Page < CanvasCc::CanvasCC::Models::Resource

    PAGE_ID_POSTFIX = '_PAGE'
    WIKI_CONTENT = 'wiki_content'
    BOOK_PATH = WIKI_CONTENT + '/books'

    EDITING_ROLE_TEACHER = 'teachers'

    MAX_URL_LENGTH = 80

    attr_accessor :workflow_state, :editing_roles, :body, :title, :front_page

    def initialize
      super
      @type = WEB_CONTENT_TYPE
      @front_page = false
    end

    def identifier=(identifier)
      @identifier = identifier
    end

    def identifier
      @identifier
    end

    def page_name= name
      @title = name
      @href = "#{WIKI_CONTENT}/#{self.class.convert_name_to_url(name)}.html"
    end

    def self.convert_name_to_url(name)
      url = CGI::escape(name.downcase.gsub(/\s/, '-').gsub('.', 'dot'))
      if url.length > MAX_URL_LENGTH
        url = url[0,MAX_URL_LENGTH][/.{0,#{MAX_URL_LENGTH}}/mu]
      end
      url
    end

  end
end
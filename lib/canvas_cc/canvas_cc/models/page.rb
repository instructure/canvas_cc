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
      url = urlify(name)
      if url.length > MAX_URL_LENGTH
        url = url[0,MAX_URL_LENGTH][/.{0,#{MAX_URL_LENGTH}}/mu]
      end
      url
    end

    def self.urlify(name)
      name = name.downcase.gsub(/\s/, '-').gsub('.', '-dot-')
      name.gsub!('(', '-')
      name.gsub!(')', '-')
      name.gsub!('_', '-')
      name.gsub!('--', '-')
      name.gsub!('"', '')
      name.gsub!('$', ' dollars ')
      name.gsub!(/[äöüß]/) do |match|
        case match
        when "ä" then 'a'
        when "ö" then 'o'
        when "ü" then 'u'
        when "ß" then 'ss'
        end
      end
      name = to_url(name)
      CGI::escape(name)
    end

    def self.to_url(title)
      title = remove_formatting(title).downcase
      title = replace_whitespace(title, "-")
      title = collapse(title, "-")
    end

    def self.remove_formatting(title)
      title = strip_html_tags(title)
      title = convert_accented_entities(title)
      title = convert_misc_entities(title)
      title = convert_misc_characters(title)
      collapse(title)
    end

    def self.strip_html_tags(title, leave_whitespace = false)
      name = /[\w:_-]+/
      value = /([A-Za-z0-9]+|('[^']*?'|"[^"]*?"))/
      attr = /(#{name}(\s*=\s*#{value})?)/
      rx = /<[!\/?\[]?(#{name}|--)(\s+(#{attr}(\s+#{attr})*))?\s*([!\/?\]]+|--)?>/
      (leave_whitespace) ?  title.gsub(rx, "").strip : title.gsub(rx, "").gsub(/\s+/, " ").strip
    end

    def self.convert_accented_entities(title)
      title.gsub(/&([A-Za-z])(grave|acute|circ|tilde|uml|ring|cedil|slash);/, '\1')
    end

    def self.convert_misc_entities(title)
      {
        "#822[01]" => "\"",
        "#821[67]" => "'",
        "#8230" => "...",
        "#8211" => "-",
        "#8212" => "--",
        "#215" => "x",
        "gt" => ">",
        "lt" => "<",
        "(#8482|trade)" => "(tm)",
        "(#174|reg)" => "(r)",
        "(#169|copy)" => "(c)",
        "(#38|amp)" => "and",
        "nbsp" => " ",
        "(#162|cent)" => " cent",
        "(#163|pound)" => " pound",
        "(#188|frac14)" => "one fourth",
        "(#189|frac12)" => "half",
        "(#190|frac34)" => "three fourths",
        "(#176|deg)" => " degrees"
      }.each do |textiled, normal|
        title.gsub!(/&#{textiled};/, normal)
      end
      title.gsub(/&[^;]+;/, "")
    end

    def self.convert_misc_characters(title)
      title = title.gsub(/\.{3,}/, " dot dot dot ")
      # Special rules for money
      {
        /(\s|^)\$(\d+)\.(\d+)(\s|$)/ => '\2 dollars \3 cents',
        /(\s|^)£(\d+)\.(\d+)(\s|$)/u => '\2 pounds \3 pence',
      }.each do |found, replaced|
        replaced = " #{replaced} " unless replaced =~ /\\1/
        title.gsub!(found, replaced)
      end
      # Back to normal rules
      {
        /\s*&\s*/ => "and",
        /\s*#/ => "number",
        /\s*@\s*/ => "at",
        /(\S|^)\.(\S)/ => '\1 dot \2',
        /(\s|^)\$(\d*)(\s|$)/ => '\2 dollars',
        /(\s|^)£(\d*)(\s|$)/u => '\2 pounds',
        /(\s|^)¥(\d*)(\s|$)/u => '\2 yen',
        /\s*\*\s*/ => "star",
        /\s*%\s*/ => "percent",
        /\s*(\\|\/)\s*/ => "slash",
      }.each do |found, replaced|
        replaced = " #{replaced} " unless replaced =~ /\\1/
        title.gsub!(found, replaced)
      end
      title.gsub(/(^|\w)'(\w|$)/, '\1\2').gsub(/[\.,:;()\[\]\/\?!\^'"_]/, " ")
    end

    def self.replace_whitespace(title, replace = " ")
      title.gsub(/\s+/, replace)
    end

    def self.collapse(title, character = " ")
      title.sub(/^#{character}*/, "").sub(/#{character}*$/, "").squeeze(character)
    end

    def self.path_safe
      gsub(/[^a-zA-Z0-9\-_]+/, '-')
    end

  end
end
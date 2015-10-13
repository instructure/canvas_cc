module CanvasCc::CanvasCC
  class PageWriter

    def initialize(work_dir, *pages)
      @work_dir = work_dir
      @pages = pages
    end

    def write
      Dir.mkdir(File.join(@work_dir, CanvasCc::CanvasCC::Models::Page::WIKI_CONTENT))
      @pages.each { |page| write_html(page) }
    end


    private

    def write_html(page)
      builder = Nokogiri::HTML::Builder.new(:encoding => 'UTF-8') do |doc|
        doc.html { |html|
          html.head { |head|
            head.meta('http-equiv' => 'Content-Type', content: 'text/html; charset=utf-8')
            head.meta(name: 'identifier', content: page.identifier)
            head.meta(name: 'editing_roles', content: page.editing_roles)
            head.meta(name: 'workflow_state', content: page.workflow_state)
            head.meta(name: 'front_page', content: page.front_page)
            head.title page.title
          }
          html.body { |body|
            body << Nokogiri::HTML::fragment(page.body)
          }
        }
      end
      file = File.join(@work_dir, page.href)
      FileUtils.mkdir_p(File.dirname(file))
      File.open(file, 'w') { |f| f.write(builder.to_html) }
    end

  end
end
require 'haml'

class Base
  def initialize(opts)
    @opts = opts
  end
  def html
    hash = {:lang=>'en'}
    if @opts[:amp]
      hash['⚡'] = ''
    end
    hash
  end
  def css(name)
    if @opts[:amp]
      '<style>' + File.read("target/css/#{name}") + '</style>'
    else
      "<link type='text/css' href='/css/#{name}?#{@opts[:revision]}' rel='stylesheet'/>"
    end
  end
  def input(path)
    Page.new(File.read(path), @opts).html
  end
end

class Page
  def initialize(haml, opts)
    @haml = haml
    @opts = opts
  end
  def html
    engine = Haml::Engine.new(
      @haml,
      :format => :xhtml,
      :style => :indented
    )
    if !@opts.key?(:day)
      @opts[:day] = Time.now.strftime('%d-%m-%Y')
    end
    engine.render(Base.new(@opts), @opts)
  end
end

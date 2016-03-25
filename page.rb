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
    engine.render(
      Base.new(@opts),
      :amp => @opts[:amp],
      :revision => @opts[:revision],
      :canonical => @opts[:canonical]
    )
  end
end

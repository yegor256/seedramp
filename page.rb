require 'haml'
require 'time'

class Base
  def initialize(opts)
    @opts = opts
    ['title', 'description'].each do |var|
      eval "def #{var}=(v)\n @opts[:#{var}]=v\nend"
      eval "def #{var}\n @opts[:#{var}]\nend"
    end
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
      '<style amp-custom="amp-custom">' + File.read("target/css/#{name}") + '</style>'
    else
      "<link type='text/css' href='/css/#{name}?#{@opts[:revision]}' rel='stylesheet'/>"
    end
  end
  def youtube(id)
    if @opts[:amp]
      "<amp-youtube data-videoid='#{id}' layout='responsive' width='480' height='270'></amp-youtube>"
    else
      "<iframe class='video' src='https://www.youtube.com/embed/#{id}?controls=2' allowfullscreen='yes'>&#8203;</iframe>"
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
    if !@opts.key?(:published)
      @opts[:published] = Time.now
    end
    engine.render(Base.new(@opts), @opts)
  end
end

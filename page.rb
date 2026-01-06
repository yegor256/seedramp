# SPDX-FileCopyrightText: Copyright (c) 2016-2026 SeedRamp
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require 'haml'
require 'time'

# base
class Base
  def initialize(opts)
    @opts = opts
  end

  def method_missing(method_name, *args, &_block)
    if method_name.to_s.end_with?('=')
      key = method_name.to_s.chomp('=').to_sym
      @opts[key] = args.first
    else
      @opts[method_name.to_sym]
    end
  end

  def respond_to_missing?(_method_name, _include_private = false)
    true
  end

  def html
    hash = { lang: 'en' }
    hash['⚡'] = '' if @opts[:amp]
    hash
  end

  def css(name)
    if @opts[:amp]
      "<style amp-custom='amp-custom'>#{File.read("target/css/#{name}")}</style>"
    else
      "<link type='text/css'
        href='/css/#{name}?#{@opts[:revision]}'
        rel='stylesheet'/>"
    end
  end

  def youtube(id)
    if @opts[:amp]
      "<amp-youtube data-videoid='#{id}'
        layout='responsive' width='480' height='270'></amp-youtube>"
    else
      "<iframe class='video'
        src='https://www.youtube.com/embed/#{id}?controls=2'
        frameborder='0' allowfullscreen='yes'>&#8203;</iframe>"
    end
  end

  def input(path)
    Page.new(File.read(path), @opts).html
  end
end

# Page to render
class Page
  def initialize(haml, opts)
    @haml = haml
    @opts = opts
  end

  def html
    @opts[:published] = Time.now unless @opts.key?(:published)
    Haml::Template.new { @haml }.render(Base.new(@opts))
  end
end

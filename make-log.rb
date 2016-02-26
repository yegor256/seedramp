#!/usr/bin/env ruby
STDOUT.sync = true

require 'yaml'
require 'haml'
require 'liquid'
require 'redcarpet'

md = File.read(ARGV[0])
head, body = md.split(/\n--\n/, 2)
yaml = YAML.load(head)

puts Haml::Engine.new(File.read('./pages/_log.haml')).render(
  Object.new,
  :content => Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(
    Liquid::Template.parse(body).render()
  ),
  :yaml => yaml,
)

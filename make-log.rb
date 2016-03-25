#!/usr/bin/env ruby
STDOUT.sync = true

require 'yaml'
require 'liquid'
require 'redcarpet'
require 'slop'
require './page.rb'

opts = Slop.parse do |o|
  o.string '--path', 'log path'
  o.string '--revision', 'Git revision'
  o.string '--canonical', 'canonical URL without a suffix'
  o.bool '--amp', 'enable AMP mode', default: false
end

md = STDIN.read
head, body = md.split(/\n--\n/, 2)
yaml = YAML.load(head)

puts Page.new(
  File.read('./pages/_log.haml'),
  opts.to_hash.merge(
    :content => Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(
      Liquid::Template.parse(body).render()
    ),
    :yaml => yaml,
    :day => File.dirname(opts[:path]).gsub(/^log\//, '').gsub(/\//, '-')
  )
).html

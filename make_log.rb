#!/usr/bin/env ruby
# SPDX-FileCopyrightText: Copyright (c) 2016-2026 SeedRamp
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

$stdout.sync = true

require 'yaml'
require 'liquid'
require 'redcarpet'
require 'slop'
require './page'

opts = Slop.parse do |o|
  o.string '--path', 'log path'
  o.string '--revision', 'Git revision'
  o.string '--canonical', 'canonical URL without a suffix'
  o.bool '--amp', 'enable AMP mode', default: false
end

md = $stdin.read
head, body = md.split("\n--\n", 2)
yaml = YAML.safe_load(head)

puts Page.new(
  File.read('./pages/_log.haml'),
  opts.to_hash.merge(
    content: Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(
      Liquid::Template.parse(body).render('amp' => opts.amp?)
    ),
    yaml: yaml,
    published: Time.parse(
      File.dirname(opts[:path]).gsub(%r{^log/}, '').tr('/', '-')
    )
  )
).html

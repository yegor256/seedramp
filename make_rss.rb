#!/usr/bin/env ruby
# SPDX-FileCopyrightText: Copyright (c) 2016-2025 SeedRamp
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

$stdout.sync = true

require 'rss'
require 'nokogiri'

rss = RSS::Maker.make('atom') do |atom|
  atom.channel.author = 'SeedRamp'
  atom.channel.title = 'SeedRamp'
  atom.channel.id = 'seedramp.com'
  atom.channel.updated = Time.now
  Dir['target/log/**/*.html']
    .reject { |f| f[/\.amp\.html$/] }
    .sort
    .reverse
    .each do |file|
      p file
      xml = Nokogiri::XML.parse(File.read(file))
      atom.items.new_item do |item|
        puts xml
        published_content = xml.xpath('//meta[@name="published"]/@content')[0]
        time = published_content ? Time.parse(published_content.to_s) : Time.now
        url = file.gsub(%r{^target/}, 'http://www.seedramp.com/')
        item.id = url
        item.link = url
        item.title = xml.xpath('//title/text()')
        item.published = time
        item.updated = time
        item.summary = xml.xpath('//div[@id="content"]')
        item.author = xml.xpath('//meta[@name="author"]/@content')
      end
    end
end

puts rss

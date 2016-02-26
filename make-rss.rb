#!/usr/bin/env ruby
STDOUT.sync = true

require 'rss'
require 'nokogiri'

rss = RSS::Maker.make('atom') do |atom|
  atom.channel.author = 'SeedRamp'
  atom.channel.title = 'Venture Fund'
  atom.channel.id = 'seedramp.com'
  atom.channel.updated = Time.now
  Dir['target/log/**/*.html'].sort.reverse.each do |file|
    xml = Nokogiri::XML.parse(File.read(file))
    atom.items.new_item do |item|
      time = Time.parse(xml.xpath('//meta[@name="published"]/@content')[0])
      url = file.gsub(/^target\//, 'http://www.seedramp.com/')
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

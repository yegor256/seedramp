#!/usr/bin/env ruby
STDOUT.sync = true

require 'nokogiri'
require 'date'

today = Date.today.strftime('%Y-%m-%dT00:00:00+00:00')
xml = Nokogiri::XML::Builder.new do |xml|
  xml.urlset do
    Dir['target/**/*.html'].each do |file|
      xml.url do |url|
        url.loc file.gsub(/^target\//, 'http://www.seedramp.com/')
        url.lastmod today
      end
    end
  end
end.to_xml


puts xml

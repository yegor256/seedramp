#!/usr/bin/env ruby
STDOUT.sync = true

require 'nokogiri'
require 'date'

today = Date.today.strftime('%Y-%m-%dT00:00:00+00:00')
xml = Nokogiri::XML::Builder.new do |x|
  attrs = {
    'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
    'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd',
    'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9'
  }
  x.urlset(attrs) do
    Dir['target/**/*.html'].each do |file|
      x.url do |url|
        url.loc file.gsub(/^target\//, 'http://www.seedramp.com/')
        url.lastmod today
      end
    end
  end
end.to_xml

puts xml

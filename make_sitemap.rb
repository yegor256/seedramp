#!/usr/bin/env ruby
# SPDX-FileCopyrightText: Copyright (c) 2016-2026 SeedRamp
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

$stdout.sync = true

require 'nokogiri'
require 'date'

today = Date.today.strftime('%Y-%m-%dT00:00:00+00:00')
xml = Nokogiri::XML::Builder.new do |x|
  attrs = {
    'xmlns:xsi' => 'https://www.w3.org/2001/XMLSchema-instance',
    'xsi:schemaLocation' => 'https://www.sitemaps.org/schemas/sitemap/0.9 https://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd',
    'xmlns' => 'https://www.sitemaps.org/schemas/sitemap/0.9'
  }
  x.urlset(attrs) do
    Dir['target/**/*.html'].each do |file|
      x.url do |url|
        url.loc file.gsub(%r{^target/}, 'https://www.seedramp.com/')
        url.lastmod today
      end
    end
  end
end.to_xml

puts xml

#!/usr/bin/env ruby
STDOUT.sync = true

require 'xembly'
require 'nokogiri'

xml = Nokogiri::XML(STDIN)

url = xml.xpath('//link[@rel="canonical"]/@href').first.text.gsub(/\.html$/, '.amp.html')

puts Xembly::Xembler.new(
  Xembly::Directives.new(
    %{
      XPATH "/html"; ATTR "amp", "amp"; ATTR "lang", "en";
      XPATH "head";

      ADD "link"; ATTR "rel", "canonical";
      ATTR "href", "#{url}";
      UP;

      ADD "style";
      ATTR "amp-boilerplate", "amp";
      SET "body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}";
      UP;

      ADD "noscript"; ADD "style";
      ATTR "amp-boilerplate", "amp";
      SET "body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}";
      UP; UP;

      ADD "script"; ATTR "async", "async";
      ATTR "src", "https://cdn.ampproject.org/v0.js";
      SET "// empty";
      UP;

      XPATH "//*[@class='video']"; REMOVE;
      XPATH "//script[not(@src)]"; REMOVE;
    }
  )
).apply(xml.to_xml).to_xml.gsub('<?xml version="1.0"?>', '<!DOCTYPE html>')


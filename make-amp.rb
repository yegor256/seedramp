#!/usr/bin/env ruby
STDOUT.sync = true

require 'xembly'
require 'nokogiri'
require 'date'

html = ARGV[0]
name = html.gsub(/^target\//, '/').gsub(/\.html$/, '')

origin = File.read(html)

File.write(
  html,
  Xembly::Xembler.new(
    Xembly::Directives.new(
      %{
      XPATH "/html/head";
      ADD "link";
      ATTR "rel", "amphtml";
      ATTR "href", "http://www.seedramp.com#{name}.amp.html";
      UP;
      ADD "link";
      ATTR "rel", "canonical";
      ATTR "href", "http://www.seedramp.com#{name}.html";
      }
    )
  ).apply(origin)
)

File.write(
  "target#{name}.amp.html",
  Xembly::Xembler.new(
    Xembly::Directives.new(
      %{
      XPATH "/html"; ATTR "amp", "amp"; ATTR "lang", "en";
      XPATH "head";

      ADD "link"; ATTR "rel", "canonical";
      ATTR "href", "http://www.seedramp.com#{name}.html";
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

      XPATH "body";
      XPATH "//iframe"; REMOVE;
      }
    )
  ).apply(origin)
)


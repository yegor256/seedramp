#!/usr/bin/env ruby
STDOUT.sync = true

require 'slop'
require './page.rb'

opts = Slop.parse do |o|
  o.string '--revision', 'Git revision'
  o.string '--canonical', 'canonical URL without a suffix'
  o.bool '--amp', 'enable AMP mode', default: false
end

puts Page.new(STDIN.read, opts.to_hash).html

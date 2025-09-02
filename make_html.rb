#!/usr/bin/env ruby
# frozen_string_literal: true

$stdout.sync = true

require 'slop'
require './page'

opts = Slop.parse do |o|
  o.string '--revision', 'Git revision'
  o.string '--canonical', 'canonical URL without a suffix'
  o.bool '--amp', 'enable AMP mode', default: false
end

puts Page.new($stdin.read, opts.to_hash).html

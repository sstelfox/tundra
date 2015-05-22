#!/usr/bin/env ruby

require 'json'

valid_entries = []

File.read(ARGV[0]).split("\n\n").each do |proc_entry|
  entry = {}
  useful_keys = ['core id', 'cpu cores', 'cpu MHz', 'processor', 'physical id', 'siblings']

  proc_entry.split("\n").each do |l|
    key, value = l.split(/\s+:\s+/)
    entry[key] = value if useful_keys.include?(key)
  end

  valid_entries << entry unless entry.empty?
end

puts JSON.pretty_generate(valid_entries)
puts valid_entries.count

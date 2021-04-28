#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMN_WIDTH = 8

def main(files, option)
  if files.empty?
    text = $stdin.read
    output_counts(text, option['l'])
  else
    output_file_contents(files, option['l'])
  end
end

def output_file_contents(files, l_option)
  files.each do |file|
    output_single_file(file, l_option)
  end
  output_total_files(files, l_option) if files.count > 1
end

def count_line(text)
  text.count("\n")
end

def count_word(text)
  text.split(/\s+/).size
end

def count_bytesize(text)
  text.bytesize
end

def count_total_line(files)
  files.sum do |file|
    text = File.read(file)
    count_line(text)
  end
end

def count_total_word(files)
  files.sum do |file|
    text = File.read(file)
    count_word(text)
  end
end

def count_total_bytesize(files)
  files.sum do |file|
    text = File.read(file)
    count_bytesize(text)
  end
end

def output_single_file(file, l_option)
  text = File.read(file)
  output_counts(text, l_option)
  puts " #{file}"
end

def output_total_files(files, l_option)
  print count_total_line(files).to_s.rjust(COLUMN_WIDTH)
  unless l_option
    print count_total_word(files).to_s.rjust(COLUMN_WIDTH)
    print count_total_bytesize(files).to_s.rjust(COLUMN_WIDTH)
  end
  puts ' total'
end

def output_counts(text, l_option)
  print count_line(text).to_s.rjust(COLUMN_WIDTH)
  return if l_option

  print count_word(text).to_s.rjust(COLUMN_WIDTH)
  puts count_bytesize(text).to_s.rjust(COLUMN_WIDTH)
end

files = ARGV
option = ARGV.getopts('l')
main(files, option)

#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
COLUMN_WIDTH = 8

def main(files, option)
  if files.empty? && option['l']
    input = $stdin.read
    output_stdin_l_option(input)
  elsif files.empty?
    input = $stdin.read
    output_stdin(input)
  else
    option['l'] ? operate_l_option(files) : operate(files)
  end
end

def operate(files)
  files.each do |file|
    FileTest.file?(file)
    output_single_file(file)
  end
  create_total_file(files)
end

def operate_l_option(files)
  files.each do |file|
    FileTest.file?(file)
    output_single_file_l_option(file)
  end
  create_total_files_l_option(files)
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

def count_total_line(total_files)
  total_files.sum do |file|
    text = File.read(file)
    count_line(text)
  end
end

def count_total_word(total_files)
  total_files.sum do |file|
    text = File.read(file)
    count_word(text)
  end
end

def count_total_bytesize(total_files)
  total_files.sum do |file|
    text = File.read(file)
    count_bytesize(text)
  end
end

def create_total_file(files)
  total_files = []
  files.each do |file|
    total_files << file if FileTest.file?(file)
  end
  output_total_files(total_files) if files.count > 1
end

def create_total_files_l_option(files)
  total_files = []
  files.each do |file|
    total_files << file if FileTest.file?(file)
  end
  output_total_files_l_option(total_files) if files.count > 1
end

def output_single_file(file)
  text = File.read(file)
  print count_line(text).to_s.rjust(COLUMN_WIDTH)
  print count_word(text).to_s.rjust(COLUMN_WIDTH)
  print count_bytesize(text).to_s.rjust(COLUMN_WIDTH)
  puts "\s#{file}"
end

def output_total_files(total_files)
  print count_total_line(total_files).to_s.rjust(COLUMN_WIDTH)
  print count_total_word(total_files).to_s.rjust(COLUMN_WIDTH)
  print count_total_bytesize(total_files).to_s.rjust(COLUMN_WIDTH)
  puts "\stotal"
end

def output_single_file_l_option(file)
  text = File.read(file)
  print count_line(text).to_s.rjust(COLUMN_WIDTH)
  puts "\s#{file}"
end

def output_total_files_l_option(total_files)
  print count_total_line(total_files).to_s.rjust(COLUMN_WIDTH)
  puts "\stotal"
end

def output_stdin(input)
  print count_line(input).to_s.rjust(COLUMN_WIDTH)
  print count_word(input).to_s.rjust(COLUMN_WIDTH)
  puts count_bytesize(input).to_s.rjust(COLUMN_WIDTH)
end

def output_stdin_l_option(input)
  print count_line(input)
  puts 'D'
end

files = ARGV
option = ARGV.getopts('l')
main(files, option)

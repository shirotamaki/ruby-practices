#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  files = ARGV
  options = ARGV.getopts('l')
  if options['l']
    operation_option_l(files)
  else
    operation(files)
  end
end

def operation(files)
  if files.empty?
    input = $stdin.read
    output_stdin(input)
  end
  files.map do |file|
    if FileTest.directory?(file)
      output_dir(file)
    elsif FileTest.file?(file)
      output_single_file(file)
    else
      output_error(files)
    end
  end
  return unless files.last && files.count > 1

  output_plural_files(files)
end

def operation_option_l(files)
  if files.empty?
    input = $stdin.read
    output_l_option(input)
  end
  files.map do |file|
    if FileTest.directory?(file)
      output_dir_option_l(file)
    elsif FileTest.file?(file)
      output_single_file_option_l(file)
    else
      output_error(files)
    end
  end
  return unless files.last && files.count > 1
  output_plural_files_option_l(files)
end

# 部品 (行数、単語数、バイト数を数える)
def count_line(file)
  result = File.read(file).count("\n")
  result.to_i
end

def count_word(file)
  result = File.read(file).split(/\s+/).size
  result.to_i
end

def count_bytesize(file)
  result = File.read(file).bytesize
  result.to_i
end

# 部品（トータルの行数、単語数、バイト数を数える）
def count_total_lines(files)
  files.sum { |file| count_line(file) }
end

def count_total_words(files)
  files.sum { |file| count_word(file) }
end

def count_total_bytesizes(files)
  files.sum { |file| count_bytesize(file) }
end

# 部品（エラーメッセージ等）
#
def output_dir(file)
  puts "wc: #{file}: Is a directory"
  puts "0\s\s0\s\s0\s\s#{file}"
end

def output_l_dir(file)
  puts "wc: #{file}: Is a directory"
  puts "0\s#{file}"
end

def output_error(files)
  print "wc: #{files}: No such file or directory\n"
end

# 部品（アウトプット用）
def output_single_file(file)
  print count_line(file).to_s.ljust(8)
  print count_word(file).to_s.ljust(8)
  print count_bytesize(file).to_s.ljust(8)
  print "#{file}\n".to_s
end

def output_plural_files(files)
  print count_total_lines(files).to_s.ljust(8)
  print count_total_words(files).to_s.ljust(8)
  print count_total_bytesizes(files).to_s.ljust(8)
  print "total\n".to_s
end

def output_all_total(files)
  print count_total_lines(files).ljust(8)
  print "total\n".to_s
end

def output_stdin(input)
  print input.count("\n").to_s.ljust(8)
  print input.split(/\s+/).size.to_s.ljust(8)
  print input.bytesize.to_s.ljust(8)
end

def output_l_option(input)
  print input.count("\n").to_s.ljust(8)
  print "D\n".to_s
end

def output_dir_option_l(file)
  print count_line(file).to_s.ljust(8)
  print "#{file}\n".to_s
end

def output_single_file_option_l(file)
  print count_line(file).to_s.ljust(8)
  print "#{file}\n".to_s
end

def output_plural_files_option_l(files)
  print count_total_lines(files).to_s.ljust(8)
  print "total\n".to_s
end

main

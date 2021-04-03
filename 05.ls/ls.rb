#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  options = ARGV.getopts('a', 'l', 'r')
  files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
  files = files.reverse if options['r']

  if options['a'] && options['r'] && options['l']
    options_l(files)
  elsif options['l']
    options_l(files)
  else
    options_a_r(files)
  end
end

# オプションなし、aオプション、rオプション
def options_a_r(files)
  size = files.each_slice(3).to_a.size
  splitted_files = files.each_slice(size).to_a
  filled_files = splitted_files.map { |row| row.values_at(0..(size - 1)) }
  print_files = filled_files.transpose
  print_files.each do |row|
    row.each do |value|
      print "#{value.to_s.ljust(18)}\s"
    end
    print "\n"
  end
end

# lオプション、arlオプション
def options_l(files)
  total = 0
  files.each do |x|
    fs = File::Stat.new(x)
    total += fs.blocks
  end
  puts "total #{total / 2}"

  files.each do |x|
    fs = File::Stat.new(x)
    ftype = fs.ftype
    mode = format('%o', fs.mode)
    ftype_output = option_ftype(ftype)
    mode_output1 = option_mode(mode[-3])
    mode_output2 = option_mode(mode[-2])
    mode_output3 = option_mode(mode[-1])
    nlink = fs.nlink
    uid = Etc.getpwuid(fs.uid).name
    # gid = Etc.getgrgid(fs.gid).name  　# 本家lsコマンドでは表示されないため除外。
    size = fs.size
    mtime = fs.mtime.strftime('%b %d %H:%M')
    basename = File.basename(x)
    print "#{ftype_output}#{mode_output1}#{mode_output2}#{mode_output3} #{nlink} #{uid} #{size} #{mtime} #{basename}\n"
  end
end

# lオプション（ftype用のメソッド）
def option_ftype(ftype)
  {
    fifo: 'f',
    characterSpecial: 'c',
    directory: 'd',
    blockSpecial: 'b',
    file: '-',
    link: 'l',
    socket: 's'
  }[ftype.to_sym]
end

# lオプション（mode用のメソッド）
def option_mode(mode)
  {
    "0": '---',
    "1": '--x',
    "2": '-w-',
    "3": '-wx',
    "4": 'r--',
    "5": 'r-x',
    "6": 'rw-',
    "7": 'rwx'
  }[mode.to_sym]
end

main

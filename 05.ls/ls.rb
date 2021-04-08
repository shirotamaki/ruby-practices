#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  options = ARGV.getopts('a', 'l', 'r')
  files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
  files = files.reverse if options['r']
  options['l'] ? output_command_l(files) : output_command(files)
end

# オプションなし、aオプション、rオプションの場合
def output_command(files)
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

# lオプションの時totalの出力をする
def output_total(files)
  total = files.sum { |x| File::Stat.new(x).blocks }
  puts "total #{total / 2}"
end

# total部分以外の出力用メソッド
def output_detail(files)
  files.each do |x|
    fs = File::Stat.new(x)
    ftype = fs.ftype
    mode = format('%o', fs.mode)
    ftype = option_ftype(ftype)
    owner_permission = option_mode(mode[-3])
    group_permission = option_mode(mode[-2])
    other_user_permission = option_mode(mode[-1])
    nlink = fs.nlink
    uid = Etc.getpwuid(fs.uid).name
    size = fs.size
    mtime = fs.mtime.strftime('%b %d %H:%M')
    basename = File.basename(x)
    print "#{ftype}#{owner_permission}#{group_permission}#{other_user_permission}\s#{nlink}\s#{uid}\s#{size}\s#{mtime}\s#{basename}\n"
  end
end

def output_command_l(files)
  output_total(files)
  output_detail(files)
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

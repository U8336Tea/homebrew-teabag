#!/bin/ruby

#:`Usage: brew autoremove [packages]`
#:
#:Removes a target and all its dependencies.
#:
#:Currently uses a recursive method using brew leaves.
#:There's probably a better way but this works for me.
#:
#:    -v, --verbose                            Enables verbose mode.
#:    -h, --help                               Show this message.

require 'optparse'

def remove(*programs)
    leafText = `brew leaves`
    leafList = leafText.split "\n"

    puts "Removing packages #{programs.join ", "}" if $options[:verbose]
    `brew remove #{programs.join " "}`

    newLeafText = `brew leaves`
    newLeafList = newLeafText.split "\n"

    leafDiff = newLeafList - leafList
    puts "Remaining packages: #{leafDiff.join ", "} " if $options[:verbose]

    # Recursively remove every leaf that wasn't here before the first remove
    remove *leafDiff unless leafDiff.empty?
end

$options = {}
OptionParser.new do |opts|
    opts.on("-v", "--verbose") do |v|
        $options[:verbose] = v
    end
end.parse!

remove *ARGV
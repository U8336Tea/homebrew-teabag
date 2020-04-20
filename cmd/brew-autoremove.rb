#!/bin/ruby

#: Usage: brew autoremove [packages]
#:
#: Currently uses a recursive method using brew leaves
#: There's probably a better way but idk yet

def remove(*programs)
    leafText = `brew leaves`
    leafList = leafText.split "\n"

    `brew remove #{programs.join " "}`

    newLeafText = `brew leaves`
    newLeafList = newLeafText.split "\n"

    leafDiff = newLeafList - leafList

    # Recursively remove every leaf that wasn't here before the first remove
    remove *leafDiff unless leafDiff.empty?
end

remove *ARGV
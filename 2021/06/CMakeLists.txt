#!/usr/bin/env -S cmake -P CMakeLists.txt

# Do not ask why this is the way it is.
# I didn't expect this script to turn into a real thing.
# Also what a nice shebang!

cmake_minimum_required(VERSION 3.27)

function(run puzzle days outvar)
    file(READ "${puzzle}" puzzle)
    string(STRIP "${puzzle}" puzzle)
    string(REPLACE , ";" puzzle "${puzzle}")

    # We sort of allocate a map with fish=>count as key=>value pairs.
    # There is a 9th entry we serve as a buffer for new fishes.
    # The actual consumer range is 0-8.
    foreach(i RANGE 0 9)
        set(map_${i} 0)
    endforeach()
    foreach(n ${puzzle})
        math(EXPR map_${n} "${map_${n}} + 1")
    endforeach()

    # Debug print
    # message("Initial: ${puzzle}")
    # foreach(n RANGE 0 8)
    #     message("map_${n}: ${map_${n}}")
    # endforeach()

    # Day loop
    foreach(i RANGE 1 "${days}")
        set(map_9 ${map_0})
        math(EXPR map_7 "${map_7} + ${map_0}")
        set(map_0 0)

        foreach(n RANGE 1 9)
            math(EXPR n_minus "${n} - 1")
            math(EXPR map_${n_minus} "${map_${n_minus}} + ${map_${n}}")
            math(EXPR map_${n} 0)
        endforeach()

        # Debug print
        # message("\nDay ${i}")
        # foreach(n RANGE 0 8)
        #     message("map_${n}: ${map_${n}}")
        # endforeach()
    endforeach()

    # Accumulate fish counts
    set(len 0)
    foreach(n RANGE 0 8)
        math(EXPR len "${len} + ${map_${n}}")
    endforeach()

    # This is a curious way of declaring the return value
    set("${outvar}" ${len} PARENT_SCOPE)
endfunction()

set(puzzle input.tooreal.txt)

run("${puzzle}" 80 one)
message("[Day one] Number of fishes: ${one}")
# out: 345793

run("${puzzle}" 256 two)
message("[Day two] Number of fishes: ${two}")
# out: 1572643095893

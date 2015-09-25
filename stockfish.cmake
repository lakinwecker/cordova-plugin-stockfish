PROJECT(libstockfish)

set(STOCKFISH_ROOT ${CMAKE_CURRENT_BINARY_DIR}/lib/stockfish)
set(INCLUDE_DIR include)
set(LIB_DIR lib)

function(append_if_exist OUTPUT_LIST)
    set(${OUTPUT_LIST})
    foreach(f ${ARGN})
        if(EXISTS ${f})
            list(APPEND ${OUTPUT_LIST} "${f}")
        else()
            message("Warning: file missing: ${f}")
        endif()
    endforeach()
    set(${OUTPUT_LIST} ${${OUTPUT_LIST}} PARENT_SCOPE)
endfunction()

append_if_exist(SOURCES
  ${STOCKFISH_ROOT}/src/benchmark.cpp
  ${STOCKFISH_ROOT}/src/bitbase.cpp
  ${STOCKFISH_ROOT}/src/bitboard.cpp
  ${STOCKFISH_ROOT}/src/endgame.cpp
  ${STOCKFISH_ROOT}/src/evaluate.cpp
  ${STOCKFISH_ROOT}/src/material.cpp
  ${STOCKFISH_ROOT}/src/misc.cpp
  ${STOCKFISH_ROOT}/src/movegen.cpp
  ${STOCKFISH_ROOT}/src/movepick.cpp
  ${STOCKFISH_ROOT}/src/pawns.cpp
  ${STOCKFISH_ROOT}/src/position.cpp
  ${STOCKFISH_ROOT}/src/psqt.cpp
  ${STOCKFISH_ROOT}/src/search.cpp
  ${STOCKFISH_ROOT}/src/thread.cpp
  ${STOCKFISH_ROOT}/src/timeman.cpp
  ${STOCKFISH_ROOT}/src/tt.cpp
  ${STOCKFISH_ROOT}/src/uci.cpp
  ${STOCKFISH_ROOT}/src/ucioption.cpp
  ${STOCKFISH_ROOT}/src/syzygy/tbprobe.cpp
)

add_library(libstockfish ${SOURCES})
set_target_properties(libstockfish PROPERTIES OUTPUT_NAME "stockfish")
install(TARGETS libstockfish DESTINATION ${LIB_DIR})

append_if_exist(INSTALL_FILES_LIST
  ${STOCKFISH_ROOT}/src/bitboard.h
  ${STOCKFISH_ROOT}/src/bitcount.h
  ${STOCKFISH_ROOT}/src/endgame.h
  ${STOCKFISH_ROOT}/src/evaluate.h
  ${STOCKFISH_ROOT}/src/material.h
  ${STOCKFISH_ROOT}/src/misc.h
  ${STOCKFISH_ROOT}/src/movegen.h
  ${STOCKFISH_ROOT}/src/movepick.h
  ${STOCKFISH_ROOT}/src/pawns.h
  ${STOCKFISH_ROOT}/src/position.h
  ${STOCKFISH_ROOT}/src/search.h
  ${STOCKFISH_ROOT}/src/thread.h
  ${STOCKFISH_ROOT}/src/timeman.h
  ${STOCKFISH_ROOT}/src/types.h
  ${STOCKFISH_ROOT}/src/tt.h
  ${STOCKFISH_ROOT}/src/uci.h
  ${STOCKFISH_ROOT}/src/syzygy/tbprobe.h
)

foreach(f ${INSTALL_FILES_LIST})
  FILE(RELATIVE_PATH relative_file ${STOCKFISH_ROOT}/src ${f})
  GET_FILENAME_COMPONENT(relative_header_dir ${relative_file} PATH)
  INSTALL(FILES ${f} DESTINATION ${INCLUDE_DIR}/${relative_header_dir})
endforeach()

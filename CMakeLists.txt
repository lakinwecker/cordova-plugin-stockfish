CMAKE_MINIMUM_REQUIRED(VERSION 2.6)


INCLUDE(./stockfish.cmake)

set_source_files_properties(settings.h PROPERTIES GENERATED true)
add_custom_command(OUTPUT settings.h
    COMMAND sh settings.sh src/
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})

project(stockfishcli)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
include_directories(${CMAKE_CURRENT_BINARY_DIR}/lib/stockfish/src)
add_library(stockfishcli "src/stockfishcli.cpp")
target_link_libraries(stockfishcli stockfish)

add_executable(main tests/main.cpp)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/src)
target_link_libraries(main libstockfish)

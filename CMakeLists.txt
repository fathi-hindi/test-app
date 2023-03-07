cmake_minimum_required(VERSION 3.24)
project(p_)

set(CMAKE_PREFIX_PATH "/usr/local/bin/;/usr/lib/llvm-14/")



find_package(LLVM  REQUIRED)
find_package(FLEX  REQUIRED)
find_package(BISON  REQUIRED)

llvm_map_components_to_libnames(
        LLVM_LIBRARIES
        Core
        ExecutionEngine
        Interpreter
        MC
        MCJIT
        Suppo
        nativecodegen
)


add_library(test::LLVM INTERFACE IMPORTED)
target_include_directories(test::LLFLEX_FILEVM INTERFACE ${LLVM_INCLUDE_DIRS})
target_compile_definitions(test::LLVM INTERFACE ${LLVM_DEFINITIONS})
target_link_libraries(test::LLVM INTERFACE ${LLVM_LIBRARIES})


set(SOURCES
    lexer.l
    parser.y
    main.c
)

set(EXECUTABLE_NAME my_executable)

set(LEXER_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/lexer.c)
set(PARSER_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/parser.c)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(${EXECUTABLE_NAME} ${SOURCES} ${LEXER_OUTPUT} ${PARSER_OUTPUT})


FLEX_TARGET(lexer lexer.l ${LEXER_OUTPUT})
BISON_TARGET(parser parser.y ${PARSER_OUTPUT})
ADD_FLEX_BISON_DEPENDENCY(lexer parser)
target_link_libraries(p_ PRIVATE test::LLVM)


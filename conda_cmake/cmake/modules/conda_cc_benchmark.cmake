

include(CMakeParseArguments)
include(conda_config_cxx_opts)
include(conda_install_dirs)
include(conda_print_list)

function(conda_cc_benchmark)
    set(options
            VERBOSE
            )
    set(args NAME
            WORKING_DIRECTORY
            )

    set(list_args
            PUBLIC_LINKED_TARGETS
            PRIVATE_LINKED_TARGETS
            SOURCES
            COMMAND
            PUBLIC_DEFINITIONS
            PRIVATE_DEFINITIONS
            PUBLIC_INCLUDE_PATHS
            PRIVATE_INCLUDE_PATHS
            PUBLIC_COMPILE_FEATURES
            PRIVATE_COMPILE_FEATURES
            PRIVATE_COMPILE_OPTIONS
            PUBLIC_COMPILE_OPTIONS
            )

    cmake_parse_arguments(
            PARSE_ARGV 0
            CONDA_CC_BENCHMARK
            "${options}"
            "${args}"
            "${list_args}"
    )

    if (CONDA_CC_BENCHMARK_VERBOSE)
        conda_raw("-----------------------------------")
        conda_print_label("Building Test" "${CONDA_CC_BENCHMARK_NAME}")
        conda_raw("-----------------------------------")
        conda_print_label("Command to Execute" "${CONDA_CC_BENCHMARK_COMMAND}")
        conda_print_label("Working Directory" "${CONDA_CC_BENCHMARK_WORKING_DIRECTORY}")
        conda_print_list_label("Sources" CONDA_CC_BENCHMARK_SOURCES)
        conda_print_list_label("Public Linked Targest" CONDA_CC_BENCHMARK_PUBLIC_LINKED_TARGETS)
        conda_print_list_label("Private Linked Targest" CONDA_CC_BENCHMARK_PRIVATE_LINKED_TARGETS)
        conda_print_list_label("Public Include Paths" CONDA_CC_BENCHMARK_PUBLIC_INCLUDE_PATHS)
        conda_print_list_label("Private Include Paths" CONDA_CC_BENCHMARK_PRIVATE_INCLUDE_PATHS)
        conda_print_list_label("Public Compile Features" CONDA_CC_BENCHMARK_PUBLIC_COMPILE_FEATURES)
        conda_print_list_label("Private Compile Features" CONDA_CC_BENCHMARK_PRIVATE_COMPILE_FEATURES)
        conda_print_list_label("Public Definitions" CONDA_CC_BENCHMARK_PUBLIC_DEFINITIONS)
        conda_print_list_label("Private Definitions" CONDA_CC_BENCHMARK_PRIVATE_DEFINITIONS)
        conda_raw("-----------------------------------")
    endif ()

    set(testcase ${CONDA_CC_BENCHMARK_NAME})

    add_executable(${testcase} ${CONDA_CC_BENCHMARK_SOURCES})
    target_compile_definitions(${testcase} PRIVATE
            #CATCH_CONFIG_FAST_COMPILE
            $<$<CXX_COMPILER_ID:MSVC>:_SCL_SECURE_NO_WARNINGS>
            ${CONDA_CC_BENCHMARK_PRIVATE_DEFINITIONS}
            ${CONDA_CC_BENCHMARK_PUBLIC_DEFINITIONS}
            )
    target_compile_options(${testcase} PRIVATE
            $<$<CXX_COMPILER_ID:MSVC>:/EHsc;$<$<CONFIG:Release>:/Od>>
            # $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wno-deprecated;-Wno-float-equal>
            $<$<CXX_COMPILER_ID:GNU>:-Wno-deprecated-declarations>
            ${CONDA_CC_BENCHMARK_PUBLIC_COMPILE_FEATURES}
            ${CONDA_CC_BENCHMARK_PRIVATE_COMPILE_FEATURES}
            )
    target_include_directories(${testcase} PRIVATE
            ${CONDA_CC_BENCHMARK_PUBLIC_INCLUDE_PATHS}
            ${CONDA_CC_BENCHMARK_PRIVATE_INCLUDE_PATHS}
            )

    target_compile_options(${CONDA_CC_BENCHMARK_NAME} PUBLIC ${CONDA_CC_BENCHMARK_PUBLIC_COMPILE_OPTIONS} )
    target_compile_options(${CONDA_CC_BENCHMARK_NAME} PRIVATE ${CONDA_CC_BENCHMARK_PRIVATE_COMPILE_OPTIONS} )


    target_link_libraries(${testcase} ${CONDA_CC_BENCHMARK_PUBLIC_LINKED_TARGETS} ${CONDA_CC_BENCHMARK_PRIVATE_LINKED_TARGETS})
    #target_link_libraries(${testcase} --coverage -g -O0 -fprofile-arcs -ftest-coverage)
    #target_compile_options(${testcase} PRIVATE --coverage -g -O0 -fprofile-arcs -ftest-coverage)

    #MESSAGE("         Adding link libraries for ${testcase}: ${GNL_LIBS}  ${GNL_COVERAGE_FLAGS} ")

    #add_test( NAME ${testcase}
    #       COMMAND ${CONDA_CC_BENCHMARK_COMMAND}
    #      WORKING_DIRECTORY ${CONDA_CC_BENCHMARK_WORKING_DIRECTORY})

endfunction()

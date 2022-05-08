

################################################################################
# Create an executable.
#
# Example usage:
#
# conda_cc_binary(  NAME myExe
#                  SOURCES
#                       main.cpp
#                  PUBLIC_DEFINITIONS
#                     USE_DOUBLE_PRECISION=1
#                  PRIVATE_DEFINITIONS
#                     DEBUG_VERBOSE
#                  PUBLIC_INCLUDE_PATHS
#                     ${CMAKE_SOURCE_DIR}/mylib/include
#                  PRIVATE_INCLUDE_PATHS
#                     ${CMAKE_SOURCE_DIR}/include
#                  PRIVATE_LINKED_TARGETS
#                     Threads::Threads
#                  PUBLIC_LINKED_TARGETS
#                     Threads::Threads
#                  LINKED_TARGETS
#                     Threads::Threads
#                     myNamespace::myLib
# )
#
# The above example creates an alias target, myNamespace::myLibrary which can be
# linked to by other tar gets.
# PUBLIC_DEFINITIONS -  preprocessor defines which are inherated by targets which
#                       link to this library
#
# PRIVATE_DEFINITIONS - preprocessor defines which are private and only seen by
#                       myLibrary
#
# PUBLIC_INCLUDE_PATHS - include paths which are public, therefore inherted by
#                        targest which link to this library.
#
# PRIVATE_INCLUDE_PATHS - private include paths which are only visible by MyExe
#
# LINKED_TARGETS        - targets to link to.
################################################################################

function(conda_cc_binary)
    set(options
            VERBOSE)
    set(args NAME
            )

    set(list_args
            PUBLIC_LINKED_TARGETS
            PRIVATE_LINKED_TARGETS
            SOURCES
            PUBLIC_DEFINITIONS
            PRIVATE_DEFINITIONS
            PUBLIC_INCLUDE_PATHS
            PRIVATE_INCLUDE_PATHS
            PUBLIC_COMPILE_FEATURES
            PRIVATE_COMPILE_FEATURES
            PUBLIC_COMPILE_OPTIONS
            PRIVATE_COMPILE_OPTIONS
            )

    cmake_parse_arguments(
            PARSE_ARGV 0
            CONDA_CC_BINARY
            "${options}"
            "${args}"
            "${list_args}"
    )
    conda_raw("-----------------------------------")
    conda_print_label("Building Binary" "${CONDA_CC_BINARY_NAME}")
    conda_raw("-----------------------------------")
    if(CONDA_CC_BINARY_VERBOSE)
        conda_print_list_label("Sources" CONDA_CC_BINARY_SOURCES)
        conda_print_list_label("Public Linked Targest"  CONDA_CC_BINARY_PUBLIC_LINKED_TARGETS)
        conda_print_list_label("Private Linked Targest"  CONDA_CC_BINARY_PRIVATE_LINKED_TARGETS)
        conda_print_list_label("Public Include Paths"  CONDA_CC_BINARY_PUBLIC_INCLUDE_PATHS)
        conda_print_list_label("Private Include Paths" CONDA_CC_BINARY_PRIVATE_INCLUDE_PATHS)
        conda_print_list_label("Public Compile Features" CONDA_CC_BINARY_PUBLIC_COMPILE_FEATURES)
        conda_print_list_label("Private Compile Features" CONDA_CC_BINARY_PRIVATE_COMPILE_FEATURES)
        conda_print_list_label("Public Definitions" CONDA_CC_BINARY_PUBLIC_DEFINITIONS)
        conda_print_list_label("Private Definitions" CONDA_CC_BINARY_PRIVATE_DEFINITIONS)
        conda_raw("-----------------------------------")
    endif()
    add_executable( ${CONDA_CC_BINARY_NAME} ${CONDA_CC_BINARY_SOURCES} )
    target_link_libraries(${CONDA_CC_BINARY_NAME}
            PUBLIC ${CONDA_CC_BINARY_PUBLIC_LINKED_TARGETS}
            PRIVATE ${CONDA_CC_BINARY_PRIVATE_LINKED_TARGETS})



    target_include_directories( ${CONDA_CC_BINARY_NAME}
            PUBLIC
            ${CONDA_CC_BINARY_PUBLIC_INCLUDE_PATHS}
            PRIVATE
            ${CONDA_CC_BINARY_PRIVATE_INCLUDE_PATHS}
            )

    target_compile_definitions( ${CONDA_CC_BINARY_NAME}
            PUBLIC
            ${CONDA_CC_BINARY_PUBLIC_DEFINITIONS}
            PRIVATE
            ${CONDA_CC_BINARY_PRIVATE_DEFINITIONS}
            )
    target_compile_features(${CONDA_CC_BINARY_NAME} PUBLIC ${CONDA_CC_BINARY_PUBLIC_COMPILE_FEATURES} )
    target_compile_features(${CONDA_CC_BINARY_NAME} PRIVATE ${CONDA_CC_BINARY_PRIVATE_COMPILE_FEATURES} )

    target_compile_options(${CONDA_CC_BINARY_NAME} PUBLIC ${CONDA_CC_BINARY_PUBLIC_COMPILE_OPTIONS} )
    target_compile_options(${CONDA_CC_BINARY_NAME} PRIVATE ${CONDA_CC_BINARY_PRIVATE_COMPILE_OPTIONS} )


    set_property(TARGET ${CONDA_CC_BINARY_NAME} PROPERTY CXX_STANDARD ${CONDA_CXX_STANDARD})
    set_property(TARGET ${CONDA_CC_BINARY_NAME} PROPERTY CXX_STANDARD_REQUIRED ON)

    install(TARGETS ${CONDA_CC_BINARY_NAME} EXPORT ${PROJECT_NAME}Targets
            RUNTIME DESTINATION ${CONDA_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CONDA_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CONDA_INSTALL_LIBDIR}
            )

    ################################################################################

    foreach(arg IN LISTS CONDA_CC_BINARY_UNPARSED_ARGUMENTS)
        conda_warn( "Unparsed argument: ${arg}")
    endforeach()

endfunction(conda_cc_binary)
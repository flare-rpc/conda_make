

include(CMakeParseArguments)
include(conda_config_cxx_opts)
include(conda_install_dirs)
include(conda_print_list)
include(conda_print)
include(conda_variable)

# conda_cc_library(  NAME myLibrary
#                  NAMESPACE myNamespace
#                  SOURCES
#                       myLib.cpp
#                       myLib_functions.cpp
#                  HEADERS
#                        mylib.h
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
#                  PUBLIC
#                  SHARED

################################################################################
# Create a Library.
#
# Example usage:
#
# conda_cc_library(  NAME myLibrary
#                  NAMESPACE myNamespace
#                  SOURCES
#                       myLib.cpp
#                       myLib_functions.cpp
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
#                  EXPORT_FILE_PATH
#                      ${CMAKE_BINARY_DIR}/MYLIBRARY_EXPORT.h
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
# PRIVATE_INCLUDE_PATHS - private include paths which are only visible by MyLibrary
#
# LINKED_TARGETS        - targets to link to.
#
# EXPORT_FILE_PATH      - the export file to generate for dll files.
################################################################################
function(conda_cc_library)
    set(options
            PUBLIC
            SHARED
            VERBOSE
            )
    set(args NAME
            NAMESPACE
            )

    set(list_args
            PUBLIC_LINKED_TARGETS
            PRIVATE_LINKED_TARGETS
            SOURCES
            HEADERS
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
            CONDA_CC_LIB
            "${options}"
            "${args}"
            "${list_args}"
    )


    if ("${CONDA_CC_LIB_NAME}" STREQUAL "")
        get_filename_component(CONDA_CC_LIB_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
        string(REPLACE " " "_" CONDA_CC_LIB_NAME ${CONDA_CC_LIB_NAME})
        conda_print(" Library, NAME argument not provided. Using folder name:  ${CONDA_CC_LIB_NAME}")
    endif ()

    if ("${CONDA_CC_LIB_NAMESPACE}" STREQUAL "")
        set(CONDA_CC_LIB_NAMESPACE ${CONDA_CC_LIB_NAME})
        message(" Library, NAMESPACE argument not provided. Using target alias:  ${CONDA_CC_LIB_NAME}::${CONDA_CC_LIB_NAME}")
    endif ()

    if ("${CONDA_CC_LIB_SOURCES}" STREQUAL "")
        set(CONDA_CC_LIB_IS_INTERFACE true)
    else ()
        set(CONDA_CC_LIB_IS_INTERFACE false)
    endif ()

    if (CONDA_CC_LIB_SHARED)
        set(CONDA_BUILD_TYPE "SHARED")
    else ()
        set(CONDA_BUILD_TYPE "STATIC")
    endif ()


    conda_raw("-----------------------------------")
    conda_print_label("Create Library" "${CONDA_CC_LIB_NAMESPACE}::${CONDA_CC_LIB_NAME}")
    conda_raw("-----------------------------------")
    if (CONDA_CC_LIB_VERBOSE)
        conda_print_list_label("Sources" CONDA_CC_LIB_SOURCES)
        conda_print_list_label("Public Linked Targest" CONDA_CC_LIB_PUBLIC_LINKED_TARGETS)
        conda_print_list_label("Private Linked Targest" CONDA_CC_LIB_PRIVATE_LINKED_TARGETS)
        conda_print_list_label("Public Include Paths" CONDA_CC_LIB_PUBLIC_INCLUDE_PATHS)
        conda_print_list_label("Private Include Paths" CONDA_CC_LIB_PRIVATE_INCLUDE_PATHS)
        conda_print_list_label("Public Compile Features" CONDA_CC_LIB_PUBLIC_COMPILE_FEATURES)
        conda_print_list_label("Private Compile Features" CONDA_CC_LIB_PRIVATE_COMPILE_FEATURES)
        conda_print_list_label("Public Definitions" CONDA_CC_LIB_PUBLIC_DEFINITIONS)
        conda_print_list_label("Private Definitions" CONDA_CC_LIB_PRIVATE_DEFINITIONS)
        if (CONDA_CC_LIB_PUBLIC)
            conda_print_label("Public" "true")
        else ()
            conda_print_label("Public" "false")
        endif ()
        conda_print_label("Libaray type" ${CONDA_BUILD_TYPE})
        conda_print_label("Interface" ${CONDA_CC_LIB_IS_INTERFACE})
        conda_raw("-----------------------------------")
    endif ()
    if (NOT CONDA_CC_LIB_IS_INTERFACE)
        add_library(${CONDA_CC_LIB_NAME} ${CONDA_BUILD_TYPE} ${CONDA_CC_LIB_SOURCES} ${CONDA_CC_LIB_HEADERS})
        add_library(${CONDA_CC_LIB_NAMESPACE}::${CONDA_CC_LIB_NAME} ALIAS ${CONDA_CC_LIB_NAME})

        target_compile_features(${CONDA_CC_LIB_NAME} PUBLIC ${CONDA_CC_LIB_PUBLIC_COMPILE_FEATURES})
        target_compile_features(${CONDA_CC_LIB_NAME} PRIVATE ${CONDA_CC_LIB_PRIVATE_COMPILE_FEATURES})

        target_compile_options(${CONDA_CC_LIB_NAME} PUBLIC ${CONDA_CC_LIB_PUBLIC_COMPILE_OPTIONS})
        target_compile_options(${CONDA_CC_LIB_NAME} PRIVATE ${CONDA_CC_LIB_PRIVATE_COMPILE_OPTIONS})

        target_link_libraries(${CONDA_CC_LIB_NAME} PUBLIC ${CONDA_CC_LIB_PUBLIC_LINKED_TARGETS})
        target_link_libraries(${CONDA_CC_LIB_NAME} PRIVATE ${CONDA_CC_LIB_PRIVATE_LINKED_TARGETS})

        target_include_directories(${CONDA_CC_LIB_NAME}
                PUBLIC
                ${CONDA_CC_LIB_INCLUDE_PATHS}
                ${CONDA_CC_LIB_PUBLIC_INCLUDE_PATHS}
                PRIVATE
                ${CONDA_CC_LIB_PRIVATE_INCLUDE_PATHS}
                )

        target_compile_definitions(${CONDA_CC_LIB_NAME}
                PUBLIC
                ${CONDA_CC_LIB_PUBLIC_DEFINITIONS}
                PRIVATE
                ${CONDA_CC_LIB_PRIVATE_DEFINITIONS}
                )
    else ()
        add_library(${CONDA_CC_LIB_NAME} INTERFACE)
        add_library(${CONDA_CC_LIB_NAMESPACE}::${CONDA_CC_LIB_NAME} ALIAS ${CONDA_CC_LIB_NAME})
        target_compile_features(${CONDA_CC_LIB_NAME} INTERFACE ${CONDA_CC_LIB_PUBLIC_COMPILE_FEATURES})
        target_compile_features(${CONDA_CC_LIB_NAME} INTERFACE ${CONDA_CC_LIB_PRIVATE_COMPILE_FEATURES})

        target_compile_options(${CONDA_CC_LIB_NAME} INTERFACE ${CONDA_CC_LIB_PUBLIC_COMPILE_OPTIONS})
        target_compile_options(${CONDA_CC_LIB_NAME} INTERFACE ${CONDA_CC_LIB_PRIVATE_COMPILE_OPTIONS})

        target_link_libraries(${CONDA_CC_LIB_NAME} INTERFACE
                ${CONDA_CC_LIB_PUBLIC_LINKED_TARGETS}
                ${CONDA_CC_LIB_PRIVATE_LINKED_TARGETS}
                )

        target_include_directories(${CONDA_CC_LIB_NAME}
                INTERFACE
                ${CONDA_CC_LIB_INCLUDE_PATHS}
                ${CONDA_CC_LIB_PUBLIC_INCLUDE_PATHS}
                ${CONDA_CC_LIB_PRIVATE_INCLUDE_PATHS}
                )

        target_compile_definitions(${CONDA_CC_LIB_NAME} INTERFACE ${CONDA_CC_LIB_DEFINES})

    endif ()

    if (CONDA_CC_LIB_PUBLIC)

        install(TARGETS ${CONDA_CC_LIB_NAME}
                EXPORT ${PROJECT_NAME}Targets
                RUNTIME DESTINATION ${CONDA_INSTALL_BINDIR}
                LIBRARY DESTINATION ${CONDA_INSTALL_LIBDIR}
                ARCHIVE DESTINATION ${CONDA_INSTALL_LIBDIR}
                INCLUDES DESTINATION ${CONDA_INSTALL_INCLUDEDIR}
                )
    endif ()

    foreach (arg IN LISTS CONDA_CC_LIB_UNPARSED_ARGUMENTS)
        message(WARNING "Unparsed argument: ${arg}")
    endforeach ()

endfunction()


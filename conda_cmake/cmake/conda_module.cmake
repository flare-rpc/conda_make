
include(conda_print)
include(conda_cc_library)
include(conda_cc_test)
include(conda_cc_binary)
include(conda_cc_benchmark)
include(conda_print_list)
include(conda_check)
include(conda_variable)
include(conda_include)

if (NOT CONDA_PREFIX)
    set(CONDA_PREFIX ${PROJECT_SOURCE_DIR}/conda)
    conda_print("CONDA_PREFIX not set, set to ${CONDA_PREFIX}")
endif ()

link_directories(${CONDA_PREFIX}/${CONDA_INSTALL_LIBDIR})

list(APPEND CMAKE_PREFIX_PATH $ENV{CONDA_PREFIX})

conda_include("${CONDA_PREFIX}/${CONDA_INSTALL_INCLUDEDIR}")
conda_include("${PROJECT_BINARY_DIR}")
conda_include("${PROJECT_SOURCE_DIR}")

MACRO(directory_list result curdir)
    FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
    SET(dirlist "")
    FOREACH(child ${children})
        IF(IS_DIRECTORY ${curdir}/${child} )
            LIST(APPEND dirlist ${child})
        ENDIF()
    ENDFOREACH()
    SET(${result} ${dirlist})
ENDMACRO()

directory_list(install_libs "${CONDA_PREFIX}/${CONDA_INSTALL_LIBDIR}/cmake")

FOREACH(installed_lib  ${install_libs})
    list(APPEND CMAKE_MODULE_PATH
            ${CONDA_PREFIX}/${CONDA_INSTALL_LIBDIR}/cmake/${installed_lib})

ENDFOREACH()

include(conda_outof_source)
include(conda_platform)
include(conda_pkg_dump)

CONDA_ENSURE_OUT_OF_SOURCE_BUILD("must out of source dir")

#if (NOT DEV_MODE AND ${PROJECT_VERSION} MATCHES "0.0.0")
#    conda_error("PROJECT_VERSION must be set in file project_profile or set -DDEV_MODE=true for develop debug")
#endif()


set(CMAKE_CXX_FLAGS_DEBUG "-g3 -O0")
set(CMAKE_CXX_FLAGS_RELEASE "-O2")


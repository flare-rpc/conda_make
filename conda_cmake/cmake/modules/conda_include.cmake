
include(conda_variable)

MACRO(conda_include_list result)
    foreach(arg IN LISTS ${result})
        list(APPEND CONDA_INCLUDE_DIRS ${arg})
        conda_print(${CONDA_INCLUDE_DIRS})
        include_directories(${arg})
    endforeach()
ENDMACRO()

MACRO(conda_include arg1)
    include_directories(${arg1})
    list(APPEND CONDA_INCLUDE_DIRS ${arg1})
    foreach(arg ${ARGN})
        list(APPEND CONDA_INCLUDE_DIRS ${arg})
        include_directories(${arg})
    endforeach()
    conda_print(${CONDA_INCLUDE_DIRS})
ENDMACRO()
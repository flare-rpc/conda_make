

include(conda_print)
include(conda_color)
MACRO(conda_directory_list result curdir)
    FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
    SET(dirlist "")
    FOREACH(child ${children})
        IF(IS_DIRECTORY ${curdir}/${child} )
            LIST(APPEND dirlist ${child})
        ENDIF()
    ENDFOREACH()
    SET(${result} ${dirlist})
ENDMACRO()

MACRO(conda_print_list result)
    foreach(arg IN LISTS ${result})
        message(" - ${conda_cyan}${arg}${conda_colour_reset}")
    endforeach()
ENDMACRO()


MACRO(conda_print_list_label Label ListVar)
    message("${conda_yellow}${Label}${conda_colour_reset}:")
    conda_print_list(${ListVar})
ENDMACRO()




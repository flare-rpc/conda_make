
if (NOT WIN32)
    string(ASCII 27 Esc)
    set(conda_colour_reset   "${Esc}[m")
    set(conda_colour_bold    "${Esc}[1m")
    set(conda_red            "${Esc}[31m")
    set(conda_green          "${Esc}[32m")
    set(conda_yellow         "${Esc}[33m")
    set(conda_blue           "${Esc}[34m")
    set(conda_agenta         "${Esc}[35m")
    set(conda_cyan           "${Esc}[36m")
    set(conda_white          "${Esc}[37m")
    set(conda_bold_red       "${Esc}[1;31m")
    set(conda_bold_green     "${Esc}[1;32m")
    set(conda_bold_yellow    "${Esc}[1;33m")
    set(conda_bold_blue      "${Esc}[1;34m")
    set(conda_bold_magenta   "${Esc}[1;35m")
    set(conda_bold_cyan      "${Esc}[1;36m")
    set(conda_bold_white     "${Esc}[1;37m")
endif ()

include(CMakeParseArguments)
include(conda_config_cxx_opts)
include(conda_install_dirs)


function(conda_check_target my_target)
    if(NOT TARGET ${my_target})
        message(FATAL_ERROR " CARBIN: compiling ${PROJECT_NAME} requires a ${my_target} CMake target in your project,
                   see CMake/README.md for more details")
    endif(NOT TARGET ${my_target})
endfunction()
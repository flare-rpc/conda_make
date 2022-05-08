

include(conda_print)
include(conda_platform)

set(CONDA_GENERATOR "TGZ")

conda_print("on platform ${CMAKE_HOST_SYSTEM_NAME} package type tgz")

string(TOLOWER ${CMAKE_HOST_SYSTEM_NAME} HOST_SYSTEM_NAME)

if(SYSTEM_NAME MATCHES "centos")
    set(CONDA_GENERATOR "TGZ;RPM")
    include(conda_package_rpm)
    string(REGEX MATCH "([0-9])" ELV "${LINUX_VER}")
    set(HOST_SYSTEM_NAME el${CMAKE_MATCH_1})
elseif(SYSTEM_NAME MATCHES "rhel")
    set(CONDA_GENERATOR "TGZ;RPM")
    include(conda_package_rpm)
    string(REGEX MATCH "([0-9])" ELV "${LINUX_VER}")
    set(HOST_SYSTEM_NAME el${CMAKE_MATCH_1})
endif()

################################################################################
# Copyright (C) 2019-2020 GSI Helmholtzzentrum fuer Schwerionenforschung GmbH  #
#                                                                              #
#              This software is distributed under the terms of the             #
#              GNU Lesser General Public Licence (LGPL) version 3,             #
#                  copied verbatim in the file "LICENSE"                       #
################################################################################
if(CMAKE_BINARY_DIR STREQUAL CMAKE_SOURCE_DIR)
  message(FATAL_ERROR "In-source builds are not supported.")
endif()

cmake_minimum_required(VERSION 3.0 FATAL_ERROR)
cmake_policy(VERSION 3.0...3.16)

project(FairSoft LANGUAGES C CXX Fortran)

# Update spack submodule
find_package(Git)
if(GIT_FOUND)
  execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
endif()

# Test #######################################################################
include(CTest)

if (DEFINED FS_TEST_WORKDIR AND NOT "${FS_TEST_WORKDIR}" STREQUAL "")
    message(STATUS "FS_TEST_WORKDIR: ${FS_TEST_WORKDIR}")
    if (EXISTS "${FS_TEST_WORKDIR}" AND IS_DIRECTORY "${FS_TEST_WORKDIR}")
        # Everything fine.
    else()
        message(FATAL_ERROR "If you set FS_TEST_WORKDIR, make sure, "
                "it is a directory")
    endif()
else()
    set(FS_TEST_WORKDIR "${CMAKE_BINARY_DIR}/fairsoft_ctest")
    file(MAKE_DIRECTORY "${FS_TEST_WORKDIR}")
    message(STATUS "Created directory for test run: ${FS_TEST_WORKDIR}")
endif()

macro(fs_test_might_fail testname)
  # If the test fails with exit code 1, mark it as skipped.
  # Not exactly, what we want, but hopefully better.
  set_property(TEST ${testname} APPEND PROPERTY
               SKIP_RETURN_CODE 1)
endmacro()
function(fs_test_props_base testname)
  set_property(TEST ${testname} APPEND PROPERTY ENVIRONMENT
               TARGETDIR=${FS_TEST_WORKDIR})
  set_property(TEST ${testname} APPEND PROPERTY ENVIRONMENT
               CMAKE_BINARY_DIR=${CMAKE_BINARY_DIR})
endfunction()
function(fs_test_props testname)
  fs_test_props_base(${testname})
  set_property(TEST ${testname} APPEND PROPERTY
               FIXTURES_REQUIRED fixture.main)
  set_property(TEST ${testname} APPEND PROPERTY
               TIMEOUT 10800)
endfunction()
function(fs_test)
  cmake_parse_arguments(ARGS "MIGHT_FAIL" "NAME;ENV;SPEC;POST" "" ${ARGN})
  if(ARGS_ENV)
    set(type env)
    set(what ${ARGS_ENV}/spack.yaml)
  elseif(ARGS_SPEC)
    set(type spec)
    set(what ${ARGS_SPEC})
  endif()
  add_test(NAME ${ARGS_NAME}
           COMMAND test/build${type}.sh ${what} ${ARGS_POST}
           WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
  fs_test_props(${ARGS_NAME})
  if(ARGS_MIGHT_FAIL)
    fs_test_might_fail(${ARGS_NAME})
  endif()
endfunction()


# Test setup
# ----------

add_test(NAME test.start
         COMMAND test/buildstart.sh
         WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
fs_test_props_base(test.start)
set_property(TEST test.start APPEND PROPERTY
             FIXTURES_SETUP fixture.main)


# Main tests
# ----------

fs_test(NAME test.fairroot_develop    ENV test/env/fairroot_develop)

# Test cleanup
# ------------

add_test(NAME test.cleanup
         COMMAND test/buildcleanup.sh
         WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
fs_test_props_base(test.cleanup)
set_property(TEST test.cleanup APPEND PROPERTY
             FIXTURES_CLEANUP fixture.main)

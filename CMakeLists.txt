#[[
    This file launches a suite for end-to-end testing of programs which link to the
    libCellML library.  It assumes a structure as below:
    
    Provided files:

        CMakeLists.txt
        tests/
            colours.cmake
            compare_output.cmake
            make_all_tests.cmake
            run_all_tests.cmake

    Template files: Edit the templates provided for each group of tests.

        tests/
            test_example.cmake:         For each group of tests, the user must supply a .cmake file
                                        based upon the test_example.cmake file provided.  Add each file
                                        to the TEST_LIST below.
            example/                    A directory for group of tests.
                first_test_example/     For each test, supply a directory whose name duplicates the 
                                        directory that the program to be tested is in.
                    test.cmake          This file defines which outputs are to be tested and the executable 
                                        to run.
                    (other)             All exemplar files should be put into this directory too. 

    After using the template files provided, and filling in the TEST_LIST below, use these commands
    to run the test suite.

    Create a build directory and change into it.
    From that directory, enter the commands below to use this directory to create and run the tests.

    cmake -DINSTALL_PREFIX=relative/path/to/libcellml/installation -S path/to/the/tests/directory -B .
    make -j
    make -j test

    Once the tests have been built and run, the results will be written to the terminal.  If any tests
    fail, a file called test_report.diff can be found in this build directory which will detail where
    differences have been found between the exemplar files and those created when the tested executables
    were run.

]]

# Use the TEST_LIST to specify a .cmake file for each of the groups of tests to run.
# Each of the files listed should exist in the tests/ directory.
set(TEST_LIST 
    test_example.cmake
)

# ----------------- DO NOT CHANGE ANYTHING BELOW THIS LINE -----------------------

cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0007 NEW)

set(INSTALL_PREFIX "" CACHE PATH "Please enter the path to the libCellML install directory using the syntax -DINSTALL_PREFIX=your_path")
set(TEST_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/tests")

# General setup stuff
set(COMPARE_SCRIPT "compare_output.cmake")
include(tests/colours.cmake)

# Copy cmake scripts into the temp directory
file(GLOB transit 
    "${TEST_ROOT}/*.cmake"
)
file(COPY ${transit} DESTINATION ${CMAKE_BINARY_DIR})

# Make the tests.  Tests listed here should follow the template
# in these files.
foreach(t ${TEST_LIST})
    set(REBUILD ON)
    include("${TEST_ROOT}/${t}")
endforeach()

set(REBUILD OFF)

# Run "make test" to run all the tests.
add_custom_target(test
    COMMAND ${CMAKE_COMMAND} 
        -DTEST_LIST="${TEST_LIST}"
        -DTEST_ROOT=${TEST_ROOT}
        -DCOMPARE_SCRIPT=${COMPARE_SCRIPT}
        -P run_all_tests.cmake
)

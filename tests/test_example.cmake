#[[ 

    This file allows you to set all of the options needed to configure 
    the end-to-end testing specifically for your tests.  

]]

# Set the name of this group of tests.  This will be used as the folder
# name inside the current source directory to look for tests, as well
# as the place where they'll end up in the temporary build directory.
set(TEST_GROUP_NAME "example")

# Make a list of the files that need to be built and run. 
# The testing structure will interpret the highest directory specified
# as the TEST_DIR variable (eg: "first_test_example" below). 
# For each entry in the SRC_CPP list there must be a corresponding directory
# in the TEST_GROUP_NAME directory with:
#  - the TEST_DIR name, and
#  - containing a test.cmake file.
# NOTE: There can be no spaces in the directories and test names!

set(SRC_CPP 
    first_test_example/example1.cpp  # This implies there is a folder "example/first_test_example" containing
                                     # "test.cmake" in this directory, and that there is a file called "example1.cpp"
                                     # in the ${CMAKE_CURRENT_SOURCE_DIR}/example/first_test_example directory.
    second_test_example/example2.cpp # This implies there is a folder "example/second_test_example" containing "test.cmake" in this directory.
)

# If you need extra source files to include in all builds they can 
# be specified here.  These should be common for all files to be tested
# in the list above.
set(EXTRA_CPP 
    "${CMAKE_CURRENT_SOURCE_DIR}/utilities/utilities.cpp"
)

# Set the path(s) to any header files that are needed.
set(EXTRA_H 
    "${CMAKE_CURRENT_SOURCE_DIR}/utilities/utilities.h"
)

# These are the defaults. They can be changed.
set(ORIG_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/example_source")
set(WORKING_PATH "${CMAKE_BINARY_DIR}/${TEST_GROUP_NAME}")
set(EXPECTED_OUTPUT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/tests/${TEST_GROUP_NAME}")

# ------------------ DO NOT CHANGE ANYTHING BELOW THIS LINE ---------------------------
if(REBUILD)
    include(tests/make_all_tests.cmake)
endif()

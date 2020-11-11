#[[
    A copy of this script should be put into each folder along with the exemplar 
    output files against which the test will be run.  

    Set both the name of the test executable(the 'test_exe') and the output file names below.
    Make sure that each file (including the 'stdout' file, if comparison is desired) exists
    in this directory too.
]]

set(output_files 
    # List the names of any output files here.  The entry 'stdout' is used to compare the terminal output.
    stdout
)
set(test_exe example2)


# -------------------------- DO NOT CHANGE ANYTHING BELOW THIS LINE -------------------------------

# Run the processes launch this executable and compare the files.
execute_process(COMMAND ${CMAKE_COMMAND}
        -DWORKING_PATH=${WORKING_PATH} 
        -DEXPECTED_OUTPUT_PATH=${EXPECTED_OUTPUT_PATH}
        -DTEST_DIR=${TEST_DIR}
        -DTEST_EXE=${test_exe}
        "-DFILES=${output_files}"  # The quotes are needed in order to pass a list.
        -P ${COMPARE_SCRIPT}
    )

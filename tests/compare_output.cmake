#[[    
    This script is used to compare the results from comparing the files specified 
    in each test.cmake file with those output from running the program to be tested.

    It expects command line inputs:
        TEST_DIR the directory name containing the test.
        FILES a list of files to test (NB: the file names must not contain spaces).
        WORKING_PATH the path to the current working directory.
        EXPECTED_OUTPUT_PATH the root path to where expected file exemplars are.
        TEST_EXE the program to run to test.

    YOU SHOULD NOT NEED TO EDIT THIS FILE.
]]

include(colours.cmake)

get_filename_component(abs ${WORKING_PATH} ABSOLUTE)

set(test_dir "${abs}/${TEST_DIR}")
set(expected_dir "${EXPECTED_OUTPUT_PATH}/${TEST_DIR}")
set(executable "./${TEST_EXE}")

message("${Green}[ RUN      ]${ColourReset} ${TEST_DIR}.${TEST_EXE}")

set(all_logs "${test_dir}/logs/${TEST_DIR}_report.txt")

# Run the executable and collect the stdout in 'stdout'.
execute_process(
    COMMAND ${executable} 
    OUTPUT_FILE stdout
    WORKING_DIRECTORY "${test_dir}/"
)

# Compare any files in the output_files list.
set(error_count 0)
file(WRITE ${all_logs} "")

foreach(file_name ${FILES})

    set(log "${test_dir}/logs/${file_name}.diff")
    set(expected "${expected_dir}/${file_name}")
    set(testfile "${test_dir}/${file_name}")

    file(REMOVE ${log})

    # Check that the files to compare exist:
    if(NOT EXISTS "${expected}")
        message("       ${Magenta}ERROR! Could not open expected output file: ${expected}${ColourReset}")
        file(APPEND ${all_logs} 
                    "ERROR: Could not open expected output file: ${expected}\n"
                )
                math(EXPR error_count "${error_count}+1")
    elseif(NOT EXISTS "${testfile}")
        message("       ${Magenta}ERROR! Could not open test output file: ${testfile}${ColourReset}")
        file(APPEND ${all_logs} 
            "ERROR: Could not open expected output file: ${testfile}\n"
        )
        math(EXPR error_count "${error_count}+1")
    else()

        execute_process(COMMAND diff -u -E ${expected} ${testfile} OUTPUT_FILE ${log})

        # Test log file contents.  If the log file is empty then the test has passed.
        file(READ ${log} errors)

        if("${errors}" STREQUAL "")
            file(REMOVE ${log})
        else()
            file(APPEND ${all_logs} 
                    "ERROR: ${file_name}\n"
                )
            file(APPEND ${all_logs} 
                "${errors}"
            )
            file(APPEND ${all_logs} "\n")
            math(EXPR error_count "${error_count}+1")
            message("                ERROR: ${file_name} does not match exemplar.")
        endif()

    endif()

endforeach()

if(${error_count} GREATER 0)
    message("${Magenta}[  FAILED  ]${ColourReset} ${TEST_DIR}.${TEST_EXE}")
else()
    file(APPEND ${all_logs}
            "All tests passed successfully."
        )
    message("${Green}[       OK ]${ColourReset} ${TEST_DIR}.${TEST_EXE}")
endif()

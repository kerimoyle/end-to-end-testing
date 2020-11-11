#[[

    This script is used to create the testing structure and trigger the
    building and linking of the programs for testing. 

    Creating the structure involves making a local testing copy of the
    program and related resources for building and running.  
    Starting from a single *.cpp file specified in the SRC_CPP list 
    (which is passed from each instance of the test_template.cmake files),
    we extract two pieces of information:
        - the containing directory (saved as $src_path)
        - the main file to run (saved as $src) 
    
    Within the $src_path directory, we assume that all files specific to this 
    test can be located using these patterns:
        - $src_path/*.cpp
        - $src_path/*.h
        - $src_path/*.c
        - $src_path/*.cellml
        - $src_path/resources/*.cpp
        - $src_path/resources/*.h
        - $src_path/resources/*.c
        - $src_path/resources/*.cellml
    You can chance these patterns below, but YOU SHOULD NOT NEED TO EDIT ANYTHING ELSE IN THIS FILE.

    NOTE: To include general utility files needed by all tests in each group, please
    see the instructions in the "test_example.cmake" file.

]]


# ----------------- DO NOT CHANGE THIS SECTION ----------------------

get_filename_component(TESTS_PATH ${EXPECTED_OUTPUT_PATH} ABSOLUTE)

file(MAKE_DIRECTORY ${WORKING_PATH})

foreach(file ${EXTRA_CPP})
    file(COPY ${file} DESTINATION ${WORKING_PATH})
endforeach()
foreach(file ${EXTRA_H})
    file(COPY ${file} DESTINATION ${WORKING_PATH})
endforeach()

# Process each source.
foreach(s ${SRC_CPP})

    # Set the source file.
    set(src "${ORIG_SRC_DIR}/${s}")

    # Getting the name of the containing folder so that the structure can be retained.
    get_filename_component(src_file "${src}" NAME)
    get_filename_component(src_path "${src}" DIRECTORY)

    # The name of the test is the name of the soruce file sans extension.
    get_filename_component(test_name "${src}" NAME_WE)

    # The name of the test_dir is the directory containing this source file to test.
    get_filename_component(a_second_dir "${src}/.." ABSOLUTE)
    get_filename_component(test_dir "${a_second_dir}" NAME)

    # Duplicating the structure to the temporary testing directories.
    file(MAKE_DIRECTORY "${WORKING_PATH}/${test_dir}")

    # Retrieve tutorial source and expected output from list, and copy to testing directories.
    if(EXISTS "${src}")
        message(STATUS "Processing ${src}")

        # Copy all code and resources into the local test folder.
        file(GLOB transit 
            "${src_path}/*.cpp"
            "${src_path}/*.c"
            "${src_path}/*.h"
            "${src_path}/*.cellml"
        )
        file(COPY ${transit} DESTINATION "${WORKING_PATH}/${test_dir}/")

        file(GLOB transit 
        "${src_path}/resources/*.cpp"
        "${src_path}/resources/*.c"
        "${src_path}/resources/*.h"
        "${src_path}/resources/*.cellml"
        )
        file(COPY ${transit} DESTINATION "${WORKING_PATH}/${test_dir}/resources/")
        
        # Build this source code into an executable.
        set(project_name "${test_name}")
        project(${project_name} VERSION 0.1.0)
        set(libCellML_DIR "${INSTALL_PREFIX}/lib/cmake/libCellML")
        find_package(libCellML REQUIRED)

        set(project_src
                "${WORKING_PATH}/${test_dir}/${src_file}"
                ${EXTRA_CPP}
            )
        include_directories("${WORKING_PATH}")

        add_executable(${project_name} ${project_src})
        set_target_properties(${project_name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${WORKING_PATH}/${test_dir}")
        target_link_libraries(${project_name} PUBLIC cellml)

    else()
        message(WARNING "${Magenta}Can't find ${src} ${ColourReset}")
    endif()

endforeach()
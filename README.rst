# end-to-end-testing
This repository contains a template for an end-to-end testing framework for simple projects.
It's intended to be used with libCellML.

Requirements
------------

- CMake (minimum 3.12, see https://cmake.org/);
- C++ tool chain; and
- libCellML installation (see https://github.com/cellml/libcellml).

Setup
-----
Clone this repository into your computer.
This will create a directory containing:

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
                                    to the `TEST_LIST` below.
        example/                    A directory for each group of tests.
            first_test_example/     For each test, supply a directory whose name duplicates the 
                                    directory that the program to be tested is in.
                test.cmake          This file defines which outputs are to be tested and the executable 
                                    to run.
                (other)             All exemplar files should be put into this directory too. 

After using the template files provided, and filling in the `TEST_LIST` below, use these commands to run the test suite.

Create a build directory and change into it.
From that directory, enter the commands below to use this directory to create and run the tests.

First we create the testing structure and populate it with the correct files:

.. code-block:: terminal

    cmake -DINSTALL_PREFIX=relative/path/to/libcellml/installation -S path/to/the/tests/directory -B .

Next, we build the test copies of each of the executables which are to be tested:

.. code-block:: terminal

    make -j

Finally, we run the test framework to compare the output from each test executable with the exemplars provided:

.. code-block:: terminal

    make -j test

Once the tests have been built and run, the results will be written to the terminal.
If any tests fail, a file called `test_report.diff` can be found in this build directory which will detail where differences have been found between the exemplar files and those created when the tested executables were run.
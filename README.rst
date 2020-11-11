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

.. code-block:: text 

    CMakeLists.txt
    tests/
        colours.cmake
        compare_output.cmake
        make_all_tests.cmake
        run_all_tests.cmake

Template files: Edit the templates provided for each group of tests.

.. code-block:: text 

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

Run the example tests
---------------------
Create a new directory and change into it.
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

**NOTE** the example above has been deliberately set up so that the second test will fail, in order that the test report file is created and you can see what it looks like.

Test your own programs
----------------------
1) For each group of tests you'll need your own copy (renamed as appropriate) of:

   a) `tests/test_example.cmake` This contains options about your build and your tests.
   b) `tests/example` For each group of tests you'll need to create an appropriately named directory inside the testing structure.
   c) `tests/example/first_test_example` For each test in the group, you need a directory whose name reflects the directory in which the program to be tested can be found.  
     For example, here we have two test directories: `first_test_example` and `second_test_example`.
     In the source location (`example_source` in this case) are also two directories named `first_test_example` and `second_test_example`.
   d) `example_source` Your own directory in which the programs to be tested can be found for this group.

   Once you've created the structure appropriate for your tests, you need to edit the configuration files to tell the testing where to look.  

2) Open the `CMakeLists.txt` file for editing.
   You will need to alter the `TEST_LISTS` in this file to include your own name(s) instead of the `test_example.cmake` file that's in the template.

3) Open your version of the `tests/test_example.cmake` file for editing.
   You will find instructions in that file for what the variables mean.
   Change them to reflect your structure.

4) For each of the tests you want to run, copy the `tests/example/first_test_example/test.cmake` file into each of the directories you created in step 1b.
   Each of these should be edited to provide:
   
   a) The name of the executable.
      Note that this should be the name of the *.cpp file containing the `main()` function, without its extension.
   b) The names of any output files that should be compared.
      Note that this can also include a file called `stdout` which will collect any terminal output from running the executable.

5) In each of the directories containing `test.cmake` files (that you edited in step 4), make sure that you've also provided the exemplar files to test against.  
   These files must have the same names as those listed in step 4b.
   In the `first_test_example` we've used the `stdout` file to capture the terminal output.

6) Create a temporary directory to house the testing files and results.
   Navigate into this directory and open a terminal there. 
   Repeat the steps in the example testing section above, but using your own test structure instead.

   .. code-block:: terminal

        cmake -DINSTALL_PREFIX=relative/path/to/libcellml/installation -S path/to/the/tests/directory -B .
        make -j
        make -j test

7) If everything has worked and all tests have passed, you will see the green `[  PASSED  ] Tests complete.` printed to the terminal.
   If everything has worked and some tests have failed, these will be listed in pink, and a file named `test_report.diff` will have been created detailing the differences found between your exemplar files and those produced by running the executables.  
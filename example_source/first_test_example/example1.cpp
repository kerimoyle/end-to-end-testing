#include <iostream>

#include <libcellml>

#include "utilities.h"

int main()
{
    std::cout << "Hello end-to-end testing world!" << std::endl;

    // This is defined in one of the external dependency files, specified in the EXTRA_CPP and EXTRA_H
    // files in the tests/test_example.cmake file.
    areExtraFilesIncluded();
}
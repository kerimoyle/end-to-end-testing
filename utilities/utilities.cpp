
/**
 *  This is an example file to be included in the testing structure as an external dependency.
 *  It is specified in the tests/test_example.cmake file under the variable EXTRA_CPP.
 */

#include <iostream>

#include "utilities.h"

void areExtraFilesIncluded()
{
    std::cout << "You've included me - huzzah!" << std::endl;
}

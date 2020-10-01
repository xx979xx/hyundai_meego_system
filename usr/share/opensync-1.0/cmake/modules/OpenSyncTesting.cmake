ENABLE_TESTING()
INCLUDE( CTest )

SET( CMAKE_C_FLAGS_PROFILING "-g -O0 -Wall -W -Wshadow -Wunused-variable -Wunused-parameter -Wunused-function -Wunused -Wno-system-headers -Wwrite-strings -fprofile-arcs -ftest-coverage" CACHE STRING "Profiling Compiler Flags" ) 
SET( CMAKE_SHARED_LINKER_FLAGS_PROFILING " -fprofile-arcs -ftest-coverage" CACHE STRING "Profiling Linker Flags" )
SET( CMAKE_MODULE_LINKER_FLAGS_PROFILING " -fprofile-arcs -ftest-coverage" CACHE STRING "Profiling Linker Flags" )
SET( CMAKE_EXEC_LINKER_FLAGS_PROFILING " -fprofile-arcs -ftest-coverage" CACHE STRING "Profiling Linker Flags" )

MACRO( OPENSYNC_ADD_TEST _testName _testSource ) 

  ADD_EXECUTABLE( ${_testName} ${_testSource} )
  TARGET_LINK_LIBRARIES( ${_testName} ${ARGN} )
  ADD_TEST( ${_testName} ${CMAKE_CURRENT_BINARY_DIR}/${_testName} )

ENDMACRO( OPENSYNC_ADD_TEST )

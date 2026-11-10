# Check if the system has the specified function; treat glibc "stub"
# functions as nonexistent:
# CHECK_FUNCTION_EXISTS_GLIBC (FUNCTION FUNCVAR)
#
#  FUNCTION - the function(s) where the prototype should be declared
#  FUNCVAR - variable to define if the function does exist
#
# In particular, this understands the glibc convention of
# defining macros __stub_XXXX or __stub___XXXX if the function
# does appear in the library but is merely a stub that does nothing.
# By detecting this case, we can select alternate behavior on
# platforms that don't support this functionality.
#
# The following variables may be set before calling this macro to
# modify the way the check is run:
#
#  CMAKE_REQUIRED_FLAGS = string of compile command line flags
#  CMAKE_REQUIRED_DEFINITIONS = list of macros to define (-DFOO=bar)
#  CMAKE_REQUIRED_INCLUDES = list of include directories
#  CMAKE_REQUIRED_LIBRARIES = list of libraries to link
#  CMAKE_REQUIRED_LINK_OPTIONS = list of linker options
#  CMAKE_REQUIRED_QUIET = suppress check messages
# Copyright (c) 2009, Michihiro NAKAJIMA
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

INCLUDE(CheckFunctionExists)
INCLUDE(CheckCSourceCompiles)

MACRO (CHECK_FUNCTION_EXISTS_GLIBC _FUNC _FUNCVAR)
  IF(NOT DEFINED ${_FUNCVAR})
    # Check for glibc stubs and link the function in the same probe.
    # limits.h and assert.h expose the stub macros without requiring a header
    # that declares the function.
    CHECK_C_SOURCE_COMPILES("
#ifdef __STDC__
#include <limits.h>
#else
#include <assert.h>
#endif
#if defined __stub_${_FUNC} || defined __stub___${_FUNC}
#error ${_FUNC} is a stub
#endif
#ifdef __cplusplus
extern \"C\"
#endif
char ${_FUNC}(void);
int main(void)
{
  return ${_FUNC}();
}
" ${_FUNCVAR})
  ENDIF(NOT DEFINED ${_FUNCVAR})
ENDMACRO (CHECK_FUNCTION_EXISTS_GLIBC)

#   Sample M4 file

AC_DEFUN([SAMPLE],[
AC_REQUIRE([ANOTHER_SAMPLE])
printf "$2" >> "$1"
])

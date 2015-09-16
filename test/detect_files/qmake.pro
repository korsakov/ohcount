CONFIG += qt debug
HEADERS += hello.h
SOURCES += hello.cpp
SOURCES += main.cpp
win32 {
	SOURCES += hellowin.cpp
}
unix {
	SOURCES += hellounix.cpp
}
!exists( main.cpp ) {
	error( "No main.cpp file found" )
}
win32:debug {
	CONFIG += console
}

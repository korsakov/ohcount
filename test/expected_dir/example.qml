qml	comment	// Just an example of QML file...
qml	blank	
qml	code	import QtQuick 2.0
qml	blank	
qml	code	Rectangle {
qml	code	    width: 200
qml	code	    height: 200
qml	code	    color: "crimson"
qml	blank	
qml	code	    MouseArea {
qml	code	        anchors.fill: parent
qml	code	        onClicked: {
qml	comment	            // Was clicked
qml	code	            Qt.quit();
qml	code	        }
qml	code	    }
qml	code	}

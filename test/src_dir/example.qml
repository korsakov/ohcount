// Just an example of QML file...

import QtQuick 2.0

Rectangle {
    width: 200
    height: 200
    color: "crimson"

    MouseArea {
        anchors.fill: parent
        onClicked: {
            // Was clicked
            Qt.quit();
        }
    }
}

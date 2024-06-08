import QtQuick
import "sidebar/left" 1.0

Window {
    id: root
    visible: true
    width: 750
    height: 750
    title: qsTr("Effortless")

    SidebarLeft {
        id: sidebarLeft
        anchors {left: parent.left; top: parent.top; bottom: parent.bottom}
    }

    Rectangle {
        id: _
        height: 50
        color: "blue"
        anchors {left: sidebarLeft.right; top: parent.top; right: parent.right}
    }
}

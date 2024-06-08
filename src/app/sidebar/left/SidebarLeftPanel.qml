import QtQuick
import QtQuick.Controls

Item {
    property alias text: label.text
    property string iconName: icon.name

    width: column.width
    height: 50

    Icon {
        id: icon

        anchors {left: parent.left; top: parent.top; bottom: parent.bottom}

        size: 50
        name: iconName
    }

    Label {
        id: label

        visible: sidebarLeft.width > 75

        verticalAlignment: Text.AlignVCenter
        anchors {left: icon.right; right: parent.right}
        height: parent.height

        font.pixelSize: 20
        elide: Text.ElideRight

        color: "black"
    }
}

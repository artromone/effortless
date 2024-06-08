import QtQuick
import QtQuick.Controls

Item {
    property alias text: label.text
    property alias color: label.color
    property string iconName: icon.name

    Icon {
        id: icon

        anchors {left: parent.left; top: parent.top; bottom: parent.bottom}

        size: 50
        name: iconName
    }

    Label {
        id: label

        verticalAlignment: Text.AlignVCenter
        anchors {left: icon.right; right: parent.right}
        height: parent.height

        font.pixelSize: 20
        elide: Text.ElideRight

        background: Rectangle {
            color: "gray"
            anchors.fill: parent
        }
    }
}

import QtQuick
import QtQuick.Controls

Rectangle {
    id: sidebarLeft
    width: 200
    color: "white"

    Label {
        id: accountLabel
        anchors {left: parent.left; top: parent.top; right: parent.right}
        width: column.width
        height: 50

        color: "white"
        background: Rectangle {color:"gray"; anchors.fill: parent}
        text: "Account"
    }

    Column {
        id: column
        anchors {left: parent.left; top: accountLabel.bottom; right: parent.right}
        anchors.topMargin: 16
        spacing: 8

        // Icon {
        //     source: "icons/account_black.svg"

        //     anchors.fill: parent
        //     sourceSize.width: button.width
        //     sourceSize.height: button.height
        // }

        Label {
            width: column.width
            height: 50

            color: "white"
            background: Rectangle {color:"gray"; anchors.fill: parent}
            text: "TASKS"
        }

        Label {
            width: column.width
            height: 50

            color: "white"
            background: Rectangle {color:"gray"; anchors.fill: parent}
            text: "LABELS"
        }
    }

    property bool isDragging: false

    MouseArea {
        id: mouseArea
        hoverEnabled: true

        property real resizeHandleSize: 2.5
        property real mouseXPrev

        Rectangle {anchors.fill: parent; color: "black"}

        width: resizeHandleSize
        anchors {right: parent.right; top: parent.top; bottom: parent.bottom}

        onHoveredChanged: {
            if (containsMouse)
            {
                width = resizeHandleSize * 3
                sidebarLeft.width += resizeHandleSize
            }
            else
            {
                width = resizeHandleSize
                sidebarLeft.width -= resizeHandleSize
            }
        }

        onPressed: {
            mouseXPrev = mouseX;

            sidebarLeft.isDragging = true;
        }
        onReleased: sidebarLeft.isDragging = false;

        onPositionChanged: {
            if (sidebarLeft.isDragging) {

                width = resizeHandleSize * 3
                sidebarLeft.width += resizeHandleSize

                var deltaX = mouseX - mouseXPrev;

                var newWidth = sidebarLeft.width + deltaX;
                if (newWidth < 75)
                {
                    newWidth = 75;
                }
                else if (newWidth > root.width / 4)
                {
                    newWidth = root.width / 4
                }
                sidebarLeft.width = newWidth;
            }
        }
    }
}

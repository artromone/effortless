import QtQuick

Rectangle {
    id: sidebarLeft
    width: 200
    color: "white"

    SidebarLeftPanel {
        id: accountLabel
        anchors {left: parent.left; top: parent.top}

        iconName: "account_black"
        text: "ACCOUNT"
    }

    Column {
        id: column
        anchors {left: parent.left; top: accountLabel.bottom; right: parent.right}
        anchors.topMargin: 25
        spacing: 10

        SidebarLeftPanel {
            width: column.width
            height: 50

            iconName: "tasks_black"
            text: "TASKS"
        }

        SidebarLeftPanel {
            width: column.width
            height: 50

            iconName: "label_black"
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
                if (newWidth < 55)
                {
                    newWidth = 55;
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

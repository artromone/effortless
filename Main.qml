import QtQuick

Window {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Effortless")

    Rectangle {
        id: rect
        width: 200; height: 200
        color: "white"
        anchors {left: parent.left; top: parent.top; bottom: parent.bottom}

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
                    rect.width += resizeHandleSize
                }
                else
                {
                    width = resizeHandleSize
                    rect.width -= resizeHandleSize
                }
            }

            onPressed: {
                mouseXPrev = mouseX;

                rect.isDragging = true;
            }
            onReleased: rect.isDragging = false;

            onPositionChanged: {
                if (rect.isDragging) {

                    width = resizeHandleSize * 3
                    rect.width += resizeHandleSize

                    var deltaX = mouseX - mouseXPrev;

                    var newWidth = rect.width + deltaX;
                    if (newWidth < 75)
                    {
                        newWidth = 75;
                    }
                    else if (newWidth > root.width / 4)
                    {
                        newWidth = root.width / 4
                    }
                    rect.width = newWidth;
                }
            }
        }

        Component.onCompleted: {
            console.log("Component loaded");
        }
    }
}

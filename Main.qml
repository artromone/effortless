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

            property real mouseXPrev

            Rectangle {anchors.fill: parent; color: "black"}

            width: 5
            anchors {right: parent.right; top: parent.top; bottom: parent.bottom}

            onHoveredChanged: {
                if (containsMouse)
                {
                    width = 15
                    rect.width += 5
                }
                else
                {
                    width = 5
                    rect.width -= 5
                }
            }

            onPressed: {
                mouseXPrev = mouseX;
                rect.isDragging = true;
            }
            onReleased: rect.isDragging = false;

            onPositionChanged: {
                if (rect.isDragging) {
                    var deltaX = mouseX - mouseXPrev;

                    var newWidth = rect.width + deltaX;
                    if (newWidth < 20 || newWidth > root.width / 3)
                    {
                        return;
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

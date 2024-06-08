import QtQuick

Item {
    id: root

    height: 2000

    property color color_base: "#ffffff"
        property color color_accent: "#00ff00"
        property color color_hover: "#caffcf"
        property color color_press: "#74ff7f"

        signal changeIndex(var index_src, var index_dest)
        signal removeIndex(var index)

        onChangeIndex: {
            _model.move(index_src, index_dest, 1);
        }

        onRemoveIndex: {
            _model.remove(index);
        }

        ListView {
            id: view
            anchors.fill: parent
            anchors.margins: 20
            model: _model
            spacing: 10
            clip: true


            displaced: Transition {
                NumberAnimation {
                    properties: "x,y"
                    easing.type: Easing.OutQuad
                    duration: 200
                }
            }

            delegate: DroppableRect {
                id: rect

                height: 100
                width: view.width

                Text {
                    text: t
                    anchors.centerIn: parent
                    font.pixelSize: parent.height/4
                }

                onDropped: {
                    root.changeIndex(srcIndex, destIndex);
                }

                onDoubleClicked: {
                    root.deleteImageFromModel(index);
                }
            }

        }

        ListModel {
            id: _model

            ListElement {
                t: "Text 1"
            }

            ListElement {
                t: "Text 2"
            }

            ListElement {
                t: "Text 3"
            }
            ListElement {
                t: "Text 4"
            }
            ListElement {
                t: "Text 5"
            }
        }
}

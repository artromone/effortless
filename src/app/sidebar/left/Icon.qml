import QtQuick

Image {
    property string name
    property real size

    source: Qt.resolvedUrl("/icons/" + name + ".svg")

    sourceSize.width: size
    sourceSize.height: size
    fillMode: Image.PreserveAspectFit
}

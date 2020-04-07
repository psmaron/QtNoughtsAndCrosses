import QtQuick 2.0

Item {
    property alias circleOverlay: circleOverlay
    property alias crossOverlay: crossOverlay

    Image {
        id: cross
        source: 'resources/cross.svg'
        sourceSize: Qt.size(parent.width*0.8, parent.height*0.8)
        anchors.centerIn: parent
        smooth: true
        visible: false
    }

    ColorOverlay {
        id: crossOverlay
        source: cross
        anchors.fill: cross
        color: "#F6D55C"
        smooth: true
        visible: false
    }

    Image {
        id: circle
        source: 'resources/circle.svg'
        sourceSize: Qt.size(parent.width*0.8, parent.height*0.8)
        anchors.centerIn: parent
        smooth: true
        visible: false
    }

    ColorOverlay {
        id: circleOverlay
        objectName: "circleOverlay"
        source: circle
        anchors.fill: circle
        color: "#F6D55C"
        smooth: true
        visible: false
    }
}

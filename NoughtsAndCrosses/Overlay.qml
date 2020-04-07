import QtQuick 2.0
import QtQml 2.12

/*!
  After the game ends, either due to a draw or a winning configuration,
  dims the foreground and displays end game message
  After user presses the overlay itself, it disappears and sends signal
  to game board to start new round
  */

Rectangle {
    id: overlay
    color: "#55000000"
    visible: false

    signal overlayClicked()

    property string messageToShow: ""

    function showEndGameMessage(message) {
        messageToShow = message
        timer.start()
    }

    Timer {
        id: timer
        interval: 500; running: false; repeat: false
        onTriggered: {
            winningText.text = messageToShow
            overlay.visible = true
        }
    }

    Rectangle {
        height: parent.height/4
        width: parent.width
        color: "#88000000"
        anchors.verticalCenter: parent.verticalCenter

        MyText {
            id: winningText
            anchors.centerIn: parent
            text: "error"
            color: 'white'
            font.pointSize: parent.height/3 > 0 ? parent.height/3 : 1
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        propagateComposedEvents: false
        onClicked: {
            overlay.visible = false
            overlayClicked()
        }
    }
}

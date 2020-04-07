import QtQuick 2.12
import QtQuick.Window 2.2

/*!
  Game screen consists of couple of screen that interact with each other
  Game engine is implemented in GameBoard C++ backend
  UI tries to be responsive, but only to some degree
  */

Window {
    visible: true
    width: 640
    height: 480
    minimumHeight: 100
    minimumWidth: minimumHeight
    title: qsTr("Noughts and Crosses")

    property bool init: false
    property color bgColor: '#173F5F'

    onAfterRendering: { // wait until all items render and then send them data to display
        if (!init) {
            gameBoard.initBoard()
            init = true
        }
    }

    Connections {
        target: gameBoard
        onDoEndGameWithMessage: {
            overlay.showEndGameMessage(message)
        }
        onNextTurnForPlayer: {
            notificationsBar.updateWhichPlayerHasMove(playerId)
        }
        onDoUpdateStats: {
            playersScreen.updatePlayerStats(playersData)
        }
    }

    Connections {
        target: overlay
        onOverlayClicked: {
            gameBoard.clearBoard()
        }
    }

    Overlay {
        id: overlay
        z: 1
        anchors.fill: parent
    }

    Row {
        anchors.fill: parent

        Column {
            width: parent.width * 0.7
            height: parent.height

            NotificationsBar {
                id: notificationsBar
                height: parent.height * 0.1
                width: parent.width
                color: bgColor
            }

            GameBoard {
                id: gameBoard
                height: parent.height * 0.9
                width: parent.width
                color: bgColor
            }
        }

        PlayersScreen {
            id: playersScreen
            width: parent.width * 0.3
            height: parent.height
            color: bgColor
        }
    }

}

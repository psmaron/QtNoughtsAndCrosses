import GameBoard 1.0

import QtGraphicalEffects 1.0
import QtQuick 2.12

/*!
  A Grid with 9 squares that players press in order to place O or X symbol.
  Displays grid along with symbols and line that crosses winning combination.
  Sends signal about game progress to main window, so it can dispatch them
  to proper components. There's also 2-way communication with backend, which handles
  game's logic, in order to display game's status
  */

GameBoard {
    id: gameBoard

    property alias color: rect.color

    signal doEndGameWithMessage(string message)
    signal doNextTurnForPlayer(string playerId)
    signal doUpdateStats(var playersData)

    Connections {
        target: gameBoard
        onPutSymbol: doPutSymbol(squareIndex, mark)
        onEndGameWithMessage: doEndGameWithMessage(message)
        onNextTurnForPlayer: doNextTurnForPlayer(playerId)
        onUpdateStats: doUpdateStats(playersData)
        onMarkWinningLine: printWinningLine(winType)
    }

    function doPutSymbol(squareIndex, mark) {
        if (mark === 'o')
            boardGrid.children[squareIndex].circleMark.visible = true
        else if (mark === 'x')
            boardGrid.children[squareIndex].crossMark.visible = true
    }

    function clearBoard() {
        for (var i=0; i<9; i++) {
            boardGrid.children[i].circleMark.visible = false
            boardGrid.children[i].crossMark.visible = false
        }
        winningLine.visible = false
    }

    function printWinningLine(winType) { // could have used PathLine instead...
        if (winType >= 1 && winType <= 3) { // winning line is on 1st or 2nd or 3rd row
            winningLine.x = Qt.binding(function() { return winningLine.squareWidth/2 + boardGrid.spacing })
            winningLine.y = Qt.binding(function() { return winningLine.squareHeight/2 + boardGrid.spacing + (winType-1)*(winningLine.squareHeight+boardGrid.padding) })
            winningLine.endHeight = Qt.binding(function() { return winningLine.squareWidth*2 + 2*boardGrid.padding })
            winningLine.rotation = -90
        }
        if (winType >= 4 && winType <= 6) { // winning line is on 1st or 2nd or 3rd column
            winningLine.x = Qt.binding(function() { return winningLine.squareWidth/2 + boardGrid.spacing  + (winType-4)*(winningLine.squareWidth+boardGrid.padding) })
            winningLine.y = Qt.binding(function() { return winningLine.squareHeight/2 + boardGrid.spacing })
            winningLine.endHeight = Qt.binding(function() { return winningLine.squareHeight*2 + 2*boardGrid.padding })
            winningLine.rotation = 0
        }
        if (winType === 7) { // winning line is on 1st diagonal
            winningLine.x = Qt.binding(function() { return winningLine.squareWidth/2 + boardGrid.spacing })
            winningLine.y = Qt.binding(function() { return winningLine.squareHeight/2 + boardGrid.spacing })
            winningLine.endHeight = Qt.binding(function() { return (Math.sqrt(Math.pow(winningLine.squareWidth, 2) + Math.pow(winningLine.squareHeight, 2)) + boardGrid.padding)*2 })
            winningLine.rotation = Qt.binding(function() { return -Math.atan(winningLine.squareWidth/winningLine.squareHeight)*180/Math.PI })
        }
        if (winType === 8) { // winning line is on 2nd diagonal
            winningLine.x = Qt.binding(function() { return winningLine.squareWidth/2 + boardGrid.spacing + 2*(winningLine.squareWidth+boardGrid.padding)})
            winningLine.y = Qt.binding(function() { return winningLine.squareHeight/2 + boardGrid.spacing })
            winningLine.endHeight = Qt.binding(function() { return (Math.sqrt(Math.pow(winningLine.squareWidth, 2) + Math.pow(winningLine.squareHeight, 2)) + boardGrid.padding)*2 })
            winningLine.rotation = Qt.binding(function() { return Math.atan(winningLine.squareWidth/winningLine.squareHeight)*180/Math.PI })
        }
        winningLine.visible = true
    }

    Rectangle { // provide bg for component
        anchors.fill: parent
        id: rect
    }

    Rectangle { // drawn to cross symbols on a board after player has won
        id: winningLine
        property int squareHeight: boardGrid.children[0].height
        property int squareWidth: boardGrid.children[0].width
        property int endHeight: 0
        width: 15
        border.color: 'yellow'
        border.width: 1
        color: '#ED553B'
        transformOrigin: Item.TopLeft
        z: 1
        visible: false

        states: [
            State { when: winningLine.visible; PropertyChanges { target: winningLine; height: winningLine.endHeight}},
            State { when: !winningLine.visible; PropertyChanges { target: winningLine; height: 0}}
        ]
        transitions: [ Transition { NumberAnimation { property: "height"; duration: 500}}]
    }

    Grid {
        id: boardGrid
        anchors.fill: parent
        columns: 3; rows: columns
        padding: 8
        spacing: 6

        Repeater {
            model: 9

            Rectangle {
                id: boardSquare
                width: (parent.width-2*boardGrid.padding-2*boardGrid.spacing)/3
                height: (parent.height-2*boardGrid.padding-2*boardGrid.spacing)/3
                color: squareColor

                property alias circleMark: circleOverlay
                property alias crossMark: crossOverlay
                property color squareColor: '#20639B'
                property color symbolColor: "#F6D55C"

                MouseArea {
                    pressAndHoldInterval: 0
                    anchors.fill: parent
                    onPressAndHold: {
                        parent.x = parent.x+3
                        parent.y = parent.y+3
                        parent.color = '#4083BB'
                    }
                    onReleased: {
                        squarePressed(index)
                        parent.x = parent.x-3
                        parent.y = parent.y-3
                        parent.color = squareColor
                    }
                }

                Image {
                    id: crossIcon
                    source: 'resources/cross.svg'
                    sourceSize: Qt.size(parent.width*0.8, parent.height*0.8)
                    anchors.centerIn: parent
                    smooth: true
                    visible: false
                }

                ColorOverlay {
                    id: crossOverlay
                    source: crossIcon
                    anchors.fill: crossIcon
                    color: symbolColor
                    smooth: true
                    visible: false

                    states: [
                        State { when: crossOverlay.visible;
                                PropertyChanges { target: crossOverlay; opacity: 1.0 }},
                        State { when: !crossOverlay.visible;
                                PropertyChanges { target: crossOverlay; opacity: 0.0 }}
                    ]
                    transitions: [ Transition { NumberAnimation { property: "opacity"; duration: 250}} ]
                }

                Image {
                    id: circleIcon
                    source: 'resources/circle.svg'
                    sourceSize: Qt.size(parent.width*0.8, parent.height*0.8)
                    anchors.centerIn: parent
                    smooth: true
                    visible: false
                }

                ColorOverlay {
                    id: circleOverlay
                    objectName: "circleOverlay"
                    source: circleIcon
                    anchors.fill: circleIcon
                    color: symbolColor
                    smooth: true
                    visible: false

                    states: [
                        State { when: circleOverlay.visible;
                                PropertyChanges { target: circleOverlay; opacity: 1.0 }},
                        State { when: !circleOverlay.visible;
                                PropertyChanges { target: circleOverlay; opacity: 0.0 }}
                    ]
                    transitions: [ Transition { NumberAnimation { property: "opacity"; duration: 250}} ]
                }
            }
        }
    }
}

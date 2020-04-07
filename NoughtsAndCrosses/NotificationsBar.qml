import QtQuick 2.12

/*!
 Displays who's turn is it now
 */

Rectangle {
    property string player: "?"

    function updateWhichPlayerHasMove(symbol) {
        player = symbol
    }

    MyText {
        anchors.centerIn: parent
        text: "Player #" + player + "'s turn"
        color: "#ED553B"
        font.pointSize: parent.height/3 > 0 ? parent.height/3 : 1
    }
}

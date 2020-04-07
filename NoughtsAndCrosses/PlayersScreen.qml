import QtQuick 2.12

/*!
  Displays players statistics: wins, loses & draws
  Also displays which symbol they are currently playing with
  */

Rectangle {
    id: root

    function updatePlayerStats(playersData) {
        for (var i=0; i<2; i++) {
            col.children[i].children[1].children[0].text = "Symbol: <b><font color=\"#F6D55C\"/>" + playersData[0 + i*4]
            col.children[i].children[1].children[1].text = "Wins: <b>" + playersData[1 + i*4]
            col.children[i].children[1].children[2].text = "Loses: <b>" + playersData[2 + i*4]
            col.children[i].children[1].children[3].text = "Draws: <b>" + playersData[3 + i*4]
        }
    }

    Column {
        id: col
        anchors.fill: parent

        Repeater {
            model: 2

            Rectangle {
                id: playerData
                height: parent.height/2
                width: parent.width
                color: '#173F5F'

                MyText {
                    id: header
                    text: "Player #" + (+index + +1)
                }

                Column {
                    topPadding: header.height*1.5

                    Repeater {
                        model: 4

                        Text {
                            id: statsPlaceholder
                            width: header.width
                            color: 'white'
                            font.family: 'Segoe UI'
                            font.weight: Font.Medium
                            font.pointSize: header.height/3 > 0 ? header.height/3 : 1
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }
}

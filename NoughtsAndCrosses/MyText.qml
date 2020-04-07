import QtQuick 2.12

/*!
 Just a simple text used all over the place with some properties already set
*/

Text {
    text: "Whose turn is it"

    color: '#3CAEA3'
    topPadding: parent.height/50
    width: parent.width
    horizontalAlignment: Text.AlignHCenter
    elide: Text.ElideRight

    font.family: 'Segoe UI'
    font.bold: true
    font.pointSize: parent.height/15 > 0 ? parent.height/15 : 1
}

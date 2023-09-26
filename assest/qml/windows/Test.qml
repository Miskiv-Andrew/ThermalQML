import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts

Item {
    visible: true
    width: 600
    height: 300

    Rectangle {
        id: rectangleCoef
        radius: 10
        color: "#fafafa"
        anchors.fill: parent
        layer.enabled: true
        layer.effect: DropShadow {
            color: "#a0676767"
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 4
            radius: 4


        }

        Rectangle{
            id: content
            x: 10
            y: 10
            color: "#fafafa"
            anchors.fill: parent
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5

        }
    }
}

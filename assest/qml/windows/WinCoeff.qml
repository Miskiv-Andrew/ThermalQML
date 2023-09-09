import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

Item {
    visible: true
    width: 600
    height: 300

    Rectangle {
        id: rectangleCoef
        radius: 10
        color: "red"
        anchors.top: rectangleChart.bottom
        anchors.fill: parent
        layer.enabled: true
        layer.effect: DropShadow {
            color: "#a0676767"
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 4
            radius: 4

        }


        Rectangle {
            id: rectangle
            height: 50
            color: "#dcdcdc"
            radius: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0

            Switch {
                id: switchThermalCompOnOff
                x: 414
                text: qsTr("Термокомпенсація Вкл/Вмкн")
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 10
                anchors.bottomMargin: 10
                anchors.topMargin: 10
            }

            Button {
                id: buttonWriteThermalCoef
                width: 98
                text: qsTr("Зчитати")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.bottomMargin: 10
                anchors.topMargin: 10
            }

            Button {
                id: buttonReadThermalCoef
                width: 130
                text: qsTr("Зашити")
                anchors.left: buttonWriteThermalCoef.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.bottomMargin: 10
                anchors.topMargin: 10
            }
        }

        Rectangle {
            id: rectangleTableRange
            width: parent.width*0.7
            color: "#ffffff"
            anchors.left: parent.left
            anchors.top: rectangle.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0

            TableView{
                id: tableViewRange
                anchors.fill: parent
            }
        }

        Rectangle {
            id: rectangleTableCurrent
            x: 317
            width: parent.width*0.3
            color: "#ffffff"
            anchors.right: parent.right
            anchors.top: rectangle.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 0

            TableView{
                id: tableViewCurrent
                anchors.fill: parent
            }
        }


    }
}

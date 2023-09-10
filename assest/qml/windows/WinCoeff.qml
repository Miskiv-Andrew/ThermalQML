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
        color: "#fafafa"
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


            Rectangle {
                id: rectangle
                height: 50
                color: "#f0f0f0"
                radius: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                CheckBox {
                    id: checkThermalCompOnOff
                    x: 414
                    width: 170
                    height: 30
                    text: qsTr("Термокомпенсація")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    font.pointSize: 12
                    font.family: "Arial"
                    focusPolicy: Qt.ClickFocus
                    anchors.rightMargin: 10
                }

                Button {
                    id: buttonWriteThermalCoef
                    width: 100
                    height: 30
                    text: qsTr("Зчитати")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    font.family: "Arial"
                    font.pointSize: 12
                    anchors.leftMargin: 10
                }

                Button {
                    id: buttonReadThermalCoef
                    width: 100
                    height: 30
                    text: qsTr("Зашити")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: buttonWriteThermalCoef.right
                    font.family: "Arial"
                    font.pointSize: 12
                    anchors.leftMargin: 10
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
}

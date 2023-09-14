import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    Rectangle {
        id: bacground
        color: "#ffffff"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Rectangle {
            id: content
            color: "#cbcbcb"
            radius: 10
            anchors.fill: parent
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10

            Column {
                id: columnActionBtn
                width: parent.width/2 - 20
                height: parent.height
                topPadding: 10
                padding: 0
                spacing: 10


                Button {
                    id: buttonTurnOnFurnace
                    text: qsTr("Включити пічку")
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width-20
                    height: 50
                }

                Button {
                    id: buttonActivateFurnace
                    text: qsTr("Активувати пічку")
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width-20
                    height: 50
                }


                Button {
                    id: buttonSetTemperature
                    text: qsTr("Встановити температуру")
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width-20
                    height: 50
                }

                Button {
                    id: buttonGetCurrentTemperature
                    text: qsTr("Отримати температуру")
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width-20
                    height: 50
                }

                Button {
                    id: buttonDeactivateFurnace
                    text: qsTr("Деактивувати пічку")
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width-20
                    height: 50
                }

                Button {
                    id: buttonTurnOffFurnace
                    text: qsTr("Виключити пічку")
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width-20
                    height: 50
                }
            }

            Column {
                id: columnDataFurnace
                width: parent.width/2 - 20
                anchors.left: columnActionBtn.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                topPadding: 10
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                padding: 0
                spacing: 10

                TextField {
                    id: textFieldSetTemperature
                    placeholderText: qsTr("Встановити температуру")
                    width: parent.width - 20
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TextField {
                    id: textFieldCurrentTemperature
                    placeholderText: qsTr("Поточна температура")
                    width: parent.width - 20
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TextArea {
                    id: textAreaLog
                    placeholderText: qsTr("Інформація про дії")
                    width: parent.width - 20
                    height: 230
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }



}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Item {
    width: parent.width
    height: 50

    Menu {
        id: actionMenu
        x: actionBtn.x + actionBtn.width
        y: actionBtn.y + actionBtn.height

        font.family: "Poppins Medium"
        font.pixelSize: 14


        MenuItem {
            text: qsTr("Підключити")
            onTriggered: zoomIn()
        }

        MenuSeparator {}

        Menu {
            title: "Додатково.."

            font.family: "Poppins Medium"
            font.pixelSize: 14

            MenuItem {
                text: qsTr("Видалити")
                onTriggered: zoomOut()
            }
        }
    }

    Rectangle {
        id: background
        radius: 10
        anchors.fill: parent
        color: index % 2 == 0 ? "#00000000" : "#e6e6e6"

        GridLayout {
            anchors.fill: parent
            anchors.margins: 5
            columns: 2
            rows: 2

            Text {
                Layout.fillWidth: true
                id: deviceName
                text: deviceNameStr
                font.italic: true
                font.family: "Poppins Medium"
            }

            RoundButton {
                Layout.rowSpan: 2
                id: actionBtn
                radius: 10
                text: "..."
                onClicked: actionMenu.open()
            }

            Text {
                Layout.fillWidth: true
                id: comPortName
                text: comPortNameStr
                font.family: "Poppins Light"
            }
        }

        /*
        Button {
            id: buttonConnect
            x: 301
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            flat: true
            anchors.rightMargin: 10
            Image {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                source: "qrc:/icons/arrow-left-right.svg"
                anchors.rightMargin: 2
                anchors.leftMargin: 2
                anchors.bottomMargin: 2
                anchors.topMargin: 2
            }
        }*/

    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.66}D{i:5}D{i:7}
}
##^##*/

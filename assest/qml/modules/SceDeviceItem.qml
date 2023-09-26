import QtQuick 2.0
import QtQuick.Controls

Item {
    width: parent.width
    height: 50

    Rectangle {
        id: background
        radius: 10
        anchors.fill: parent
        color: index % 2 == 0 ? "#00000000" : "#e6e6e6"
        Text {
            id: deviceName
            text: deviceNameStr
            anchors.left: parent.left
            anchors.top: parent.top
            font.italic: true
            font.family: "Poppins Medium"
            anchors.topMargin: 5
            anchors.leftMargin: 10
        }
        Text {
            id: comPortName
            text: comPortNameStr
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            font.family: "Poppins Light"
            anchors.leftMargin: 10
            anchors.bottomMargin: 5
        }

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
        }

        Button {
            id: buttonDelete
            x: 251
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: buttonConnect.left
            flat: true
            anchors.rightMargin: 10
            Image {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                source: "qrc:/icons/trash.svg"
                anchors.rightMargin: 2
                anchors.leftMargin: 2
                anchors.bottomMargin: 2
                anchors.topMargin: 2
            }
        }

        BusyIndicator {
            id: busyIndicator
            width: comPortName.height
            height: comPortName.height
            anchors.left: comPortName.right
            anchors.bottom: parent.bottom
            padding: 1
            anchors.leftMargin: 10
            anchors.bottomMargin: 5
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.66}D{i:5}D{i:7}
}
##^##*/

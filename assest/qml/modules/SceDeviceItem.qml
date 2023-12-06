import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


//---Styles
import "../styles/Style.js" as Stl

Item {
    width: parent.width
    height: 60

    Menu {
        id: actionMenu
        x: actionBtn.x + actionBtn.width
        y: actionBtn.y + actionBtn.height

        font.pointSize: Stl.Font.small

        MenuItem {
            text: qsTr("Підключити")
            onTriggered: zoomIn()
        }
        MenuSeparator {}
        Menu {
            title: "Додатково.."
            font.pointSize: Stl.Font.small

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
                font.pixelSize: Stl.Font.medium
            }

            Button {
                Layout.rowSpan: 2
                id: actionBtn
                display: AbstractButton.TextBesideIcon
                icon.source: "qrc:/icons/three-dots.svg"
                onClicked: actionMenu.open()
                flat: true
            }

            Text {
                Layout.fillWidth: true
                id: comPortName
                text: comPortNameStr
                font.pixelSize: Stl.Font.small
                font.italic: true
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.66}D{i:5}D{i:7}
}
##^##*/

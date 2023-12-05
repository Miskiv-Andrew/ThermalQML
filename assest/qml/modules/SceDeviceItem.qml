import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Item {
    width: parent.width
    height: 60

    //sizes
    property real bFontSize: 18
    property real mFontSize: 14
    property real sFontSize: 10

    property real btnHeight: 40
    property real btnWidth: 180
    property real btnFontSize: 180

    property real radiusCommon: 10
    property real marginCommon: 10

    Menu {
        id: actionMenu
        x: actionBtn.x + actionBtn.width
        y: actionBtn.y + actionBtn.height

        font.pointSize: sFontSize

        MenuItem {
            text: qsTr("Підключити")
            onTriggered: zoomIn()
        }
        MenuSeparator {}
        Menu {
            title: "Додатково.."
            font.pointSize: sFontSize

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
                font.pixelSize: mFontSize
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
                font.pixelSize: sFontSize
                font.italic: true
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

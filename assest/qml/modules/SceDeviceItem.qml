import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs


Item {
    width: parent.width
    height: 60

    property bool switchInfo: true

    MessageDialog {
        id: delMesDialog
        text: " "
        informativeText: "Зберігати данні прилада?"
        buttons: MessageDialog.Yes | MessageDialog.No | MessageDialog.Cancel

        onAccepted: {
            var command = ["delete_dev", index, "save"]
            dsContext.receive_data_from_QML(command)
            //deviceListModel.removeDevice(index) //pass index in devicelist.h
            console.log(command)
        }

        onRejected: {
            var command = ["delete_dev", index, "not"]
            dsContext.receive_data_from_QML(command)
            //deviceListModel.removeDevice(index) //pass index in devicelist.h
            console.log(command)
        }

    }


    Menu {
        id: actionMenu
        x: actionBtn.x + actionBtn.width
        y: actionBtn.y + actionBtn.height

        font.pointSize: sm.sFont

        MenuItem {
            text: qsTr("Підключити")
            onTriggered: {}
        }

        MenuSeparator {}

        Menu {
            title: "Додатково.."
            font.pointSize: sm.sFont

            MenuItem {
                text: qsTr("Видалити")
                onTriggered: { delMesDialog.open() }
            }
        }
    }

    Rectangle {
        id: background
        radius: 10
        anchors.fill: parent
        color: index % 2 == 0 ? "#00000000" : "#e6e6e6"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                if (!model.selected) {
                    var command = ["select_dev", index]
                    dsContext.receive_data_from_QML(command)
                    deviceListModel.setSelectedIndex(index) //pass index in devicelist.h
                    console.log(command)
                }
            }
            //display info of tenperature if hovered
            onEntered: { tempInfoLable.text = "-10 0 20 30" }
            onExited: { tempInfoLable.text = "20.0 °C | [4]" }
        }

        GridLayout {
            anchors.fill: parent
            anchors.margins: 5
            columns: 2
            rows: 2

            Text {
                Layout.fillWidth: true
                id: deviceName
                text: model.deviceName
                color: index === deviceListModel.selectedIndex ? "orangered" : "dark"
                font.pixelSize: sm.mFont
            }

            Button {
                Layout.rowSpan: 2
                id: actionBtn
                display: AbstractButton.TextBesideIcon
                icon.source: "qrc:/icons/three-dots.svg"
                icon.color: index === deviceListModel.selectedIndex ? "orangered" : "dark"
                onClicked: actionMenu.open()
                flat: true

            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    id: comPortName
                    text: model.comPortName
                    font.pixelSize: sm.sFont
                    font.italic: true
                }

                IconLabel {
                    id: isConnected
                    visible: index === deviceListModel.selectedIndex
                    icon.source: "qrc:/icons/hdd-network.svg"
                }

                Text {
                    id: tempInfoLable
                    visible: switchInfo
                    text: "20.0 °C | [4]"
                    clip: true
                    font.pixelSize: sm.sFont
                }

            }


        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: false
        onTriggered: {
            switchInfo = !switchInfo
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.66}D{i:5}D{i:7}
}
##^##*/

import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtCharts 6.3
import Qt.labs.qmlmodels 1.0
import QtQuick.Dialogs

//---User Module Includes
import "modules"
import "windows"
import "pages"
import "styles"

ApplicationWindow  {
    id: app
    width: 1280
    height: 720
    visible: true
    color: "#00000000"
    title: qsTr("UTC")

    Settings { id: sm }

    Material.accent: Material.DeepOrange

    menuBar: MenuBar {
        id: menu
        font.pointSize: sm.sFont

        Menu {
            title: qsTr("&Файл")
            font.pointSize: sm.sFont
            Action { text: qsTr("Відкрити спектр")
                onTriggered: { fileDialog.open() }
            }
            Action { text: qsTr("Зберегти спектр") }
            Action { text: qsTr("Зберегти CSV") }
        }
        Menu {
            title: qsTr("Прилади")
            font.pointSize: sm.sFont
            Action { text: qsTr("Почати пошук")
                onTriggered: {
                    var command = ["start_search"]
                    dsContext.receive_data_from_QML(command)
                    console.log(command)
                }
            }
            Action { text: qsTr("Перепідключити")
                onTriggered: {
                    var command = ["start_research"]
                    dsContext.receive_data_from_QML(command)
                    console.log(command)
                }
            }
            Action { text: qsTr("Відновити сессію")
                onTriggered: {
                    fileDialogSession.open()
                }
            }
            Action { text: qsTr("Додати прилад до сесії")
                onTriggered: {
                    fileDialogAddToSession.open()
                }
            }
        }
        Menu {
            title: qsTr("Робота")
            font.pointSize: sm.sFont
            Action { text: qsTr("Старт роботи системи")
                onTriggered: {
                    var command = ["start_work_system"]
                    dsContext.receive_data_from_QML(command)
                    console.log(command) }
            }
        }
        Menu {
            title: qsTr("&Управління")
            font.pointSize: sm.sFont
            Action { text: qsTr("Пічка")
                onTriggered: { manualHeater.show() }
            }
        }

    }

    FileDialog {
        id: fileDialogSession
        title: "Виберіть файл сесії"
        onAccepted: {
            var filePath = selectedFile.toString().replace("file:///",'')
            var command = ["restart_session", filePath]
            dsContext.receive_data_from_QML(command)
            console.log(command)
        }
    }

    FileDialog {
        id: fileDialogAddToSession
        title: "Виберіть прилад для додання до сесії"
        onAccepted: {
            var filePath = selectedFile.toString().replace("file:///",'')
            var command = ["add_device", filePath]
            dsContext.receive_data_from_QML(command)
            console.log(command)
        }
    }

    FileDialog {
        id: fileDialog
        title: "Виберіть файл спектра"
        onAccepted: {
            var filePath = selectedFile.toString().replace("file:///",'')
            console.log("You chose: " + filePath)
        }
    }

    SceUser {
        x: menu.width - width
        y: menu.y
        height: menu.height
        width: menu.height
        z: 10
    }

    WinHeater{
        //additional window of manual controll of heater
        id: manualHeater
        Material.accent: Material.DeepOrange
        visible: false;
    }

    WinLogin{
        visible: true
    }

    ColorTheme{
        id: colortheme
    }

    Rectangle {
        id: background
        color: "#ffffff"
        anchors.fill: parent

        Rectangle {
            id: appContent
            color: "transparent"
            anchors.fill: parent
            clip: true

            SwipeView {
                id: swipeView
                anchors.left: leftMenuFrame.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                interactive: false
                anchors.topMargin: 0
                anchors.leftMargin: 0
                currentIndex: 0
                onCurrentIndexChanged: {
                    leftMenuBtnDev.checked = !currentIndex
                    leftMenuBtnSett.checked = currentIndex
                }

                PageDevice {
                    id: pageDevices
                }

                PageSettings{
                    id: pageSettings
                }

                PageTest {
                    id: pageTest
                }

            }

            PageIndicator {
                id: indicator

                count: swipeView.count
                currentIndex: swipeView.currentIndex
                anchors.bottom: swipeView.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id: leftMenuFrame
                width: 40
                color: "#dbdcdb"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 20
                    anchors.bottomMargin: 20
                    anchors.leftMargin: -10
                    spacing: 10

                    Button {
                        id: leftMenuBtnDev
                        display: AbstractButton.TextBesideIcon
                        icon.source: "qrc:/icons/house.svg"
                        width: 10
                        checkable: true
                        autoExclusive: true
                        flat: true
                        onClicked: swipeView.setCurrentIndex(0)
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    Button {
                        id: leftMenuBtnSett
                        display: AbstractButton.TextBesideIcon
                        icon.source: "qrc:/icons/gear.svg"
                        width: 10
                        checkable: true
                        autoExclusive: true
                        flat: true
                        onClicked: swipeView.setCurrentIndex(1)
                    }

                    Button {
                        id: leftMenuBtnTest
                        display: AbstractButton.TextBesideIcon
                        icon.source: "qrc:/icons/terminal.svg"
                        width: 10
                        checkable: true
                        autoExclusive: true
                        flat: true
                        onClicked: swipeView.setCurrentIndex(2)
                    }
                }
            }
        }
    }

    Connections { target: dsContext }
}





/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/

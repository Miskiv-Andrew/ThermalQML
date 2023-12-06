import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtCharts 6.3
import Qt.labs.qmlmodels 1.0
import QtQuick.Dialogs

//---Styles
import "./styles/Style.js" as Stl

//---User Module Includes
import "modules"
import "windows"
import "scripts"
import "pages"

ApplicationWindow  {
    id: app
    width: 1280
    height: 720
    visible: true
    color: "#00000000"
    title: qsTr("UTC")

    Material.accent: Material.DeepOrange

    menuBar: MenuBar {

        font.pointSize: Stl.Font.small

        Menu {
            title: qsTr("&Файл")
            font.pointSize: Stl.Font.small
            Action { text: qsTr("Відкрити спектр")
                onTriggered: { fileDialog.open() }
            }
            Action { text: qsTr("Зберегти спектр") }
            Action { text: qsTr("Зберегти CSV") }
        }
        Menu {
            title: qsTr("&Управління")
            font.pointSize: Stl.Font.small
            Action { text: qsTr("Пічка")
                onTriggered: { manualHeater.show() }
            }

        }
        Menu {
            title: qsTr("&Вигляд")
            font.pointSize: Stl.Font.small
            CheckBox { text: qsTr("Список девайсів"); onClicked: { WinDevlist.visible = checked; } }
            CheckBox { text: qsTr("Вікно спектра"); onClicked: { WinSpectr.visible = checked; } }
            CheckBox { text: qsTr("Вікно коефіціентів"); onClicked: { WinCoeff.visible = checked; } }
        }
        Menu {
            title: qsTr("&Справка")
            font.pointSize: Stl.Font.small
            Action { text: qsTr("&About") }
        }

    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        onAccepted: {
            var filePath = fileDialog.selectedFile.toString().replace("file:///",'')
            console.log("You chose: " + filePath)
            pageDevices.itemSpecrumAlias.updateSpectrum(filePath)
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    WinHeater{
        //additional window of manual controll of heater
        id: manualHeater
        Material.accent: Material.DeepOrange
        visible: false;
    }


    // INTERNAL FUNCTIONS
    WindowControlScript {
        id: windowManager
    }

    FontStyle{
        id: fontstyle
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
}





/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/

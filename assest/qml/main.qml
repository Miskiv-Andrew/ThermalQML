import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtCharts 6.3
import Qt.labs.qmlmodels 1.0
import QtQuick.Dialogs

//---User Module Includes
import "modules"
import "windows"
import "scripts"

ApplicationWindow  {
    id: app
    width: 1280
    height: 720
    visible: true
    color: "#00000000"
    title: qsTr("UTC")

    menuBar: MenuBar {
        Menu {
            title: qsTr("&Файл")
            Action { text: qsTr("Відкрити спектр")
                onTriggered: { fileDialog.open() }
            }
            Action { text: qsTr("Зберегти спектр") }
            Action { text: qsTr("Зберегти CSV") }
        }
        Menu {
            title: qsTr("&Управління")
            Action { text: qsTr("Пічка")
                onTriggered: { manualHeater.show()  }
            }

        }
        Menu {
            title: qsTr("&Вигляд")
            CheckBox { text: qsTr("Список девайсів"); onClicked: { WinDevlist.visible = checked; } }
            CheckBox { text: qsTr("Вікно спектра"); onClicked: { WinSpectr.visible = checked; } }
            CheckBox { text: qsTr("Вікно коефіціентів"); onClicked: { WinCoeff.visible = checked; } }
        }
        Menu {
            title: qsTr("&Справка")
            Action { text: qsTr("&About") }
        }

    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        onAccepted: {
            var filePath = fileDialog.selectedFile.toString().replace("file:///",'')
            console.log("You chose: " + filePath)
            itemSpectr.updateSpectrum(filePath)
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    WinHeater{
        //additional window of manual controll of heater
        id: manualHeater
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
                    buttonDevices.activeMenu = !currentIndex
                    buttonSettings.activeMenu = currentIndex
                }

                Page {
                    id: pageDevices

                    Rectangle {
                        id: rectangleDevices
                        color: "#dbdcdc"
                        anchors.fill: parent

                        ScrollView {
                            id: scrollViewDevices
                            anchors.fill: parent
                            padding: 0
                            rightPadding: 10
                            bottomPadding: 10
                            leftPadding: 10
                            topPadding: 10

                            WinDevlist {
                                id: rectangleDevList
                                width: app.width*0.2
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.topMargin: 10
                                anchors.bottomMargin: 10
                            }

                            SceSpitter{
                                id: splitter2
                                elementParent: parent
                                verticalOrientation: true
                                element1: rectangleDevList
                                element2: rectangleAdditional
                            }

                            Rectangle {
                                id: rectangleAdditional
                                color: "#00000000"
                                border.width: 0
                                anchors.left: rectangleDevList.right
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.margins: 10


                                WinSpectr{
                                    id: itemSpectr
                                    width: parent.width
                                    height: parent.height * 0.7
                                    anchors.bottomMargin: 10
                                }

                                SceSpitter{
                                    id: splitter1
                                    elementParent: parent
                                    element1: itemSpectr
                                    element2: itemCoeff
                                }

                                WinCoeff{
                                    id: itemCoeff
                                    width: parent.width
                                    height: parent.height - itemSpectr.height - splitter1.height
                                    anchors.top: splitter1.bottom
                                    anchors.topMargin: 0
                                }

                            }
                        }
                    }

                }

                Page {
                    id: pageSettings

                    Rectangle {
                        id: rectangleSettings
                        color: "#dbdcdc"
                        anchors.fill: parent

                        ScrollView {
                            id: scrollViewSettings
                            anchors.fill: parent

                            Rectangle {
                                id: rectangleSettingsContent
                                color: "#fafafa"
                                radius: 10
                                border.width: 0
                                anchors.fill: parent
                                anchors.rightMargin: 20
                                anchors.leftMargin: 20
                                anchors.bottomMargin: 20
                                anchors.topMargin: 20
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    color: "#a3676767"
                                    transparentBorder: true
                                    horizontalOffset: 2
                                    verticalOffset: 4
                                    radius: 4

                                }
                            }
                        }
                    }

                }

                Page {
                    id: pageTest

                    Rectangle {
                        id: rectangleTest
                        color: "#dbdcdc"
                        anchors.fill: parent

                        ScrollView {
                            id: scrollViewTest
                            anchors.fill: parent

                            Rectangle {
                                id: rectangleTestContent
                                color: "#fafafa"
                                radius: 10
                                border.width: 0
                                anchors.fill: parent
                                anchors.rightMargin: 20
                                anchors.leftMargin: 20
                                anchors.bottomMargin: 20
                                anchors.topMargin: 20
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    color: "#a3676767"
                                    transparentBorder: true
                                    horizontalOffset: 2
                                    verticalOffset: 4
                                    radius: 4

                                    Test{
                                        id: testWindow
                                        anchors.fill: parent
                                    }

                                }
                            }
                        }
                    }

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
                width: 30
                color: "#dbdcdb"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 20
                    anchors.bottomMargin: 20
                    spacing: 10

                    SceLeftMenuButton {
                        Layout.preferredWidth: 30
                        id: buttonDevices
                        btnIcon: "qrc:/icons/house.svg"
                        onClicked: swipeView.setCurrentIndex(0)

                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    SceLeftMenuButton {
                        Layout.preferredWidth: 30
                        id: buttonSettings
                        btnIcon: "qrc:/icons/gear.svg"
                        onClicked: swipeView.setCurrentIndex(1)
                    }


                    SceLeftMenuButton {
                        Layout.preferredWidth: 30
                        id: buttonTest
                        btnIcon: "qrc:/icons/terminal.svg"
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

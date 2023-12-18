import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects

Page {

    Rectangle {
        color: "#dbdcdc"
        anchors.fill: parent

        Connections { target: smContext }

        MessageDialog {
            id: popupApply
            text: " "
            informativeText: "Для того щоб зміни вступили в силу перезавантажде додаток"
            buttons: MessageDialog.Ok
        }

        ScrollView {
            anchors.fill: parent

            Rectangle {
                color: "#fafafa"
                radius: 10
                anchors.fill: parent
                anchors.margins: 20
                layer.enabled: true
                layer.effect: DropShadow {
                    color: "#a3676767"
                    transparentBorder: true
                    horizontalOffset: 2
                    verticalOffset: 4
                    radius: 4
                }

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 0
                    columnSpacing: 0
                    columns: 3

                    ScrollView {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 200

                        Column {
                            anchors.fill: parent
                            spacing: 5

                            Button {
                                text: "Інтерфейс"
                                display: AbstractButton.TextBesideIcon
                                icon.source: "qrc:/icons/display.svg"
                                font.pixelSize: sm.mFont;
                                width: parent.width
                                checkable: true
                                autoExclusive: true
                                flat: true
                            }

                            Button {
                                text: "Telegram bot"
                                display: AbstractButton.TextBesideIcon
                                icon.source: "qrc:/icons/telegram.svg"
                                font.pixelSize: sm.mFont;
                                width: parent.width
                                checkable: true
                                autoExclusive: true
                                flat: true
                            }

                            Rectangle {
                                color: "#40000000"
                                radius: 10
                                height: 2
                                width: parent.width
                            }

                            Item { Layout.fillHeight: true }

                            Button {
                                text: "Зберегти"
                                display: AbstractButton.TextBesideIcon
                                icon.source: "qrc:/icons/save.svg"
                                font.pixelSize: sm.mFont;
                                width: parent.width
                                flat: true
                                onClicked: {
                                    smContext.writeSettingsToFile()
                                    popupApply.open()
                                }
                            }

                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        width: 3
                        color: "gray"
                    }

                    SwipeView {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Item {
                            id: intefaceSett

                            ScrollView {
                                anchors.fill: parent
                                anchors.margins: 10

                                Column {
                                    anchors.fill: parent
                                    anchors.leftMargin: 100
                                    anchors.rightMargin: 100
                                    topPadding: 50
                                    spacing: 10

                                    Text { text: "Інтерфейс"; font.bold: true; font.pixelSize: sm.bFont; verticalAlignment: Text.AlignTop; }

                                    Rectangle {
                                        color: "#ffffff"
                                        width: intefaceSett.width-220 //220 - this is marging from colimn + margin from ScroolView
                                        height: 300
                                        radius: 10
                                        layer.enabled: true
                                        layer.effect: DropShadow {
                                            color: "#a3676767"
                                            transparentBorder: true
                                            horizontalOffset: 2
                                            verticalOffset: 4
                                            radius: 8
                                        }


                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 10

                                            RowLayout {
                                                Layout.preferredHeight: 50
                                                ColumnLayout {
                                                    Text { text: "Розмір тексту"; font.pixelSize: sm.mFont; Layout.fillWidth: true }
                                                    Text { text: "Розмір тексту у всьому додатку"; font.pixelSize: sm.sFont; Layout.fillWidth: true; color: "gray"}
                                                }
                                                ComboBox {model: [8, 10, 12, 14, 16, 18, 20, 22, 24]; font.pixelSize: sm.mFont;
                                                    onActivated: smContext.setValue("Font/size", currentText)
                                                    Component.onCompleted: currentIndex = find(smContext.getValue("Font/size"))
                                                }
                                            }
                                            Rectangle { color: "#eaeaea"; height: 2; Layout.fillWidth: true }

                                            RowLayout {
                                                Layout.preferredHeight: 50

                                                ColumnLayout {
                                                    Text { text: "Дельта розміру тексту"; font.pixelSize: sm.mFont; Layout.fillWidth: true }
                                                    Text { text: "Різниця між малим/великим текстом відностно основго розміру"; font.pixelSize: sm.sFont; Layout.fillWidth: true; color: "gray"}
                                                }
                                                ComboBox { model: [0, 1, 2, 3, 4, 5, 6, 7, 8]; font.pixelSize: sm.mFont;
                                                    onActivated: smContext.setValue("Font/deltaSize", currentText)
                                                    Component.onCompleted: currentIndex = find(smContext.getValue("Font/deltaSize"))
                                                }
                                            }
                                            Rectangle { color: "#eaeaea"; height: 2; Layout.fillWidth: true }

                                            RowLayout {
                                                Layout.preferredHeight: 50

                                                ColumnLayout {
                                                    Text { text: "Висота кнопок"; font.pixelSize: sm.mFont; Layout.fillWidth: true }
                                                    Text { text: ""; font.pixelSize: sm.sFont; Layout.fillWidth: true; color: "gray"}
                                                }
                                                ComboBox { model: [20, 30, 40, 50, 60, 70, 80]; font.pixelSize: sm.mFont;
                                                    onActivated: smContext.setValue("Control/btnHeight", currentText)
                                                    Component.onCompleted: currentIndex = find(smContext.getValue("Control/btnHeight"))
                                                }
                                            }
                                            Rectangle { color: "#eaeaea"; height: 2; Layout.fillWidth: true }

                                            RowLayout {
                                                Layout.preferredHeight: 50

                                                ColumnLayout {
                                                    Text { text: "Ширина кнопок"; font.pixelSize: sm.mFont; Layout.fillWidth: true }
                                                    Text { text: ""; font.pixelSize: sm.sFont; Layout.fillWidth: true; color: "gray"}
                                                }
                                                ComboBox {model: [100, 120, 140, 160, 180, 200, 220, 240]; font.pixelSize: sm.mFont;
                                                    onActivated: smContext.setValue("Control/btnWidth", currentText)
                                                    Component.onCompleted: currentIndex = find(smContext.getValue("Control/btnWidth"))
                                                }
                                            }


                                        }
                                    }
                                }

                            }

                        }


                    }
                }

            }
        }
    }


}



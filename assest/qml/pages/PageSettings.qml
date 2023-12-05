import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Page {

    Rectangle {
        color: "#dbdcdc"
        anchors.fill: parent

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
                                text: "Interface"
                                display: AbstractButton.TextBesideIcon
                                icon.source: "qrc:/icons/reply.svg"
                                width: parent.width
                                checkable: true
                                autoExclusive: true
                                flat: true
                            }

                            Button {
                                text: "Telegram Bot"
                                display: AbstractButton.TextBesideIcon
                                icon.source: "qrc:/icons/send.svg"
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

                                    Text { text: "Display"; font.bold: true; font.pixelSize:18; verticalAlignment: Text.AlignTop; }

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
                                                Text { text: "Size"; font.pixelSize: 14; Layout.fillWidth: true }
                                                ComboBox { model: ["Small", "Normal", "Big"]; font.pixelSize: 14; }
                                            }
                                            Rectangle { color: "#eaeaea"; height: 2; Layout.fillWidth: true }

                                            RowLayout {
                                                Layout.preferredHeight: 50
                                                Text { text: "Antializing"; font.pixelSize: 14; Layout.fillWidth: true }
                                                Switch { }
                                            }
                                            Rectangle { color: "#eaeaea"; height: 2; Layout.fillWidth: true }

                                            RowLayout {
                                                Layout.preferredHeight: 50
                                                ColumnLayout {
                                                    Text { text: "Icon size"; font.pixelSize: 14; Layout.fillWidth: true }
                                                    Text { text: "Size of desctop icons"; font.pixelSize: 12; Layout.fillWidth: true; color: "gray"}
                                                }
                                                ComboBox {  model: ["Small", "Normal", "Big"]; font.pixelSize: 14 }
                                            }
                                            Rectangle { color: "#eaeaea"; height: 2; Layout.fillWidth: true }

                                            RowLayout {
                                                Layout.preferredHeight: 50
                                                ColumnLayout {
                                                    Text { text: "Sorting"; font.pixelSize: 14; Layout.fillWidth: true }
                                                    Text { text: "Sorting data in the table"; font.pixelSize: 12; Layout.fillWidth: true; color: "gray"}
                                                }
                                                Switch { }
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



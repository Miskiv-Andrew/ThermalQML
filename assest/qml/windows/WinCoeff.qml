import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

Item {
    visible: true
    width: 600
    height: 300

    Rectangle {
        id: rectangleCoef
        radius: 10
        color: "#fafafa"
        anchors.fill: parent
        layer.enabled: true
        layer.effect: DropShadow {
            color: "#a0676767"
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 4
            radius: 4


        }

        Rectangle{
            id: content
            x: 10
            y: 10
            color: "#fafafa"
            anchors.fill: parent
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5


            Rectangle {
                id: rectangle
                height: 50
                color: "#f0f0f0"
                radius: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                CheckBox {
                    id: checkThermalCompOnOff
                    x: 414
                    width: 170
                    height: 30
                    text: qsTr("Термокомпенсація")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    font.pointSize: 12
                    font.family: "Arial"
                    focusPolicy: Qt.ClickFocus
                    anchors.rightMargin: 10
                }

                Button {
                    id: buttonWriteThermalCoef
                    width: 100
                    height: 30
                    text: qsTr("Зчитати")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    font.family: "Arial"
                    font.pointSize: 12
                    anchors.leftMargin: 10
                }

                Button {
                    id: buttonReadThermalCoef
                    width: 100
                    height: 30
                    text: qsTr("Зашити")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: buttonWriteThermalCoef.right
                    font.family: "Arial"
                    font.pointSize: 12
                    anchors.leftMargin: 10
                }
            }

            Rectangle {
                id: rectangleTableRange
                width: parent.width*0.7
                color: "#ffffff"
                anchors.left: parent.left
                anchors.top: rectangle.bottom
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                TableView {
                    id: tableViewCoeff
                    anchors.fill: parent
                    //alternatingRows: true
                    columnSpacing: 1
                    rowSpacing: 1
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    model: TableModel {
                        TableModelColumn { display: "Name" }
                        TableModelColumn { display: "50°C" }
                        TableModelColumn { display: "40°C" }
                        TableModelColumn { display: "30°C" }
                        TableModelColumn { display: "20°C" }
                        TableModelColumn { display: "10°C" }
                        TableModelColumn { display: "0°C" }
                        TableModelColumn { display: "-10°C" }
                        TableModelColumn { display: "-20°C" }

                        // Define the data
                        rows: [
                            { Name: "/",   "50°C": "50°C", "40°C": "40°C", "30°C": "30°C", "20°C": "20°C", "10°C": "10°C", "0°C": "0°C", "-10°C": "-10°C", "-20°C": "-20°C" },
                            { Name: "Темп.",   "50°C": 10, "40°C": 15, "30°C": 20, "20°C": 25, "10°C": 30, "0°C": 35, "-10°C": 40, "-20°C": 45 },
                            { Name: "Код Uzm", "50°C": 8, "40°C": 12, "30°C": 16, "20°C": 20, "10°C": 24, "0°C": 28, "-10°C": 32, "-20°C": 36 },
                            { Name: "Шум",     "50°C": 5, "40°C": 10, "30°C": 15, "20°C": 20, "10°C": 25, "0°C": 30, "-10°C": 35, "-20°C": 40 },
                            { Name: "Сдвиг",   "50°C": 12, "40°C": 18, "30°C": 24, "20°C": 30, "10°C": 36, "0°C": 42, "-10°C": 48, "-20°C": 54 }
                        ]
                    }

                    delegate: Rectangle {
                        implicitWidth: 60
                        implicitHeight: 30
                        border.width: 1
                        radius: 3

                        TextEdit {
                            anchors.fill: parent
                            text: display
                            font.family: "Poppins Medium"
                            font.styleName: "Poppins Light"
                            horizontalAlignment: TextEdit.AlignHCenter
                            verticalAlignment: TextEdit.AlignVCenter
                            selectByMouse: true

                        }
                    }
                }
            }

            Rectangle {
                id: rectangleTableCurrent
                x: 317
                width: parent.width*0.3
                color: "#ffffff"
                anchors.right: parent.right
                anchors.top: rectangle.bottom
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0

                TableView {
                    id: tableViewCurrent
                    anchors.fill: parent
                    //alternatingRows: true
                    columnSpacing: 1
                    rowSpacing: 1
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    model: TableModel {
                        TableModelColumn { display: "Name" }
                        TableModelColumn { display: "Curr" }


                        // Define the data
                        rows: [
                            { Name: "/",   "Curr": "Поточна", },
                            { Name: "Темп.",   "Curr": 10 },
                            { Name: "Код Uzm", "Curr": 8 },
                            { Name: "Шум",     "Curr": 5  },
                            { Name: "Сдвиг",   "Curr": 12 }
                        ]
                    }

                    delegate: Rectangle {
                        implicitWidth: 60
                        implicitHeight: 30
                        border.width: 1
                        radius: 4

                        TextEdit {
                            anchors.fill: parent
                            text: display
                            font.family: "Poppins Medium"
                            font.styleName: "Poppins Light"
                            horizontalAlignment: TextEdit.AlignHCenter
                            verticalAlignment: TextEdit.AlignVCenter
                            selectByMouse: true

                        }
                    }
                }
            }


        }
    }
}

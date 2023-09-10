import QtQuick 2.0
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

import "../modules"

Item {

    visible: true
    width: 300
    height: 700

    Rectangle {
        id: rectangleDevList
        color: "#fafafa"
        radius: 10
        anchors.fill: parent
        layer.enabled: true
        layer.effect: DropShadow {
            color: "#a3676767"
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 4
            radius: 4
        }

        ListView {
            id: listView
            anchors.fill: parent
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5

            delegate: SceDeviceItem{

            }

            model: ListModel {
                ListElement {
                    deviceNameStr: "Spectra №19000031"
                    comPortNameStr: "COM1"
                }

                ListElement {
                    deviceNameStr: "Spectra №19000033"
                    comPortNameStr: "COM2"
                }

                ListElement {
                    deviceNameStr: "Cadmium №18000032"
                    comPortNameStr: "COM3"
                }

                ListElement {
                    deviceNameStr: "BDBG-09 №16000034"
                    comPortNameStr: "COM4"
                }
            }
        }
    }
}

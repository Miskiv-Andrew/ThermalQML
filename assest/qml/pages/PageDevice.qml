import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../modules"
import "../windows"


Page {

    //sizes
    property real fontSize: 14

    property real buttonHeight: 40
    property real buttonWidth: 180

    property real radiusCont: 10
    property real marginCont: 10

    property alias itemSpecrumAlias: itemSpectr

    Rectangle {
        id: rectangleDevices
        color: "#dbdcdc"
        anchors.fill: parent

        ScrollView {
            id: scrollViewDevices
            anchors.fill: parent
            padding: 10

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


import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import "../modules"
import "../windows"

Page {

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

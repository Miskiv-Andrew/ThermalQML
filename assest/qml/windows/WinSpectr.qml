import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

Rectangle {
    id: rectangleChart
    x: 10
    y: 10
    height: parent.height/2
    color: "#fafafa"
    radius: 10
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.rightMargin: 10
    anchors.leftMargin: 10
    anchors.topMargin: 10
    layer.enabled: true
    layer.effect: DropShadow {
        color: "#a0676767"
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 4
        radius: 4
    }



    Rectangle {
        id: rectangleSpectr
        width: parent.width*0.6
        color: "#d5d5d5"
        anchors.left: parent.left
        anchors.top: rectangleTop.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0

        ChartView {
            id: spectrumChart
            anchors.fill: parent
            backgroundColor : "#00000000"
            margins.bottom: 0
            margins.top: 0
            margins.left: 0
            margins.right: 0
            antialiasing: true
            theme: ChartView.ChartThemeQt
            legend.visible: false

    //        MouseArea {
    //            anchors.fill: parent
    //            hoverEnabled  : true

    //            onClicked: {

    //                var p = Qt.point(mouse.x, mouse.y);
    //                var cp = spectrumChart.mapToValue(p, spectrumLine);
    //                console.log(cp.x + " " + cp.y)


    //                }
    //        }

            MouseArea {
                id: chartMouseArea
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    var mousePoint = mapFromItem(chartMouseArea, mouse.x, mouse.y);
                    var xAxis = spectrumChart.axisX;
                    var yAxis = spectrumChart.axisY;
                    var xValue = xAxis.min + (xAxis.max - xAxis.min) * (mousePoint.x / spectrumChart.width);
                    var yValue = yAxis.min + (yAxis.max - yAxis.min) * (1 - mousePoint.y / spectrumChart.height);

                    var closestPoint = Qt.point(mouse.x, mouse.y); //internal.findClosestPoint(xValue, yValue);
                    if (closestPoint) {
                        internal.showInfoRectangle(closestPoint.x, closestPoint.y);
                    } else {
                        internal.hideInfoRectangle();
                    }
                }
            }


            Rectangle {
                id: infoRectangle
                width: 100
                height: 25
                color: "#50505050"

                visible: false

                Text {
                    id: infoText
                    anchors.centerIn: parent
                }
            }

            LineSeries {
                id: spectrumLine
                XYPoint { x: 0; y:383}
                XYPoint { x: 100; y:886}
                XYPoint { x: 200; y:777}
                XYPoint { x: 350; y:915}
            }
        }
    }

    Rectangle {
        id: rectangleData
        x: 440
        width: parent.width*0.4
        color: "#ffffff"
        anchors.right: parent.right
        anchors.top: rectangleTop.bottom
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0

        Column {
            id: column
            anchors.fill: parent
            spacing: 20

            Text {
                id: textAccTime
                text: qsTr("Час накопичення: - ")
                font.pixelSize: 12
            }

            Text {
                id: textIntegCPS
                text: qsTr("Інтенсивність (інтегрована), cps: - ")
                font.pixelSize: 12
            }
            Text {
                id: textSpectrCPS
                text: qsTr("Інтенсивність (спектр), cps: - ")
                font.pixelSize: 12
            }
            Text {
                id: textCurrentPED
                text: qsTr("ПЕД, мкЗв/год: - ")
                font.pixelSize: 12
            }
            Text {
                id: textTemperature
                text: qsTr("Температура, °C: - ")
                font.pixelSize: 12
            }
        }
    }

    Rectangle {
        id: rectangleTop
        height: 50
        color: "#eeeeee"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Switch {
            id: switchStartStopSpectr
            text: qsTr("Почати накопичення")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10
        }

        Switch {
            id: switchLogarifmSpect
            text: qsTr("Логарифмічна шкала")
            anchors.left: switchStartStopSpectr.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10
        }

        DelayButton {
            id: delayButtonClearSpectr
            text: qsTr("Очистити")
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10
        }
    }


}

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import QtCharts 6.3

Item {
    visible: true
    width: 700
    height: 350

    Rectangle {
        id: rectangleChart
        x: 10
        y: 10
        color: "#fafafa"
        radius: 10
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.topMargin: 0
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
            anchors.fill: parent
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5

            Rectangle {
                id: rectangleSpectr
                color: "#ffffff"
                anchors.left: parent.left
                anchors.right: rectangleData.left
                anchors.top: rectangleTop.bottom
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
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
                    legend.visible: false


                    ValueAxis {
                        id: valueAxis
                        tickCount: 10
                        labelFormat: "%.0f"
                    }

                    AreaSeries {
                        name: "Spectr"
                        axisX: valueAxis
                        color: "#700000ff"
                        upperSeries: LineSeries {
                            XYPoint { x: 1; y: 1 }
                            XYPoint { x: 5; y: 10 }
                            XYPoint { x: 50; y: 100 }
                            XYPoint { x: 100; y: 50 }
                            XYPoint { x: 200; y: 10 }
                            XYPoint { x: 400; y: 400 }
                            XYPoint { x: 600; y: 600}
                            XYPoint { x: 800; y: 400 }
                            XYPoint { x: 1000; y: 50 }

                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onDoubleClicked: spectrumChart.zoomReset();
                    }

                    PinchArea{
                        id: pa
                        anchors.fill: parent
                        onPinchUpdated: {
                            spectrumChart.zoomReset();
                            var center_x = pinch.center.x
                            var center_y = pinch.center.y
                            var width_zoom = height/pinch.scale;
                            var height_zoom = width/pinch.scale;
                            var r = Qt.rect(center_x-width_zoom/2, center_y - height_zoom/2, width_zoom, height_zoom)
                            spectrumChart.zoomIn(r)
                        }

                    }


                }
            }

            Rectangle {
                id: rectangleData
                x: 410
                y: 40
                width: 100
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
                    clip: true
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
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
                color: "#f0f0f0"
                radius: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Switch {
                    id: switchStartStopSpectr
                    text: qsTr("Почати накопичення")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    font.pointSize: 12
                    font.family: "Arial"
                    anchors.leftMargin: 10
                }

                Switch {
                    id: switchLogarifmSpect
                    text: qsTr("Логарифмічна шкала")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: switchStartStopSpectr.right
                    font.pointSize: 12
                    font.family: "Arial"
                    anchors.leftMargin: 10
                }

                Button {
                    id: delayButtonClearSpectr
                    width: 100
                    height: 30
                    text: qsTr("Очистити")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    font.pointSize: 12
                    layer.mipmap: false
                    font.bold: false
                    font.family: "Arial"
                    anchors.rightMargin: 10
                }
            }

        }
    }


}

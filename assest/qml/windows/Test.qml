import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtCharts 2.1


Item {
    visible: true
    width: 640
    height: 480

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
            anchors.right: rectangleData.left
            anchors.top: rectangleTop.bottom
            anchors.fill: parent



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

                Rectangle{
                    id: zoomAreaRec
                    color: "#00000000"
                    border.color: "#50ff0000"
                    border.width: 2
                    radius: 10
                    clip: true
                    visible: false
                }

                MouseArea {
                    id: zoomMouseArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton

                    //zoom chart
                    property real startX
                    property real startY
                    property real endX
                    property real endY

                    //drag chart
                    property real lastMouseX: 0
                    property real lastMouseY: 0
                    property real chartOffsetX: 0
                    property real chartOffsetY: 0

                    onReleased: {
                        endX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                        endY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                        console.log("Released - " + "EndX: " + endX + "; EndY: " + endY + "\n");
                        zoomChart();
                        updateRectangle(0, 0, 0, 0, false);
                    }

                    onPressed: {
                        startX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                        startY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                        lastMouseX = mouse.x
                        lastMouseY = mouse.y
                        console.log("Pressed - " + "StartX: " + startX + "; StartY: " + startY + "\n");
                    }

                    onPositionChanged: {
                        if (mouse.button === Qt.RightButton) {
                            var deltaX = mouse.x - lastMouseX
                            var deltaY = mouse.y - lastMouseY
                            chartOffsetX += deltaX
                            chartOffsetY += deltaY
                            spectrumChart.position.x = chartOffsetX
                            spectrumChart.position.y = chartOffsetY
                            lastMouseX = mouse.x
                            lastMouseY = mouse.y
                        }
                        else{
                            endX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                            endY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                            updateRectangle(startX, startY, endX - startX, endY - startY, true);
                        }
                    }

                    function zoomChart() {
                        if (startX < endX) {
                            var r = Qt.rect(startX, startY, endX - startX, endY - startY);
                            spectrumChart.zoomIn(r);
                        }
                        if (startX > endX) {
                            spectrumChart.zoomReset();
                        }

                    }

                    function updateRectangle(x, y, w, h, draw) {

                        if (startX < endX) {
                            zoomAreaRec.visible = draw
                            zoomAreaRec.x = x
                            zoomAreaRec.y = y
                            zoomAreaRec.width = w
                            zoomAreaRec.height = h
                        }

                    }
                }


            }
        }
    }
}

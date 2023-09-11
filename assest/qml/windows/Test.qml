import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import QtCharts 6.3

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
                    id: valueAxisX
                    labelFormat: "%.0f"
                }

                ValueAxis {
                    id: valueAxisY
                    labelFormat: "%.0f"
                }

                AreaSeries {
                    name: "Spectr"
                    axisX: valueAxisX
                    axisY: valueAxisY
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
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    //zoom chart
                    property real startX
                    property real startY
                    property real endX
                    property real endY

                    //drag chart
                    property bool isMove
                    property bool isZoom
                    property point previous: Qt.point(mouseX, mouseY)
                    property point scrollPoint
                    property double scale: -1.0
                    function reset(){
                        scrollPoint = Qt.point(0,0);
                    }

                    onReleased: (mouse)=> {
                        if(isZoom == true){
                            endX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                            endY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                            zoomChart();
                            updateRectangle(0, 0, 0, 0, false);
                            isZoom = false;
                            console.log("onReleased Zoom")
                        }
                        if(isMove == true){
                            isMove = false
                            console.log("onReleased Move")
                        }
                        //console.log("Released - " + "EndX: " + endX + "; EndY: " + endY + "\n");
                    }

                    onPressed: (mouse)=> {

                        if(mouse.button == Qt.LeftButton){
                            startX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                            startY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                            isZoom = true
                            console.log("onPressed Qt.LeftButton")
                        }
                        else if(mouse.button == Qt.RightButton){
                            previous = Qt.point(mouse.x, mouse.y);
                            isMove = true
                            console.log("onPressed Qt.RightButton")
                        }

                        //console.log("Pressed - " + "StartX: " + startX + "; StartY: " + startY + "\n");
                    }

                    onPositionChanged: (mouse)=> {
                        if (isZoom == true){

                            endX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                            endY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                            updateRectangle(startX, startY, endX - startX, endY - startY, true);
                            console.log("onPositionChanged Qt.LeftButton");
                        }

                        else if(isMove == true){

                            if(spectrumChart.isZoomed()) {

                                scrollPoint.x = (previous.x - mouse.x)*scale;
                                scrollPoint.y = (previous.y - mouse.y)*scale;

                                if(scrollPoint.y > 0)
                                {
                                    spectrumChart.scrollUp(scrollPoint.y);
                                    spectrumChart.scrollDown(0);
                                }
                                else{
                                    spectrumChart.scrollDown(-scrollPoint.y);
                                    spectrumChart.scrollUp(0);
                                }
                                if(scrollPoint.x > 0)
                                {
                                    spectrumChart.scrollLeft(scrollPoint.x);
                                    spectrumChart.scrollRight(0);
                                }
                                else{
                                    spectrumChart.scrollLeft(0);
                                    spectrumChart.scrollRight(-scrollPoint.x);
                                }

                                console.log("onPositionChanged Qt.RightButton");
                                previous = Qt.point(mouse.x, mouse.y);
                            }
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

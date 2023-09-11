import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import QtCharts 6.3

Item {
    visible: true
    width: 1200
    height: 500

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
                anchors.right: parent.right
                anchors.top: rectangleTop.bottom
                anchors.bottom: parent.bottom
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

                    TextEdit {
                        id: textEditSpectrumInfo
//                        text: "Час накопичення: 000 сек \n" +
//                              "Інтенсивність (інтегрована), cps: -\n" +
//                              "Інтенсивність (спектр), cps: -\n" +
//                              "ПЕД, мкЗв/год: -\n" +
//                              "Температура, °C: -\n"
                        textFormat: Text.RichText
                        text: '<p> . <img src="qrc:/icons/clock.svg" width="12" height="12">  0000, сек  </p>' +
                           '<p> . <img src="qrc:/icons/asterisk.svg" width="12" height="12">  0000 (0000), cps  </p>' +
                        '<p> . <img src="qrc:/icons/radioactive.svg" width="12" height="12">  00.00, мкЗв/год  </p>' +
                   '<p> . <img src="qrc:/icons/thermometer-snow.svg" width="12" height="12">  00.00, °C  </p>'
                        anchors.fill: parent
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignRight
                        anchors.rightMargin: 25
                        anchors.leftMargin: 25
                        anchors.bottomMargin: 25
                        anchors.topMargin: 25
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

                    Rectangle{
                      id: linemarker
                      height: parent.height
                      width: 1
                      visible: false
                      color: "#bbff0000"
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
                        property bool isSelected
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
                                isMove = false;
                                isSelected = false
                                console.log("onReleased Move")
                            }

                            //draw vertical line if isnt moving
                            drawVertical(mapToItem(spectrumChart, mouse.x, mouse.y).x, isSelected)
                            //console.log("Released - " + "EndX: " + endX + "; EndY: " + endY + "\n");
                        }

                        onPressed: (mouse)=> {

                            if(mouse.button == Qt.LeftButton){
                                startX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                                startY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                                isZoom = true
                                isSelected = true
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

                        function drawVertical(x, visibleState) {
                            linemarker.visible = visibleState
                            var theValue = x
                            linemarker.x = mouseX - linemarker.width/2

                            console.log(visibleState)
                        }
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

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/

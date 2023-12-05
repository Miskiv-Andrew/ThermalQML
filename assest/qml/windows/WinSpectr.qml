import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import QtCharts 6.3

//---Styles
import "./modules/StyleParameters.qml" as Stl

Item {

    property real leftBoundry:  0
    property real rightBoundry: 2048


    function updateSpectrum(path) {
        //updating chart and adjust size in c++
        ssContext.updateFromFile(spectrumChart.series(0), path)
        //ssContext.updateFromFile(spectrumChart.series(1), path)
        adjustSize(leftBoundry, rightBoundry)
    }

    function clearChart(){
        spectrumSeries.clear()
        gausSeries.clear()
    }

    function adjustSize(left, right){

        valueAxisX.min = left;
        valueAxisX.max = right;
        leftBoundry = left
        rightBoundry = right
    }

    Rectangle {
        id: rectangleChart
        x: 10
        y: 10
        color: "#fafafa"
        radius: 10
        anchors.fill: parent
        anchors.margins: 0
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
            anchors.margins: 5

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    Layout.preferredHeight: 50
                    Layout.fillWidth: true

                    id: rectangleTop
                    color: "#f0f0f0"
                    radius: 10

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 0

                        Switch {
                            id: switchStartStopSpectr
                            text: qsTr("Почати накопичення")
                            font.pointSize: Stl.sFontSize
                        }

                        Switch {
                            id: switchLogarifmSpect
                            text: qsTr("Логарифмічна шкала")
                            font.pointSize: Stl.sFontSize
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Button {
                            Layout.preferredWidth: Stl.buttonWidth
                            Layout.preferredHeight: Stl.buttonHeight
                            display: AbstractButton.TextBesideIcon
                            icon.source: "qrc:/icons/eraser.svg"
                            text: "Очистити"
                            font.pointSize: Stl.sFontSize
                            onClicked: spectrumSeries.clear()
                        }
                    }
                }

                Rectangle {
                    id: rectangleSpectr
                    color: "#ffffff"
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ChartView {
                        id: spectrumChart
                        anchors.fill: parent
                        backgroundColor: "transparent"
                        anchors.margins: 0
                        antialiasing: false
                        legend.visible: false


                        ValueAxis {
                            id: valueAxisX
                            labelFormat: "%.0f"
                            labelsFont:Qt.font({pointSize: Stl.sFontSize})
                        }

                        ValueAxis {
                            id: valueAxisY
                            labelFormat: "%.0f"
                            //font.pointSize: fontSize - 4
                            labelsFont:Qt.font({pointSize: Stl.sFontSize})
                        }

                        LineSeries {
                            id: spectrumSeries
                            axisX: valueAxisX
                            axisY: valueAxisY
                        }

                        LineSeries {
                            id: gausSeries
                            axisX: valueAxisX
                            axisY: valueAxisY
                        }

                        TextEdit {
                            id: textEditSpectrumInfo
                            textFormat: Text.RichText
                            text: '<p> 000 сек  </p>' +
                                  '<p> 0000 (0000) cps  </p>' +
                                  '<p> 00.00 мкЗв/год  </p>' +
                                  '<p> 00.00 °C  </p>'
                            anchors.fill: parent
                            font.pixelSize: Stl.bFontSize
                            horizontalAlignment: Text.AlignRight
                            anchors.margins: 50
                        }

                        Rectangle{
                            id: zoomAreaRec
                            color: "#00000000"
                            border.color: "#50ff0000"
                            border.width: 2
                            radius: 4
                            clip: true
                            visible: false
                        }

                        Rectangle {
                            id: linemarker
                            y: spectrumChart.plotArea.top
                            height: spectrumChart.plotArea.height
                            width: 1
                            visible: false
                            color: "#bbff0000"

                            Rectangle {
                                anchors.top: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: 25
                                width: 40
                                color: "#bbff0000"
                                radius: 4

                                Text {
                                    anchors.fill: parent
                                    id: mcText
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pointSize: Stl.sFontSize
                                    text: ""


                                }
                            }
                        }

                        MouseArea {
                            id: crosshairMouseArea
                            anchors.fill: spectrumChart
                            hoverEnabled: true

                            Rectangle {
                                id: verticalCrosshair
                                y: spectrumChart.plotArea.top
                                x: crosshairMouseArea.mouseX - width / 2
                                height: spectrumChart.plotArea.height
                                width: 1
                                visible: false
                                color: "#bbff0000"

                                Rectangle {
                                    anchors.top: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    height: 25
                                    width: 40
                                    color: "#bbff0000"
                                    radius: 4

                                    Text {
                                        id: vcText
                                        anchors.fill: parent
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pointSize: Stl.sFontSize
                                        text: ""

                                    }
                                }
                            }

                            Rectangle {
                                id: horizontalCrosshair
                                x: spectrumChart.plotArea.left
                                y: crosshairMouseArea.mouseY - height / 2
                                width: spectrumChart.plotArea.width
                                height: 1
                                visible: false
                                color: "#bbff0000"

                                Rectangle {
                                    anchors.left: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    height: 25
                                    width: 40
                                    color: "#bbff0000"
                                    radius: 4

                                    Text {
                                        anchors.fill: parent
                                        id: hcText
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.pointSize: Stl.sFontSize
                                        text: ""

                                    }
                                }
                            }

                            onEntered: {
                                verticalCrosshair.visible = true;
                                horizontalCrosshair.visible = true;
                            }

                            onExited: {
                                verticalCrosshair.visible = false;
                                horizontalCrosshair.visible = false;
                            }

                            onPositionChanged: {
                                // Update the position of the crosshair elements based on the mouse position
                                verticalCrosshair.x = mouseX - 1 / 2;
                                horizontalCrosshair.y = mouseY - 1 / 2;

                                // Calculate channel and cps values based on the mouse position
                                var plotPos = spectrumChart.mapToValue(Qt.point(mouseX, mouseY));

                                // Set the channel and cps values based on your calculation
                                vcText.text = Math.floor(plotPos.x);
                                hcText.text = Math.floor(plotPos.y); // Replace with your actual calculation
                            }
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
                                            }
                                            if(isMove == true){
                                                isMove = false;
                                                isSelected = false
                                            }
                                            if(startX == endX){
                                                //draw vertical line if isnt moving
                                                drawVertical(mapToItem(spectrumChart, mouse.x, mouse.y).x, isSelected)
                                            }

                                            //horizontalCrosshair.visible = true
                                            //verticalCrosshair.visible = true

                                        }

                            onPressed: (mouse)=> {

                                           if(mouse.button == Qt.LeftButton){
                                               startX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                                               startY = mapToItem(spectrumChart, mouse.x, mouse.y).y;

                                               // Calculate channel and cps values based on the mouse position
                                               var plotPos = spectrumChart.mapToValue(Qt.point(mouseX, mouseY));
                                               mcText.text = Math.floor(plotPos.x)

                                               isZoom = true
                                               isSelected = true
                                           }
                                           else if(mouse.button == Qt.RightButton){
                                               previous = Qt.point(mouse.x, mouse.y);
                                               isMove = true
                                           }

                                       }

                            onPositionChanged: (mouse)=> {
                                                   if (isZoom == true){
                                                       endX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                                                       endY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                                                       updateRectangle(startX, startY, endX - startX, endY - startY, true);
                                                       linemarker.visible = false
                                                       //horizontalCrosshair.visible = false
                                                       //verticalCrosshair.visible = false
                                                   }

                                                   else if(isMove == true){

                                                       if(spectrumChart.isZoomed()) {

                                                           linemarker.visible = false

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
                            }
                        }

                        RangeSlider {
                            id: rangeSlider
                            anchors.left: parent.left
                            anchors.right: parent.right
                            //x: spectrumChart.plotArea.left
                            //width: spectrumChart.plotArea.width
                            //anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.rightMargin: 20
                            anchors.leftMargin: 20
                            anchors.bottomMargin: -10
                            from: 0
                            to: 2048

                            second.value: 2048
                            first.value: 0

                            first.onMoved: adjustSize(first.value, second.value)
                            second.onMoved: adjustSize(first.value, second.value)
                        }
                    }

                }
            }




        }
    }

    //    Timer {
    //        id: refreshTimer
    //        interval: 2 // 60 Hz
    //        running: true
    //        repeat: true
    //        onTriggered: {
    //            ssContext.update(spectrumChart.series(0));
    //        }
    //    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}D{i:23}
}
##^##*/

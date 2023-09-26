import QtQuick 2.15
import QtQuick.Controls 2.15

Slider {
    id: sliderTemp
    width: 200
    height: 20

    property color handelColor: "#5f64ff"

    property int stepInterval: 5 // Set the interval for displaying text
    readonly property int tickHeight: 5

    property alias highlight: rectangleHighlight

    handle: Rectangle {
        id: rectangleHandle
        x: sliderTemp.leftPadding + sliderTemp.visualPosition * (sliderTemp.availableWidth - width)
        width: 16
        height: 16
        radius: 8
        anchors.verticalCenter: parent.verticalCenter
        color: handelColor

        Rectangle{
            id: rectangleHighlight
            width: 60
            height: 30
            radius: 4
            anchors.left: parent.horizontalCenter
            color: handelColor
            anchors.bottom: parent.bottom
            anchors.leftMargin: -30
            anchors.bottomMargin: 25


            Text {
                id: valueTemp
                color: "white"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Poppins"
                text: "0 °C"
            }

            Rectangle{
                id: pointerSharp
                width: 10
                height: 10
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                rotation: 45
                anchors.topMargin: 25
                color: handelColor

            }

        }
    }


    Item {
        id: rowLayout
        parent: sliderTemp.background
        width: sliderTemp.width
        height: 8
        anchors.top: sliderTemp.bottom
        anchors.topMargin: 0


        Canvas {
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width
            height: 20
            anchors.topMargin: 15

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                var scaleSpacing = width / (sliderTemp.to - sliderTemp.from);
                var scaleHeight = tickHeight;
                var centerY = height / 2;

                ctx.strokeStyle = "black";
                ctx.lineWidth = 1;

                // Draw the scale
                for (var i = sliderTemp.from; i <= sliderTemp.to ; i+=stepInterval) {
                    var x = (i - sliderTemp.from) * scaleSpacing;
                    ctx.beginPath();
                    ctx.moveTo(x, centerY - scaleHeight / 2);
                    ctx.lineTo(x, centerY + scaleHeight / 2);
                    ctx.stroke();

                }

                // Draw the center indicator
                ctx.strokeStyle = "red";
                ctx.lineWidth = 2;
                var centerX = width / 2;
                ctx.beginPath();
                ctx.moveTo(centerX, centerY - scaleHeight);
                ctx.lineTo(centerX, centerY + scaleHeight);
                ctx.stroke();
            }
        }

    }
    onValueChanged: {
        valueTemp.text = sliderTemp.value.toFixed(2) + " °C"
    }


}

import QtQuick 2.15
import QtQuick.Controls 2.15

import "../modules"

Window {

    width: 800
    height: 300
    visible: true

    property var currentTemp: null
    property var targetTemp: null

    Connections {
        target: disp

        function onSend_qml_1_param(data) {
            textAreaLog.append(data)
        }

        function onSend_qml_2_param(data, temp) {
            textAreaLog.append(data)
            currentTemp.text = temp
        }
    }

    // Timer for update temperature lable
    Timer {
        id: updateTempLable
        interval: 2000 // 2 seconds
        repeat: true
        running: true

        onTriggered: {
            temperatureLable.text = `Цільова темепратура: ${targetTemp} / Поточна температура: ${currentTemp}`
        }
    }

    QtObject{
        id: f

        function connectFurnace(state){

            if(state){
                disp.qml_rec_order_heater(5, 0.0)
            }
            else{
                disp.qml_rec_order_heater(3, 0.0)
            }

        }

        function activateControllSysyem(state){

            if(state){
                disp.qml_rec_order_heater(2, 0.0);
            }
            else{
                disp.qml_rec_order_heater(3, 0.0);
            }

        }

    }

    Rectangle {
        id: bacground
        color: "#ffffff"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0

        Rectangle {
            id: content
            color: "#cbcbcb"
            radius: 10
            anchors.fill: parent
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 30


            ScrollView {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: rectangleControl.bottom
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                anchors.topMargin: 0

                TextArea {
                    id: textAreaLog
                    width: parent.width
                    height: parent.height
                    selectedTextColor: "#ffffff"
                    font.family: "Poppins"
                    font.pointSize: 12 // Adjust the height as neededs
                }
            }

            Rectangle {
                id: rectangleControl
                width: parent.width
                height: 100
                color: "#00000000"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Switch {
                    id: switchFurnaceConncet
                    height: 30
                    text: qsTr("Підключення до пічки")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    font.family: "Poppins"
                    font.pointSize: 14
                    anchors.leftMargin: 10
                    anchors.topMargin: 10
                    onClicked: f.connectFurnace(switchFurnaceConncet.state)
                }

                Switch {
                    id: switchControllSystem
                    height: 30
                    text: "Система контролю"
                    anchors.left: parent.left
                    anchors.top: switchFurnaceConncet.bottom
                    font.family: "Poppins"
                    font.pointSize: 14
                    anchors.leftMargin: 10
                    anchors.topMargin: 10
                    onClicked: f.activateControllSysyem(switchControllSystem.state)
                }

                Text {
                    id: temperatureLable
                    y: sliderTemp.y
                    width: sliderTemp.width
                    height: 30
                    text: qsTr("Цільова темепратура: -- / Поточна температура: --")
                    anchors.right: parent.right
                    anchors.top: sliderTemp.bottom
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.rightMargin: 10
                    font.family: "Poppins"
                    font.pointSize: 14
                    anchors.topMargin: 10

                }

                SceSlider {
                    id: sliderTemp
                    height: 30
                    anchors.left: switchFurnaceConncet.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 10
                    wheelEnabled: true
                    anchors.topMargin: 10
                    anchors.leftMargin: 10

                    snapMode: RangeSlider.SnapAlways
                    stepSize: 0.1
                    to: 75
                    from: -75
                    value: 0

                    // Timer to handle the delay
                    Timer {
                        id: delayTimer
                        interval: 2000 // 2 seconds
                        repeat: false
                        running: false

                        onTriggered: {
                            targetTemp = sliderTemp.value.toFixed(2)
                            // Send your temperature change command here
                            disp.qml_rec_order_heater(4, targetTemp)
                            console.log("Temperature command sent:", targetTemp)
                            //hide highlight when command accepted
                            sliderTemp.highlight.visible = false
                        }
                    }

                    // Handler for slider svalue changes
                    onValueChanged: {
                        // Restart the timer on every value change
                        sliderTemp.highlight.visible = true
                        delayTimer.restart()
                    }
                }

            }

        }
    }

}

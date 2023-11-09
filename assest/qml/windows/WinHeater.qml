import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../modules"

Window {

    width: 1200
    height: 400
    visible: true

    property double previosTemperature: 0
    property double currentTemperature: 0
    property double targetTemperature: 0
    property double nextTemperature: 0
    property double manualTemperature: 0

    property string currentMode: "Термокомпенсація"
    property string buttonOnState: "Увімкнути"

    property int timeLeft: 600
    property int timePassed: 600

    property int fontSize: 14

    Connections {
        target: disp

        function onSend_qml_1_param(data) {
            var currentTime = new Date();
            var formattedTime = currentTime.toLocaleTimeString(); // Форматируйте время, как вам нужно
            var message = formattedTime + data;
            textAreaLog.append(message);
        }

        function onSend_qml_2_param(data, temp) {
            var currentTime = new Date();
            var formattedTime = currentTime.toLocaleTimeString(); // Форматируйте время, как вам нужно
            var message = formattedTime + data;
            textAreaLog.append(message);
            currentTemp.text = temp;
        }
    }

    // Timer for update temperature lable
    Timer {
        id: updateTempLable
        interval: 2000 // 2 seconds
        repeat: true
        running: true

        onTriggered: {
            temperatureLable.text = `Цільова темепратура: ${targetTemperature} / Поточна температура: ${currentTemperature}`
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
        color: "#dbdcdc"
        anchors.fill: parent

        GridLayout {
            anchors.fill: parent
            anchors.margins: 20
            columns: 2
            columnSpacing: 20


            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 300
                id: contentList
                color: "white"
                radius: 10
                layer.enabled: true
                layer.effect: DropShadow {
                    color: "#a0676767"
                    transparentBorder: true
                    horizontalOffset: 2
                    verticalOffset: 4
                    radius: 4
                }
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                id: contentManual
                color: "white"
                radius: 10
                layer.enabled: true
                layer.effect: DropShadow {
                    color: "#a0676767"
                    transparentBorder: true
                    horizontalOffset: 2
                    verticalOffset: 4
                    radius: 4
                }


                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120
                        id: rectangleControl
                        color: "#00000000"

                        GridLayout {
                            anchors.fill: parent
                            anchors.margins: 20

                            columns: 2
                            rows: 2

                            Item {
                                Layout.fillHeight: true
                                Layout.preferredWidth: 300

                                Switch {
                                    id: switchFurnaceConncet
                                    text: qsTr("Підключення до пічки")
                                    anchors.fill: parent
                                    font.family: "Poppins"
                                    font.pointSize: fontSize
                                    onClicked: f.connectFurnace(switchFurnaceConncet.state)
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                SceSlider {
                                    id: sliderTemp
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    wheelEnabled: true
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
                                            targetTemperature = sliderTemp.value.toFixed(2)
                                            // Send your temperature change command here
                                            disp.qml_rec_order_heater(4, targetTemperature)
                                            console.log("Temperature command sent:", targetTemperature)
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

                            Item {
                                Layout.fillHeight: true
                                Layout.preferredWidth: 300

                                Switch {
                                    id: switchControllSystem
                                    anchors.fill: parent
                                    text: "Система контролю"
                                    font.family: "Poppins"
                                    font.pointSize: fontSize
                                    onClicked: f.activateControllSysyem(switchControllSystem.state)
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Text {
                                    id: temperatureLable
                                    anchors.fill: parent
                                    text: qsTr("Цільова темепратура: -- / Поточна температура: --")
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: "Poppins"
                                    font.pointSize: fontSize
                                }
                            }
                        }
                    }


                    ScrollView {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        TextArea {
                            id: textAreaLog
                            selectedTextColor: "#ffffff"
                            font.family: "Poppins"
                            font.pointSize: 12 // Adjust the height as neededs
                            background: Rectangle { color: "#00000000"; border.width: 1; border.color: "#e0e0e0"; radius: 10 }

                        }
                    }
                }
            }
        }
    }
}

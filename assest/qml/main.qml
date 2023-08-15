import QtQuick
import QtQuick.Controls 2.15
//---User Module Includes
import "modules"

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Rectangle {
        id: background
        color: ColorTheme.background
        anchors.fill: parent

        Button {
            x: 0
            y: 0
            width: 100
            height: 100
            text: "click"
            onClicked: f()
        }
    }

    function f() {
        console.log(ColorTheme.currentTheme)
    }
}

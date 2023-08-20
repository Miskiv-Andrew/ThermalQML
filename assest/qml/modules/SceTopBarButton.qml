import QtQuick 2.0
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Button{
    id: btnTopBar
    property url btnIcon: ""
    property color colorMouseOver: "#40ffffff"
    property color colorMouseDown: "#50ffffff"
    property real opacityIcon: 0
    flat: true

    QtObject{
        id: internal

        property var dynamicColor: if(btnTopBar.down){
                                       btnTopBar.down ? colorMouseDown : "#00000000"
                                   }else{
                                       btnTopBar.hovered ? colorMouseOver : "#00000000"
                                   }
    }

    width: 30
    height: 30
    background: Rectangle{
        id: bgBtnTopBar
        color: internal.dynamicColor


        Image {
            id: iconBtnTopBar
            anchors.verticalCenter: bgBtnTopBar.verticalCenter
            source: btnIcon
            anchors.horizontalCenter: bgBtnTopBar.horizontalCenter
            width: 12
            height: 12
            visible: true
            antialiasing: true
        }

        ColorOverlay{
            anchors.fill: iconBtnTopBar
            source: iconBtnTopBar
            color: "#CCCCCC"
            antialiasing: true
            opacity: opacityIcon
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:3}
}
##^##*/

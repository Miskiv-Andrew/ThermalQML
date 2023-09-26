import QtQuick 2.0
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects



Button{
    id: btnTopBar

    property bool activeMenu: false
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
    layer.enabled: false

    Rectangle{
        id: bgBtnTopBar
        color: internal.dynamicColor
        anchors.fill: parent


        Image {
            id: iconBtnTopBar
            anchors.verticalCenter: bgBtnTopBar.verticalCenter
            source: btnIcon
            anchors.horizontalCenter: bgBtnTopBar.horizontalCenter
            width: 15
            height: 15
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

    Rectangle{
        id: focusIndicator
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.verticalCenter: parent.verticalCenter
        width: 3
        height: 18
        color: "#b50000ff"
        radius: 2
        visible: activeMenu ? true : false
    }
}


/*##^##
Designer {
    D{i:0;height:30;width:30}D{i:5}
}
##^##*/

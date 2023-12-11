import QtQuick

Item {

    Connections { target: smContext }

    property real fontDelta: smContext.getValue("Font/deltaSize") || 2
    property real bFont: mFont + fontDelta
    property real mFont: smContext.getValue("Font/size") || 14
    property real sFont: mFont - fontDelta

    property real btnH: smContext.getValue("Control/btnHeight") || 40
    property real btnW: smContext.getValue("Control/btnWidth") || 160

    Component.onCompleted: {
        console.log("Font/size " + smContext.getValue("Font/size"))
    }

}




import QtQuick 2.15

Item {
    property int splitterWidth: 10

    property Item elementParent: null
    property Item element1: null
    property Item element2: null

    property string hoverColor: "#300000ff"
    property string defaultColor: "#000000ff"

    property bool movable: true // Set to true to allow moving the splitter
    property bool verticalOrientation: false // Set to true for a vertical splitter
    property variant topAnchor: verticalOrientation ?  undefined : element1.bottom
    property variant leftAnchor: verticalOrientation ? element1.right : undefined

    width: verticalOrientation ? splitterWidth : elementParent.width
    height: verticalOrientation ? elementParent.height : splitterWidth

    anchors {
        top: topAnchor
        left: leftAnchor
    }


    Rectangle {
        id: rectangleSplitter
        anchors.fill: parent
        radius: 5
        color: defaultColor

        MouseArea {
            id: mouseArea
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: movable ? (verticalOrientation ? Qt.SplitHCursor : Qt.SplitVCursor) : Qt.ArrowCursor
            property int startY: 0
            property int startX: 0
            property int startHeight: element1.height
            property int startWidth: element1.width

            onEntered: {
                if (movable)
                    parent.color = hoverColor
            }

            onExited: parent.color = defaultColor

            onPressed: {
                if (movable) {
                    parent.color = hoverColor
                    startY = mouse.y
                    startX = mouse.x
                    startHeight = element1.height
                    startWidth = element1.width
                }
            }

            onReleased: {
                if (movable) {
                    //parent.color = defaultColor
                    var deltaY = mouse.y - startY
                    var deltaX = mouse.x - startX
                    if (verticalOrientation) {
                        element1.width = Math.max(0, Math.min(elementParent.width, startWidth + deltaX))
                    } else {
                        element1.height = Math.max(0, Math.min(elementParent.height, startHeight + deltaY))
                    }
                }
            }
        }
    }
}


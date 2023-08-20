import QtQuick
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtCharts 6.3

//---User Module Includes
import "modules"




Window {
    id: app
    width: 1280
    height: 720
    visible: true
    color: "#00000000"
    title: qsTr("UTC")

    // REMOVE TITLE BAR
    flags: Qt.Window | Qt.FramelessWindowHint

    // PROPERTIES
    property int windowStatus: 0
    property int windowMargin: 10

    // INTERNAL FUNCTIONS
    QtObject{
        id: internal

        // Close Left Top Menu Popup
        function closeLeftPopup(){
            topTitleMenusExited.running = true
            console.log("Closed Popup")
            leftPopupMenu.activeMenu = true
            leftPopupMenu.rotateNormal()
            topTitleMenus.visible = false
        }

        // Show Overlay
        function showOverlay(){
            colorOverlayApp.visible = true
            showOverlayAnimation.running = true
        }
        function closeOverlay(){
            hideOverlayAnimation.running = true
        }

        // Maximize Restore
        function maximizeRestore(){
            if(windowStatus == 0){
                app.showMaximized()
                windowStatus = 1
                windowMargin = 0
                buttonMaximize.btnIcon = "qrc:/icons/window-stack.svg"
            }
            else{
                app.showNormal()
                windowStatus = 0
                windowMargin = 10
                buttonMaximize.btnIcon = "qrc:/icons/window-fullscreen.svg"
            }
        }

        // If Maximized Restore
        function ifMaximizedRestore(){
            if(windowStatus == 1){
                app.showNormal()
                windowStatus = 0
                windowMargin = 10
                buttonMaximize.btnIcon = "qrc:/icons/window-fullscreen.svg"
            }
        }

        // Restore Margins
        function restoreMargins(){
            windowStatus = 0
            windowMargin = 10
            buttonMaximize.btnIcon = "qrc:/icons/window-fullscreen.svg"
        }
    }

    //FontStyle
    Item {

        id: fontstyle

        readonly property string ppBold:                ppBoldFont.name
        readonly property string ppItalic:              ppItalicFont.name
        readonly property string ppLight:               ppLightFont.name
        readonly property string ppMedium:              ppMediumFont.name
        readonly property string ppMediumItalic:        ppMediumItalicFont.name
        readonly property string ppRegular:             ppRegularFont.name
        readonly property string ppSemiBold:            ppSemiBoldFont.name
        readonly property string ppSemiBoldItalic:      ppSemiBoldItalicFont.name

        FontLoader{ id: ppBoldFont;             source: "qrc:/Fonts/Poppins-Bold.ttf" }
        FontLoader{ id: ppItalicFont;           source: "qrc:/Fonts/Poppins-Italic.ttf" }
        FontLoader{ id: ppLightFont;            source: "qrc:/Fonts/Poppins-Light.ttf" }
        FontLoader{ id: ppMediumFont;           source: "qrc:/Fonts/Poppins-Medium.ttf" }
        FontLoader{ id: ppMediumItalicFont;     source: "qrc:/Fonts/Poppins-MediumItalic.ttf" }
        FontLoader{ id: ppRegularFont;          source: "qrc:/Fonts/Poppins-Regular.ttf" }
        FontLoader{ id: ppSemiBoldFont;         source: "qrc:/Fonts/Poppins-SemiBold.ttf" }
        FontLoader{ id: ppSemiBoldItalicFont;   source: "qrc:/Fonts/Poppins-SemiBoldItalic.ttf" }

    }
    //ColorTheme
    Item {

        id: colortheme

        QtObject {
            id: themes
            readonly property var light: ["#07130f", "#daf1ea", "#b1ecd8", "#325fc8", "#315fc9"]
            readonly property var dark: ["#daf1ea", "#07130f", "#73338e", "#010403", "#a9bdea"]
        }

        property var currentTheme: themes.dark
        property alias themes: themes

        readonly property string text: currentTheme[0]
        readonly property string background: currentTheme[1]
        readonly property string primary: currentTheme[2]
        readonly property string secondary: currentTheme[3]
        readonly property string accent: currentTheme[4]

    }
    //SizeModel
    Item {

        id: sizemodule

        readonly property int topBarHeight: 30
        readonly property int leftMenuWidth: 35

    }

    Rectangle {
        id: background
        color: "#ffffff"
        anchors.fill: parent
        anchors.rightMargin: windowMargin
        anchors.leftMargin: windowMargin
        anchors.bottomMargin: windowMargin
        anchors.topMargin: windowMargin



        Rectangle {
            id: appContent
            color: "transparent"
            anchors.fill: parent
            clip: true

            SwipeView {
                id: swipeView
                anchors.left: leftMenuFrame.right
                anchors.right: parent.right
                anchors.top: topBarFrame.bottom
                anchors.bottom: parent.bottom
                currentIndex: 1
                onCurrentIndexChanged: {
                    buttonDevices.activeMenu = !currentIndex
                    buttonSettings.activeMenu = currentIndex
                }

                Page {
                    id: pageDevices


                    Rectangle {
                        id: rectangleDevices
                        color: "#dbdcdc"
                        anchors.fill: parent

                        ScrollView {
                            id: scrollViewDevices
                            anchors.fill: parent
                            padding: 0
                            rightPadding: 10
                            bottomPadding: 10
                            leftPadding: 10
                            topPadding: 10

                            Rectangle {
                                id: rectangleDevList
                                width: app.width*0.2
                                color: "#fafafa"
                                border.width: 0
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.topMargin: 10
                                anchors.bottomMargin: 10
                                radius: 10
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    color: "#a3676767"
                                    transparentBorder: true
                                    horizontalOffset: 2
                                    verticalOffset: 4
                                    radius: 4
                                }
                            }

                            Rectangle {
                                id: rectangleAdditional
                                color: "#00000000"
                                border.width: 0
                                anchors.left: rectangleDevList.right
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.rightMargin: 0
                                anchors.bottomMargin: 0
                                anchors.topMargin: 0
                                anchors.leftMargin: 10


                                Rectangle {
                                    id: rectangleChart
                                    x: 10
                                    y: 10
                                    height: parent.height/2
                                    color: "#fafafa"
                                    radius: 10
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 10
                                    anchors.topMargin: 10
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
                                    id: rectangleCoef
                                    x: 10
                                    height: parent.height/2
                                    color: "#fafafa"
                                    radius: 10
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: rectangleChart.bottom
                                    anchors.bottom: parent.bottom
                                    anchors.topMargin: 10
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 10
                                    anchors.bottomMargin: 10
                                    layer.enabled: true
                                    layer.effect: DropShadow {
                                        color: "#a0676767"
                                        transparentBorder: true
                                        horizontalOffset: 2
                                        verticalOffset: 4
                                        radius: 4

                                    }
                                }
                            }


                        }
                    }

                }

                Page {
                    id: pageSettings

                    Rectangle {
                        id: rectangleSettings
                        color: "#dbdcdc"
                        anchors.fill: parent

                        ScrollView {
                            id: scrollViewSettings
                            anchors.fill: parent

                            Rectangle {
                                id: rectangleSettingsContent
                                color: "#fafafa"
                                radius: 10
                                border.width: 0
                                anchors.fill: parent
                                anchors.rightMargin: 20
                                anchors.leftMargin: 20
                                anchors.bottomMargin: 20
                                anchors.topMargin: 20
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    color: "#a3676767"
                                    transparentBorder: true
                                    horizontalOffset: 2
                                    verticalOffset: 4
                                    radius: 4
                                }
                            }
                        }
                    }

                }

            }

            PageIndicator {
                id: indicator

                count: swipeView.count
                currentIndex: swipeView.currentIndex
                anchors.bottom: swipeView.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle{
                id: topBarFrame
                x: 298
                height: 30
                color: "#dbdcdb"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top


                DragHandler{
                    onActiveChanged: if(active){
                                         app.startSystemMove()
                                         internal.ifMaximizedRestore()
                                     }
                }

                Row {
                    id: rowTopBar
                    anchors.fill: parent
                    rightPadding: 5
                    spacing: 5
                    layoutDirection: Qt.RightToLeft

                    SceTopBarButton {
                        id: buttonClose
                        anchors.verticalCenter: parent.verticalCenter
                        btnIcon: "qrc:/icons/x-lg.svg"
                        onClicked: {
                            app.close()
                        }

                    }
                    SceTopBarButton {
                        id: buttonMaximize
                        anchors.verticalCenter: parent.verticalCenter
                        btnIcon: "qrc:/icons/window-fullscreen.svg"
                        onClicked: {
                            internal.maximizeRestore()
                        }
                    }

                    SceTopBarButton {
                        id: buttonMinimize
                        anchors.verticalCenter: parent.verticalCenter
                        btnIcon: "qrc:/icons/dash-lg.svg"
                        onClicked: {
                            app.showMinimized()
                            internal.restoreMargins()
                        }
                    }

                }

            }

            Rectangle {
                id: leftMenuFrame
                width: sizemodule.leftMenuWidth
                color: "#dbdcdb"
                anchors.left: parent.left
                anchors.top: topBarFrame.bottom
                anchors.bottom: parent.bottom


                Column {
                    id: columnLeftMenu
                    x: 0
                    y: 148
                    anchors.fill: parent
                    topPadding: rectangleDevList.y

                    SceLeftMenuButton {
                        id: buttonDevices
                        width: 30
                        btnIcon: "qrc:/icons/house.svg"
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: swipeView.setCurrentIndex(0)

                    }

                    SceLeftMenuButton {
                        id: buttonSettings
                        width: 30
                        btnIcon: "qrc:/icons/gear.svg"
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: 20
                        onClicked: swipeView.setCurrentIndex(1)

                    }
                }
            }
        }

    }

    MouseArea {
        id: leftResize
        width: 5
        anchors.left: background.left
        anchors.top: background.top
        anchors.bottom: background.bottom
        anchors.leftMargin: -5
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        cursorShape: Qt.SizeHorCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { app.startSystemResize(Qt.LeftEdge) }
        }
    }

    MouseArea {
        id: rightResize
        width: 5
        anchors.right: background.right
        anchors.top: background.top
        anchors.bottom: background.bottom
        anchors.rightMargin: -5
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        cursorShape: Qt.SizeHorCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { app.startSystemResize(Qt.RightEdge) }
        }
    }

    MouseArea {
        id: topResize
        height: 5
        anchors.left: background.left
        anchors.right: background.right
        anchors.top: background.top
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: -5
        cursorShape: Qt.SizeVerCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { app.startSystemResize(Qt.TopEdge) }
        }
    }

    MouseArea {
        id: bottomResize
        height: 5
        anchors.left: background.left
        anchors.right: background.right
        anchors.bottom: background.bottom
        anchors.bottomMargin: -5
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        cursorShape: Qt.SizeVerCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { app.startSystemResize(Qt.BottomEdge) }
        }
    }

    MouseArea {
        id: topLeftResize
        width: 10
        height: 10
        anchors.left: background.left
        anchors.top: background.top
        anchors.leftMargin: -10
        anchors.topMargin: -10
        cursorShape: Qt.SizeFDiagCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { app.startSystemResize(Qt.LeftEdge | Qt.TopEdge) }
        }
    }

    MouseArea {
        id: topRightResize
        width: 10
        height: 10
        anchors.right: background.right
        anchors.top: background.top
        anchors.rightMargin: -10
        anchors.topMargin: -10
        cursorShape: Qt.SizeBDiagCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { app.startSystemResize(Qt.RightEdge | Qt.TopEdge) }
        }
    }

    MouseArea {
        id: bottomLeftResize
        width: 10
        height: 10
        anchors.left: background.left
        anchors.bottom: background.bottom
        anchors.leftMargin: -10
        anchors.bottomMargin: -10
        cursorShape: Qt.SizeBDiagCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { app.startSystemResize(Qt.LeftEdge | Qt.BottomEdge) }
        }
    }

    MouseArea {
        id: bottomRightResize
        x: 1270
        y: 710
        width: 10
        height: 10
        anchors.right: background.right
        anchors.bottom: background.bottom
        rotation: 0
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        cursorShape: Qt.SizeFDiagCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { app.startSystemResize(Qt.RightEdge | Qt.BottomEdge) }
        }
    }

}





/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}D{i:20}D{i:25}D{i:23}D{i:31}D{i:22}
}
##^##*/

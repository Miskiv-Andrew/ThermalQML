import QtQuick 2.0

Item {
    // INTERNAL FUNCTIONS
    QtObject{
        id: internalFunction

        // PROPERTIES
        property int windowStatus: 0
        property int windowMargin: 10


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
}

import QtQuick
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtCharts 6.3
import Qt.labs.qmlmodels 1.0


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

        //---SPECTRUM CHAR

        function findClosestPoint(targetX, targetY) {
            var closestPoint;
            var minDistance = Number.MAX_VALUE;

            for (var i = 0; i < spectrumLine.count; i++) {
                var point = spectrumLine.at(i);
                var distance = Math.abs(point.x - targetX);
                if (distance < minDistance) {
                    closestPoint = point;
                    minDistance = distance;
                }
            }

            return closestPoint;
        }

        function showInfoRectangle(x, y) {
            infoRectangle.visible = true;
            infoRectangle.x = x - infoRectangle.width / 2;
            infoRectangle.y = y - infoRectangle.height - 10; // Adjust position
            infoText.text = "X: " + x.toFixed(2) + " Y: " + y.toFixed(2);
        }

        function hideInfoRectangle() {
            infoRectangle.visible = false;
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
        radius: 5
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
                anchors.leftMargin: 0
                currentIndex: 0
                onCurrentIndexChanged: {
                    buttonDevices.activeMenu = !currentIndex
                    buttonSettings.activeMenu = currentIndex
                }

                Page {
                    id: pageDevices


                    Rectangle {
                        id: rectangleDevices
                        color: "#dbdcdc"
                        radius: 5
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

                                ListView {
                                    id: listView
                                    anchors.fill: parent
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 10
                                    anchors.bottomMargin: 10
                                    anchors.topMargin: 10
                                    delegate: SceDeviceItem{

                                    }

                                    model: ListModel {
                                        ListElement {
                                            deviceNameStr: "Spectra №19000031"
                                            comPortNameStr: "COM1"
                                        }

                                        ListElement {
                                            deviceNameStr: "Spectra №19000033"
                                            comPortNameStr: "COM2"
                                        }

                                        ListElement {
                                            deviceNameStr: "Cadmium №18000032"
                                            comPortNameStr: "COM3"
                                        }

                                        ListElement {
                                            deviceNameStr: "BDBG-09 №16000034"
                                            comPortNameStr: "COM4"
                                        }
                                    }
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

                                    ChartView {
                                        id: spectrumChart
                                        anchors.fill: parent
                                        backgroundColor : "#00000000"
                                        margins.bottom: 0
                                        margins.top: 0
                                        margins.left: 0
                                        margins.right: 0
                                        antialiasing: true
                                        theme: ChartView.ChartThemeQt
                                        legend.visible: false

//                                        MouseArea {
//                                            anchors.fill: parent
//                                            hoverEnabled  : true

//                                            onClicked: {

//                                                var p = Qt.point(mouse.x, mouse.y);
//                                                var cp = spectrumChart.mapToValue(p, spectrumLine);
//                                                console.log(cp.x + " " + cp.y)


//                                                }
//                                        }

                                        MouseArea {
                                            id: chartMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true

                                            onClicked: {
                                                var mousePoint = mapFromItem(chartMouseArea, mouse.x, mouse.y);
                                                var xAxis = spectrumChart.axisX;
                                                var yAxis = spectrumChart.axisY;
                                                var xValue = xAxis.min + (xAxis.max - xAxis.min) * (mousePoint.x / spectrumChart.width);
                                                var yValue = yAxis.min + (yAxis.max - yAxis.min) * (1 - mousePoint.y / spectrumChart.height);

                                                var closestPoint = Qt.point(mouse.x, mouse.y); //internal.findClosestPoint(xValue, yValue);
                                                if (closestPoint) {
                                                    internal.showInfoRectangle(closestPoint.x, closestPoint.y);
                                                } else {
                                                    internal.hideInfoRectangle();
                                                }
                                            }
                                        }


                                        Rectangle {
                                            id: infoRectangle
                                            width: 100
                                            height: 25
                                            color: "#50505050"

                                            visible: false

                                            Text {
                                                id: infoText
                                                anchors.centerIn: parent
                                            }
                                        }

                                        LineSeries {
                                            id: spectrumLine
                                            XYPoint { x: 0; y:383}
                                            XYPoint { x: 1; y:886}
                                            XYPoint { x: 2; y:777}
                                            XYPoint { x: 3; y:915}
                                            XYPoint { x: 4; y:793}
                                            XYPoint { x: 5; y:335}
                                            XYPoint { x: 6; y:386}
                                            XYPoint { x: 7; y:492}
                                            XYPoint { x: 8; y:649}
                                            XYPoint { x: 9; y:421}
                                            XYPoint { x: 10; y:362}
                                            XYPoint { x: 11; y:27}
                                            XYPoint { x: 12; y:690}
                                            XYPoint { x: 13; y:59}
                                            XYPoint { x: 14; y:763}
                                            XYPoint { x: 15; y:926}
                                            XYPoint { x: 16; y:540}
                                            XYPoint { x: 17; y:426}
                                            XYPoint { x: 18; y:172}
                                            XYPoint { x: 19; y:736}
                                            XYPoint { x: 20; y:211}
                                            XYPoint { x: 21; y:368}
                                            XYPoint { x: 22; y:567}
                                            XYPoint { x: 23; y:429}
                                            XYPoint { x: 24; y:782}
                                            XYPoint { x: 25; y:530}
                                            XYPoint { x: 26; y:862}
                                            XYPoint { x: 27; y:123}
                                            XYPoint { x: 28; y:67}
                                            XYPoint { x: 29; y:135}
                                            XYPoint { x: 30; y:929}
                                            XYPoint { x: 31; y:802}
                                            XYPoint { x: 32; y:22}
                                            XYPoint { x: 33; y:58}
                                            XYPoint { x: 34; y:69}
                                            XYPoint { x: 35; y:167}
                                            XYPoint { x: 36; y:393}
                                            XYPoint { x: 37; y:456}
                                            XYPoint { x: 38; y:11}
                                            XYPoint { x: 39; y:42}
                                            XYPoint { x: 40; y:229}
                                            XYPoint { x: 41; y:373}
                                            XYPoint { x: 42; y:421}
                                            XYPoint { x: 43; y:919}
                                            XYPoint { x: 44; y:784}
                                            XYPoint { x: 45; y:537}
                                            XYPoint { x: 46; y:198}
                                            XYPoint { x: 47; y:324}
                                            XYPoint { x: 48; y:315}
                                            XYPoint { x: 49; y:370}
                                            XYPoint { x: 50; y:413}
                                            XYPoint { x: 51; y:526}
                                            XYPoint { x: 52; y:91}
                                            XYPoint { x: 53; y:980}
                                            XYPoint { x: 54; y:956}
                                            XYPoint { x: 55; y:873}
                                            XYPoint { x: 56; y:862}
                                            XYPoint { x: 57; y:170}
                                            XYPoint { x: 58; y:996}
                                            XYPoint { x: 59; y:281}
                                            XYPoint { x: 60; y:305}
                                            XYPoint { x: 61; y:925}
                                            XYPoint { x: 62; y:84}
                                            XYPoint { x: 63; y:327}
                                            XYPoint { x: 64; y:336}
                                            XYPoint { x: 65; y:505}
                                            XYPoint { x: 66; y:846}
                                            XYPoint { x: 67; y:729}
                                            XYPoint { x: 68; y:313}
                                            XYPoint { x: 69; y:857}
                                            XYPoint { x: 70; y:124}
                                            XYPoint { x: 71; y:895}
                                            XYPoint { x: 72; y:582}
                                            XYPoint { x: 73; y:545}
                                            XYPoint { x: 74; y:814}
                                            XYPoint { x: 75; y:367}
                                            XYPoint { x: 76; y:434}
                                            XYPoint { x: 77; y:364}
                                            XYPoint { x: 78; y:43}
                                            XYPoint { x: 79; y:750}
                                            XYPoint { x: 80; y:87}
                                            XYPoint { x: 81; y:808}
                                            XYPoint { x: 82; y:276}
                                            XYPoint { x: 83; y:178}
                                            XYPoint { x: 84; y:788}
                                            XYPoint { x: 85; y:584}
                                            XYPoint { x: 86; y:403}
                                            XYPoint { x: 87; y:651}
                                            XYPoint { x: 88; y:754}
                                            XYPoint { x: 89; y:399}
                                            XYPoint { x: 90; y:932}
                                            XYPoint { x: 91; y:60}
                                            XYPoint { x: 92; y:676}
                                            XYPoint { x: 93; y:368}
                                            XYPoint { x: 94; y:739}
                                            XYPoint { x: 95; y:12}
                                            XYPoint { x: 96; y:226}
                                            XYPoint { x: 97; y:586}
                                            XYPoint { x: 98; y:94}
                                            XYPoint { x: 99; y:539}
                                            XYPoint { x: 100; y:795}
                                            XYPoint { x: 101; y:570}
                                            XYPoint { x: 102; y:434}
                                            XYPoint { x: 103; y:378}
                                            XYPoint { x: 104; y:467}
                                            XYPoint { x: 105; y:601}
                                            XYPoint { x: 106; y:97}
                                            XYPoint { x: 107; y:902}
                                            XYPoint { x: 108; y:317}
                                            XYPoint { x: 109; y:492}
                                            XYPoint { x: 110; y:652}
                                            XYPoint { x: 111; y:756}
                                            XYPoint { x: 112; y:301}
                                            XYPoint { x: 113; y:280}
                                            XYPoint { x: 114; y:286}
                                            XYPoint { x: 115; y:441}
                                            XYPoint { x: 116; y:865}
                                            XYPoint { x: 117; y:689}
                                            XYPoint { x: 118; y:444}
                                            XYPoint { x: 119; y:619}
                                            XYPoint { x: 120; y:440}
                                            XYPoint { x: 121; y:729}
                                            XYPoint { x: 122; y:31}
                                            XYPoint { x: 123; y:117}
                                            XYPoint { x: 124; y:97}
                                            XYPoint { x: 125; y:771}
                                            XYPoint { x: 126; y:481}
                                            XYPoint { x: 127; y:675}
                                            XYPoint { x: 128; y:709}
                                            XYPoint { x: 129; y:927}
                                            XYPoint { x: 130; y:567}
                                            XYPoint { x: 131; y:856}
                                            XYPoint { x: 132; y:497}
                                            XYPoint { x: 133; y:353}
                                            XYPoint { x: 134; y:586}
                                            XYPoint { x: 135; y:965}
                                            XYPoint { x: 136; y:306}
                                            XYPoint { x: 137; y:683}
                                            XYPoint { x: 138; y:219}
                                            XYPoint { x: 139; y:624}
                                            XYPoint { x: 140; y:528}
                                            XYPoint { x: 141; y:871}
                                            XYPoint { x: 142; y:732}
                                            XYPoint { x: 143; y:829}
                                            XYPoint { x: 144; y:503}
                                            XYPoint { x: 145; y:19}
                                            XYPoint { x: 146; y:270}
                                            XYPoint { x: 147; y:368}
                                            XYPoint { x: 148; y:708}
                                            XYPoint { x: 149; y:715}
                                            XYPoint { x: 150; y:340}
                                            XYPoint { x: 151; y:149}
                                            XYPoint { x: 152; y:796}
                                            XYPoint { x: 153; y:723}
                                            XYPoint { x: 154; y:618}
                                            XYPoint { x: 155; y:245}
                                            XYPoint { x: 156; y:846}
                                            XYPoint { x: 157; y:451}
                                            XYPoint { x: 158; y:921}
                                            XYPoint { x: 159; y:555}
                                            XYPoint { x: 160; y:379}
                                            XYPoint { x: 161; y:488}
                                            XYPoint { x: 162; y:764}
                                            XYPoint { x: 163; y:228}
                                            XYPoint { x: 164; y:841}
                                            XYPoint { x: 165; y:350}
                                            XYPoint { x: 166; y:193}
                                            XYPoint { x: 167; y:500}
                                            XYPoint { x: 168; y:34}
                                            XYPoint { x: 169; y:764}
                                            XYPoint { x: 170; y:124}
                                            XYPoint { x: 171; y:914}
                                            XYPoint { x: 172; y:987}
                                            XYPoint { x: 173; y:856}
                                            XYPoint { x: 174; y:743}
                                            XYPoint { x: 175; y:491}
                                            XYPoint { x: 176; y:227}
                                            XYPoint { x: 177; y:365}
                                            XYPoint { x: 178; y:859}
                                            XYPoint { x: 179; y:936}
                                            XYPoint { x: 180; y:432}
                                            XYPoint { x: 181; y:551}
                                            XYPoint { x: 182; y:437}
                                            XYPoint { x: 183; y:228}
                                            XYPoint { x: 184; y:275}
                                            XYPoint { x: 185; y:407}
                                            XYPoint { x: 186; y:474}
                                            XYPoint { x: 187; y:121}
                                            XYPoint { x: 188; y:858}
                                            XYPoint { x: 189; y:395}
                                            XYPoint { x: 190; y:29}
                                            XYPoint { x: 191; y:237}
                                            XYPoint { x: 192; y:235}
                                            XYPoint { x: 193; y:793}
                                            XYPoint { x: 194; y:818}
                                            XYPoint { x: 195; y:428}
                                            XYPoint { x: 196; y:143}
                                            XYPoint { x: 197; y:11}
                                            XYPoint { x: 198; y:928}
                                            XYPoint { x: 199; y:529}
                                            XYPoint { x: 200; y:776}
                                            XYPoint { x: 201; y:404}
                                            XYPoint { x: 202; y:443}
                                            XYPoint { x: 203; y:763}
                                            XYPoint { x: 204; y:613}
                                            XYPoint { x: 205; y:538}
                                            XYPoint { x: 206; y:606}
                                            XYPoint { x: 207; y:840}
                                            XYPoint { x: 208; y:904}
                                            XYPoint { x: 209; y:818}
                                            XYPoint { x: 210; y:128}
                                            XYPoint { x: 211; y:688}
                                            XYPoint { x: 212; y:369}
                                            XYPoint { x: 213; y:917}
                                            XYPoint { x: 214; y:917}
                                            XYPoint { x: 215; y:996}
                                            XYPoint { x: 216; y:324}
                                            XYPoint { x: 217; y:743}
                                            XYPoint { x: 218; y:470}
                                            XYPoint { x: 219; y:183}
                                            XYPoint { x: 220; y:490}
                                            XYPoint { x: 221; y:499}
                                            XYPoint { x: 222; y:772}
                                            XYPoint { x: 223; y:725}
                                            XYPoint { x: 224; y:644}
                                            XYPoint { x: 225; y:590}
                                            XYPoint { x: 226; y:505}
                                            XYPoint { x: 227; y:139}
                                            XYPoint { x: 228; y:954}
                                            XYPoint { x: 229; y:786}
                                            XYPoint { x: 230; y:669}
                                            XYPoint { x: 231; y:82}
                                            XYPoint { x: 232; y:542}
                                            XYPoint { x: 233; y:464}
                                            XYPoint { x: 234; y:197}
                                            XYPoint { x: 235; y:507}
                                            XYPoint { x: 236; y:355}
                                            XYPoint { x: 237; y:804}
                                            XYPoint { x: 238; y:348}
                                            XYPoint { x: 239; y:611}
                                            XYPoint { x: 240; y:622}
                                            XYPoint { x: 241; y:828}
                                            XYPoint { x: 242; y:299}
                                            XYPoint { x: 243; y:343}
                                            XYPoint { x: 244; y:746}
                                            XYPoint { x: 245; y:568}
                                            XYPoint { x: 246; y:340}
                                            XYPoint { x: 247; y:422}
                                            XYPoint { x: 248; y:311}
                                            XYPoint { x: 249; y:810}
                                            XYPoint { x: 250; y:605}
                                            XYPoint { x: 251; y:801}
                                            XYPoint { x: 252; y:661}
                                            XYPoint { x: 253; y:730}
                                            XYPoint { x: 254; y:878}
                                            XYPoint { x: 255; y:305}
                                            XYPoint { x: 256; y:320}
                                            XYPoint { x: 257; y:736}
                                            XYPoint { x: 258; y:444}
                                            XYPoint { x: 259; y:626}
                                            XYPoint { x: 260; y:522}
                                            XYPoint { x: 261; y:465}
                                            XYPoint { x: 262; y:708}
                                            XYPoint { x: 263; y:416}
                                            XYPoint { x: 264; y:282}
                                            XYPoint { x: 265; y:258}
                                            XYPoint { x: 266; y:924}
                                            XYPoint { x: 267; y:637}
                                            XYPoint { x: 268; y:62}
                                            XYPoint { x: 269; y:624}
                                            XYPoint { x: 270; y:600}
                                            XYPoint { x: 271; y:36}
                                            XYPoint { x: 272; y:452}
                                            XYPoint { x: 273; y:899}
                                            XYPoint { x: 274; y:379}
                                            XYPoint { x: 275; y:550}
                                            XYPoint { x: 276; y:468}
                                            XYPoint { x: 277; y:71}
                                            XYPoint { x: 278; y:973}
                                            XYPoint { x: 279; y:131}
                                            XYPoint { x: 280; y:881}
                                            XYPoint { x: 281; y:930}
                                            XYPoint { x: 282; y:933}
                                            XYPoint { x: 283; y:894}
                                            XYPoint { x: 284; y:660}
                                            XYPoint { x: 285; y:163}
                                            XYPoint { x: 286; y:199}
                                            XYPoint { x: 287; y:981}
                                            XYPoint { x: 288; y:899}
                                            XYPoint { x: 289; y:996}
                                            XYPoint { x: 290; y:959}
                                            XYPoint { x: 291; y:773}
                                            XYPoint { x: 292; y:813}
                                            XYPoint { x: 293; y:668}
                                            XYPoint { x: 294; y:190}
                                            XYPoint { x: 295; y:95}
                                            XYPoint { x: 296; y:926}
                                            XYPoint { x: 297; y:466}
                                            XYPoint { x: 298; y:84}
                                            XYPoint { x: 299; y:340}
                                            XYPoint { x: 300; y:90}
                                            XYPoint { x: 301; y:684}
                                            XYPoint { x: 302; y:376}
                                            XYPoint { x: 303; y:542}
                                            XYPoint { x: 304; y:936}
                                            XYPoint { x: 305; y:107}
                                            XYPoint { x: 306; y:445}
                                            XYPoint { x: 307; y:756}
                                            XYPoint { x: 308; y:179}
                                            XYPoint { x: 309; y:418}
                                            XYPoint { x: 310; y:887}
                                            XYPoint { x: 311; y:412}
                                            XYPoint { x: 312; y:348}
                                            XYPoint { x: 313; y:172}
                                            XYPoint { x: 314; y:659}
                                            XYPoint { x: 315; y:9}
                                            XYPoint { x: 316; y:336}
                                            XYPoint { x: 317; y:210}
                                            XYPoint { x: 318; y:342}
                                            XYPoint { x: 319; y:587}
                                            XYPoint { x: 320; y:206}
                                            XYPoint { x: 321; y:301}
                                            XYPoint { x: 322; y:713}
                                            XYPoint { x: 323; y:372}
                                            XYPoint { x: 324; y:321}
                                            XYPoint { x: 325; y:255}
                                            XYPoint { x: 326; y:819}
                                            XYPoint { x: 327; y:599}
                                            XYPoint { x: 328; y:721}
                                            XYPoint { x: 329; y:904}
                                            XYPoint { x: 330; y:939}
                                            XYPoint { x: 331; y:811}
                                            XYPoint { x: 332; y:940}
                                            XYPoint { x: 333; y:667}
                                            XYPoint { x: 334; y:705}
                                            XYPoint { x: 335; y:228}
                                            XYPoint { x: 336; y:127}
                                            XYPoint { x: 337; y:150}
                                            XYPoint { x: 338; y:984}
                                            XYPoint { x: 339; y:658}
                                            XYPoint { x: 340; y:920}
                                            XYPoint { x: 341; y:224}
                                            XYPoint { x: 342; y:422}
                                            XYPoint { x: 343; y:269}
                                            XYPoint { x: 344; y:396}
                                            XYPoint { x: 345; y:81}
                                            XYPoint { x: 346; y:630}
                                            XYPoint { x: 347; y:84}
                                            XYPoint { x: 348; y:292}
                                            XYPoint { x: 349; y:972}
                                            XYPoint { x: 350; y:672}
                                            XYPoint { x: 351; y:850}
                                            XYPoint { x: 352; y:625}
                                            XYPoint { x: 353; y:385}
                                            XYPoint { x: 354; y:222}
                                            XYPoint { x: 355; y:299}
                                            XYPoint { x: 356; y:640}
                                            XYPoint { x: 357; y:42}
                                            XYPoint { x: 358; y:898}
                                            XYPoint { x: 359; y:713}
                                            XYPoint { x: 360; y:298}
                                            XYPoint { x: 361; y:190}
                                            XYPoint { x: 362; y:524}
                                            XYPoint { x: 363; y:590}
                                            XYPoint { x: 364; y:209}
                                            XYPoint { x: 365; y:581}
                                            XYPoint { x: 366; y:819}
                                            XYPoint { x: 367; y:336}
                                            XYPoint { x: 368; y:732}
                                            XYPoint { x: 369; y:155}
                                            XYPoint { x: 370; y:994}
                                            XYPoint { x: 371; y:4}
                                            XYPoint { x: 372; y:379}
                                            XYPoint { x: 373; y:769}
                                            XYPoint { x: 374; y:273}
                                            XYPoint { x: 375; y:776}
                                            XYPoint { x: 376; y:850}
                                            XYPoint { x: 377; y:255}
                                            XYPoint { x: 378; y:860}
                                            XYPoint { x: 379; y:142}
                                            XYPoint { x: 380; y:579}
                                            XYPoint { x: 381; y:884}
                                            XYPoint { x: 382; y:993}
                                            XYPoint { x: 383; y:205}
                                            XYPoint { x: 384; y:621}
                                            XYPoint { x: 385; y:567}
                                            XYPoint { x: 386; y:504}
                                            XYPoint { x: 387; y:613}
                                            XYPoint { x: 388; y:961}
                                            XYPoint { x: 389; y:754}
                                            XYPoint { x: 390; y:326}
                                            XYPoint { x: 391; y:259}
                                            XYPoint { x: 392; y:944}
                                            XYPoint { x: 393; y:202}
                                            XYPoint { x: 394; y:202}
                                            XYPoint { x: 395; y:506}
                                            XYPoint { x: 396; y:784}
                                            XYPoint { x: 397; y:21}
                                            XYPoint { x: 398; y:842}
                                            XYPoint { x: 399; y:868}
                                            XYPoint { x: 400; y:528}
                                            XYPoint { x: 401; y:189}
                                            XYPoint { x: 402; y:872}
                                            XYPoint { x: 403; y:908}
                                            XYPoint { x: 404; y:958}
                                            XYPoint { x: 405; y:498}
                                            XYPoint { x: 406; y:36}
                                            XYPoint { x: 407; y:808}
                                            XYPoint { x: 408; y:753}
                                            XYPoint { x: 409; y:248}
                                            XYPoint { x: 410; y:303}
                                            XYPoint { x: 411; y:333}
                                            XYPoint { x: 412; y:133}
                                            XYPoint { x: 413; y:648}
                                            XYPoint { x: 414; y:890}
                                            XYPoint { x: 415; y:754}
                                            XYPoint { x: 416; y:567}
                                            XYPoint { x: 417; y:746}
                                            XYPoint { x: 418; y:368}
                                            XYPoint { x: 419; y:529}
                                            XYPoint { x: 420; y:500}
                                            XYPoint { x: 421; y:46}
                                            XYPoint { x: 422; y:788}
                                            XYPoint { x: 423; y:797}
                                            XYPoint { x: 424; y:249}
                                            XYPoint { x: 425; y:990}
                                            XYPoint { x: 426; y:303}
                                            XYPoint { x: 427; y:33}
                                            XYPoint { x: 428; y:363}
                                            XYPoint { x: 429; y:497}
                                            XYPoint { x: 430; y:253}
                                            XYPoint { x: 431; y:892}
                                            XYPoint { x: 432; y:686}
                                            XYPoint { x: 433; y:125}
                                            XYPoint { x: 434; y:152}
                                            XYPoint { x: 435; y:996}
                                            XYPoint { x: 436; y:975}
                                            XYPoint { x: 437; y:188}
                                            XYPoint { x: 438; y:157}
                                            XYPoint { x: 439; y:729}
                                            XYPoint { x: 440; y:436}
                                            XYPoint { x: 441; y:460}
                                            XYPoint { x: 442; y:414}
                                            XYPoint { x: 443; y:921}
                                            XYPoint { x: 444; y:460}
                                            XYPoint { x: 445; y:304}
                                            XYPoint { x: 446; y:28}
                                            XYPoint { x: 447; y:27}
                                            XYPoint { x: 448; y:50}
                                            XYPoint { x: 449; y:748}
                                            XYPoint { x: 450; y:556}
                                            XYPoint { x: 451; y:902}
                                            XYPoint { x: 452; y:794}
                                            XYPoint { x: 453; y:697}
                                            XYPoint { x: 454; y:699}
                                            XYPoint { x: 455; y:43}
                                            XYPoint { x: 456; y:39}
                                            XYPoint { x: 457; y:2}
                                            XYPoint { x: 458; y:428}
                                            XYPoint { x: 459; y:403}
                                            XYPoint { x: 460; y:500}
                                            XYPoint { x: 461; y:681}
                                            XYPoint { x: 462; y:647}
                                            XYPoint { x: 463; y:538}
                                            XYPoint { x: 464; y:159}
                                            XYPoint { x: 465; y:151}
                                            XYPoint { x: 466; y:535}
                                            XYPoint { x: 467; y:134}
                                            XYPoint { x: 468; y:339}
                                            XYPoint { x: 469; y:692}
                                            XYPoint { x: 470; y:215}
                                            XYPoint { x: 471; y:127}
                                            XYPoint { x: 472; y:504}
                                            XYPoint { x: 473; y:629}
                                            XYPoint { x: 474; y:49}
                                            XYPoint { x: 475; y:964}
                                            XYPoint { x: 476; y:285}
                                            XYPoint { x: 477; y:429}
                                            XYPoint { x: 478; y:343}
                                            XYPoint { x: 479; y:335}
                                            XYPoint { x: 480; y:177}
                                            XYPoint { x: 481; y:900}
                                            XYPoint { x: 482; y:238}
                                            XYPoint { x: 483; y:971}
                                            XYPoint { x: 484; y:949}
                                            XYPoint { x: 485; y:289}
                                            XYPoint { x: 486; y:367}
                                            XYPoint { x: 487; y:988}
                                            XYPoint { x: 488; y:292}
                                            XYPoint { x: 489; y:795}
                                            XYPoint { x: 490; y:743}
                                            XYPoint { x: 491; y:144}
                                            XYPoint { x: 492; y:829}
                                            XYPoint { x: 493; y:390}
                                            XYPoint { x: 494; y:682}
                                            XYPoint { x: 495; y:340}
                                            XYPoint { x: 496; y:541}
                                            XYPoint { x: 497; y:569}
                                            XYPoint { x: 498; y:826}
                                            XYPoint { x: 499; y:232}
                                        }
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

                                    TableView {
                                        anchors.fill: parent
                                        alternatingRows: true
                                        columnSpacing: 1
                                        rowSpacing: 1
                                        clip: true

                                        model: TableModel {
                                            TableModelColumn { display: "Name" }
                                            TableModelColumn { display: "50°C" }
                                            TableModelColumn { display: "40°C" }
                                            TableModelColumn { display: "30°C" }
                                            TableModelColumn { display: "20°C" }
                                            TableModelColumn { display: "10°C" }
                                            TableModelColumn { display: "0°C" }
                                            TableModelColumn { display: "-10°C" }
                                            TableModelColumn { display: "-20°C" }

                                            // Define the data
                                            rows: [
                                                { Name: "Темп.",   "50°C": 10, "40°C": 15, "30°C": 20, "20°C": 25, "10°C": 30, "0°C": 35, "-10°C": 40, "-20°C": 45 },
                                                { Name: "Код Uzm", "50°C": 8, "40°C": 12, "30°C": 16, "20°C": 20, "10°C": 24, "0°C": 28, "-10°C": 32, "-20°C": 36 },
                                                { Name: "Шум",     "50°C": 5, "40°C": 10, "30°C": 15, "20°C": 20, "10°C": 25, "0°C": 30, "-10°C": 35, "-20°C": 40 },
                                                { Name: "Сдвиг",   "50°C": 12, "40°C": 18, "30°C": 24, "20°C": 30, "10°C": 36, "0°C": 42, "-10°C": 48, "-20°C": 54 }
                                            ]
                                        }

                                        delegate: Rectangle {
                                            implicitWidth: 75
                                            implicitHeight: 30
                                            border.width: 1
                                            radius: 5

                                            Text {
                                                text: display
                                                font.family: "Poppins Medium"
                                                anchors.centerIn: parent
                                                font.styleName: "Poppins Light"
                                            }
                                        }
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
                radius: 5
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
                anchors.topMargin: 0


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
    D{i:0;formeditorZoom:0.9}D{i:32}
}
##^##*/

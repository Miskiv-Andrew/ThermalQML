import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import QtCharts 6.3

Item {
    visible: true
    width: 1200
    height: 500

    Rectangle {
        id: rectangleChart
        x: 10
        y: 10
        color: "#fafafa"
        radius: 10
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.topMargin: 0
        layer.enabled: true
        layer.effect: DropShadow {
            color: "#a0676767"
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 4
            radius: 4
        }

        Rectangle{
            id: content
            x: 10
            y: 10
            anchors.fill: parent
            anchors.margins: 5

            Rectangle {
                id: rectangleSpectr
                color: "#ffffff"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: rectangleTop.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 0



                ChartView {
                    id: spectrumChart
                    anchors.fill: parent
                    backgroundColor : "#00000000"
                    anchors.margins: 0
                    antialiasing: true
                    legend.visible: false


                    ValueAxis {
                        id: valueAxisX
                        labelFormat: "%.0f"
                    }

                    ValueAxis {
                        id: valueAxisY
                        labelFormat: "%.0f"
                    }

//                    BarSeries {
//                            id: mySeries
//                            //axisX: BarCategoryAxis { categories: [1, 2, 3, 4, 5, 6, 7, 8] }
//                            BarSet { label: "spectr"; values:       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 190, 91, 41, 21, 23, 37, 54, 116, 174, 255, 281, 399, 457, 442, 489, 523, 588, 544, 634, 634, 726, 695, 641, 812, 731, 743, 706, 675, 778, 627, 745, 697, 793, 701, 759, 757, 885, 769, 844, 903, 972, 950, 1009, 959, 1023, 983, 1055, 1016, 1090, 974, 1122, 1018, 1184, 1034, 1022, 1355, 1184, 1086, 1140, 1052, 1167, 1050, 1044, 1211, 1165, 1046, 1081, 1093, 1239, 1055, 1068, 1111, 1171, 1033, 1114, 1103, 1135, 979, 1047, 1020, 1061, 1049, 1090, 1001, 1074, 972, 1004, 1056, 1080, 929, 1027, 998, 1100, 904, 961, 986, 998, 961, 1030, 918, 1021, 929, 999, 896, 1026, 872, 1076, 874, 972, 844, 957, 842, 963, 850, 953, 783, 927, 786, 733, 1109, 877, 812, 903, 814, 913, 731, 786, 885, 860, 777, 836, 720, 854, 718, 796, 801, 812, 737, 845, 776, 862, 731, 842, 753, 890, 750, 875, 811, 963, 827, 977, 953, 971, 919, 1071, 943, 1087, 968, 1032, 1034, 1123, 985, 1206, 1043, 1166, 1059, 1084, 1051, 1153, 1099, 1164, 1054, 1129, 1027, 1118, 960, 1078, 932, 1056, 889, 1046, 913, 1023, 939, 937, 903, 893, 836, 876, 846, 782, 801, 889, 815, 769, 718, 775, 689, 782, 698, 839, 691, 698, 663, 740, 618, 697, 622, 702, 660, 647, 561, 682, 577, 725, 665, 722, 596, 611, 567, 610, 535, 590, 549, 619, 510, 556, 474, 554, 522, 551, 482, 533, 502, 526, 502, 544, 475, 510, 438, 483, 418, 502, 423, 507, 434, 323, 520, 447, 422, 453, 394, 433, 372, 403, 414, 498, 429, 436, 421, 459, 390, 383, 426, 471, 417, 414, 400, 435, 401, 426, 344, 412, 365, 402, 364, 404, 349, 384, 407, 399, 344, 361, 343, 418, 367, 397, 339, 412, 314, 385, 322, 417, 377, 408, 381, 366, 330, 367, 314, 389, 326, 330, 338, 424, 363, 336, 326, 408, 328, 356, 377, 403, 359, 353, 358, 391, 330, 327, 319, 360, 317, 354, 343, 363, 332, 334, 315, 350, 329, 363, 341, 384, 330, 369, 338, 369, 309, 356, 297, 339, 297, 404, 322, 361, 304, 350, 335, 373, 308, 348, 295, 331, 320, 346, 298, 390, 286, 345, 314, 348, 333, 338, 326, 330, 295, 355, 298, 333, 340, 368, 332, 359, 332, 394, 304, 347, 365, 366, 339, 350, 264, 320, 306, 375, 335, 336, 319, 329, 308, 324, 301, 360, 321, 338, 278, 333, 314, 379, 329, 335, 270, 317, 297, 354, 311, 405, 344, 350, 281, 340, 322, 372, 302, 334, 302, 327, 323, 318, 289, 304, 293, 314, 289, 331, 293, 296, 324, 360, 294, 335, 311, 336, 315, 340, 302, 355, 302, 433, 298, 371, 309, 327, 296, 350, 314, 288, 297, 313, 305, 337, 253, 315, 310, 338, 284, 341, 302, 351, 300, 341, 314, 341, 256, 347, 316, 307, 284, 327, 318, 364, 295, 340, 335, 319, 337, 340, 311, 310, 302, 349, 308, 332, 246, 331, 283, 337, 313, 356, 314, 342, 307, 345, 311, 303, 297, 333, 277, 331, 294, 364, 293, 272, 422, 346, 323, 306, 323, 337, 293, 325, 344, 375, 327, 311, 336, 340, 296, 320, 343, 368, 327, 357, 329, 333, 305, 338, 315, 344, 289, 347, 298, 381, 288, 329, 343, 382, 312, 341, 319, 379, 310, 340, 335, 326, 338, 383, 310, 342, 328, 344, 323, 357, 298, 297, 340, 389, 366, 375, 298, 373, 328, 335, 290, 359, 310, 327, 382, 401, 318, 378, 358, 369, 352, 337, 363, 401, 332, 361, 361, 380, 336, 339, 325, 397, 355, 374, 346, 399, 309, 371, 359, 398, 336, 404, 346, 391, 334, 427, 367, 423, 357, 373, 370, 451, 337, 402, 390, 436, 332, 379, 369, 438, 347, 396, 348, 417, 381, 416, 382, 412, 362, 427, 394, 467, 379, 376, 372, 404, 381, 395, 417, 372, 335, 372, 389, 395, 319, 372, 368, 439, 349, 330, 375, 344, 337, 382, 343, 378, 319, 393, 297, 332, 323, 353, 323, 320, 294, 321, 279, 345, 291, 326, 262, 311, 259, 324, 260, 316, 286, 290, 264, 287, 250, 259, 242, 248, 245, 266, 226, 267, 257, 269, 248, 279, 243, 260, 222, 256, 222, 254, 209, 257, 226, 277, 218, 272, 246, 285, 255, 245, 226, 255, 241, 258, 231, 277, 219, 277, 224, 254, 224, 261, 228, 236, 207, 238, 220, 240, 212, 273, 254, 230, 206, 251, 224, 229, 204, 229, 240, 233, 206, 231, 203, 201, 205, 231, 217, 195, 200, 231, 229, 239, 192, 220, 186, 228, 173, 206, 215, 254, 189, 217, 234, 237, 210, 252, 212, 235, 222, 275, 247, 287, 287, 289, 280, 338, 348, 426, 356, 400, 347, 412, 372, 438, 403, 473, 441, 500, 481, 539, 484, 557, 525, 566, 551, 580, 495, 633, 560, 746, 618, 681, 569, 638, 573, 614, 563, 599, 509, 581, 564, 608, 541, 611, 490, 543, 468, 505, 447, 513, 440, 451, 370, 432, 351, 395, 315, 339, 301, 345, 283, 338, 227, 264, 207, 232, 200, 188, 166, 172, 154, 168, 159, 145, 127, 151, 141, 110, 94, 123, 105, 115, 102, 116, 110, 104, 107, 130, 72, 115, 108, 135, 120, 140, 110, 165, 145, 149, 136, 207, 162, 215, 200, 225, 195, 243, 216, 261, 222, 298, 248, 342, 300, 333, 307, 394, 326, 416, 328, 436, 377, 446, 380, 455, 395, 556, 326, 477, 432, 460, 418, 523, 423, 449, 432, 483, 448, 472, 414, 473, 398, 452, 393, 439, 363, 371, 338, 390, 332, 375, 334, 306, 267, 313, 265, 310, 232, 298, 221, 232, 240, 234, 196, 187, 138, 184, 158, 162, 128, 145, 93, 110, 97, 114, 84, 92, 100, 99, 68, 80, 60, 63, 56, 61, 58, 40, 41, 48, 41, 58, 30, 40, 38, 26, 24, 32, 28, 34, 26, 20, 24, 25, 23, 27, 21, 30, 27, 20, 20, 22, 21, 26, 22, 20, 8, 19, 14, 16, 12, 20, 13, 24, 11, 19, 22, 19, 15, 19, 15, 18, 14, 19, 12, 8, 12, 12, 11, 16, 7, 13, 18, 16, 9, 8, 9, 18, 6, 18, 8, 11, 16, 12, 7, 16, 4, 14, 18, 9, 10, 11, 4, 2, 2, 5, 6, 12, 8, 7, 11, 6, 8, 13, 12, 13, 12, 17, 8, 10, 17, 13, 7, 13, 8, 13, 10, 11, 11, 9, 6, 12, 11, 13, 8, 5, 12, 6, 9, 10, 10, 5, 6, 7, 10, 3, 4, 5, 9, 12, 10, 4, 8, 12, 9, 11, 4, 7, 3, 5, 4, 4, 6, 11, 6, 10, 6, 3, 5, 10, 7, 6, 4, 12, 9, 7, 6, 9, 6, 4, 12, 1, 8, 8, 7, 8, 5, 6, 8, 9, 4, 3, 4, 7, 5, 7, 8, 4, 12, 12, 7, 5, 7, 5, 4, 5, 7, 14, 0, 7, 6, 4, 5, 4, 6, 6, 8, 9, 5, 5, 1, 5, 8, 6, 6, 6, 7, 5, 6, 6, 6, 6, 6, 8, 3, 7, 5, 3, 7, 4, 9, 2, 6, 2, 7, 2, 5, 4, 2, 5, 5, 7, 2, 2, 7, 7, 8, 8, 5, 0, 5, 5, 5, 3, 2, 6, 4, 5, 3, 6, 6, 6, 1, 3, 2, 5, 5, 5, 6, 4, 2, 5, 1, 8, 3, 3, 0, 6, 5, 6, 2, 3, 4, 5, 4, 2, 5, 2, 8, 4, 2, 7, 6, 3, 1, 3, 1, 5, 6, 2, 5, 4, 7, 4, 2, 3, 4, 3, 3, 6, 5, 5, 8, 4, 3, 2, 2, 4, 5, 3, 6, 5, 4, 2, 1, 3, 1, 1, 5, 2, 4, 2, 6, 1, 3, 4, 5, 5, 3, 5, 3, 1, 7, 1, 3, 2, 2, 6, 3, 3, 5, 6, 5, 3, 1, 6, 2, 10, 2, 2, 2, 4, 3, 2, 3, 1, 1, 4, 1, 3, 2, 1, 3, 3, 3, 3, 2, 5, 2, 0, 3, 3, 2, 1, 3, 2, 1, 6, 4, 5, 1, 5, 3, 5, 1, 3, 1, 2, 6, 2, 1, 3, 3, 1, 0, 4, 1, 2, 3, 2, 2, 4, 2, 2, 2, 2, 3, 6, 3, 3, 5, 2, 3, 5, 1, 3, 6, 3, 1, 6, 3, 2, 3, 2, 2, 6, 4, 4, 3, 5, 1, 2, 5, 5, 1, 4, 5, 2, 0, 1, 4, 4, 0, 4, 2, 2, 3, 5, 1, 3, 3, 2, 4, 6, 2, 3, 5, 2, 0, 3, 2, 1, 4, 1, 8, 2, 4, 4, 7, 3, 4, 1, 3, 4, 7, 3, 4, 4, 0, 1, 4, 5, 0, 5, 5, 8, 4, 10, 2, 6, 2, 3, 7, 0, 0, 6, 7, 3, 5, 2, 1, 1, 2, 4, 2, 5, 5, 2, 7, 5, 2, 5, 2, 3, 2, 5, 2, 4, 2, 4, 2, 1, 0, 1, 1, 3, 3, 3, 1, 1, 2, 2, 3, 2, 2, 2, 3, 5, 4, 2, 1, 2, 2, 4, 1, 2, 3, 1, 3, 2, 2, 5, 4, 3, 3, 1, 2, 5, 1, 4, 2, 4, 1, 1, 3, 0, 4, 0, 1, 4, 2, 3, 4, 5, 4, 1, 2, 2, 3, 3, 3, 4, 0, 1, 1, 0, 7, 1, 0, 1, 2, 3, 2, 1, 1, 4, 5, 1, 1, 2, 0, 2, 3, 1, 2, 1, 1, 1, 6, 2, 2, 0, 0, 0, 0, 2, 1, 1, 0, 2, 0, 3, 0, 0, 3, 0, 1, 2, 1, 0, 1, 3, 1, 0, 0, 2, 2, 2, 0, 3, 1, 2, 2, 1, 1, 4, 1, 1, 1, 0, 1, 2, 4, 5, 1, 3, 1, 3, 4, 0, 0, 2, 0, 2, 1, 2, 3, 3, 1, 0, 1, 3, 4, 2, 1, 0, 2, 2, 2, 3, 0, 4, 0, 1, 1, 1, 2, 0, 1, 1, 3, 3, 0, 1, 2, 3, 4, 2, 3, 2, 2, 1, 2, 3, 0, 3, 3, 2, 5, 2, 3, 2, 2, 1, 0, 2, 1, 2, 2, 1, 3, 0, 5, 3, 4, 4, 0, 2, 1, 3, 2, 3, 1, 1, 0, 2, 4, 0, 3, 2, 3, 2, 2, 1, 1, 2, 2, 2, 1, 5, 4, 0, 1, 0, 2, 2, 2, 3, 0, 1, 1, 2, 1, 3, 1, 1, 0, 1, 1, 0, 4, 2, 1, 0, 1, 0, 0, 2, 1, 2, 0, 0, 1, 0, 2, 3, 1, 0, 1, 3, 0, 1, 1, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 2, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 2, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 2, 1, 1, 1, 3, 6, 11, 13, 12, 2, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] }

//                        }

                    AreaSeries {
                        name: "Spectr"
                        axisX: valueAxisX
                        axisY: valueAxisY
                        color: "#700000ff"
                        upperSeries: LineSeries {
                            XYPoint { x: 1; y: 1 }
                            XYPoint { x: 5; y: 10 }
                            XYPoint { x: 50; y: 100 }
                            XYPoint { x: 100; y: 50 }
                            XYPoint { x: 200; y: 10 }
                            XYPoint { x: 400; y: 400 }
                            XYPoint { x: 600; y: 600}
                            XYPoint { x: 800; y: 400 }
                            XYPoint { x: 1000; y: 50 }

                        }
                    }

                    Rectangle {
                        id: spectrumInfo
                        height: parent.height
                        color: "#2400ff15"
                        width: 120
                        anchors.right: parent.right
                        radius: 10


                        // Add a property to track the state of the rectangle
                        property bool isExpanded: false

                        MouseArea {
                            id: addInfoMouseArea
                            anchors.fill: parent

                            onClicked: {
                                // Toggle the isExpanded property when clicked
                                spectrumInfo.isExpanded = !spectrumInfo.isExpanded
                            }

                            // Add hover effect to expand on hover
                            onEntered: {
                                if (!spectrumInfo.isExpanded)
                                    spectrumInfo.expandAnimation.start()
                            }
                            onExited: {
                                if (!spectrumInfo.isExpanded)
                                    spectrumInfo.shrinkAnimation.start()
                            }
                        }

                        /*
                        Text {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignTop
                            anchors.margins: 10
                            font.family: "Poppins"
                            font.pointSize: 12
                            text: "Час: --\nПЕД: --\nCPS: --"
                        }*/

                        TextEdit {
                            id: textEditSpectrumInfo
                            //                        text: "Час накопичення: 000 сек \n" +
                            //                              "Інтенсивність (інтегрована), cps: -\n" +
                            //                              "Інтенсивність (спектр), cps: -\n" +
                            //                              "ПЕД, мкЗв/год: -\n" +
                            //                              "Температура, °C: -\n"
                            textFormat: Text.RichText
                            text: '<p> <img src="qrc:/icons/clock.svg" width="14" height="14">  0000 сек  </p>' +
                                  '<p> <img src="qrc:/icons/asterisk.svg" width="14" height="14">  0000 cps  </p>' +
                                  '<p> <img src="qrc:/icons/radioactive.svg" width="14" height="14">  00.00 мкЗв  </p>' +
                                  '<p> <img src="qrc:/icons/thermometer-snow.svg" width="14" height="14">  00.00 °C  </p>'
                            anchors.fill: parent
                            font.pixelSize: 14
                            horizontalAlignment: Text.AlignRight
                            anchors.margins: 5
                        }

                        // Define an animation for expanding
                        SequentialAnimation {
                            id: expandAnimation
                            NumberAnimation {
                                target: spectrumInfo
                                property: "width"
                                to: parent.width*0.1
                                duration: 300
                            }
                            PropertyAction {
                                target: spectrumInfo
                                property: "height"
                                value: parent.height
                            }
                        }

                        // Define an animation for shrinking
                        SequentialAnimation {
                            id: shrinkAnimation
                            NumberAnimation {
                                target: spectrumInfo
                                property: "width"
                                to: parent.width * 0.05
                                duration: 300
                            }
                            PropertyAction {
                                target: spectrumInfo
                                property: "height"
                                value: parent.height
                            }
                        }

                        // Watch for changes in the isExpanded property and trigger animations accordingly
                        onIsExpandedChanged: {
                            if (isExpanded) {
                                expandAnimation.start()
                            } else {
                                shrinkAnimation.start()
                            }
                        }
                    }


                    TextEdit {
                        visible: false
                        id: textEditSpectrumInfo1
                        //                        text: "Час накопичення: 000 сек \n" +
                        //                              "Інтенсивність (інтегрована), cps: -\n" +
                        //                              "Інтенсивність (спектр), cps: -\n" +
                        //                              "ПЕД, мкЗв/год: -\n" +
                        //                              "Температура, °C: -\n"
                        textFormat: Text.RichText
                        text: '<p> <img src="qrc:/icons/clock.svg" width="12" height="12">  0000, сек  </p>' +
                              '<p> <img src="qrc:/icons/asterisk.svg" width="12" height="12">  0000 (0000), cps  </p>' +
                              '<p> <img src="qrc:/icons/radioactive.svg" width="12" height="12">  00.00, мкЗв/год  </p>' +
                              '<p>  <img src="qrc:/icons/thermometer-snow.svg" width="12" height="12">  00.00, °C  </p>'
                        anchors.fill: parent
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignRight
                        anchors.rightMargin: 25
                        anchors.leftMargin: 25
                        anchors.bottomMargin: 25
                        anchors.topMargin: 25
                    }

                    Rectangle{
                        id: zoomAreaRec
                        color: "#00000000"
                        border.color: "#50ff0000"
                        border.width: 2
                        radius: 10
                        clip: true
                        visible: false
                    }

                    Rectangle{
                        id: linemarker
                        height: parent.height
                        width: 1
                        visible: false
                        color: "#bbff0000"
                    }

                    MouseArea {
                        id: zoomMouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        //zoom chart
                        property real startX
                        property real startY
                        property real endX
                        property real endY

                        //drag chart
                        property bool isMove
                        property bool isZoom
                        property bool isSelected
                        property point previous: Qt.point(mouseX, mouseY)
                        property point scrollPoint
                        property double scale: -1.0
                        function reset(){
                            scrollPoint = Qt.point(0,0);
                        }

                        onReleased: (mouse)=> {
                                        if(isZoom == true){
                                            endX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                                            endY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                                            zoomChart();
                                            updateRectangle(0, 0, 0, 0, false);
                                            isZoom = false;

                                            console.log("onReleased Zoom")
                                        }
                                        if(isMove == true){
                                            isMove = false;
                                            isSelected = false
                                            console.log("onReleased Move")
                                        }

                                        //draw vertical line if isnt moving
                                        drawVertical(mapToItem(spectrumChart, mouse.x, mouse.y).x, isSelected)
                                        //console.log("Released - " + "EndX: " + endX + "; EndY: " + endY + "\n");
                                    }

                        onPressed: (mouse)=> {

                                       if(mouse.button == Qt.LeftButton){
                                           startX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                                           startY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                                           isZoom = true
                                           isSelected = true
                                           console.log("onPressed Qt.LeftButton")
                                       }
                                       else if(mouse.button == Qt.RightButton){
                                           previous = Qt.point(mouse.x, mouse.y);
                                           isMove = true
                                           console.log("onPressed Qt.RightButton")
                                       }



                                       //console.log("Pressed - " + "StartX: " + startX + "; StartY: " + startY + "\n");
                                   }

                        onPositionChanged: (mouse)=> {
                                               if (isZoom == true){

                                                   endX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                                                   endY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                                                   updateRectangle(startX, startY, endX - startX, endY - startY, true);
                                                   console.log("onPositionChanged Qt.LeftButton");
                                               }

                                               else if(isMove == true){

                                                   if(spectrumChart.isZoomed()) {

                                                       scrollPoint.x = (previous.x - mouse.x)*scale;
                                                       scrollPoint.y = (previous.y - mouse.y)*scale;

                                                       if(scrollPoint.y > 0)
                                                       {
                                                           spectrumChart.scrollUp(scrollPoint.y);
                                                           spectrumChart.scrollDown(0);
                                                       }
                                                       else{
                                                           spectrumChart.scrollDown(-scrollPoint.y);
                                                           spectrumChart.scrollUp(0);
                                                       }
                                                       if(scrollPoint.x > 0)
                                                       {
                                                           spectrumChart.scrollLeft(scrollPoint.x);
                                                           spectrumChart.scrollRight(0);
                                                       }
                                                       else{
                                                           spectrumChart.scrollLeft(0);
                                                           spectrumChart.scrollRight(-scrollPoint.x);
                                                       }

                                                       console.log("onPositionChanged Qt.RightButton");
                                                       previous = Qt.point(mouse.x, mouse.y);
                                                   }
                                               }
                                           }

                        function zoomChart() {
                            if (startX < endX) {
                                var r = Qt.rect(startX, startY, endX - startX, endY - startY);
                                spectrumChart.zoomIn(r);
                            }
                            if (startX > endX) {
                                spectrumChart.zoomReset();
                            }

                        }

                        function updateRectangle(x, y, w, h, draw) {
                            zoomAreaRec.visible = draw
                            zoomAreaRec.x = x
                            zoomAreaRec.y = y
                            zoomAreaRec.width = w
                            zoomAreaRec.height = h
                        }

                        function drawVertical(x, visibleState) {
                            linemarker.visible = visibleState
                            var theValue = x
                            linemarker.x = mouseX - linemarker.width/2

                            console.log(visibleState)
                        }
                    }


                }
            }

            Rectangle {
                id: rectangleTop
                height: 50
                color: "#f0f0f0"
                radius: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Switch {
                    id: switchStartStopSpectr
                    text: qsTr("Почати накопичення")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    font.pointSize: 12
                    font.family: "Arial"
                    anchors.leftMargin: 10
                }

                Switch {
                    id: switchLogarifmSpect
                    text: qsTr("Логарифмічна шкала")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: switchStartStopSpectr.right
                    font.pointSize: 12
                    font.family: "Arial"
                    anchors.leftMargin: 10
                }

                Button {
                    id: delayButtonClearSpectr
                    width: 100
                    height: 30
                    text: qsTr("Очистити")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    font.pointSize: 12
                    layer.mipmap: false
                    font.bold: false
                    font.family: "Arial"
                    anchors.rightMargin: 10
                }
            }

        }
    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/

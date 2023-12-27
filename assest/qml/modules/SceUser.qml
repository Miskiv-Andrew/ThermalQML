import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {

    property bool isExpanded: false
    property bool isAddInfo: false

    width: 40
    height: 40

    Rectangle {
        id: userAccount
        anchors.fill: parent
        anchors.margins: 0
        color: "transparent"
        radius: 100

        Rectangle {
            anchors.fill: parent
            anchors.margins: 5
            color: "darkOrange"
            radius: 100

            IconImage {
                anchors.fill: parent
                anchors.margins: 5
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source: "qrc:/icons/person.svg"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: isExpanded = !isExpanded
                onEntered: isAddInfo = true
                onExited: isAddInfo = false
            }
        }
    }

    Rectangle {
        id: expandWindow
        x: userAccount.x + userAccount.width - width - 5
        y: userAccount.y + userAccount.height + 10
        width: 400
        height: 300
        color: "gray"
        radius: 10
        visible: isExpanded

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10

            Text {
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: sm.sFont
                text: "UserName"
            }


            Rectangle {
                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
                Layout.alignment: Qt.AlignHCenter
                color: "darkOrange"
                radius: 100
                clip: true

                Image {
                    anchors.fill: parent
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    id: userImage
                    //source: "qrc:/icons/defaultLogo.png"
                    fillMode: Image.PreserveAspectCrop
                }

            }




            Text {
                Layout.alignment: Qt.AlignHCenter
                font.pointSize: sm.mFont
                text: "Вітаємо, UserName"
            }

            Button {
                Layout.alignment: Qt.AlignHCenter
                font.pointSize: sm.sFont
                text: "Курування обліковим записом"
            }


        }
    }
}

import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Window {
    id: windowLogin

    height:300
    width: 250

    ColumnLayout {
        Material.accent: Material.DeepOrange
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: bFontSize
            text: "Увійти"
        }

        Item { }

        TextArea  {
            Layout.fillWidth: true
            placeholderText: "Логін або ID"
        }

        TextArea  {
            Layout.fillWidth: true
            placeholderText: "Пароль"
        }

        Item { }

        Button {
            Layout.fillWidth: true
            Material.background: Material.DeepOrange
            text: "Вхід"
        }

    }
}

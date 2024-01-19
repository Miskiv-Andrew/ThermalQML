import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Window {
    id: windowLogin

    height:300
    width: 250

    signal userLoggedIn(string username)

    Connections {
        target: dsContext
    }

    ColumnLayout {
        Material.accent: Material.DeepOrange
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: sm.bFont
            text: "Увійти"
        }

        Item { }

        TextArea  {
            id: login
            Layout.fillWidth: true
            placeholderText: "Логін або ID"
        }

        TextArea  {
            id: pass
            Layout.fillWidth: true
            placeholderText: "Пароль"
        }

        Item { }

        Button {
            Layout.fillWidth: true
            Material.background: Material.DeepOrange
            text: "Вхід"

            onClicked: {
                var command = []
                command = ["connect_heater", login.text]
                dsContext.receive_data_from_QML(command)
                windowLogin.userLoggedIn(login.text);
                console.log(command)
            }
        }

    }
}

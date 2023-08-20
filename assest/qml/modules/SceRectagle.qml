import QtQuick

//Test component

Item {
    id: itm

    height: 100
    width: 100

    Rectangle{
        id: rec
        color: "green"
        height: 100
        width: 100

        Text {
            id: name
            text: qsTr("text")
        }
    }

}

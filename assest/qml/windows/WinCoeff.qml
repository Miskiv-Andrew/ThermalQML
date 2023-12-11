import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts

Item {

    property real leftBoundry:  0
    property real rightBoundry: 2048

    Item {
        id: param

        property int contentMargins: 10
        property int tableWidth: content.width

        property ListModel headerModel: ListModel {}

        property int tableColums: 11
        property int tableRows: 4

        property int tableColumnsSpacing: 0
        property int tableRowSpacing: 1

        property int tableCellRadius: 0
    }

    Rectangle {
        id: rectangleCoef
        radius: 10
        color: "#fafafa"
        anchors.fill: parent
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
            color: "#fafafa"
            anchors.fill: parent
            anchors.margins: 5

            ColumnLayout{
                anchors.fill: parent

                Rectangle {
                    Layout.preferredHeight: 50
                    Layout.fillWidth: true
                    color: "#f0f0f0"
                    radius: 10

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 0

                        CheckBox {
                            Layout.fillWidth: true
                            id: checkThermalCompOnOff
                            text: qsTr("Термокомпенсація")
                            font.pointSize: sm.sFont
                            focusPolicy: Qt.ClickFocus
                        }


                        Button {
                            Layout.preferredWidth: sm.btnW
                            Layout.preferredHeight: sm.btnH
                            display: AbstractButton.TextBesideIcon
                            icon.source: "qrc:/icons/chevron-bar-expand.svg"
                            text: "Зчитати"
                            font.pointSize: sm.sFont
                        }

                        Button {
                            Layout.preferredWidth: sm.btnW
                            Layout.preferredHeight: sm.btnH
                            display: AbstractButton.TextBesideIcon
                            icon.source: "qrc:/icons/chevron-bar-contract.svg"
                            text: "Зашити"
                            font.pointSize: sm.sFont
                        }

                    }
                }


                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    id: contentTable
                    color: "#a0a0a0"
                    radius: 10

                    onWidthChanged: {
                        param.tableWidth = contentTable.width;
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Row{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 25
                            id: rowHeader

                            Repeater{
                                model: param.headerModel
                                id: headerModel

                                Rectangle {
                                    id: headerDelegate
                                    width: ((parent.width/headerModel.count) - rowHeader.spacing)
                                    height: 25
                                    color: "transparent"

                                    Text {
                                        anchors.centerIn: parent
                                        text: model.headerText  // Use modelData to display the header text
                                        font.pointSize: sm.sFont
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 2
                            id: spacerHorizontal
                            color: "black"
                        }

                        TableView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            id: tableView

                            columnSpacing: param.tableColumnsSpacing
                            rowSpacing: param.tableRowSpacing
                            clip: true



                            //model: CoeffTableModel {
                            //    id: tableModel
                            //}

                            delegate: Rectangle {
                                implicitWidth: ((param.tableWidth/param.tableColums))
                                implicitHeight: 50
                                border.width: 0
                                radius: param.tableCellRadius
                                color: (model.row%2) ? "#f0f0f0" : "#ffffff"

                                TextInput {
                                    text: display
                                    selectByMouse: true
                                    anchors.fill: parent
                                    horizontalAlignment: TextEdit.AlignHCenter
                                    verticalAlignment: TextEdit.AlignVCenter
                                    font.pointSize: sm.sFont
                                    validator: DoubleValidator {
                                        top: 10000.00;
                                        bottom: -100.00;
                                        decimals: 2;
                                        //locale: Qt.locale("en_US")
                                        notation: DoubleValidator.StandardNotation }

                                    onEditingFinished: {

                                        console.log("Model index is: ", tableModel.index(row, column));
                                        var modifiedText = text.replace(",",".")
                                        //  write data to model //    setData method in tablemodel.cpp  //

                                        //first row of table always temperature
                                        if(row === 0) {
                                            tableModel.setData(tableModel.index(row, column), parseFloat(modifiedText), Qt.EditRole);
                                        }
                                        else{
                                            tableModel.setData(tableModel.index(row, column), parseInt(modifiedText), Qt.EditRole);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

import QtQuick


//--text: #07130f;
//--background: #daf1ea;
//--primary: #73338e;
//--secondary: #b1ecd8;
//--accent: #325fc8;
Item {

    QtObject {
        id: themes
        readonly property var light: ["#07130f", "#daf1ea", "#b1ecd8", "#325fc8", "#315fc9"]
        readonly property var dark: ["#daf1ea", "#07130f", "#73338e", "#010403", "#a9bdea"]
    }

    property var currentTheme: themes.light
    property alias themes: themes

    readonly property string text: currentTheme[0]
    readonly property string background: currentTheme[1]
    readonly property string primary: currentTheme[2]
    readonly property string secondary: currentTheme[3]
    readonly property string accent: currentTheme[4]
}

import QtQuick

Item {

    //sizes
    property real bFontSize: 18
    property real mFontSize: 14
    property real sFontSize: 10

    property real btnHeight: 40
    property real btnWidth: 150
    property real btnFontSize: 180

    property real radiusCommon: 10
    property real marginCommon: 10

    readonly property string ppBlackItalic:         ppBlackItalicFont.name
    readonly property string ppBold:                ppBoldFont.name
    readonly property string ppExtraBold:           ppExtraBoldFont.name
    readonly property string ppExtraBoldItalic:     ppExtraBoldItalicFont.name
    readonly property string ppExtraLight:          ppExtraLightFont.name
    readonly property string ppExtraLightItalic:    ppExtraLightItalicFont.name
    readonly property string ppItalic:              ppItalicFont.name
    readonly property string ppLight:               ppLightFont.name
    readonly property string ppMedium:              ppMediumFont.name
    readonly property string ppMediumItalic:        ppMediumItalicFont.name
    readonly property string ppRegular:             ppRegularFont.name
    readonly property string ppSemiBold:            ppSemiBoldFont.name
    readonly property string ppSemiBoldItalic:      ppSemiBoldItalicFont.name
    readonly property string ppThin:                ppThinFont.name
    readonly property string ppThinItalic:          ppThinItalicFont.name


    FontLoader{ id: ppBlackItalicFont;      source: "qrc:/Fonts/Poppins/Poppins-BlackItalic.ttf" }
    FontLoader{ id: ppBoldFont;             source: "qrc:/Fonts/Poppins/Poppins-Bold.ttf" }
    FontLoader{ id: ppExtraBoldFont;        source: "qrc:/Fonts/Poppins/Poppins-ExtraBold.ttf" }
    FontLoader{ id: ppExtraBoldItalicFont;  source: "qrc:/Fonts/Poppins/Poppins-ExtraBoldItalic.ttf" }
    FontLoader{ id: ppExtraLightFont;       source: "qrc:/Fonts/Poppins/Poppins-ExtraLight.ttf" }
    FontLoader{ id: ppExtraLightItalicFont; source: "qrc:/Fonts/Poppins/Poppins-ExtraLightItalic.ttf" }
    FontLoader{ id: ppItalicFont;           source: "qrc:/Fonts/Poppins/Poppins-Italic.ttf" }
    FontLoader{ id: ppLightFont;            source: "qrc:/Fonts/Poppins/Poppins-Light.ttf" }
    FontLoader{ id: ppMediumFont;           source: "qrc:/Fonts/Poppins/Poppins-Medium.ttf" }
    FontLoader{ id: ppMediumItalicFont;     source: "qrc:/Fonts/Poppins/Poppins-MediumItalic.ttf" }
    FontLoader{ id: ppRegularFont;          source: "qrc:/Fonts/Poppins/Poppins-Regular.ttf" }
    FontLoader{ id: ppSemiBoldFont;         source: "qrc:/Fonts/Poppins/Poppins-SemiBold.ttf" }
    FontLoader{ id: ppSemiBoldItalicFont;   source: "qrc:/Fonts/Poppins/Poppins-SemiBoldItalic.ttf" }
    FontLoader{ id: ppThinFont;             source: "qrc:/Fonts/Poppins/Poppins-Thin.ttf" }
    FontLoader{ id: ppThinItalicFont;       source: "qrc:/Fonts/Poppins/Poppins-ThinItalic.ttf" }


}

import QtQuick

Item {

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


    FontLoader{ id: ppBlackItalicFont;      source: "qrc:/Fonts/Poppins-BlackItalic.ttf" }
    FontLoader{ id: ppBoldFont;             source: "qrc:/Fonts/Poppins-Bold.ttf" }
    FontLoader{ id: ppExtraBoldFont;        source: "qrc:/Fonts/Poppins-ExtraBold.ttf" }
    FontLoader{ id: ppExtraBoldItalicFont;  source: "qrc:/Fonts/Poppins-ExtraBoldItalic.ttf" }
    FontLoader{ id: ppExtraLightFont;       source: "qrc:/Fonts/Poppins-ExtraLight.ttf" }
    FontLoader{ id: ppExtraLightItalicFont; source: "qrc:/Fonts/Poppins-ExtraLightItalic.ttf" }
    FontLoader{ id: ppItalicFont;           source: "qrc:/Fonts/Poppins-Italic.ttf" }
    FontLoader{ id: ppLightFont;            source: "qrc:/Fonts/Poppins-Light.ttf" }
    FontLoader{ id: ppMediumFont;           source: "qrc:/Fonts/Poppins-Medium.ttf" }
    FontLoader{ id: ppMediumItalicFont;     source: "qrc:/Fonts/Poppins-MediumItalic.ttf" }
    FontLoader{ id: ppRegularFont;          source: "qrc:/Fonts/Poppins-Regular.ttf" }
    FontLoader{ id: ppSemiBoldFont;         source: "qrc:/Fonts/Poppins-SemiBold.ttf" }
    FontLoader{ id: ppSemiBoldItalicFont;   source: "qrc:/Fonts/Poppins-SemiBoldItalic.ttf" }
    FontLoader{ id: ppThinFont;             source: "qrc:/Fonts/Poppins-Thin.ttf" }
    FontLoader{ id: ppThinItalicFont;       source: "qrc:/Fonts/Poppins-ThinItalic.ttf" }


}

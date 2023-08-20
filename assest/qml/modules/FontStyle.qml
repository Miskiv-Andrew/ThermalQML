import QtQuick

pragma Singleton

Item {

    readonly property string ppBlack:               ppBlackFont.name
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


    FontLoader{ id: ppBlackFont;            source: "./Fonts/Poppins-Black.ttf" }
    FontLoader{ id: ppBlackItalicFont;      source: "./Fonts/Poppins-BlackItalic.ttf" }
    FontLoader{ id: ppBoldFont;             source: "./Fonts/Poppins-Bold.ttfk.ttf" }
    FontLoader{ id: ppExtraBoldFont;        source: "./Fonts/Poppins-ExtraBold.ttf.ttf" }
    FontLoader{ id: ppExtraBoldItalicFont;  source: "./Fonts/Poppins-ExtraBoldItalic.ttf.ttf" }
    FontLoader{ id: ppExtraLightFont;       source: "./Fonts/Poppins-ExtraLight.ttf.ttf" }
    FontLoader{ id: ppExtraLightItalicFont; source: "./Fonts/Poppins-ExtraLightItalic.ttf.ttf" }
    FontLoader{ id: ppItalicFont;           source: "./Fonts/Poppins-Italic.ttf.ttf" }
    FontLoader{ id: ppLightFont;            source: "./Fonts/Poppins-Light.ttf.ttf" }
    FontLoader{ id: ppMediumFont;           source: "./Fonts/Poppins-Medium.ttf.ttf" }
    FontLoader{ id: ppMediumItalicFont;     source: "./Fonts/Poppins-MediumItalic.ttf.ttf" }
    FontLoader{ id: ppRegularFont;          source: "./Fonts/Poppins-Regular.ttf.ttf" }
    FontLoader{ id: ppSemiBoldFont;         source: "./Fonts/Poppins-SemiBold.ttf.ttf" }
    FontLoader{ id: ppSemiBoldItalicFont;   source: "./Fonts/Poppins-SemiBoldItalic.ttf.ttf" }
    FontLoader{ id: ppThinFont;             source: "./Fonts/Poppins-Thin.ttf.ttf" }
    FontLoader{ id: ppThinItalicFont;       source: "./Fonts/Poppins-ThinItalic.ttf.ttf" }


}

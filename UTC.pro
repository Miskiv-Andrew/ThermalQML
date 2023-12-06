QT += quick charts

SOURCES += \
    main.cpp

resources.files +=      assest/qml/main.qml \
                        assest/qml/modules/ColorTheme.qml
                        assest/qml/modules/FontStyle.qml


resources.prefix = /$${TARGET}
RESOURCES += resources \
    assest/res.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    assest/qml/main.qml \
    assest/qml/modules/ColorTheme.qml \
    assest/qml/modules/FontStyle.qml \
    assest/qml/modules/SceDeviceItem.qml \
    assest/qml/modules/SceLeftMenuButton.qml \
    assest/qml/modules/SceSlider.qml \
    assest/qml/modules/SceSpitter.qml \
    assest/qml/modules/SceTopBarButton.qml \
    assest/qml/modules/StyleParameters.qml \
    assest/qml/pages/PageDevice.qml \
    assest/qml/pages/PageSettings.qml \
    assest/qml/pages/PageTest.qml \
    assest/qml/scripts/SpectrumControlScript.qml \
    assest/qml/scripts/WindowControlScript.qml \
    assest/qml/windows/Test.qml \
    assest/qml/windows/WinCoeff.qml \
    assest/qml/windows/WinDevlist.qml \
    assest/qml/windows/WinHeater.qml \
    assest/qml/windows/WinSpectr.qml

HEADERS += \
    backend/dispatcher.h \
    backend/heater.h

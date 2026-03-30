cmake_minimum_required(VERSION 3.16)

project(mediaPlayerRemote VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Bluetooth Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appmediaPlayerRemote
    main.cpp
)

qt_add_qml_module(appmediaPlayerRemote
    URI mediaPlayerRemote
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES btagent.h btSocket.h
        SOURCES backend.h backend.cpp
        SOURCES settingsmanager.h settingsmanager.cpp
        SOURCES androidcontrol.h androidcontrol.cpp

        #pages
        QML_FILES Pages/ControlPage.qml
        QML_FILES Pages/ConnectionPage.qml
        QML_FILES Pages/SettingsPage.qml

        #custom Components
        RESOURCES CustomComponents/qmldir
        QML_FILES CustomComponents/CustomButton.qml CustomComponents/CustomButtonWithIcon.qml
        QML_FILES CustomComponents/CustomCheckBox.qml CustomComponents/CustomCollapsiblePanel.qml
        QML_FILES CustomComponents/CustomCombobox.qml CustomComponents/CustomComboboxWithIcon.qml
        QML_FILES CustomComponents/CustomPopupMenu.qml CustomComponents/CustomPopupMessage.qml
        QML_FILES CustomComponents/CustomProccessBar.qml CustomComponents/CustomSwitch.qml
        QML_FILES CustomComponents/CustomSwitchText.qml CustomComponents/CustomTextInput.qml CustomComponents/CustomTimer.qml
        QML_FILES CustomComponents/CustomSlider.qml CustomComponents/CustomTextInputForMacAddress.qml
        QML_FILES CustomComponents/CustomTextInputWithMask.qml

        #javascript scripts
        QML_FILES Pages/scripts.js

        #icons
        RESOURCES icons/bluetooth.png icons/wifi.png

)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appmediaPlayerRemote PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmediaPlayerRemote
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# add_subdirectory(../CommandHandler ../../build/CommandHandler_build)

target_link_libraries(appmediaPlayerRemote
    PRIVATE Qt6::Quick
    Qt6::Bluetooth
    Qt6::Core
    # CommandHandler
)

include(GNUInstallDirs)
install(TARGETS appmediaPlayerRemote
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

cmake_minimum_required(VERSION 3.16)

project(effortless VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(APP_PATH "src/app")
set(SIDEBAR_LEFT_QML_DIR "${APP_PATH}/sidebar/left")

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Widgets)

qt_standard_project_setup()

qt_add_executable(appeffortless ${APP_PATH}/main.cpp)

qt_add_qml_module(appeffortless
    URI effortless
    VERSION 1.0
    QML_FILES ${APP_PATH}/Main.qml
    QML_FILES ${SIDEBAR_LEFT_QML_DIR}/SidebarLeft.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appeffortless PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appeffortless
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appeffortless
    PRIVATE Qt6::Quick Qt6::Widgets
)

include(GNUInstallDirs)
install(TARGETS appeffortless
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

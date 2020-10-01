import QtQuick 1.1
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import com.settings.variables 1.0
import Qt.labs.gestures 2.0
import AppEngineQMLConstants 1.0

Item {
    id: cueBg
    width: APP.const_APP_SETTINGS_MAIN_SCREEN_WIDTH
    height: APP.const_APP_SETTINGS_MAIN_SCREEN_HEIGHT
    anchors.top: parent.top

    Image{
        z: 300
        anchors.top: parent.top
        anchors.topMargin:73
        anchors.left: parent.left
        visible:!isRightBg
        source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_L
    }

    Image{
        z: 300
        anchors.top: parent.top
        anchors.topMargin:73
        anchors.left: parent.left
        anchors.leftMargin:589
        visible:isRightBg
        source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_R
    }
}

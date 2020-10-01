import QtQuick 1.1
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import com.settings.variables 1.0
import Qt.labs.gestures 2.0
import AppEngineQMLConstants 1.0

Item {
    id: cueBg
    anchors.fill: parent

    Image{
        z: 300
        anchors.top: parent.top
        anchors.topMargin:73
        anchors.right: parent.right
        visible:!isRightBg
        source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_L
    }

    Image{
        z: 300
        anchors.top: parent.top
        anchors.topMargin:73
        anchors.right: parent.right
        anchors.rightMargin:585
        visible:isRightBg
        source: RES.const_URL_IMG_SETTINGS_CUE_SCREEN_BG_R
    }
}

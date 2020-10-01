import QtQuick 1.1

import com.settings.variables 1.0
import com.settings.defines 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES

DHAVN_AppSettings_FocusedItem{
    id: rootScreenManager

    property bool _videostatus

    width: 1280
    height: 627

    name: "RootScreenManager"

    default_x: 0
    default_y: 0
    focus_x: 0
    focus_y: 0
    property bool is_focused_BackButton: false

    //function changeVideoMode()
    //{
    //    rootScreenMainLoader.nested_state = APP.const_APP_SETTINGS_SCREEN_SET_VIDEO_MODE
    //}

    onVisibleChanged:
    {
        if(visible){

            rootScreenManager.hideFocus()
            rootScreenManager.setFocusHandle(0,0)
            rootScreenManager.showFocus()

        }
    }

    Rectangle
    {

       id: lockoutRect

       visible: true
       anchors.fill: parent

       color: "black"
       z:100

       Image
       {

           id: lockoutImg
           anchors.left: parent.left
           anchors.leftMargin: 562
           anchors.top: parent.top
           anchors.topMargin: 289 -93
           width: 162
           height: 161
           //y: 70// 289
           source: RES.const_URL_IMG_SETTINGS_DRS_BLOCK
       }


       Text
       {

           width: parent.width
           horizontalAlignment:Text.AlignHCenter

           anchors.top : lockoutImg.bottom
           text: qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SCREEN_DRS_INFO")) + LocTrigger.empty
           font.pointSize: 32
           color: "white"
           font.family: EngineListener.getFont(false)

       }

    }

    DHAVN_AppSettings_TitleBar
    {
        id: titleBar
        focus_x: 0
        focus_y: 0
        titleText: "STR_SETTING_SETTINGS_SCREEN_TITLE"

        z:200
        onFocus_visibleChanged: {

            //EngineListener.printLogMessage("DRS Focus_visible: " + focus_visible);
            if(focus_visible)
            {

            }
        }


        //onJogDown:
        //{
        //    if(focus_visible)
        //        is_focused_BackButton = true
        //}
    }

}

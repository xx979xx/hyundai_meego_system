import QtQuick 1.0
//import Transparency 1.0 //removed by junam 2013.09.30 for change raster
// import QmlStatusBarWidget 2.0  // removed by kihyung 2012.12.15 for STATUSBAR_NEW

import "DHAVN_VP_CONSTANTS.js" as CONST
import "../DHAVN_AppMediaPlayer_General.js" as AVPGEN // added by yungi 2013.10.10 for ITS 194869

//{ changed by junam 2013.09.30 for change raster
//TransparencyPainter
Item  //} changed by junam
{
    objectName: "videoRoot"
    id: main
    clip: true

    width:  CONST.const_SCREEN_WIDTH
    height: CONST.const_SCREEN_HEIGHT

    // { added by Sergey for CR#15575
    Connections
    {
        target: VideoEngine

        onBlackVideoOnRear:
        {
            EngineListenerMain.qmlLog("[MP] [QML] DHAVN_VP_rear_main :: onBlackVideo : bHide = ", bHide)
            blackMode.visible = bHide
        }
    }
// { added by yungi 2013.10.10 for ITS 194869
    Connections
    {
        target: EngineListenerMain
        onSetModeAreaOnlyBgRear:
        {
            EngineListenerMain.qmlLog("[MP] [QML] DHAVN_VP_main :: onSetModeAreaOnlyBgRear : bDimOn = ", bDimOn)
            modeAreaOnlyBg.visible =bDimOn
        }
    }

    Rectangle
    {
        id: modeAreaOnlyBg

        width: AVPGEN.const_APP_MEDIA_PLAYER_MAIN_SCREEN_WIDTH
        height: AVPGEN.const_STATUSBAR_WIDGET_Y // modified by yungi 2013.12.16 for ITS 215828

        color: Qt.rgba( 0, 0, 0, 0.8 )
        anchors.top: parent.top
        //anchors.topMargin: AVPGEN.const_APP_MEDIA_PLAYER_MODEAREA_SCREEN_HEIGHT // deleted by yungi 2013.12.16 for ITS 215828

        z: 500
        visible: false

        // { added by yungi 2013.12.16 for ITS 215828
        MouseArea
        {
            anchors.fill: parent
            enabled: modeAreaOnlyBg.visible
        }
        // } added by yungi 2013.12.16
    }
// } added by yungi

    Rectangle
    {
        id: blackMode
        visible: false
        anchors.fill:parent
        color: "black"
    }
    // } added by Sergey for CR#15575.

    // { removed by kihyung 2012.12.15 for STATUSBAR_NEW
    /*
    QmlStatusBarWidget
    {
       id:statusbar
       objectName: "statusBar"
       // { modified by eugeny.novikov 2012.08.25 for menu_btn_remove request
       isMenuBtnVisible: false

//       onVisibleChanged:
//       {
//           if( visible )
//           statusbar.isMenuBtnVisible = visible;
//       }
         // } modified by eugeny.novikov
    }
    */
    // } removed by kihyung 2012.12.15 for STATUSBAR_NEW
        
    Component.onCompleted : {
        EngineListener.notifyComplete(main, false);
    }
}


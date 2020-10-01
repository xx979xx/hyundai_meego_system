// { added by Sergey 04.08.2013 for ITS#179312
import QtQuick 1.1
import Qt.labs.gestures 2.0
import VPEnum 1.0 // added by wspark 2014.02.07 for ITS 224221

import QmlStatusBar 1.0
import QmlModeAreaWidget 1.0
import AppEngineQMLConstants 1.0

import "models"
import "components"
import "DHAVN_VP_CONSTANTS.js" as CONST


DHAVN_VP_FocusedItem
{
    id: main

    name: "VP_ModeArea" // added by Sergey 26.09.2013 for ITS#191542
    default_x: 0
    default_y: 0
        
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    
    visible: video_model.isShown


    onVisibleChanged:
    {
        if(video_model.isShown == true && visible == false)
            video_model.setIsShown(true)
    }


    Component.onCompleted:
    {
            modeArea.currentSelectedIndex = 0
            modeAreaModel.set(modeArea.currentSelectedIndex, {isVisible: true} )
    }

    Connections
    {
        target: video_model

        onTextChanged:
        {
            modeAreaModel.set(modeArea.currentSelectedIndex, {isVisible: true} )
            modeAreaModel.set( modeArea.currentSelectedIndex, {name: video_model.text})
        }
    }

    // { added by Sergey 26.09.2013 for ITS#191542
    Connections
    {
        target: EngineListener

        onFsAnimation: modeArea.bFullScreenAnimation = bOn

        onTitleBackground: modeAreaModel.isTrBG = bTrBG // added by cychoi 2014.05.16 for ITS 237528
    }

    // { added by cychoi 2014.01.09 for ITS 218953
    Connections
    {
        target: VideoEngine

        onSystemPopupShow:
        {
            // { modified by yungi 2014.02.11 No CR Fixed Focus now show   // { modified by wspark 2014.02.07 for ITS 224221
            if( disp == SM.disp)
                modeArea.is_popup_shown = bShown
            else
                modeArea.is_popup_shown = false
            // } modified by yungi 2014.02.11 // } modified by wspark
        }

        onLocalPopupShow:
        {
            // { modified by yungi 2014.02.11 No CR Fixed Focus now show // { modified by wspark 2014.02.07 for ITS 224221
            if( disp == SM.disp)
                modeArea.is_popup_shown = bShown
            else
                modeArea.is_popup_shown = false
            // } modified by yungi 2014.02.11  // } modified by wspark
        }
    }
    // } added by cychoi 2014.01.09


    
    function log(str)
    {
        EngineListenerMain.qmlLog("QML " + main.name + ": " + str);
    }
	// } added by Sergey 26.09.2013 for ITS#191542

// ===================================== SUB ELEMENTS ============================================

    GestureArea
    {
        width: modeArea.width
        height: modeArea.height
        anchors.verticalCenter: modeArea.verticalCenter
        anchors.horizontalCenter: modeArea.horizontalCenter

        Tap
        {
            onStarted: controller.onMousePressed()
            onFinished: controller.onMouseReleased()
        }
    }
    
    QmlModeAreaWidget
    {
        id: modeArea

        objectName: "modeArea"

        anchors.top: main.top
        anchors.horizontalCenter: main.horizontalCenter
        anchors.topMargin: (onScreen) ? CONST.const_MODEAREA_OFFSET_TOP : CONST.const_MODEAREA_OFFSET_TOP-CONST.const_FULL_SCREEN_OFFSET //-height modified by edo.lee 2013.08.09 ITS 183057

        mirrored_layout: EngineListenerMain.middleEast

        modeAreaModel: modeAreaModel
        isAVPMode: true // DUAL_KEY
        bAutoBeep: false // added by Sergey 19.11.2013 for beep issue

        property int focus_x : 0
        property int focus_y : 0
        property bool onScreen: true
        property bool bFullScreenAnimation: true


        onBeep: EngineListenerMain.ManualBeep(); // added by Sergey 19.11.2013 for beep issue
        onQmlLog: EngineListenerMain.qmlLog(Log); // added by oseong.kwon 2014.08.04 for show log


        onModeArea_BackBtn:
        {
            VideoEngine.setIsBackPressByJog(isJogDial);
            VideoEngine.setIsBackRRC(bRRC);
            controller.onSoftkeyBack();
        }

        // { modified by Sergey 26.10.2013 for ITS#198719
        onModeArea_RightBtn:
        {
            EngineListener.repaintUIQML(SM.disp);
            controller.listButtonHandler();
        }
        // } modified by Sergey 26.10.2013 for ITS#198719
        
        onModeArea_MenuBtn:  controller.menuButtonHandler()
        onModeAreaModelChanged: {}
        onJogEvent: controller.onJogEvent(arrow, status) // added by Sergey 03.10.2013 for ITS#193201


        // { modified by Sergey 11.08.2013
        Behavior on anchors.topMargin
        {
            PropertyAnimation
            {
               duration: (modeArea.bFullScreenAnimation) ? CONST.const_FULLSCREEN_DURATION_ANIMATION : 0 //modified by edo.lee 2013.08.10 ITS 0183704
               onRunningChanged:
               {
                    if(!running && modeArea.bFullScreenAnimation == false) //modified by edo.lee 2013.08.10 ITS 0183704
                        modeArea.bFullScreenAnimation = true; //modified by edo.lee 2013.08.10 ITS 0183704
               }
            }
        }
        // } modified by Sergey 11.08.2013



        QmlStatusBar
        {
            id: statusBar

            width: 1280;
            height: 93

            z:10;
            y: -93
            anchors.horizontalCenter: main.horizontalCenter

            homeType: "button"
            middleEast: EngineListenerMain.middleEast
        }
	}


    DHAVN_VP_Model_ModeArea_Main
    {
        id: modeAreaModel

        property bool counter_visible: video_model.counterVisible
        property int mode_area_counter_number: video_model.currentFile
        property int mode_area_counter_total: video_model.filesNumber
        property bool rb_visible: video_model.isListBtnVisible
        property bool mb_visible: video_model.menuBtnVisible
        property string rb_text: QT_TR_NOOP("STR_MEDIA_LIST_MENU")
        property string mb_text: QT_TR_NOOP("STR_SETTING_SYSTEM_DISPLAY")
        property bool right_text_visible: video_model.rTextVisible
        property string mode_area_right_text: video_model.rText
        property string icon: video_model.iconVisible ? video_model.icon : ""
        property bool isTrBG: true; //[KOR][ITS][0181269][minor](aettie.ji)
        property string name_fr: video_model.frText // added by cychoi 2014.07.17 for ITS 242695 (ITS 236729) title suffix
    }

}
// } added by Sergey 04.08.2013 for ITS#179312

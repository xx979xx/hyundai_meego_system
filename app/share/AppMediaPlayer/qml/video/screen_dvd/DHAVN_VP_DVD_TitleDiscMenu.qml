// { modified by Sergey 12.05.2013
import Qt 4.7
import QtQuick 1.1
import Qt.labs.gestures 2.0
import AppEngineQMLConstants 1.0


import "../components"
import "../DHAVN_VP_CONSTANTS.js" as CONST
import "../DHAVN_VP_RESOURCES.js" as RES //added by edo.lee 2013.02.27
import "../popUp/DHAVN_MP_PopUp_Resources.js" as RES_POPUP // added by yungi 2013.09.26 for ITS_NA 191163

DHAVN_VP_FocusedItem
{
    id: main

    width: CONST.const_SCREEN_WIDTH
    height: CONST.const_SCREEN_HEIGHT
    LayoutMirroring.enabled: east
    LayoutMirroring.childrenInherit: east

    default_x: 0
    default_y: 0

    property bool east: EngineListenerMain.middleEast
    property bool loadingMode : false  // added by lssanh 2013.05.18 ISV81619
    property bool fgLoadingMode : false // added by cychoi 2013.09.13 for ITS 190207 Infinite DVD Loading Screen
    property int loading_disp : 0 // added by yungi 2013.10.10 for ITS 194869
    property bool stoppingMode : false // added by cychoi 2015.08.28 for ITS 266537

    Connections
    {
        target: controller

        // { added by cychoi 2013.09.13 for ITS 190207 Infinite DVD Loading Screen
        onFgLoadingModeChanged:
        {
            main.fgLoadingMode  = onLoading;
        }
        // } added by cychoi 2013.09.13
        // { added by cychoi 2015.08.28 for ITS 266537
        onStoppingModeChanged:
        {
            main.stoppingMode  = onStopping;
            EngineListenerMain.qmlLog("[MP][QML] TitleDiscMenu :: onStoppingModeChanged : " + onStopping);
        }
        // } added by cychoi 2015.08.28
        onShowLockout:
        {
            lockoutRect.visible  = onShow;
            visualCue.visible  = !onShow;//added by eunhye 2013.04.19
            if(onShow) main.visible = onShow; //modfied by yungi 2013.10.06 for ITS 193569
            EngineListenerMain.qmlLog("[MP][QML] TitleDiscMenu :: onShowLockout : " + onShow);
        }
        // { added by eunhye 2013.03.22
        onHideTitleDiscMenu:
        {
            main.visible  = onHide;
            EngineListenerMain.qmlLog("[MP][QML] TitleDiscMenu :: onHideTitleDiscMenu : " + onHide);
        }
        // } added by eunhye 2013.03.22
        // { added by lssanh 2013.05.18 ISV81619
        onLoadingModeChanged:
        {
            EngineListenerMain.qmlLog("[MP][QML] TitleDiscMenu :: onLoadingModeChanged : " + onLoading);
            main.loadingMode  = onLoading;
        }
        // } added by lssanh 2013.05.18 ISV81619

        // { added by yungi 2013.10.10 for ITS 194869
        onTitleDiscLoadingDisplayCheck:
        {
            EngineListenerMain.qmlLog("[MP][QML] TitleDiscMenu :: onTitleDiscLoadingDisplayCheck : " + m_disp);
            main.loading_disp = m_disp
        }
        // } added by yungi
    }

    // { modified by cychoi 2014.06.19 for overlapped DMB/Camera screen and DVD Title/Disc Menu screen
    Rectangle
    {
        id: mainBgRect

        anchors.fill:parent
        visible: true
        color: ((main.loadingMode || main.fgLoadingMode || main.stoppingMode) && lockoutRect.visible == false) ? "black" : "transparent"

        Image
        {
            id: mainBg

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 205
            anchors.leftMargin: 32
            source: RES.const_URL_IMG_DVD_TITLE_BG
        }
    }
    // } modified by cychoi 2014.06.19

    Rectangle
    {
        id: lockoutRect //added by edo.lee 2013.02.26

        anchors.fill:parent
        visible: false
        color: "black"

        Image
        {
	//[KOR][ITS][181226][comment](aettie.ji)
            id : lockoutImg
           //anchors.horizontalCenter:parent.horizontalCenter
           anchors.left: parent.left
           anchors.leftMargin: 562
            anchors.top: parent.top
            anchors.topMargin: CONST.const_NO_PBCUE_LOCKOUT_ICON_TOP_OFFSET // modified by lssanh 2013.05.24 ISV84099
            source: RES.const_URL_IMG_LOCKOUT_ICON
        }

        Text
        {
            //anchors.horizontalCenter: parent.horizontalCenter
            //added by edo.lee 2013.06.22
             width: parent.width           
             horizontalAlignment:Text.AlignHCenter
	     //[KOR][ITS][181226][comment](aettie.ji)
           // anchors.top: parent.top
           // anchors.topMargin: CONST.const_NO_PBCUE_LOCKOUT_TEXT_TOP_OFFSET // modified by lssanh 2013.05.24 ISV84099
            anchors.top: lockoutImg.bottom
            //text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_CAPTION_VIDEO_DISABLED_INFO") + LocTrigger.empty
            text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_DISC_VCD_DRIVING_REGULATION") + LocTrigger.empty    //modified by edo.lee 2013.05.24        
            font.pointSize: 32//36 //modified by edo.lee 2013.05.24        
            color: "white"
        }
    }


    DHAVN_VP_4ArrowVisualCue
    {
        id: visualCue

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 339
        anchors.leftMargin: 910

        property int focus_x: 0
        property int focus_y: 0

        // { added by cychoi 2013.08.08 for default focus on 4 arrow visual cue
        onVisibleChanged:
        {
            if(visible)
             {
                //EngineListenerMain.qmlLog("[VP_DVD_TitleDiscMenu] onVisibleChanged:lostFocus :: visible: " + visible)
                // { modified by cychoi 2014.07.01 for focus handling on LCD ON/OFF (ITS 241667)
                if(VideoEngine.isVideoTempMode()==false) // modified by cychoi 2014.07.15 seperation isTempMode memeber variable
                {
                    main.setDefaultFocus( UIListenerEnum.JOG_DOWN ) 
                }
                // } modified by cychoi 2014.07.01
             }
            // { added by yungi 2013.11.08 for ITS 206323
            else
            {
                lTextColor = false
                jogOnReleased(1)
                jogOnReleased(5)
                jogOnReleased(7)
                jogOnReleased(3)
            }
            // } added by yungi
        }
        // } added by cychoi 2013.08.08

        onUpperArrowLongClicked: { lostFocus( UIListenerEnum.JOG_UP, 0 ) } // added by cychoi 2013.08.07 for ITS 181411 Move focus to Menu and Back SK's in DVD Title/Disc Menu
        onUpperArrowClicked: { controller.cursorKey(2) }
        onLeftArrowClicked: { controller.cursorKey(0) }
        onRightArrowClicked: { controller.cursorKey(1) }
        // { modified by yungi 2013.11.07 for ITS 207181
        onBottomArrowClicked:
        {
            if(modeAreaDownArrowEnabled)
            {
                controller.cursorKey(3)
                modeAreaDownArrowEnabled = false
            }
        }
        // } modified by yungi
        onCenterClicked: { controller.select() }

        // { added by yungi 2014.01.14 for ITS 219246
        onSignalVisualCueSelected:
        {
            SM.setDefaultFocus()
            main.showFocus()
        }
        // } added by yungi 2014.01.14
    }
    // { added by yungi 2013.09.26 for ITS_NA 191163

    //{ modified by yongkyun.lee 2013-11-11 for : NOCR JOG is no beep

    Rectangle
    {
        visible: ((main.loadingMode || main.fgLoadingMode) && lockoutRect.visible == false)
        width: CONST.const_SCREEN_WIDTH
        height: CONST.const_SCREEN_HEIGHT
        color: Qt.rgba( 0, 0, 0, CONST.const_POPUP_BG_BLACKOUT_1 )
        z: 1000

        Image
        {
            id: loadingPopupBg
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: CONST.const_POPUP_TYPEA_TOP_MARGIN
            anchors.leftMargin: CONST.const_POPUP_TYPEA_LEFT_MARGIN
            source : RES_POPUP.const_POPUP_TYPE_A

            // { modified by wspark 2014.01.13 for ITS 219467
            /*
            AnimatedImage
            {
                smooth: true
                anchors.horizontalCenter: parent.horizontalCenter
                y: CONST.const_LOADING_POPUP_TYPEA_ICON_TOP_MARGIN
                source: RES.const_URL_IMG_LOADING_ICON
            }
            */

            Image
            {
                id: idImageContainer
                source: RES.const_URL_IMG_LOADING_PATH + "loading_01.png"
                anchors.horizontalCenter: parent.horizontalCenter
                y: CONST.const_LOADING_POPUP_TYPEA_ICON_TOP_MARGIN
                visible: true

                // PROPERTIES
                SequentialAnimation on source {
                    running: idImageContainer.visible
                    loops: Animation.Infinite

                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_01.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_02.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_03.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_04.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_05.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_06.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_07.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_08.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_09.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_10.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_11.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_12.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_13.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_14.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_15.png"; easing.type: Easing.InOutQuad }
                    PropertyAnimation { duration: 100; to: RES.const_URL_IMG_LOADING_PATH + "loading_16.png"; easing.type: Easing.InOutQuad }
                }
            }
            // } modified by wspark

            Text
            {
                anchors.horizontalCenter: parent.horizontalCenter
                y: CONST.const_LOADING_POPUP_TYPEA_TEXT_TOP_MARGIN
                text: qsTranslate(CONST.const_LANGCONTEXT,"STR_MEDIA_LOADING") + LocTrigger.empty // modified by yungi 2013.04.16 ITS162630
                font { pointSize: 40; family: "DH_HDR"} // modified by yungi 2014.02.06 for ITS 223860
                color: CONST.const_FONT_COLOR_BRIGHT_GREY
            }
        }
        onVisibleChanged:
        {
            EngineListenerMain.qmlLog("[VP_DVD_TitleDiscMenu] SetModeAreaDim:" + visible + " , loading_disp:" + loading_disp) // modified by yungi 2013.10.10 for ITS 194869
            EngineListenerMain.qmlLog("[VP_DVD_TitleDiscMenu] loadingMode:" + main.loadingMode + " , fgLoadingMode:" + main.fgLoadingMode) // modified by yungi 2013.10.10 for ITS 194869

            EngineListenerMain.SetModeAreaDim(visible , main.loading_disp) // modified by yungi 2013.10.10 for ITS 194869
        }
    }

    // } added by yungi

 // { deleted by yungi 2013.09.26 for ITS_NA 191163
    // { added by lssanh 2013.05.18 ISV81619
    // } added by lssanh 2013.05.18 ISV81619
 // } deleted by yungi

}
// } modified by Sergey 12.05.2013

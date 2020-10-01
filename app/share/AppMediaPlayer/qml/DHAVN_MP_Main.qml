// { modified by Sergey for CR#16565
import Qt 4.7
import Qt.labs.gestures 2.0
import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppMediaPlayer_General.js" as AVPGEN
import "audio/DHAVN_AppMusicPlayer_General.js" as MPC
import "audio/DHAVN_AppMusicPlayer_Resources.js" as RES

Item
{
    id: mediaMain

    width: AVPGEN.const_APP_MEDIA_PLAYER_MAIN_SCREEN_WIDTH
    height: AVPGEN.const_APP_MEDIA_PLAYER_MAIN_SCREEN_HEIGHT

    focus: true
    property int popupInterval : 0 // added by wspark 2013.03.14 for ITS 158762
   //  property int pressedHardKey: 0 // added by suilyou 20130913 DUAL_KEY


    Component.onCompleted:
    {
        EngineListenerMain.SetRoot(mediaMain)
    }

    /* 2013.09.26 delete by youngsim.jo
    Item
    {
        id : loadingPopup

        anchors.fill: parent
        anchors.topMargin: 93 // modified by ravikanth 17-04-13
        smooth: true

        Image
        {
            id: bgImage
            source: RES.const_APP_MUSIC_PLAYER_URL_IMG_GENERAL_BACKGROUND_5
        }

        Text
        {
            id: loadingText

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: 333 - 93

            text: qsTranslate(MPC.const_APP_MUSIC_PLAYER_LANGCONTEXT, "STR_MEDIA_LOADING") + LocTrigger.empty // modified by yungi 2013.04.16 ITS162630
            font.pointSize: MPC.const_APP_MUSIC_PLAYER_FONT_SIZE_TEXT_HDB_40_FONT
            color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
        }

        AnimatedImage
        {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: loadingText.verticalCenter
            anchors.topMargin: 66

            source: RES.const_URL_IMG_LOADING_ICON
            smooth: true
        }

        MouseArea
        {
            anchors.fill: parent
            enabled: false
        }
    }
    */
    // { deleted by yungi 2013.10.10 for ITS 194869
    // { added by yungi 2013.09.27 for ITS_NA 191163
    // } added by yungi
    // } deleted by yungi


    Connections
    {
        target: EngineListenerMain

        onShowDeckErrPopup:
        {
            popup.source = "DHAVN_MP_Popup.qml"
            popup.item.setText(text)
            popup.item.setButtons(btn1, btn2)
            popup.visible = true
            // { modified by wspark for ITS 158762
            /*
            if(msec != 0)
                popTimer.start(msec)
            */
            popupInterval = msec
            if(msec != 0)
                popTimer.start()
            // } modified by wspark
        }
        //{added by aettie.ji 2013.02.05 for ISV 71489, 71340, 71339, 71338
        onRetranslateUi:
        {
            LocTrigger.retrigger()
        }
        //}added by aettie.ji 2013.02.05 for ISV 71489, 71340, 71339, 71338

        //onLoadComponent: loadingPopup.visible = false; // 2013.09.26 delete by youngsim.jo added by junam 2013.09.24 for fast agree

        //onSetModeAreaOnlyBg: modeAreaOnlyBg.visible = bDimOn //deleted by yungi 2013.10.10 for ITS 194869 // added by yungi 2013.09.27 for ITS_NA 191163
        //added by suilyou 20130930 ITS 0182895 START
        onChangedJogKeyPressed:
        {
            pressedHardKey = EngineListenerMain.getJogKeyPressed
            EngineListenerMain.qmlLog("onChangedHardKeyPressed =" + pressedHardKey)
        }
        onChangedJogKeyReleased:
        {
            pressedHardKey = EngineListenerMain.getJogKeyReleased
            EngineListenerMain.qmlLog("onChangedHardKeyReleased =" + pressedHardKey)
        }
        onChangedTouchPressed:
        {
            EngineListenerMain.qmlLog("onChangedTouchPressed =" + EngineListenerMain.getTouchPressed )
        }
        //added by suilyou 20130930 ITS 0182895 END
    }

    Connections
    {
        target: popup.item

        onButtonClicked:
        {
            popTimer.stop()
            popup.visible = false
        }
    }

    Loader { id: popup; z:500 }

    Timer
    {
        id: popTimer
        interval : popupInterval // added by wspark 2013.03.14 for ITS 158762
        onTriggered:
        {
            popup.visible = false
        }
    }
    /*
    MouseArea
    {
        id:id_mouseArea_block_filter
        anchors.fill: parent
        beepEnabled: false // added by Sregey 10.10.2013 for ITS#194837
        noClickAfterExited :true //added by junam 2013.10.23 for ITS_EU_197445
        z:100000
        enabled: pressedHardKey != 0 ? (EngineListenerMain.getCloneState4QML() ? true : false ) : false
        onEnabledChanged: {
            if(enabled==true)
                EngineListenerMain.qmlLog("Touch Blocking HardKeyPressing")
            else
                EngineListenerMain.qmlLog("NO Touch Blocking HardKeyPressing")

            EngineListenerMain.blockMouse = enabled; // added by Sergey 26.10.2013 for ITS#198513
        }
    } DUAL_KEY */
}
// } modified by Sergey for CR#16565

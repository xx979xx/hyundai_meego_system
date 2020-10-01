import Qt 4.7
import QmlModeAreaWidget 1.0
import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
import CQMLLogUtil 1.0

Item {
    id: pndrDrivingRestrictionView
    width: PR.const_PANDORA_ALL_SCREEN_WIDTH
    height: PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT
    y: PR.const_PANDORA_ALL_SCREENS_TOP_OFFSET

    //properties declaration
    property bool isFromErrorView: false
    property bool focusVisible: true //DrivingRestrictionView
    property bool backupFocus: false //true:explainView, false:modeArea //modified by jyjeon 2014-05-16 for ITS 236495
    //property bool isJogEventinModeArea: false // for Jog Events in mode area. //removed by jyjeon 2015-05-16 not used
    property bool isInsufficientEX: false;

    property string logString :""

    //Declaration of QML Signals
    //signal handleBackRequest
    signal handleBackRequest(bool isJogDial); //modified by esjang 2013.06.21 for Touch BackKey


    Rectangle
    {
       id: lockoutRect

       //visible: true//video_model.lockoutMode
       anchors.fill:parent

       color: "black"

       Image
       {

           id: lockoutImg
           anchors.left: parent.left
           anchors.leftMargin: 562
           y: 289 - 93 //( video_model.progressBarMode == "AUX" )? CONST.const_NO_PBCUE_LOCKOUT_ICON_TOP_OFFSET:CONST.const_LOCKOUT_ICON_TOP_OFFSET // modified by lssanh 2013.05.24 ISV84099
           source: PR_RES.const_APP_PANDORA_URL_IMG_LOCKOUT_ICON
       }

       Text
       {

           width: parent.width
           horizontalAlignment:Text.AlignHCenter
           anchors.top : lockoutImg.bottom
           text: qsTranslate("main", "STR_PANDORA_DRIVING_RESTRICTION");
           font.pointSize: 32//36//modified by edo.lee 2013.05.24
           color: "white"
       }

    }

    // MODE AREA
    QmlModeAreaWidget
    {
        id: drivingRestrictionViewModeAreaWidget
        bAutoBeep: false
        anchors.top: parent.top
        modeAreaModel: drivingRestrictionModeAreaModel
        //Properties Declaration
        search_visible: false
        onBeep: UIListener.ManualBeep(); // added by esjang for ITS # 217173  //deleted by cheolhwan 2014-01-09. ITS 218630.

        onModeArea_BackBtn:
        {
            __LOG ("QmlModeAreaWidget: onModeArea_BackBtn" , LogSysID.LOW_LOG );
            handleBackRequest(isJogDial);//modified by esjang 2013.06.21 for Touch BackKey
        }

        onLostFocus:
        {

                        pndrDrivingRestrictionView.focusVisible = false;
                        drivingRestrictionViewModeAreaWidget.showFocus();
                        drivingRestrictionViewModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);

        }

        ListModel
        {
            id: drivingRestrictionModeAreaModel
            property string text: qsTranslate("main","STR_PANDORA_WHY_THIS_SONG")
            property bool mb_visible: false;
            property bool rb_visible: false;
            property bool bb_visible: true;

        }
    }
    DHAVN_PandoraLoading{
        id:waitIndicator
        visible: false
        anchors.verticalCenter: pndrDrivingRestrictionView.verticalCenter
        //anchors.horizontalCenter: pndrExplainView.horizontalCenter
        x: PR.const_PANDORA_LOADING_WAIT_IMAGE_X_OFFSET  // add by cheolhwan 2013.11.28 for center align.
    }

    /***************************************************************************/
    /**************************** Private functions START **********************/
    /***************************************************************************/
    function __LOG( textLog , level)
    {
       logString = "DrivingRestriction.qml::" + textLog ;
       logUtil.log(logString , level);
    }

    //{ modified by yongkyun.lee 2014-03-11 for : ITS 228237
    function setInsufficient(isIns)
    {
        (isInsufficientEX = isIns);
    }
    //} modified by yongkyun.lee 2014-03-11


    // handles foreground event
    function handleForegroundEvent ()
    {
        pndrDrivingRestrictionView.visible = true;
       // waitIndicator.visible = true;
      //  pndrTrack.RequestExplaination();
    }

    // handle retranlateUI event
    function handleRetranslateUI(languageId)
    {
        LocTrigger.retrigger()
        drivingRestrictionViewModeAreaWidget.retranslateUI(PR.const_PANDORA_LANGCONTEXT);
    }
    function getWaitIndicatorStatus()
    {
        return waitIndicator.visible;
    }

    function isJogListenState()
    {
        var ret = true;
        if(waitIndicator.visible || drivingRestrictionViewModeAreaWidget.focus_visible)
        {
            ret = false;
        }
        return ret;
    }

    function handleJogKey(arrow , status)
    {
        __LOG("handlejogkey -> arrow : " + arrow + " , status : "+status , LogSysID.LOW_LOG );

    }

    function manageFocusOnPopUp(status)
    {
        __LOG("manageFocusOnPopUp -> status : " + status , LogSysID.LOW_LOG );

        if(status)
        {
            if(pndrDrivingRestrictionView.focusVisible)
            {
                pndrDrivingRestrictionView.focusVisible = false;
                pndrDrivingRestrictionView.backupFocus = true;
            }
            drivingRestrictionViewModeAreaWidget.hideFocus();
        }
        else
        {
            if(pndrDrivingRestrictionView.backupFocus)
            {
                pndrDrivingRestrictionView.backupFocus = false;
            pndrDrivingRestrictionView.focusVisible = true;
                drivingRestrictionViewModeAreaWidget.showFocus();
            }
            else
            {
                drivingRestrictionViewModeAreaWidget.showFocus();
            }
        }

    }

    Component.onCompleted: {
        activeView = pndrDrivingRestrictionView;
           handleForegroundEvent();
        //pndrDrivingRestrictionView.focusVisible = false;
        drivingRestrictionViewModeAreaWidget.showFocus();
        drivingRestrictionViewModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);

    }

    onVisibleChanged:
    {
        if(visible == false)
        {
            flick.contentX = 0;
            flick.contentY = 0;
        }
    }

    Connections
    {
        target: pndrTrack

    }
}

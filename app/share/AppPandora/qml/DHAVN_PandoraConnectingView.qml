import Qt 4.7
import QmlModeAreaWidget 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
import CQMLLogUtil 1.0

Item  {
    id: pndrConnectingView
    width: PR.const_PANDORA_ALL_SCREEN_WIDTH
    height: PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT
    y: PR.const_PANDORA_ALL_SCREENS_TOP_OFFSET
    visible: true
	
   // Declaration of Properties
    property int counter: PR.const_PANDORA_CONNECTING_VIEW_TIMER_COUNTER_MIN_VAL
    property bool isFromErrorView: false
    property bool isInsufficientCV: false;

    property string logString :""
	//Declaration of QML Signals
    //signal handleBackRequest
    signal handleBackRequest(bool isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
    signal deviceNotFound

    Image {
        id: connectingWaitImage
        x: PR.const_PANDORA_CONNECTING_WAIT_IMAGE_X_OFFSET
        y: PR.const_PANDORA_CONNECTING_WAIT_IMAGE_Y_OFFSET
        source: PR_RES.const_APP_PANDORA_CONNECTING_WAIT[counter]
        asynchronous : true
    }

    Text
    {
        id: connectingWaitText1
        x: PR.const_PANDORA_CONNECTING_WAIT_TEXT1_X_OFFSET
        y: PR.const_PANDORA_CONNECTING_WAIT_TEXT1_Y_OFFSET
        color: PR.const_PANDORA_CONNECTING_TEXT_COLOR
        horizontalAlignment: Text.AlignHCenter 
        verticalAlignment: Text.AlignVCenter 
        width: PR.const_PANDORA_CONNECTING_TEXT_WIDTH
        text: qsTranslate("main", "STR_PANDORA_CONNECTING_VIEW_TEXT1");
        font.pointSize: PR.const_PANDORA_CONNECTING_TEXT_FONT_SIZE
        font.family: PR.const_PANDORA_CONNECTING_TEXT_FONT_FAMILY
       
    }

    Text
    {
        id: connectingWaitText2
        x: PR.const_PANDORA_CONNECTING_WAIT_TEXT2_X_OFFSET
        y: PR.const_PANDORA_CONNECTING_WAIT_TEXT2_Y_OFFSET
        color: PR.const_PANDORA_CONNECTING_TEXT_COLOR
        horizontalAlignment: Text.AlignHCenter 
        verticalAlignment: Text.AlignVCenter 
        width: PR.const_PANDORA_CONNECTING_TEXT_WIDTH
		
        text: qsTranslate("main", "STR_PANDORA_CONNECTING_VIEW_TEXT2");
        font.pointSize: PR.const_PANDORA_CONNECTING_TEXT_FONT_SIZE
        font.family: PR.const_PANDORA_CONNECTING_TEXT_FONT_FAMILY
    }

    //{ added by esjang 2013.06.04 for ITS #166991
    Text
    {
        id: front_back_indicator_text
        /*
        anchors.left: pandoraLogo.right
        anchors.leftMargin: 10
        anchors.bottom: pandoraLogo.bottom
        anchors.bottomMargin: -16// -14
        */
        text: UIListener.getConnectTypeName()

       // x:  ( language == 2 || language == 7 ) ?  PR.const_PANDORA_MODEWIDGET_LOGO_TEXT1_X_OFFSET :

        anchors.left : pandoraLogo.right //modified by wonseok.heo NOCR for text location 2014.03.10 ( language == 2 || language == 7 ) ?  pndrConnectingView.left : pandoraLogo.right
        anchors.leftMargin: 28 //modified by wonseok.heo NOCR for text location 2014.03.10 (language == 2 || language == 7) ? PR.const_PANDORA_MODEWIDGET_LOGO_TEXT1_X_OFFSET : 28


        y: PR.const_PANDORA_MODEWIDGET_LOGO_TEXT1_Y_OFFSET

        z: 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: PR.const_PANDORA_LIGHT_DIMMED // modified by wonseok.heo NOCR for text location 2014.03.10 PR.const_PANDORA_COLOR_WHITE//const_PANDORA_COLOR_LOG_TEXT_GREY
        font.pointSize: 40
        font.family: "NewHDB"//"HDR"
        style: Text.Sunken
        visible: UIListener.GetVariantRearUSB() || UIListener.IsBTPandora() //modified by jyjeon 2014.01.11 for ITS 218524
    }
    //} added by esjang 2013.06.04 for ITS #166991

    Image{
        id: pandoraLogo
        source: PR_RES.const_APP_PANDORA_TRACK_VIEW_PANDORALOGO_IMAGE

        //(UIListener.GetVariantRearUSB) ? (anchors.left: front_back_indicator_text.right) : (x: PR.const_APP_PANDORA_TRACK_VIEW_PANDORALOGO_X_OFFSET)
        anchors.left : pndrConnectingView.left // { modified by wonseok.heo NOCR for text location 2014.03.10 ( front_back_indicator_text.text !=""  /*UIListener.GetVariantRearUSB()== true*/ ) ? //modified by jyjeon 2014.01.15 for ITS 219728
                           //(( language == 2 || language == 7 ) ? front_back_indicator_text.right : pndrConnectingView.left) :  pndrConnectingView.left }
        anchors.leftMargin: 42 //modified by wonseok.heo NOCR for text location 2014.03.10( language == 2 || language == 7 ) ? ( (front_back_indicator_text.text !="" /*UIListener.GetVariantRearUSB()*/== true )? 28 : 46 ) : 46 //modified by jyjeon 2014.01.15 for ITS 219728
        y: PR.const_APP_PANDORA_TRACK_VIEW_PANDORALOGO_Y_OFFSET
        z: 1
    }


    Timer
    {
        id: waitTimer
        interval: 100; //esjang modified 2013.09.06 for loading icon spec
        running: pndrConnectingView.visible;
        repeat: true

        onTriggered:
        {

            counter = counter + 1;

            if( counter == PR.const_PANDORA_TIMER_COUNTER_MAX_VAL )
            {
                counter = PR.const_PANDORA_TIMER_COUNTER_MIN_VAL;
            }
            connectingWaitImage.source = PR_RES.const_APP_PANDORA_CONNECTING_WAIT[counter];


        }
    }

/***************************************************************************/
/**************************** Private functions START **********************/
/***************************************************************************/

    function __LOG( textLog , level)
    {
       logString = "ConnectingView.qml::" + textLog ;
       logUtil.log(logString , level);
    }

    //{ modified by yongkyun.lee 2014-03-11 for : ITS 228237
    function setInsufficient(isIns)
    {
       (isInsufficientCV = isIns);
    }
    //} modified by yongkyun.lee 2014-03-11 
    

     // handles foreground event
    function handleForegroundEvent ()
    {
        UIListener.Connect();
        pndrConnectingView.visible = visibleStatus;
    }

    // handle retranlateUI event
    function handleRetranslateUI(languageId)
    {
        LocTrigger.retrigger();
	// added by esjang 2013.12.18 for ITS # 216039
        modeAreaWidget.retranslateUI(PR.const_PANDORA_LANGCONTEXT);
        front_back_indicator_text.text = UIListener.getConnectTypeName();
        connectingWaitText1.text = qsTranslate("main", "STR_PANDORA_CONNECTING_VIEW_TEXT1");
        connectingWaitText2.text = qsTranslate("main", "STR_PANDORA_CONNECTING_VIEW_TEXT2");
    }

    //{ added by cheolhwan 2014-02-26. ITS 225019. Connecting view is displayed indefinitely when pandora entered during no network.
    function setChangeErrorText (curState)
    {
        __LOG("setChangeErrorText -> curState:" + curState , LogSysID.LOW_LOG);
        if(curState === 0)
        {
            //Default Value
            connectingWaitText1.text = qsTranslate("main", "STR_PANDORA_CONNECTING_VIEW_TEXT1");
            connectingWaitText2.text = qsTranslate("main", "STR_PANDORA_CONNECTING_VIEW_TEXT2");
            connectingWaitImage.visible = true;
        }
        else
        {
            //Insufficent Error
            connectingWaitText1.text = "";
            connectingWaitText2.text = qsTranslate("main", "STR_PANDORA_CONNECTING_VIEW_INSUFFICENT_TEXT");
            connectingWaitImage.visible = false;
        }
    }
    //} added by cheolhwan 2014-02-26. ITS 225019. Connecting view is displayed indefinitely when pandora entered during no network.

/***************************************************************************/
/**************************** Private functions END ************************/
/***************************************************************************/

    // MODE AREA
    QmlModeAreaWidget
    {
        id: modeAreaWidget
        anchors.top: parent.top
        modeAreaModel: mode_area_model
        bAutoBeep: false

        search_visible: false
        onBeep: UIListener.ManualBeep(); // added by esjang for ITS # 217173

        ListModel
        {
            id: mode_area_model
        }

        onModeArea_BackBtn:
        {
            //pndrConnectingView.handleBackRequest()
            pndrConnectingView.handleBackRequest(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
        }
    }

    function isJogListenState()
    {
        var ret = true;

        if(modeAreaWidget.focus_visible)
        {
            ret = false;
        }
        return ret;
    }

    function handleJogKey(arrow , status)
    {
        __LOG("handlejogkey -> arrow : " + arrow + " , status : "+status, LogSysID.LOW_LOG);

        switch(arrow)
        {
            case UIListenerEnum.JOG_UP:
                if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                {
                    modeAreaWidget.showFocus();
                    modeAreaWidget.setDefaultFocus(arrow);
                }
                break;
        }
    }

    function manageFocusOnPopUp(status)
    {
        if(status)
        {
            modeAreaWidget.hideFocus();
        }
        else
        {
            modeAreaWidget.showFocus();
        }
    }


    //Initial setup after the Component Completed its loading
    Component.onCompleted: {
        activeView = pndrConnectingView;
//        pndrConnectingView.visible = true;
        //{ added by cheolhwan 2014-02-13. ITS 223524.
        modeAreaWidget.showFocus();
        modeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
        //} added by cheolhwan 2014-02-13. ITS 223524.
        __LOG("onCompleted", LogSysID.LOW_LOG);
    }
}

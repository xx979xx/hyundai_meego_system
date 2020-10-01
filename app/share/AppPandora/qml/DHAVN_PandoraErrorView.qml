import Qt 4.7
import QmlModeAreaWidget 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
import CQMLLogUtil 1.0

Item{
    id: pandoraErrorView
    width: PR.const_PANDORA_ALL_SCREEN_WIDTH
    height: PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT
    x : 0
    y : 0

    //Properties declaration
    property bool isFromErrorView: false
    property bool isNetworkError: false // added by esjang 2013.05.16 for certification issue, networkerror
    property  bool focusVisible : true
    property int errorIndex: 0  // add by cheolhwan 2013.12.04 for ITS 211672.
    property bool isInsufficientEV: false;  
    
    property string logString :""
    
    //Declaration of QML Signals
    //signal handleBackRequest
    signal handleBackRequest(bool isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
    signal handleConnectionRequest

    Text {
        id: firstLine
        text:qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT1");
        y: PR.const_PANDORA_ERROR_VIEW_TEXT1_Y_OFFSET//273
        color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: PR.const_PANDORA_CONNECTING_TEXT_FONT_SIZE
        font.family: PR.const_PANDORA_CONNECTING_TEXT_FONT_FAMILY
    }
    Text {
        id: secondLine
        text:qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT2");
        y: firstLine.y + 60
        font.pointSize: PR.const_PANDORA_CONNECTING_TEXT_FONT_SIZE
        font.family: PR.const_PANDORA_CONNECTING_TEXT_FONT_FAMILY
        color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: thirdLine
        text:qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT3");
        y: secondLine.y + 60 //PR.const_PANDORA_ERROR_VIEW_TEXT2_Y_OFFSET
        font.pointSize: PR.const_PANDORA_CONNECTING_TEXT_FONT_SIZE
        font.family: PR.const_PANDORA_CONNECTING_TEXT_FONT_FAMILY
        color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text
      {
          id: front_back_indicator_text

          text: UIListener.getConnectTypeName();

          anchors.left : pandoraLogo.right //modified by wonseok.heo NOCR for text location 2014.03.10 ( language == 2 || language == 7 ) ?  pandoraErrorView.left : pandoraLogo.right
          anchors.leftMargin: 28 //modified by wonseok.heo NOCR for text location 2014.03.10 (language == 2 || language == 7) ? PR.const_PANDORA_MODEWIDGET_LOGO_TEXT1_X_OFFSET : 28

          y: PR.const_PANDORA_MODEWIDGET_LOGO_TEXT1_Y_OFFSET + 93
          z: 1
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          color: PR.const_PANDORA_LIGHT_DIMMED //modified by wonseok.heo NOCR for text location 2014.03.10 PR.const_PANDORA_COLOR_WHITE//const_PANDORA_COLOR_LOG_TEXT_GREY
          font.pointSize: 40
          font.family: "NewHDB"//"HDR"
          style: Text.Sunken
          visible: UIListener.GetVariantRearUSB() ||  UIListener.IsBTPandora() //modified by jyjeon 2014.01.11 for ITS 218524
      }


      Image{
          id: pandoraLogo
          source: PR_RES.const_APP_PANDORA_TRACK_VIEW_PANDORALOGO_IMAGE

          anchors.left : pandoraErrorView.left // { modified by wonseok.heo NOCR for text location 2014.03.10 ( front_back_indicator_text.text !=""  /*UIListener.GetVariantRearUSB()== true*/ ) ? //modified by jyjeon 2014.01.15 for ITS 219728
                            // (( language == 2 || language == 7 ) ? front_back_indicator_text.right : pandoraErrorView.left) :  pandoraErrorView.left }
          anchors.leftMargin: 42 //modified by wonseok.heo NOCR for text location 2014.03.10( language == 2 || language == 7 ) ? ( (front_back_indicator_text.text !="" /*UIListener.GetVariantRearUSB()*/== true )? 28 : 46 ) : 46 //modified by jyjeon 2014.01.15 for ITS 219728

          y: PR.const_APP_PANDORA_TRACK_VIEW_PANDORALOGO_Y_OFFSET + 93
          z: 1
      }

    

    Item {
        id:okButton
        x: PR.const_PANDORA_ERROR_VIEW_OK_BUTTON_X_OFFSET//409
        y: PR.const_PANDORA_ERROR_VIEW_OK_BUTTON_Y_OFFSET//477
        width: 462
        height: 85

           Image {
            id: focusImg
            source: focusVisible ?  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_FOCUSED :
                PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_NORMAL
            anchors.fill: okButton
        }


        Text {
            id : okText
            text:qsTranslate("main","STR_PANDORA_ERROR_VIEW_OK");
            font.pointSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDB_32_FONT
            font.family: PR.const_PANDORA_FONT_FAMILY_HDB
            color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
       }

       MouseArea{
            anchors.fill: okButton
            beepEnabled: false
            onPressed: {
                focusImg.source = PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_PRESSED

            }

            onClicked: {
                UIListener.ManualBeep();                
                pandoraErrorView.handleConnectionRequest();
            }

            onReleased: {
                 if(focusVisible)
                    focusImg.source = PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_FOCUSED
                 else
                    focusImg.source = PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_NORMAL
            }
        }
    }

    onFocusVisibleChanged:
    {
        if(focusVisible === true)
        {
            focusImg.source =  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_FOCUSED

        }
        else
        {
            focusImg.source =  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_NORMAL
        }
    }

    // MODE AREA
    QmlModeAreaWidget
    {
        id: errorModeAreaWidget
        bAutoBeep: false
        modeAreaModel: errorModeAreaModel
        search_visible: false
        anchors.top: parent.top
        anchors.topMargin : 93
        onBeep: UIListener.ManualBeep(); // added by esjang for ITS # 217173

        onModeArea_BackBtn:
        {
            pandoraErrorView.handleBackRequest(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
        }

        ListModel
        {
            id: errorModeAreaModel
        }
        onLostFocus:
        {
            switch(arrow)
            {
                case UIListenerEnum.JOG_DOWN:
                {
                    __LOG ("QmlModeAreaWidget: onLostFocus " , LogSysID.LOW_LOG );
                    errorModeAreaWidget.hideFocus();
                    pandoraErrorView.focusVisible = true;
                    break;
                }
            }
        }
    }

    Component.onCompleted: {
        activeView = pandoraErrorView;
        pandoraErrorView.visible = visibleStatus;
       // Disconnect from , Avoid calling from radio qml .
       // TODO: Send Session terminate command on this part -esjang 
       // UIListener.Disconnect();
        UIListener.SessionTerminate();
    }

    onVisibleChanged:
    {
        if(pandoraErrorView.visible){
            front_back_indicator_text.text = UIListener.getConnectTypeName();

            //{ add by cheolhwan 2013-12-17. ITS 215841.
            if(pandoraErrorView.focusVisible === true)
            {
                focusImg.source =  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_FOCUSED
            }
            else
            {
                focusImg.source =  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_NORMAL
            }
            //} add by cheolhwan 2013-12-17. ITS 215841.
        }
    }
    //{ modified by yongkyun.lee 2014-03-11 for : ITS 228237
    function setInsufficient(isIns)
    {
        (isInsufficientEV = isIns);
    }
    //} modified by yongkyun.lee 2014-03-11 


    function handleRetranslateUI(languageId)
    {
        __LOG(" handleRetranslateUI() errorIndex = " + errorIndex , LogSysID.LOW_LOG );
        LocTrigger.retrigger()
        errorModeAreaWidget.retranslateUI(PR.const_PANDORA_LANGCONTEXT);
        //{ modified by cheolhwan 2013.12.04 for ITS 211672.
        //firstLine.text = qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT1");
        //secondLine.text = qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT2");
        //thirdLine.text = qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT3");
        switch(errorIndex)
        {
            case 6: //E_CHECK_PNDR_APP_ON_DEVICE
                firstLine.text = "";
                secondLine.text = qsTranslate("main","STR_PANDORA_UNKNOWN_ERROR_VIEW_TEXT2");
                thirdLine.text = qsTranslate("main","STR_PANDORA_UNKNOWN_ERROR_VIEW_TEXT3");
                break;
            default:
                firstLine.text = qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT1");
                secondLine.text = qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT2");
                thirdLine.text = qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT3");
                break;
        }
        //}  modified by cheolhwan 2013.12.04 for ITS 211672.
        okText.text = qsTranslate("main","STR_PANDORA_ERROR_VIEW_OK");
    }

    //{ add by cheolhwan 2013.12.04 for ITS 211672.
    function setTextChange(errIdx)
    {
        __LOG(" setTextChange() errIdx = " + errIdx + "  errorIndex = " + errorIndex , LogSysID.LOW_LOG );
        //{ add by cheolhwan 2013.12.04 for ITS 211672.
        errorIndex = errIdx;
        switch(errorIndex)
        {
            case 6: //E_CHECK_PNDR_APP_ON_DEVICE
                firstLine.text = "" ;
                secondLine.text = qsTranslate("main","STR_PANDORA_UNKNOWN_ERROR_VIEW_TEXT2");
                thirdLine.text = qsTranslate("main","STR_PANDORA_UNKNOWN_ERROR_VIEW_TEXT3");
                break;
            //{ modified by yongkyun.lee 2014-08-27 for : NOCR LOGIN
            case 32:
                firstLine.text = "" ;
                secondLine.text = qsTranslate("main","STR_PANDORA_PLEASE_LOGIN"); // modified by wonseok.heo for Error Messages 20141002 qsTranslate("main","STR_PANDORA_LOG_IN");
                thirdLine.text = "";
                break;
            //} modified by yongkyun.lee 2014-08-27 
            default:
                firstLine.text = qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT1");
                secondLine.text = qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT2");
                thirdLine.text = qsTranslate("main","STR_PANDORA_ERROR_VIEW_TEXT3");
                break;
        }
        //}  add by cheolhwan 2013.12.04 for ITS 211672.
        okText.text = qsTranslate("main","STR_PANDORA_ERROR_VIEW_OK");
    }
    //} add by cheolhwan 2013.12.04 for ITS 211672.
    
    function isJogListenState()
    {
        var ret = true;

        if(errorModeAreaWidget.focus_visible)
        {
            ret = false;
        }
        return ret;
    }

    function handleJogKey(arrow , status)
    {
        __LOG("handlejogkey -> arrow : " + arrow + " , status : "+status , LogSysID.LOW_LOG );

        switch(arrow)
        {
            case UIListenerEnum.JOG_UP:
                if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                {
                    pandoraErrorView.focusVisible = false;
                    errorModeAreaWidget.showFocus();
                    errorModeAreaWidget.setDefaultFocus(arrow);

                }
                break;
            case UIListenerEnum.JOG_CENTER:
                if(status == UIListenerEnum.KEY_STATUS_PRESSED)
                {
                    focusImg.source = PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_PRESSED
                }
                else if(status == UIListenerEnum.KEY_STATUS_RELEASED)
                {
                    pandoraErrorView.handleConnectionRequest();
                }
                //{ modified by yongkyun.lee 2014-03-25 for : ITS 231115
                else if(status == UIListenerEnum.KEY_STATUS_CANCELED)
                {
                    if(pandoraErrorView.focusVisible === true)
                    {
                        focusImg.source =  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_FOCUSED
                    }
                    else
                    {
                        focusImg.source =  PR_RES.const_APP_PANDORA_ERROR_VIEW_OK_NORMAL
                    }
                }
                //} modified by yongkyun.lee 2014-03-25 
                break;
        }
    }

    function manageFocusOnPopUp(status)
    {
        if(status)
        {
            pandoraErrorView.focusVisible = false;
        }
        else
        {
            pandoraErrorView.focusVisible = true;
        }
    }

    function __LOG( textLog , level)
    {
       logString = "ErrorView.qml::" + textLog ;
       logUtil.log(logString , level);
    }

}

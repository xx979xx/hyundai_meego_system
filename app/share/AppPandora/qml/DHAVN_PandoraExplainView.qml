import Qt 4.7
import QmlModeAreaWidget 1.0
import QmlSimpleItems 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
import CQMLLogUtil 1.0

Item {
    id: pndrExplainView
    width: PR.const_PANDORA_ALL_SCREEN_WIDTH
    height: PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT
    y: PR.const_PANDORA_ALL_SCREENS_TOP_OFFSET

    //properties declaration
    property bool isFromErrorView: false
    property bool focusVisible: true //explainView
    property bool backupFocus: false //true:explainView, false:modeArea //modified by jyjeon 2014-05-16 for ITS 236495
    //property bool isJogEventinModeArea: false // for Jog Events in mode area. //removed by jyjeon 2015-05-16 not used
    property bool isInsufficientEX: false; 

    property string logString :""

    //Declaration of QML Signals
    //signal handleBackRequest
    signal handleBackRequest(bool isJogDial); //modified by esjang 2013.06.21 for Touch BackKey

    //added by jyjeon 2014-06-19 for ITS 236495
    Image {
        id: explainTextArea
        y: PR.const_PANDORA_MODE_ITEM_HEIGHT
        source: PR_RES.const_APP_PANDORA_URL_IMG_GENERAL_BACKGROUND_F //added by wonseok.heo for ITS 266944 2015.07.30
        visible: pndrExplainView.focusVisible
    }
    //added by jyjeon 2014-06-19 for ITS 236495

    Flickable {
        id: flick
        width: parent.width;
        //{ modified by cheolhwan 2-14-01-09. ITS 218628.
        //height: parent.height 
        height: parent.height - PR.const_PANDORA_MODE_ITEM_HEIGHT
        y: PR.const_PANDORA_MODE_ITEM_HEIGHT
        //} modified by cheolhwan 2-14-01-09. ITS 218628.
        //height: parent.height - PR.const_PANDORA_ALL_SCREENS_TOP_OFFSET - PR.const_PANDORA_SCROLL_STEP_SIZE
        contentWidth: text1.paintedWidth
        contentHeight: text1.paintedHeight
        flickableDirection: Flickable.VerticalFlick 
        clip: true 

        //added by jyjeon 2014-06-03 for ITS 236495
        onMovementStarted:
        {
            __LOG ("[luan][onMovementStarted]" , LogSysID.LOW_LOG );
            if(vScroll.visible) //modified by jyjeon 2014-06-19 for ITS 236495
            {
                explainModeAreaWidget.hideFocus();
                pndrExplainView.focusVisible = true;
            }
        }

        function ensureVisible(r)
        {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }

        TextEdit
        {
            id : text1
            x: PR.const_PANDORA_WHY_THIS_SONG_TEXT1_X_OFFSET 
            //{ modified by cheolhwan 2-14-01-09. ITS 218628.
            //y: PR.const_PANDORA_WHY_THIS_SONG_TEXT1_Y_OFFSET
            y: PR.const_PANDORA_WHY_THIS_SONG_TEXT1_Y_OFFSET - PR.const_PANDORA_MODE_ITEM_HEIGHT
            //} modified by cheolhwan 2-14-01-09. ITS 218628.
            font.pointSize:PR.const_PANDORA_FONT_SIZE_TEXT_HDR_32_FONT  //modify by cheolhwan 2013.11.28 for Guideline Pandora v.2.0.4 (36->32)
            font.family : PR.const_PANDORA_FONT_FAMILY_HDR
            color: PR.const_PANDORA_COLOR_SUB_TEXT_GREY
            width: PR.const_PANDORA_WHY_THIS_SONG_TEXT_WIDTH
            height: flick.height
            wrapMode:TextEdit.Wrap
            smooth: true;
            focus: true;
	    	cursorVisible: false
            textFormat: TextEdit.AutoText
            onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)

            //added by jyjeon 2014-06-03 for ITS 236495
            MouseArea {
                x: -parent.x
                y: -parent.y
                width: flick.width;
                height: parent.height
                beepEnabled: false

                onPressed:
                {
                    __LOG ("[luan][onPressed]" , LogSysID.LOW_LOG );
                    if( vScroll.visible === true ) //modified by jyjeon 2014-06-19 for ITS 236495
                    {
                        explainModeAreaWidget.hideFocus();
                        pndrExplainView.focusVisible = true;
                    }

                }
                
                onClicked: 
                {
                    UIListener.ManualBeep();                
                }
            }
            //added by jyjeon 2014-06-03 for ITS 236495
        }
    }

    VerticalScrollBar
    {
        id: vScroll
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 34 + explainModeAreaWidget.height
        anchors.rightMargin: 8
        height: 465
        position: flick.visibleArea.yPosition
        //{ modified by cheolhwan 2-14-01-09. ITS 218628.
        //pageSize: (flick.height - explainModeAreaWidget.height - 45 )/flick.contentHeight //flick.visibleArea.heightRatio
        //visible: ( pageSize < 1 || pageSize == 1 )
        pageSize: (flick.height - 64 )/flick.contentHeight
        visible: ( pageSize < 1)
        //} modified by cheolhwan 2-14-01-09. ITS 218628.
    }
    


    // MODE AREA
    QmlModeAreaWidget
    {
        id: explainModeAreaWidget
        bAutoBeep: false
        anchors.top: parent.top
        modeAreaModel: explainModeAreaModel      
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
//            isJogEventinModeArea = true;
            switch(arrow)
            {
                case UIListenerEnum.JOG_DOWN:
                {
                    //modified by jyjeon 2014-06-19 for ITS 236495
                    if( vScroll.visible === true )
                    {
                        explainModeAreaWidget.hideFocus();
                        pndrExplainView.focusVisible = true;
                    }
                    else
                    {
                        pndrExplainView.focusVisible = false;
                        explainModeAreaWidget.showFocus();
                        explainModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
                    }
                    //modified by jyjeon 2014-06-19 for ITS 236495
                    break;
                }
            }
        }

        ListModel
        {
            id: explainModeAreaModel
            property string text: qsTranslate("main","STR_PANDORA_WHY_THIS_SONG")
            property bool mb_visible: false;
            property bool rb_visible: false;
            property bool bb_visible: true;

        }
    }

    DHAVN_PandoraLoading{
        id:waitIndicator
        visible: false
        anchors.verticalCenter: pndrExplainView.verticalCenter
        //anchors.horizontalCenter: pndrExplainView.horizontalCenter
        x: PR.const_PANDORA_LOADING_WAIT_IMAGE_X_OFFSET  // add by cheolhwan 2013.11.28 for center align.
    }

    /***************************************************************************/
    /**************************** Private functions START **********************/
    /***************************************************************************/
    function __LOG( textLog , level)
    {
       logString = "ExplainView.qml::" + textLog ;
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
        pndrExplainView.visible = true;
        waitIndicator.visible = true;
        pndrTrack.RequestExplaination();
    }

    // handle retranlateUI event
    function handleRetranslateUI(languageId)
    {
        LocTrigger.retrigger()
        explainModeAreaWidget.retranslateUI(PR.const_PANDORA_LANGCONTEXT);
    }
    function getWaitIndicatorStatus()
    {
        return waitIndicator.visible;
    }

    function isJogListenState()
    {
        var ret = true;
        if(waitIndicator.visible || explainModeAreaWidget.focus_visible)
        {
            ret = false;
        }
        return ret;
    }

    function handleJogKey(arrow , status)
    {
        __LOG("handlejogkey -> arrow : " + arrow + " , status : "+status , LogSysID.LOW_LOG );
        if(status === UIListenerEnum.KEY_STATUS_RELEASED)
        {
            switch(arrow)
            {
                case UIListenerEnum.JOG_WHEEL_LEFT:
                    if(vScroll.position > 0 && vScroll.pageSize < 1)
                        flick.contentY -= PR.const_PANDORA_SCROLL_STEP_SIZE;
                    break;
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                    if(vScroll.position +  vScroll.pageSize < 1  && vScroll.pageSize < 1)
                        flick.contentY += PR.const_PANDORA_SCROLL_STEP_SIZE;
                    break;
                case UIListenerEnum.JOG_UP:
                    pndrExplainView.focusVisible = false;
                    explainModeAreaWidget.showFocus();
                    explainModeAreaWidget.setDefaultFocus(arrow);
                    break;
            }
        }
    }

    function manageFocusOnPopUp(status)
    {

        __LOG("manageFocusOnPopUp : status" + status , LogSysID.LOW_LOG );

        //modified by jyjeon 2014-05-16 for ITS 236495
        if(status)
        {
            if(pndrExplainView.focusVisible)
            {
                pndrExplainView.focusVisible = false;
                pndrExplainView.backupFocus = true;
            }
            explainModeAreaWidget.hideFocus();
        }
        else
        {
            if(pndrExplainView.backupFocus)
            {
                pndrExplainView.backupFocus = false;
            pndrExplainView.focusVisible = true;
                explainModeAreaWidget.hideFocus();
        }
        else
        {
                explainModeAreaWidget.showFocus();
        }
        }
        //modified by jyjeon 2014-05-16 for ITS 236495
    }

    Component.onCompleted: {
        activeView = pndrExplainView;
        handleForegroundEvent();
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

        onTrackUpdated:
        {
            text1.text = "";
            waitIndicator.visible = true;
            if(inTrackToken > 0){
                pndrTrack.RequestExplaination();
            }
        }

        onTrackExplainReceived:
        {
           // __LOG("inExplain " + inExplain , LogSysID.LOW_LOG );
            waitIndicator.visible = false;
            text1.text = (inExplain==="")?qsTranslate("main","STR_PANDORA_NO_EXPLANATION"):inExplain;

            if( UIListener.IsSystemPopupVisible() || popup.visible ) return;//modified by jyjeon 2014-03-13 for ITS 229292

            //modified by jyjeon 2014-06-19 for ITS 236495
            if( vScroll.visible === false )
            {
                pndrExplainView.focusVisible = false;
                explainModeAreaWidget.showFocus();
                explainModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_UP);
            }
            //modified by jyjeon 2014-06-19 for ITS 236495
        }
    }
}

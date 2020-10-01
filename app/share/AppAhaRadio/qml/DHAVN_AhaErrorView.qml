import Qt 4.7
import QmlModeAreaWidget 1.0
import AppEngineQMLConstants 1.0
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES

Item{
    id: ahaErrorView
    width: PR.const_AHA_ALL_SCREEN_WIDTH
    height: PR.const_AHA_CONNECTING_SCREEN_HEIGHT
    y: PR.const_AHA_ALL_SCREENS_TOP_OFFSET
    anchors.bottomMargin: PR.const_AHA_ALL_SCREEN_BOTTOM_MARGIN

    //Properties declaration
    property bool isFromErrorView: false
//wsuk.kim no_network
    property int counter: PR.const_AHA_CONNECTING_VIEW_TIMER_COUNTER_MIN_VAL
    property int exceptionCounter: 0
//wsuk.kim no_network
    property  bool focusVisible : true  //wsuk.kim 130705 ok key movement

    //Declaration of QML Signals
    signal handleBackRequest
    signal handleConnectionRequest
    signal lostFocus(int arrow, int status);    //wsuk.kim error_jog

    function setHighlightedItem(inKeyId)
    {
        isDialUI = true;
    }


    Item {
        id: parentitem
//wsuk.kim 131004 ISV_924147 reconnecting error text, same as Pandor string and arrayal.
        Text {
            id: firstConnectingLine
            text: qsTranslate("main",qmlProperty.getErrorViewText()? qmlProperty.getErrorViewText():"STR_AHA_ERROR_VIEW_TEXT0");
            x: PR.const_AHA_ERROR_VIEW_TEXT1_X_OFFSET
            y: PR.const_AHA_ERROR_VIEW_TEXT1_Y_OFFSET
            color: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY
            horizontalAlignment: Text.AlignHCenter 
            verticalAlignment: Text.AlignVCenter 
            width: PR.const_AHA_ERROR_VIEW_TEXT_WIDTH
            font.pixelSize: PR.const_AHA_CONNECTING_TEXT_FONT_SIZE
            font.family: PR.const_AHA_CONNECTING_TEXT_FONT_FAMILY
        }
//wsuk.kim 131004 ISV_924147 reconnecting error text, same as Pandor string and arrayal.
        Text {
            id: secondConnectingLine
            text: qsTranslate("main",qmlProperty.getErrorViewText()? qmlProperty.getErrorViewText2Line():"STR_AHA_ERROR_VIEW_TEXT1");    //wsuk.kim 131004 ISV_924147 reconnecting error text, same as Pandor string and arrayal.
            x: PR.const_AHA_ERROR_VIEW_TEXT1_X_OFFSET
            y: PR.const_AHA_ERROR_VIEW_TEXT2_Y_OFFSET   //wsuk.kim 131004 ISV_924147 reconnecting error text, same as Pandor string and arrayal.
            color: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: PR.const_AHA_ERROR_VIEW_TEXT_WIDTH
            font.pixelSize: PR.const_AHA_CONNECTING_TEXT_FONT_SIZE
            font.family: PR.const_AHA_CONNECTING_TEXT_FONT_FAMILY
        }
        Text {
            text: qsTranslate("main",qmlProperty.getErrorViewText()? "":qmlProperty.getErrorViewText2Line());   //wsuk.kim rm_pop    //wsuk.kim 131004 ISV_924147 reconnecting error text, same as Pandor string and arrayal.
            x: PR.const_AHA_ERROR_VIEW_TEXT2_X_OFFSET
            y: PR.const_AHA_ERROR_VIEW_TEXT2_Y_OFFSET + 60   //wsuk.kim 131004 ISV_924147 reconnecting error text, same as Pandor string and arrayal.
            font.pixelSize: PR.const_AHA_CONNECTING_TEXT_FONT_SIZE
            font.family: PR.const_AHA_CONNECTING_TEXT_FONT_FAMILY
            color: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY
            horizontalAlignment: Text.AlignHCenter 
            verticalAlignment: Text.AlignVCenter 
            width: PR.const_AHA_ERROR_VIEW_TEXT_WIDTH
        }

        Image {
            id:okButton
            source: PR_RES.const_APP_AHA_ERROR_VIEW_OK_BUTTON_IMG_N
            x:PR.const_AHA_ERROR_VIEW_OK_BUTTON_X_OFFSET
            y:PR.const_AHA_ERROR_VIEW_OK_BUTTON_Y_OFFSET

            BorderImage {
                id: focusImg
                source: focusVisible? PR_RES.const_APP_AHA_ERROR_VIEW_OK_BUTTON_IMG_F : "" //wsuk.kim 130705 ok key movement
                width: okButton.width; height: okButton.height
                visible: focusVisible   //wsuk.kim 130705 ok key movement
            }

            Text {
                id : okText
                text:qsTranslate("main","STR_AHA_ERROR_VIEW_OK");
                font.pixelSize: PR.const_AHA_FONT_SIZE_TEXT_HDB_32_FONT
                font.family: PR.const_AHA_FONT_FAMILY_HDB
                color: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY
                horizontalAlignment: Text.AlignHCenter 
                verticalAlignment: Text.AlignVCenter 
                width: PR.const_AHA_ERROR_VIEW_OK_BUTTON_TEXT_WIDTH
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
           }

           MouseArea{
                anchors.fill: okButton
                onPressed: {
//wsuk.kim 130705 ok key movement
                    if(focusVisible)
                        focusImg.source = PR_RES.const_APP_AHA_ERROR_VIEW_OK_BUTTON_IMG_P
                    else
                        okButton.source = PR_RES.const_APP_AHA_ERROR_VIEW_OK_BUTTON_IMG_P
//wsuk.kim 130705 ok key movement
                }

                onClicked: {
                    if(UIListener.getNetworkStatus() === 0/*AHA_NOTIFY_RESUME_NORMAL*/ || UIListener.getNetworkStatus() === -1) //wsuk.kim no_network
                    {
                        ahaErrorView.handleConnectionRequest()
                    }
                    else
                    {
                        handleNoNetworkLoadingOn()
                    }
                }

                onReleased: {
//wsuk.kim 130705 ok key movement
                    if(focusVisible)
                        focusImg.source = PR_RES.const_APP_AHA_ERROR_VIEW_OK_BUTTON_IMG_F;
                    else
                        okButton.source = PR_RES.const_APP_AHA_ERROR_VIEW_OK_BUTTON_IMG_N;
//wsuk.kim 130705 ok key movement
                }
            }
        }
    }


//wsuk.kim no_network
    Item  {
        id: ahaNetworkingLoadingView
        visible: false

        Image {
            id: networkWaitImage
            x: PR.const_AHA_CONNECTING_WAIT_IMAGE_X_OFFSET
            y: PR.const_AHA_CONNECTING_WAIT_IMAGE_Y_OFFSET
            source: PR_RES.const_APP_AHA_CONNECTING_WAIT[counter]
        }

        Text
        {
            id: networkWaitText1
            x: PR.const_AHA_CONNECTING_WAIT_TEXT1_X_OFFSET
            y: PR.const_AHA_CONNECTING_WAIT_TEXT1_Y_OFFSET
            color: PR.const_AHA_CONNECTING_TEXT_COLOR
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: PR.const_AHA_CONNECTING_TEXT_WIDTH
            text: qsTranslate("main", "STR_AHA_CONNECTING_VIEW_TEXT1");
            font.pixelSize: PR.const_AHA_CONNECTING_TEXT_FONT_SIZE
            font.family: PR.const_AHA_CONNECTING_TEXT_FONT_FAMILY
        }

        Text
        {
            id: networkWaitText2
            x: PR.const_AHA_CONNECTING_WAIT_TEXT2_X_OFFSET
            y: PR.const_AHA_CONNECTING_WAIT_TEXT2_Y_OFFSET
            color: PR.const_AHA_CONNECTING_TEXT_COLOR
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: PR.const_AHA_CONNECTING_TEXT_WIDTH
            text: qsTranslate("main", "STR_AHA_CONNECTING_VIEW_TEXT2");
            font.pixelSize: PR.const_AHA_CONNECTING_TEXT_FONT_SIZE
            font.family: PR.const_AHA_CONNECTING_TEXT_FONT_FAMILY
        }
    }
//wsuk.kim no_network

    Image{
        id: ahaLogo
        source: PR_RES.const_APP_AHA_TRACK_VIEW_AHALOGO_IMAGE
        x: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_X_OFFSET
//wsuk.kim 130717 to change front/rear title position
        //anchors.left: front_back_indicator_text.right
        //anchors.leftMargin: UIListener.GetVariantRearUSB()? 32 : 0  //wsuk.kim 130807 ISV_86633 variant RearUSB
        anchors.bottom: front_back_indicator_text.bottom
        anchors.bottomMargin: 13
//        x: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_X_OFFSET
//        y: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_Y_OFFSET
//wsuk.kim 130717 to change front/rear title position
        z: 1000
        MouseArea{
            anchors.fill: parent
        }
    }

    //hsryu_0618_device_text
    Text
    {
        id: front_back_indicator_text
//wsuk.kim 130717 to change front/rear title position
        //x: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_X_OFFSET
        anchors.left: ahaLogo.right
        anchors.verticalCenter: errorModeAreaWidget.verticalCenter
//        anchors.left: ahaLogo.right
//        anchors.leftMargin: 10
//        anchors.bottom: ahaLogo.bottom
//        anchors.bottomMargin: -9
//wsuk.kim 130717 to change front/rear title position
        z: 1000
        text: UIListener.getConnectTypeName();
        color: PR.const_AHA_LIGHT_DIMMED
        font.pointSize: PR.const_AHA_FONT_SIZE_TEXT_HDR_40_FONT
        font.family: PR.const_AHA_FONT_FAMILY_HDB
    }

    // MODE AREA
    QmlModeAreaWidget
    {
        id: errorModeAreaWidget

        modeAreaModel: errorModeAreaModel
        search_visible: false
        anchors.top: parent.top

//wsuk.kim error_jog
        onLostFocus:
        {
           switch(arrow)
           {
               case UIListenerEnum.JOG_DOWN:
               {
                   errorModeAreaWidget.hideFocus();
//wsuk.kim 130705 ok key movement
                   ahaErrorView.focusVisible = true;
                   focusImg.source = PR_RES.const_APP_AHA_ERROR_VIEW_OK_BUTTON_IMG_F;
//wsuk.kim 130705 ok key movement
                   break;
               }
           }
        }
//wsuk.kim error_jog

        onModeArea_BackBtn:
        {
            ahaErrorView.handleBackRequest();
        }

        ListModel
        {
            id: errorModeAreaModel
        }
    }

    Component.onCompleted: {
        activeView = ahaErrorView;
        //wsuk.kim 130705 ok key movement        focusImg.visible = true;    //wsuk.kim error_jog
        //hsryu_0607_inititialize_controller
        qmlProperty.setFocusArea(PR.const_STATION_LIST_ERROR_VIEW_FOCUS);
    }

//wsuk.kim 130827 update indicator text when to change language.
    onVisibleChanged:
    {
        if(ahaErrorView.visible === true)
        {
            front_back_indicator_text.text = UIListener.getConnectTypeName();
            focusImg.source = PR_RES.const_APP_AHA_ERROR_VIEW_OK_BUTTON_IMG_F;  //wsuk.kim 131224 ITS_217070 Press hold when disp change from on to off.
        }
    }
//wsuk.kim 130827 update indicator text when to change language.

    Connections
    {
        target: /*isDialUI wsuk.kim 130705 ok key movement*/ahaErrorView.focusVisible ? UIListener:null

//wsuk.kim error_jog
        onSignalJogNavigation:
        {
            //hsryu_0502_jog_control
            if(status === UIListenerEnum.KEY_STATUS_PRESSED)
            {
                switch(arrow)
                {
                case UIListenerEnum.JOG_UP://PR.const_AHA_JOG_EVENT_ARROW_UP:
                    ahaErrorView.lostFocus(arrow, status);
                    break;
                case UIListenerEnum.JOG_CENTER: //wsuk.kim 131205 jog center key pressed image on Error view.
                    focusImg.source = PR_RES.const_APP_AHA_ERROR_VIEW_OK_BUTTON_IMG_P
                    break;
                default:
                    break;
                }
            }
            else if(status === UIListenerEnum.KEY_STATUS_RELEASED)
            {
                switch(arrow)
                {
                    case UIListenerEnum.JOG_CENTER:
                    {
                        focusImg.source = PR_RES.const_APP_AHA_ERROR_VIEW_OK_BUTTON_IMG_F
                        if(UIListener.getNetworkStatus() === 0/*AHA_NOTIFY_RESUME_NORMAL*/ || UIListener.getNetworkStatus() === -1) //wsuk.kim no_network
                        {
                            ahaErrorView.handleConnectionRequest();
                        }
                        else
                        {
                            handleNoNetworkLoadingOn();
                        }
                    }
                    break;

                    default:
                        break;
                }
            }
        }
//wsuk.kim error_jog
        onHandleDisplayOff:  // ITS 217070
        {
            focusImg.source = PR_RES.const_APP_AHA_ERROR_VIEW_OK_BUTTON_IMG_F
        }
    }

//wsuk.kim content_jog
    onLostFocus: {
        if(arrow === UIListenerEnum.JOG_UP)
        {
            ahaErrorView.focusVisible = false;  //wsuk.kim 130705 ok key movement
            errorModeAreaWidget.showFocus();
            //hsryu_0502_jog_control
			if(errorModeAreaWidget.focus_index === -1)
            {
                errorModeAreaWidget.setDefaultFocus(UIListenerEnum.JOG_WHEEL_LEFT);
            }
        }
    }
//wsuk.kim content_jog

//wsuk.kim no_network
    Timer
    {
        id: networkWaitTimer
        interval: 100   //wsuk.kim 130906 loading animation interval 100ms/frame
        running: false
        repeat: true

        onTriggered:
        {
            counter = counter + 1
            exceptionCounter = exceptionCounter + 1
            if(counter == PR.const_AHA_TIMER_COUNTER_MAX_VAL)
            {
                counter = PR.const_AHA_TIMER_COUNTER_MIN_VAL
            }

            if(exceptionCounter === 50)
            {
                exceptionCounter = 0
                handleNoNetworkLoadingOff()
            }

            networkWaitImage.source = PR_RES.const_APP_AHA_CONNECTING_WAIT[counter]
        }
    }

    function handleNoNetworkLoadingOn()
    {
        parentitem.visible = false
        ahaNetworkingLoadingView.visible = true
        networkWaitTimer.start()
    }

    function handleNoNetworkLoadingOff()
    {
        parentitem.visible = true
        ahaNetworkingLoadingView.visible = false
        networkWaitTimer.stop()
    }
//wsuk.kim no_network
}

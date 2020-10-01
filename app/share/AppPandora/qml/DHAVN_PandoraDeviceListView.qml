import Qt  4.7
import QmlModeAreaWidget 1.0
import AppEngineQMLConstants 1.0
//import DeviceInfo 1.0 // removed by jyjeon 2014-04-04 for Loading View
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
import CQMLLogUtil 1.0

Item {
    id: pndrDeviceListView
    width: PR.const_PANDORA_ALL_SCREEN_WIDTH
    height: PR.const_PANDORA_CONNECTING_SCREEN_HEIGHT
    y:PR.const_PANDORA_ALL_SCREENS_TOP_OFFSET
    anchors.bottomMargin: PR.const_PANDORA_ALL_SCREEN_BOTTOM_MARGIN
    visible: true;

    //QML Properties Declaration
    property bool isFocusVisible: true
    property int focusIndex: -1
    property variant listModel;
    property bool isFromErrorView: false
    property bool isInsufficientDLV: false;  

    property string logString :""
    //Declaration of QML Signals
    signal connectToDevice(int selectedDevice);
    //signal handleBackRequest();
    signal handleBackRequest(bool isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
    


    Text {
        id: upperText1
        text:qsTranslate("main","STR_PANDORA_DEVICELISTVIEW_TEXT1");//"More than 1 devices are connected"
        font.family: PR.const_PANDORA_FONT_FAMILY_HDR
        font.pointSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT// added by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
        color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
        y : PR.const_PANDORA_DEVICELIST_VIEW_TEXT1_Y_OFFSET
        x : PR.const_PANDORA_DEVICELIST_VIEW_TEXT1_X_OFFSET
        width: PR.const_PANDORA_DEVICELIST_VIEW_TEXT1_WIDTH
        horizontalAlignment: Text.AlignHCenter
    }
    Text {
        id: upperText2
        text:qsTranslate("main","STR_PANDORA_DEVICELISTVIEW_TEXT2");//"Please select device."
        font.family: PR.const_PANDORA_FONT_FAMILY_HDR
        font.pointSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDR_40_FONT// Modified by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
        color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY
        y : PR.const_PANDORA_DEVICELIST_VIEW_TEXT2_Y_OFFSET
        x : PR.const_PANDORA_DEVICELIST_VIEW_TEXT1_X_OFFSET
        width: PR.const_PANDORA_DEVICELIST_VIEW_TEXT1_WIDTH
        horizontalAlignment: Text.AlignHCenter
    }

    DHAVN_PandoraWaitView{
        id: waitIndicatior
        visible: false
    }

    Component{
        id: modalDelegate


        Image {
            source: PR_RES.const_APP_PANDORA_DEVICE_ICON_BG_N

            BorderImage {
                source: PR_RES.const_APP_PANDORA_DEVICE_ICON_BG_F
                border.left: 5; border.top: 5
                border.right: 5; border.bottom: 5
                visible: (index === focusIndex) && isFocusVisible && isDialUI
            }

            Image
            {
                source: listModel[index]["DeviceType"] === DeviceInfo.EBTConn ? PR_RES.const_APP_PANDORA_DEVICE_ICON_CONNECTION_BT_TYPE : PR_RES.const_APP_PANDORA_DEVICE_ICON_CONNECTION_USB_TYPE;
                anchors.top: parent.top
                anchors.topMargin: PR.const_APP_PANDORA_DEVICE_LIST_CONNECTION_TYPE_ICON_TOP_MARGIN
                anchors.left: parent.left
                anchors.leftMargin: PR.const_APP_PANDORA_DEVICE_LIST_CONNECTION_TYPE_ICON_LEFT_MARGIN
                width: PR.const_APP_PANDORA_DEVICE_LIST_CONNECTION_TYPE_ICON_WIDTH
            }

            Text{
                text: listModel[index]["DeviceName"]
                anchors.top: parent.top
                anchors.topMargin: PR.const_APP_PANDORA_DEVICE_LIST_CONNECTION_TYPE_TEXT1_TOP_MARGIN
                anchors.left: parent.left
                anchors.leftMargin: PR.const_APP_PANDORA_DEVICE_LIST_CONNECTION_TYPE_ICON_LEFT_MARGIN
                width: PR.const_APP_PANDORA_DEVICE_LIST_CONNECTION_TYPE_TEXT_WIDTH
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDB_32_FONT// modified by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                font.family: PR.const_PANDORA_FONT_FAMILY_HDB// modified by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                color: PR.const_PANDORA_COLOR_TEXT_BRIGHT_GREY// modified by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
            }

            Text{
                text: qsTranslate("main", "STR_PANDORA_USB_CONNECT")
                anchors.top: parent.top
                anchors.topMargin: PR.const_APP_PANDORA_DEVICE_LIST_CONNECTION_TYPE_TEXT2_TOP_MARGIN
                anchors.left: parent.left
                anchors.leftMargin: PR.const_APP_PANDORA_DEVICE_LIST_CONNECTION_TYPE_ICON_LEFT_MARGIN
                width: PR.const_APP_PANDORA_DEVICE_LIST_CONNECTION_TYPE_TEXT_WIDTH
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: PR.const_PANDORA_FONT_SIZE_TEXT_HDB_32_FONT// modified by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                font.family: PR.const_PANDORA_FONT_FAMILY_HDB// modified by esjang 2013.03.06 for DH Genesis GUI Design Guideline v1.1.2(2013.02.28)
                color: PR.const_PANDORA_COLOR_TEXT_DIMMED_GREY
            }

            MouseArea{
                anchors.fill: parent
                beepEnabled: false  
                onPressed: {
                    parent.source = PR_RES.const_APP_PANDORA_DEVICE_ICON_BG_P
                }
                onReleased: {
                    parent.source = PR_RES.const_APP_PANDORA_DEVICE_ICON_BG_N
                }

                onClicked: {
                    //TODO: replace '0' with index
                    UIListener.ManualBeep();
                    isDialUI = false;
                    pndrDeviceListView.connectToDevice(index);
                }
            }
        }
    }


    Row {
        id: multiDeviceListRow
        spacing: PR.const_APP_PANDORA_DEVICE_LIST_ICONS_SPACE
        Repeater{
            id: deviceList
            model: listModel
            delegate: modalDelegate
        }
        visible: listModel.length >= 2;
        x: listModel.length === 2 ? PR.const_APP_PANDORA_DEVICE_LIST_TWO_X_OFFSET : PR.const_APP_PANDORA_DEVICE_LIST_THREE_X_OFFSET
        y: listModel.length === 2 ? PR.const_APP_PANDORA_DEVICE_LIST_TWO_Y_OFFSET : PR.const_APP_PANDORA_DEVICE_LIST_THREE_Y_OFFSET
    }

    Row {
        id: singleDeviceListRow
        spacing: PR.const_APP_PANDORA_DEVICE_LIST_ICONS_SPACE
        Repeater{
            model: listModel
            delegate: modalDelegate
        }
        visible: listModel.length === 1;
        y: PR.const_APP_PANDORA_DEVICE_LIST_THREE_Y_OFFSET
        anchors.horizontalCenter: parent.horizontalCenter
    }

    QmlModeAreaWidget
    {
        id: deviceListModeAreaWidget
        bAutoBeep: false
        modeAreaModel: deviceListModeAreaModel
        search_visible: false
        parent: pndrDeviceListView
        anchors.top: parent.top
        onBeep: UIListener.ManualBeep(); // added by esjang for ITS # 217173

        onModeArea_BackBtn:
        {
            __LOG ("QmlModeAreaWidget: onModeArea_BackBtn", LogSysID.LOW_LOG);
            isDialUI = false;
	        //pndrDeviceListView.handleBackRequest();
            pndrDeviceListView.handleBackRequest(isJogDial); //modified by esjang 2013.06.21 for Touch BackKey
            
        }

        ListModel
        {
            id: deviceListModeAreaModel
            
        }
    }

    MouseArea{
        anchors.fill: parent
        beepEnabled: false     
        z: -10
        onClicked: {
            UIListener.ManualBeep();
            isDialUI = false;
        }
        
    }

    /***************************************************************************/
    /**************************** Private functions START *********************/
    /***************************************************************************/

    function __LOG( textLog , level)
    {
       logString = "DeviceListView.qml::" + textLog ;
       logUtil.log(logString , level);
    }

    //{ modified by yongkyun.lee 2014-03-11 for : ITS 228237
    function setInsufficient(isIns)
    {
        (isInsufficientDLV = isIns);
    }
    //} modified by yongkyun.lee 2014-03-11 
        

    // handles foreground event
    function handleForegroundEvent ()
    {
        visible = true;
//        var deviceInfo = UIListener.GetDeviceStatus();
//        listModel = deviceInfo;
    }

    // handle retranlateUI event
    function handleRetranslateUI(languageId)
    {
        deviceListModeAreaWidget.retranslateUI(PR.const_PANDORA_LANGCONTEXT);
    }

    // Logic for highlighting the item based on jog key events
    function setHighlightedItem(inKeyId)
    {
        __LOG("setHighlited item - isDialUI : " + isDialUI + " isFocusVisible: " + isFocusVisible +
              " focusIndex: " + focusIndex, LogSysID.LOW_LOG);
        isDialUI = true;
    }

    function hideFocus()
    {
        isFocusVisible = false
    }

    function showFocus()
    {
        isFocusVisible = true;
    }

    function handleJogEvent( arrow, status )
    {
        __LOG("handleJogEvent", LogSysID.LOW_LOG);
        switch(arrow)
        {
        case PR.const_PANDORA_JOG_EVENT_ARROW_UP:
            break;
        case PR.const_PANDORA_JOG_EVENT_ARROW_RIGHT:
        case PR.const_PANDORA_JOG_EVENT_WHEEL_RIGHT:
            __LOG("Right wheel pressed", LogSysID.LOW_LOG);
            focusNext(PR.const_PANDORA_JOG_EVENT_ARROW_RIGHT);
            break;
        case PR.const_PANDORA_JOG_EVENT_ARROW_DOWN:
            break;
        case PR.const_PANDORA_JOG_EVENT_ARROW_LEFT:
        case PR.const_PANDORA_JOG_EVENT_WHEEL_LEFT:
            __LOG("Left wheel pressed", LogSysID.LOW_LOG);
            focusPrev(PR.const_PANDORA_JOG_EVENT_ARROW_LEFT)
            break;
        case PR.const_PANDORA_JOG_EVENT_CENTER:
            if(focusIndex >=0 && focusIndex <listModel.length)
            {
                pndrDeviceListView.connectToDevice(focusIndex);
            }
            break;
        }
    }

    function focusNext( arrow )
    {
        __LOG("in focus next", LogSysID.LOW_LOG);
        var eventHandled = false;
        __LOG("in focus next Inside Focus Visibe: " + isFocusVisible+ " listModel.length: " + listModel.length, LogSysID.LOW_LOG);
        if(isFocusVisible)
        {
            if(focusIndex + 1 < listModel.length )
            {
                focusIndex += 1
                eventHandled = true;
            }
            else
            {
                focusIndex = 0;
                eventHandled = true;
            }
        }
        //console.log("focusIndex: "+ focusIndex + " eventHandled: " + eventHandled)
        __LOG("focusIndex: "+ focusIndex + " eventHandled: " + eventHandled , LogSysID.LOW_LOG );
        return eventHandled;
    }

    function focusPrev( arrow )
    {
        __LOG("in focus prev" , LogSysID.LOW_LOG );
        var eventHandled = false;
        __LOG("in focus prev Inside Focus Visibe: " + isFocusVisible+ " focusIndex: " + focusIndex , LogSysID.LOW_LOG );
        if(isFocusVisible)
        {
            if( focusIndex - 1 >= 0)
            {
                focusIndex -= 1
                eventHandled = true;
            }
            else
            {
                focusIndex = listModel.length - 1;
                return true;
            }
        }
        //console.log("focus_prev returns:  "+ eventHandled)
        __LOG("focus_prev returns:  "+ eventHandled , LogSysID.LOW_LOG );
        return eventHandled;
    }


    /***************************************************************************/
    /**************************** Private functions END    *********************/
    /***************************************************************************/

    /***************************************************************************/
    /**************************** Pandora Qt connections START ****************/
    /***************************************************************************/

//    Connections
//    {
//        target: (pndrDeviceListView.isFocusVisible && !popupVisible)?UIListener:null

//        onSignalJogNavigation:
//        {
//            __LOG("onSignalJogNavigation device list view" , LogSysID.LOW_LOG );
//            if(status === UIListenerEnum.KEY_STATUS_PRESSED //modified by esjang 2013.05.03 for AFW changed Clicked event
//                    || arrow=== UIListenerEnum.JOG_WHEEL_LEFT
//                    || arrow === UIListenerEnum.JOG_WHEEL_RIGHT)
//            {
//                handleJogEvent(arrow,status);
//            }
//        }
//    }

    Connections
    {
        target: UIListener

        onDeviceListUpdated:
        {
//            var deviceInfo = UIListener.GetDeviceStatus();
//            listModel = deviceInfo;
//            if(listModel.length === 1)
//            {
//                singleDeviceListRow.visible = true;
//                multiDeviceListRow.visible = false;
//            }
//            else
//            {
//                singleDeviceListRow.visible = false;
//                multiDeviceListRow.visible = true;
//            }
        }
    }

    /***************************************************************************/
    /**************************** Pandora Qt connections end ****************/
    /***************************************************************************/

    /***************************************************************************/
    /**************************** Pandora QML connections START ****************/
    /***************************************************************************/

    //Note: App framework is calling this from C++. So no need to define, If necessory use this
    Component.onCompleted:
    {
        __LOG("Component Completed" , LogSysID.LOW_LOG );
        activeView = pndrDeviceListView;
        showFocus();
        handleForegroundEvent();
    }

    Connections{
        target: pndrController
        onIsDialUIChanged:
        {
            if(!isDialUI)
            {
                pndrDeviceListView.showFocus();
                pndrDeviceListView.focusIndex = -1;
            }
        }
    }

    /***************************************************************************/
    /**************************** Pandora QML connections END ****************/
    /***************************************************************************/

}

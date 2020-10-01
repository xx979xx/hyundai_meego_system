import Qt 4.7
import QmlModeAreaWidget 1.0
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES

Item  {
    id: ahaConnectingView
    width: PR.const_AHA_ALL_SCREEN_WIDTH
    height: PR.const_AHA_CONNECTING_SCREEN_HEIGHT
    y: PR.const_AHA_ALL_SCREENS_TOP_OFFSET
    visible: true
	
   // Declaration of Properties
    property int counter: PR.const_AHA_CONNECTING_VIEW_TIMER_COUNTER_MIN_VAL
    property bool isFromErrorView: false

	//Declaration of QML Signals
    signal handleBackRequest

    Image {
        id: connectingWaitImage
        x: PR.const_AHA_CONNECTING_WAIT_IMAGE_X_OFFSET
        y: PR.const_AHA_CONNECTING_WAIT_IMAGE_Y_OFFSET
        source: PR_RES.const_APP_AHA_CONNECTING_WAIT[counter]
    }

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
            beepEnabled: false // added by Ryu 2013.08.25 for remove Beep sound
        }
    }

    //hsryu_0618_device_text
    Text
    {
        id: front_back_indicator_text
//wsuk.kim 130717 to change front/rear title position
        //x: PR.const_APP_AHA_TRACK_VIEW_AHALOGO_X_OFFSET
        anchors.left: ahaLogo.right
        anchors.verticalCenter: modeAreaWidget.verticalCenter
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

    Text
    {
        id: connectingWaitText1
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
        id: connectingWaitText2
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

    Timer
    {
        id: waitTimer
        interval: 100   //wsuk.kim 130906 loading animation interval 100ms/frame
        running: ahaConnectingView.visible
        repeat: true

        onTriggered:
        {
            counter = counter + 1
            if(counter == PR.const_AHA_TIMER_COUNTER_MAX_VAL)
            {
                counter = PR.const_AHA_TIMER_COUNTER_MIN_VAL
            }
            connectingWaitImage.source = PR_RES.const_APP_AHA_CONNECTING_WAIT[counter]
        }
    }

    MouseArea{
        anchors.fill: parent
        beepEnabled: false // added by Ryu 2013.08.25 for remove Beep sound
        z: -10
        onClicked: {
            //switch to touch ui
            isDialUI = false;
        }
    }

     // handles foreground event
    function handleForegroundEvent()
    {
        UIListener.printQMLDebugString("handleForegroundEvent()\n");
        UIListener.printQMLDebugString("currentDeviceIndex :" + currentDeviceIndex+ "\n");
        ahaConnectingView.visible = true;
        UIListener.Connect(currentDeviceIndex);
    }

    // handle retranlateUI event
    function handleRetranslateUI(languageId)
    {
        // TODO: Retranslate the text
        modeAreaWidget.retranslateUI(PR.const_AHA_LANGCONTEXT)
    }

    // Logic for highlighting the item based on jog key events
    function setHighlightedItem(inKeyId)
    {
        isDialUI = true;
    }

    // handles stop connection event
    function handleStopConnectEvent ()
    {
        UIListener.printQMLDebugString("[AhaConnectingView.qml] ahaConnectingView:handleStopConnectEvent..");

        ahaConnectingView.visible = false;
        waitTimer.stop();
        UIListener.printQMLDebugString("[AhaConnectingView.qml] ahaConnectingView:handleStopConnectEvent..out");
    }
/***************************************************************************/
/**************************** Private functions END ************************/
/***************************************************************************/

    // MODE AREA
    QmlModeAreaWidget
    {
        id: modeAreaWidget
        anchors.top: parent.top
        modeAreaModel: mode_area_model

        search_visible: false
        focus_visible: true

        ListModel
        {
            id: mode_area_model
        }
    }

    /***************************************************************************/
    /**************************** QmlModeAreaWidget QML connections START ******/
    /***************************************************************************/

    Connections{
        target: modeAreaWidget
        onModeArea_BackBtn:
        {
            isDialUI = false;
            ahaConnectingView.handleBackRequest()
        }
    }

    Connections{
        target: ahaConnectingView
        onHandleBackRequest:
        {
            UIListener.printQMLDebugString("onHandleBackRequest\n");
            //ITS_226052
            //waitTimer.stop();
        }
    }

    //Initial setup after the Component Completed its loading
    Component.onCompleted: {
        activeView = ahaConnectingView;
        UIListener.printQMLDebugString("AhaConnectingView onCompleted\n");
        modeAreaWidget.setDefaultFocus(0);
        ahaConnectingView.handleForegroundEvent();
    }

//wsuk.kim 130827 update indicator text when to change language.
    onVisibleChanged:
    {
        if(ahaConnectingView.visible === true)
        {
            front_back_indicator_text.text = UIListener.getConnectTypeName();
        }
    }
//wsuk.kim 130827 update indicator text when to change language.

    /***************************************************************************/
    /**************************** QmlModeAreaWidget QML connections END ********/
    /***************************************************************************/
}

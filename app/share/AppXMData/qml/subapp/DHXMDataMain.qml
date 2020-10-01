import Qt 4.7

// teleca Import
//import QmlStatusBarWidget 1.0
//import qmlgestureareaplugin 1.0

// System Import
import "../component/system/DH" as MSystem
import "../component/QML/DH" as MComp
// Local Import
import "../component/XMData/Javascript/DHXMDataMain.js" as MJavascript
import "../component/XMData/Javascript/Definition.js" as MDefinition
import "../component/XMData/Common" as XMCommon
import "../component/XMData" as XMData
import "../component/XMData/Popup" as MPopup
import QmlStatusBar 1.0


// Apply MAppMain - 2011.11.02
MComp.MAppMain {
    id: idAppMain
    y: 0
    width:systemInfo.lcdWidth; height: systemInfo.lcdHeight+systemInfo.statusBarHeight

    focus:true;
    // First Main Screen
    property string selectedMainScreen: ""// "callForXMDataMainMenu"
    property bool isWSAFromMenu: false
    property int isFullScreen: 0                // 0 : noFullScreen with no animation, 1: FullScreen with no animation, 2: noFullScreen with animation, 3: FullScreen with animation
    property bool isDragAndBounds: true;
    property bool setToastClose: false;

    property bool isKeyCanceled: false;

    signal toastPopupClose();

    function currentAppStateID() { return MJavascript.currentStateID(); }
    function preSelectedMainScreen() { return UIListener.popScreen(); }
    function setPreSelectedMainScreen() { UIListener.pushScreen(idAppMain.state); }
    function setAppMainScreen(mainScreen, saveCurrentScreen) { MJavascript.setPropertyChanges(mainScreen, saveCurrentScreen); }
    function gotoFirstScreen() { UIListener.HandleHomeKey(); }
    function gotoPreviousScreen(mainScreen) { UIListener.gotoPreviousScreen(mainScreen); MJavascript.setPropertyChanges(mainScreen, false); }
    function gotoFristScreenFroRequestFG() {MJavascript.toFirstScreen();}

    function gotoBackScreen(isTouch)
    {
        if(currentAppStateID() == idWSAlert)
        {
            if(idWSAlert.onBack() == true)
            {
                if(isWSAFromMenu)
                    MJavascript.backKeyProcessing(isTouch);
                else
                    gotoFristScreenFroRequestFG();
            }
        }
        else if(currentAppStateID().item.onBack() == true)
        {
            MJavascript.backKeyProcessing(isTouch);
        }
    }

    function onBack()
    {
        return true;
    }

    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    XMCommon.StringInfo { id: stringInfo }

    // Apply Translation
    Connections {
        target: UIListener
        onRetranslateUi: {
            console.log("DHXMDataMain: onRetranslateUi Occured!! languageId:" + languageId);
            LocTrigger.retrigger();
            stringInfo.retranslateUi();
        }

        onDisplayWSADetail: {
            if(idWSAlert.visible)
            {
                var uniqKey = idWSAlert.loadWSAPopupDetail();
                idWSAlert.showWSADetail(uniqKey);
            }else
            {
                UIListener.setMainFocusToWeather();
                setAppMainScreen("callForWSADetail", true);
            }
        }

        onGotoFirstScreen:{
            if(idAppMain.state != "callForXMDataMainMenu")
            gotoFristScreenFroRequestFG();
        }

        onCheckAntenaStatus:{
            doCheckAntenaStatus();
        }

        onSignalShowSystemPopup:{
            stopToastPopup();
            idAppMain.focusOn = false;
        }

        onSignalHideSystemPopup:{
            idAppMain.focusOn = true;
        }

    }

    Connections {
        target: weatherDataManager
        onWsaListModelChanged: {
            UIListener.consolMSG("=============== onWsaListModelChanged : value = " + on + ", idAppMain.state = " + idAppMain.state);
            console.log("=============== onWsaListModelChanged : value = " + on);
            if(idAppMain.state == "callForWSAlert" && on)
                idAppMain.isWsaListModelChanged = on;
            else
                idAppMain.isWsaListModelChanged = false;
        }
    }


    Connections {
        target: interfaceManager

        onAdvisoryMessage: {
            console.log("advisoryMessage - emit receive");
            switch(m_status)
            {
                case 1:
                {
                    idAppMain.statusAntSig = true;
                    idAppMain.isNoSignalStatus = true;
                    showCheckAntenna();
                    break;
                }
                case 2:
                {
                    idAppMain.statusAntSig = true;
                    idAppMain.isNoSignalStatus = true;
                    break;
                }
                case 3:
                {
                    if(idAppMain.isNoSignalStatus)
                    {
                        idAppMain.isNoSignalStatus = false;
                    }
                    break;
                }
                default:
                {
                    //do nothing.
                }
            }
        }

        onMmbIsCallStarted: {
            if(interfaceManager.isCallStarted)
            {
                idAppMain.isCallStart = true;
            }
            else
            {
                idAppMain.isCallStart = false;
            }
        }

        onMmbIsBTConnected: {
            if(interfaceManager.isBTConnected)
            {
                idAppMain.isBTConnectStatus = true;
            }
            else
                idAppMain.isBTConnectStatus = false;
            UIListener.consolMSG("onMmbIsBTConnected = " + idAppMain.isBTConnectStatus);
        }

    }

    // Image for Background
//    Image {
//        source: changeMainBGpath + "bg_type_a.png"
//        asynchronous: true
//    }

    // Click Event For Debugging.
//    MouseArea{
//        anchors.fill: parent
//        onPressAndHold: {
//            if(isDebugVersion)
//                idAppMain.debugOnOff = (idAppMain.debugOnOff)?false:true;
//            else
//                idAppMain.debugOnOff = false;
//            //console.log("DHXMDataMain: debugOnOff : " + debugOnOff);
//            //idAppMain.forceActiveFocus();
//        }
//        onClicked: {
//            idAppMain.returnToTouchMode();
//        }
//    }
    Keys.onPressed: {
        console.log("-XMDataMain Key pressed:" + event.key)
    }


    Image {
        source: imageInfo.imgFolderGeneral + "bg_main.png"
        asynchronous: true
    }

    QmlStatusBar {
        id: statusBar
        x: 0; y: 0;
        z: systemInfo.context_STATUSBAR
        width: 1280; height: 93
        homeType: "button"
        middleEast: false
        visible: opacity == 0 ? false : true;
        opacity: (isFullScreen == 0 || isFullScreen == 2) ? 1 : 0
        Behavior on opacity {NumberAnimation {duration: (isFullScreen == 2 || isFullScreen == 3) ? 200 : 0 } }
    }
//    Rectangle{
//        id: statusBar
//        x: 0; y: 0;
//        width: 1280; height: 93
//        visible: opacity == 0 ? false : true;
//        opacity: (isFullScreen == 0 || isFullScreen == 2) ? 1 : 0
//        Behavior on opacity {NumberAnimation {duration: (isFullScreen == 2 || isFullScreen == 3) ? 200 : 0 } }
//        color: "red"
//    }

    // Include Main Screens
    FocusScope {
        x:0;y:systemInfo.statusBarHeight
        focus:true
        id:idMainFocusScope
        z: systemInfo.context_CONTENT

        width:parent.width;
        height:parent.height - y

        // Load for XmDataMainMenu.qml
        Loader { id: idXmDataMainMenu; width:parent.width; height:parent.height; }

        // Load for StockMenu.qml
        Loader { id: idStockMenu; width:parent.width; height:parent.height }

        // Load for SportsMenu.qml
        Loader { id: idSportsMenu; width:parent.width; height:parent.height }

        // Load for WeatherMenu.qml
        Loader { id: idWeatherMenu; width:parent.width; height:parent.height }

        // Load for FuelPricesMenu.qml
        Loader { id: idFuelPricesMenu; width:parent.width; height:parent.height}

        // Load for MovieTimesMenu.qml
        Loader { id: idMovieTimesMenu; width:parent.width; height:parent.height }

        // Load for SiriusXMAlert.qml
        XMData.WeatherSecurityNAlerts { id: idWSAlert; visible: false; width:parent.width; height:parent.height }

        //For Debugging
        Rectangle{
            visible: isDebugMode();
            width:parent.width
            height:parent.height
            border.color: "white"
            border.width: 1
            color:"transparent"
            Text{text: "[Stating point] - idMainFocusScope"; color: "yellow"; }
        }
    }

    Loader {y: 0/*systemInfo.statusBarHeight*/; id: idRadioPopupWarning1Line; z: idMainFocusScope.z == systemInfo.context_CONTENT_LOW ? systemInfo.context_POPUP_LOW : systemInfo.context_POPUP}

    Loader {y: 0/*systemInfo.statusBarHeight*/; id: idRadioPopupWarning2Line; z: idMainFocusScope.z == systemInfo.context_CONTENT_LOW ? systemInfo.context_POPUP_LOW : systemInfo.context_POPUP}



    // Loading Completed!!
    Component.onCompleted: {
        console.log("[QML] DHXMDataMain onCompleted:")
        selectedMainScreen = "callForXMDataMainMenu"
        setAppMainScreen(selectedMainScreen, true);
        interfaceManager.loadAllPreloaders();
    }


    //***************************** Dim PopUp
    function showNotImplementedYet(){
        console.log("[QML] showNotImplementedYet")
        idPopup.popupFirstText= "Not yet implemented!";
        idPopup.popupLineCnt = 1;
        idPopup.visible = true;
    }
    function showNotConnectedYet(){
        console.log("[QML] showNotConnectedYet")
        idPopup.popupFirstText= "Not yet connected!";
        idPopup.popupLineCnt = 1;
        idPopup.visible = true;
    }
    function showNotConnectedWithNavigation(string){
        console.log("[QML] showNotConnectedWithNavigation")
        idPopup.popupFirstText= "Not connected with Navigation yet!";
        idPopup.popupLineCnt = 1;
        idPopup.visible = true;
    }
    function reallyDeletedSuccessfully(){
        console.log("[QML] reallyDeletedSuccessfully")
        idPopup.popupFirstText= stringInfo.sSTR_XMDATA_DELETED_SUCCESSFULLY;
        idPopup.popupLineCnt = 1;
        idPopup.visible = true;
        idPopup.focus = true;
        setToastClose = true;
    }

    function showDeletedSuccessfully(){
        console.log("[QML] showDeletedSuccessfully")
        idPopup.popupFirstText= stringInfo.sSTR_XMDATA_DELETED_SUCCESSFULLY;
        idPopup.popupLineCnt = 1;
        idPopup.visible = true;
        idPopup.focus = true;
    }
    function showAddedToFavorite(sencondText){
        console.log("[QML] showAddedToFavorite")
        idPopup.popupFirstText= stringInfo.sSTR_XMDATA_ADDED_TO_FAVORITE;
        idPopup.popupSecondText = sencondText;
        idPopup.popupLineCnt = 2;
        idPopup.visible = true;
        idPopup.focus = true;
    }
    function showListToFavoriteIsFull(){
        console.log("[QML] showListToFavoriteIsFull")
        idPopup.popupFirstText= stringInfo.sSTR_XMDATA_LIST_IS_FULL+" "+stringInfo.sSTR_XMDATA_UPMOST_10_ITEMS_CAN_BE_ADDED;
        idPopup.popupLineCnt = 1;
        idPopup.visible = true;
    }
    function showNotAffiliationList(){
        console.log("[QML] showNotAffiliationList")
        idPopup.popupFirstText= stringInfo.sSTR_XMDATA_NO_SPORTS_INFORMATION;
        idPopup.popupLineCnt = 1;
        idPopup.visible = true;
    }
    function showErrorPopup(result, detailResult){
        console.log("[QML] showErrorPopup")
        idPopup.popupFirstText= result;
        idPopup.popupLineCnt = 1;
        idPopup.visible = true;
    }

    function showNoSignalPopup(){
        if(idRadioPopupWarning2Line.visible == true)
        {
            idRadioPopupWarning2Line.focus = false;
            idRadioPopupWarning2Line.visible = false;
        }

        if( idRadioPopupWarning1Line.status == Loader.Null )
        {
            idRadioPopupWarning1Line.visible = false;
            idRadioPopupWarning1Line.source = "../component/XMData/Popup/PopupWarning1Line.qml";
        }

        if(idRadioPopupWarning1Line.visible == false)
        {
            idRadioPopupWarning1Line.visible = true;
        }
        idRadioPopupWarning1Line.focus = true;
        idRadioPopupWarning1Line.forceActiveFocus();
        idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMDATA_LOSS_OF_SIGNAL);
    }

    function showCheckAntenna(){
        if(idRadioPopupWarning1Line.visible == true)
        {
            idRadioPopupWarning1Line.focus = false;
            idRadioPopupWarning1Line.visible = false;
        }

        if( idRadioPopupWarning2Line.status == Loader.Null )
        {
            idRadioPopupWarning2Line.visible = false;
            idRadioPopupWarning2Line.source = "../component/XMData/Popup/PopupWarning2Line.qml";
        }

        if(idRadioPopupWarning2Line.visible == false)
        {
            idRadioPopupWarning2Line.visible = true;
        }
        idRadioPopupWarning2Line.focus = true;
        idRadioPopupWarning2Line.forceActiveFocus();
        idRadioPopupWarning2Line.item.onPopupWarning2LineFirst(stringInfo.sSTR_XMDATA_ANTENNA_ERROR1);
        idRadioPopupWarning2Line.item.onPopupWarning2LineSecond(stringInfo.sSTR_XMDATA_ANTENNA_ERROR2);
        idRadioPopupWarning2Line.item.onPopupWarning2LineSecondBtnUsed(false);
    }

    function doCheckAntenaStatus(){
        if(xmdataAntennaStatus.getAntennaStatus() == 2 || xmdataAntennaStatus.getAntennaStatus() == 3)
        {
            if(xmdataSignalStrength.getSignalStrength() == 0)       //DH_SIGNAL_QUALITY_NONE
            {
                showCheckAntenna();
                return false;
            }
        }
    }

    function stopToastPopup()//[ITS 187106]
    {
        if(idPopup.visible == true)
        {
            idVisualCueTimer.running = false;
            idPopup.visible = false;
            idPopup.focus = false;
            idMainFocusScope.focus = true;
            if(setToastClose)
            {
                setToastClose = false;
                idAppMain.toastPopupClose();
            }
        }
    }

    function isToastPopupVisible()
    {
        if(setToastClose == true)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    MComp.MPopupTypeToast {
        y:systemInfo.statusBarHeight
        z: idMainFocusScope.z == systemInfo.context_CONTENT_LOW ? systemInfo.context_POPUP_LOW : systemInfo.context_POPUP
        id: idPopup
        visible: false
        onVisibleChanged: {
            if(visible)
            {
                idVisualCueTimer.running = true;
            }
        }

        onPopupClicked: {
            stopToastPopup();
        }

        //[ITS 189036]
        onPopupBgClicked: {
            stopToastPopup();
        }
    }

    Timer {
        id:idVisualCueTimer;
        interval: 3000;
        running: false;
        repeat: false;
        onTriggered: {
            stopToastPopup();
        }
    }

    //for Debugging..
    property int debugOnOff: 0;
    property int buildOnOff: 0;
    function isDebugMode(){ return debugOnOff == 1; }
} /* end of idAppMain */


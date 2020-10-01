import Qt 4.7

// Local Import
import "./ListDelegate" as XMDelegate
import "./List" as XMList
import "../XMData/Common" as XMCommon
import "./Popup" as MPopup

// Because Loader is a focus scope, converted from FocusScope to Item.
//Item {
FocusScope{
    id:idXmDataMainMenu

    property int pointX : 20
    property int pointY : 175
    property int menuWidth: 414
    property int menuHeight: 177

    function onTitleOption(){
        idSubscriptionStatus.show();
    }

    // Loader for Four Background XMData
    focus:true;

    onVisibleChanged: {
        UIListener.consolMSG("XMMainMenu visible = " + visible);
        if(visible == false)
        {
            stopToastPopup();
        }
    }

    Keys.onPressed: {
        console.log("XMDataMainMenu Key pressed:" + event.key)
        if(idAppMain.isBackKey(event)){
            stopToastPopup();
            gotoBackScreen(false);//CCP
        }
    }

    function onBack()
    {
        //ITS Issue - 0150858
        if(idSubscriptionStatus.visible)
        {
            idSubscriptionStatus.hide();
            return false;
        }

        return true;
    }
    XMDelegate.XMDataMainMenuDelegate { id: idMainMenuDelegate }
    XMList.XMDataMainMenuModel{id: idMainMenulistModel}
    ListModel{
        id: idMainMenulistModel_Canada
        ListElement{
            delegateItemIndex: 1
            prevItem: 0
            nextItem: 0
        }
        ListElement{
            delegateItemIndex: 2
            prevItem: 1
            nextItem: 1
        }
        ListElement{
            delegateItemIndex: 3
            prevItem: 2
            nextItem: 2
        }
    }

    XMCommon.XMMBand{
        id: idMenuBar
        z: -1
        textTitle: stringInfo.sSTR_XMDATA_XMDATA
        menuBtnFlag: false
        subBtnFlag: true
        subBtnText: stringInfo.sSTR_XMDATA_SUBSCRIPTION
        xmLogoFlag: true
        contentItem: idMenuFocusScope
        subNoSignal: true
    }

    FocusScope{
        id:idMenuFocusScope
        x: 7;
        y: systemInfo.titleAreaHeight + 6;
        height:180*3
        width:parent.width-7
        focus : true

        property string debugname: "idMenuFocusScope"

        XMList.XMDataMainMenuList {
            id:idMainMenuList
            x: 0; y: 0
            width: parent.width
            height: parent.height
            focus: true
            listModel: (idAppMain.isVariantId == 6)? idMainMenulistModel_Canada : idMainMenulistModel
            listDelegate: idMainMenuDelegate
            visible: true
            property string debugname: "idMainMenuList"

            onVisibleChanged: {
                if(visible)
                    isDragAndBounds = (idAppMain.isVariantId == 6)? false : true
                else
                    isDragAndBounds = true;
            }
        }
    }

    MPopup.Case_E_Warning{
        id:idListIsSDMountPopUp
        visible : false;
        focus:false;
        detailText1: stringInfo.sSTR_XMDATA_SD_CARD_ERROR;
        popupLineCnt: 1

        onClose: {
            hide();
        }
        function show(){
            idListIsSDMountPopUp.visible = true;
            idListIsSDMountPopUp.focus = true;
        }
        function hide(){
            idListIsSDMountPopUp.visible = false;
            idListIsSDMountPopUp.focus = false;
            idMenuFocusScope.focus = true;
            idMenuFocusScope.forceActiveFocus();
        }
    }

    MPopup.Case_E_Warning{
        id:idTryAgainPopUp
        visible : false;
        focus:false;
        detailText1: stringInfo.sSTR_XMDATA_TRY_AGAIN_LATER;
        popupLineCnt: 1

        onClose: {
            hide();
        }
        function show(){
            idTryAgainPopUp.visible = true;
            idTryAgainPopUp.focus = true;
        }
        function hide(){
            idTryAgainPopUp.visible = false;
            idTryAgainPopUp.focus = false;
            idMenuFocusScope.focus = true;
            idMenuFocusScope.forceActiveFocus();
        }
    }

    function showHideCallPopup(value)
    {
        if(value)
        {
            if(idshCallPopup.visible == false)
                idshCallPopup.show();
        }
        else
        {
            if(idshCallPopup.visible == true)
                idshCallPopup.hide();
        }
    }

    MPopup.Case_DRS_Warning {
        id: idshCallPopup
        y:0
        visible: false
        focus:false;
        popupLineCnt: 1
        btDuringCall: true;
        detailText1: stringInfo.sSTR_XMDATA_BT_DURING_CALL_NOCALL
        detailText2: ""

        onClose: {
            hide();
        }
        function show(){
            //[ITS 191191]
            upKeyLongPressed = false;
            downKeyLongPressed = false;

            //[ITS 0233686] Check System Popup Flag
            if(UIListener.HandleGetSystemPopupFlag() == true)
                UIListener.HandleSetSystemPopupClose();

            if(idSubscriptionStatus.visible)
                idSubscriptionStatus.hide();

            if(idSubscriptionStatusNotify.visible)
                idSubscriptionStatusNotify.hide();

            idMenuFocusScope.focus = false;
            idshCallPopup.visible = true;
            idshCallPopup.focus = true;
            idshCallPopup.forceActiveFocus();
        }
        function hide(){
            idshCallPopup.visible = false;
            idshCallPopup.focus = false;
            idMenuFocusScope.focus = true;
            idMenuFocusScope.forceActiveFocus();
        }
    }

    // Subscription Status
    XMDataSubscriptionStatus{
        id:idSubscriptionStatus
        focus:false
        visible:false
        anchors.fill: parent
        onClose:
        {
            idSubscriptionStatus.initSubScriptionPopup();
            idSubscriptionStatus.hide();
        }
        function hide()
        {
            idSubscriptionStatus.visible = false;
            if(idMainMenuList.enableWeather || idMainMenuList.enableTraffic || idMainMenuList.enableStock || idMainMenuList.enableSports || idMainMenuList.enableFuel || idMainMenuList.enableMovie)
            {
                idMenuFocusScope.focus = true;
//                idMenuFocusScope.forceActiveFocus();
            }else
            {
//                idMenuBar.idBandTop.forceActiveFocus();
                if(idMenuFocusScope.KeyNavigation.up != null)
                    idMenuFocusScope.KeyNavigation.up.focus = true;
            }
        }
        function show()
        {
            idSubscriptionStatus.visible = true;
            idSubscriptionStatus.focus = true;
            idSubscriptionStatus.forceActiveFocus();
        }
    }

    // Subscription Status
    XMDataSubscriptionStatusNotify{
        id:idSubscriptionStatusNotify
        focus:false
        visible:false
        anchors.fill: parent
        onClose:
        {
            idSubscriptionStatusNotify.initSubScriptionPopup();
            idSubscriptionStatusNotify.hide();
        }
        function hide()
        {
            idSubscriptionStatusNotify.visible = false;
            idMenuFocusScope.focus = true;
//            idMenuFocusScope.forceActiveFocus();
        }
        function show(index)
        {
            idSubscriptionStatusNotify.nIndex = index;
            idSubscriptionStatusNotify.visible = true;
            idSubscriptionStatusNotify.focus = true;
            idSubscriptionStatusNotify.forceActiveFocus();
        }
    }

    function showHideDRSPopup(value)
    {
        if(value)
        {
            if(idshDRSPopup.visible == false)
                idshDRSPopup.show();
            else
            {
                idshDRSPopup.hide();
                idshDRSPopup.show();
            }
        }
        else
        {
                idshDRSPopup.hide();
        }
    }

    MPopup.Case_DRS_Warning {
        id: idshDRSPopup
        y:0
        visible: false
        focus:false;
        popupLineCnt: 1
        detailText1: stringInfo.sSTR_XMDATA_DRS_WARNING//"Not allowed to use, for safety reasons."
        detailText2: ""//"Only available when parked.";

        onClose: {
            hide();
            gotoFristScreenFroRequestFG();
        }
        function show(){
            //[ITS 191191]
            upKeyLongPressed = false;
            downKeyLongPressed = false;

            //[ITS 0233686] Check System Popup Flag
            if(UIListener.HandleGetSystemPopupFlag() == true)
                UIListener.HandleSetSystemPopupClose();

            if(idListIsSDMountPopUp.visible)
                idListIsSDMountPopUp.hide();

            if(idTryAgainPopUp.visible)
                idTryAgainPopUp.hide();

            idMenuFocusScope.focus = false;
            idshDRSPopup.visible = true;
            idshDRSPopup.focus = true;
            idshDRSPopup.forceActiveFocus();
        }
        function hide(){
            idshDRSPopup.visible = false;
            idshDRSPopup.focus = false;
            idMenuFocusScope.focus = true;
            idMenuFocusScope.forceActiveFocus();
            gotoFristScreenFroRequestFG();
        }

        Connections {
            target: interfaceManager
            onMmbIsDRSChanged: {
                if(interfaceManager.isDRSChanged == false)
                {
                    if(idshDRSPopup.visible == true)
                        showHideDRSPopup(false);
                }
            }
        }
    }

    //for Debugging..
    Text {
        x:5; y:12; id:idFileName
        text:"DHXMDataMainMenu.qml";
        color : "white"
        visible:isDebugMode();
    }

    XMRectangleForDebug {
        x:10;y:80;
        Column{
            Text{text: "XM Weather:" + getSubscriptionStatus(subscriptionData.SubWeather); color:"white";}
            Text{text: "XM AGW    :" + getSubscriptionStatus(subscriptionData.SubAGW); color:"white";}
            Text{text: "XM Traffic:" + getSubscriptionStatus(subscriptionData.SubTraffic); color:"white";}
            Text{text: "XM Stock  :" + getSubscriptionStatus(subscriptionData.SubStock); color:"white";}
            Text{text: "XM Sports :" + getSubscriptionStatus(subscriptionData.SubSports); color:"white";}
            Text{text: "XM Fuel   :" + getSubscriptionStatus(subscriptionData.SubFuelPrice); color:"white";}
            Text{text: "XM Movie  :" + getSubscriptionStatus(subscriptionData.SubMovieTimes); color:"white";}
        }
    }
    // function Descirption
    function getSubscriptionStatus(value)
    {
        switch(value){
        case 0:
            return stringInfo.sSTR_XMDATA_UNSUBSCRIBED;
        case 1:
            return stringInfo.sSTR_XMDATA_SUBSCRIBED;
        case 2:
            return stringInfo.sSTR_XMDATA_SUSPEND_ALERT;
        case 3:
            return stringInfo.sSTR_XMDATA_SUSPEND;
        case 4:
        default:
            return stringInfo.sSTR_XMDATA_INVALID;
        }
    }

    function checkFocusOfMovementEnd()
    {
        checkFocusOfScreen();
    }

    function checkFocusOfScreen()
    {
        if((idMenuFocusScope.visible == true) && (idMenuBar.contentItem.KeyNavigation.up.activeFocus == true)){
            idMenuFocusScope.focus = true;
            idMainMenuList.focus = true;
        }
    }

}

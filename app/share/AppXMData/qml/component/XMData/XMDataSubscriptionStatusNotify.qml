/**
 * FileName: XMDataSubscriptionStatus.qml
 * Author: David.Bae
 * Time: 2012-04-27 15:20
 *
 * - 2012-04-27 Initial Created by David
 */
import Qt 4.7

// System Import
import "../QML/DH" as MComp

MComp.MComponent{
    id:container
    z: systemInfo.context_POPUP
    width:parent.width;height:parent.height
    focus:false
    property int nIndex: 0
    property string firstText: ""
    property string sSXMID:"-----------"
    property bool isCallStart: idAppMain.isCallStart;
    property bool onActive: true
    property bool checkBTConnectStatus: idAppMain.isBTConnectStatus;

    signal close();

    //[ITS 216670]
    onIsCallStartChanged: {
        if(isCallStart && visible)
            close();
    }

    function getSubscriptionByIndex()
    {
        switch(nIndex)
        {
            case 1:             //traffic
            {
                return stringInfo.sSTR_XMDATA_SXM_TRAFFIC + " : " + getSubscriptionStatus(subscriptionData.SubTraffic);
            }
            case 2:             //stock
            {
                return stringInfo.sSTR_XMDATA_SXM_STOCK+ " : " + getSubscriptionStatus(subscriptionData.SubStock);
            }
            case 3:             //sports
            {
                return stringInfo.sSTR_XMDATA_SXM_SPORTS+ " : " + getSubscriptionStatus(subscriptionData.SubSports);
            }
            case 4:             //fuel
            {
                return stringInfo.sSTR_XMDATA_SXM_FUEL+ " : " + getSubscriptionStatus(subscriptionData.SubFuelPrice);
            }
            case 5:             //movie
            {
                return stringInfo.sSTR_XMDATA_SXM_MOVIE+ " : " + getSubscriptionStatus(subscriptionData.SubMovieTimes);
            }
            case 0:             //weather
            default:
            {
                return stringInfo.sSTR_XMDATA_SXM_WEATHER+ " : " + getSubscriptionStatus(subscriptionData.SubWeather);
            }
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

    function initSubScriptionPopup()
    {
        idMPopupTypeSubscriptionNotify.setButtonFocus();
    }

    MComp.MPopupTypeSubscriptionNotify{
        id:idMPopupTypeSubscriptionNotify
        popupBtnCnt: 2
        popupFirstText: getSubscriptionByIndex();
        popupNinthText: stringInfo.sSTR_XMDATA_SXM_ID + " : " + ((subscriptionData.SiriusXMID === "") ? sSXMID : subscriptionData.SiriusXMID);
        popupTenthText: (idAppMain.isVariantId == 6) ? stringInfo.sSTR_XMDATA_CALL_SIRI_TO_ENABLE_SERVICES_CANADA : stringInfo.sSTR_XMDATA_CALL888_539_SIRI_TO_ENABLE_SERVICES

        popupFirstBtnText: stringInfo.sSTR_XMDATA_OK
        popupSecondBtnText: stringInfo.sSTR_XMDATA_CALL
        secondBtnEnable: checkBTConnectStatus

        onVisibleChanged: {
            if(visible)
                container.onActive = true;
        }

        onPopupFirstBtnClicked: {
            close();
        }
        onPopupSecondBtnClicked: {
            onActive = false;
            if(isCallStart)
            {
                showHideCallPopup(true);
            }
            else
            {
                if(idAppMain.isVariantId == 6)
                    UIListener.doOutGoingBTCall("(877)438-9677");
                else
                    UIListener.doOutGoingBTCall("(800)643-2112");
            }
        }        

        onHardBackKeyClicked:{
            close();
        }

        MouseArea{
            anchors.fill: parent
            enabled: container.onActive ? false : true
        }
    }
    Connections{
        target:UIListener
        onTemporalModeMaintain:{
            container.onActive = true;

            if(!mbTemporalmode)
            {
                if(visible)
                    close();
            }
        }

        onSignalShowSystemPopup:{
            console.log("onSignalShowSystemPopup")
            if(visible)
                close();
        }
    }

    //XMRectangleForDebug{ border.width:5; border.color:"blue"}
}

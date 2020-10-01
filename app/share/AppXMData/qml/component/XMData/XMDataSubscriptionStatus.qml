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

    // Position/Size/focus Definition
    width:parent.width;height:parent.height
    focus:false
    // Property Definition include alias
    property string sSXMID:"-----------"
    property bool isCallStart: idAppMain.isCallStart;
    property bool onActive: true
    property bool checkBTConnectStatus: idAppMain.isBTConnectStatus;

    signal close();

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
        idMPopupTypeSubscription.setButtonFocus();
    }

    onIsCallStartChanged: {
        if(isCallStart && visible)
            close();
    }

    MComp.MPopupTypeSubscription{
        id:idMPopupTypeSubscription
        popupBtnCnt: 2

        popupFirstText: stringInfo.sSTR_XMDATA_SXM_RADIO + ": " + getSubscriptionStatus(subscriptionData.SubAudio);
        popupSecondText: stringInfo.sSTR_XMDATA_SXM_TRAFFIC + ": " + getSubscriptionStatus(subscriptionData.SubTraffic);
        popupThirdText: stringInfo.sSTR_XMDATA_SXM_WEATHER+ ": " + getSubscriptionStatus(subscriptionData.SubWeather);
        popupFourthText: stringInfo.sSTR_XMDATA_SXM_STOCK+ ": " + getSubscriptionStatus(subscriptionData.SubStock);
        popupFifthText: stringInfo.sSTR_XMDATA_SXM_SPORTS+ ": " + getSubscriptionStatus(subscriptionData.SubSports);
        popupSixthText: stringInfo.sSTR_XMDATA_SXM_FUEL+ ": " + getSubscriptionStatus(subscriptionData.SubFuelPrice);
        popupSeventhText: stringInfo.sSTR_XMDATA_SXM_MOVIE+ ": " + getSubscriptionStatus(subscriptionData.SubMovieTimes);
        popupEighthText: stringInfo.sSTR_XMDATA_SXM_AGW+ ": " + getSubscriptionStatus(subscriptionData.SubAGW);
        popupNinthText: stringInfo.sSTR_XMDATA_SXM_ID + ": " + ((subscriptionData.SiriusXMID === "") ? sSXMID : subscriptionData.SiriusXMID);        
//        popupTenthText: stringInfo.sSTR_XMDATA_CALL888_539_SIRI_TO_ENABLE_SERVICES //subscriptionData.PhoneNumber === "" ? stringInfo.sSTR_XMDATA_CALL888_539_SIRI_TO_ENABLE_SERVICES : sSTR_XMDATA_CALL + ":" + subscriptionData.PhoneNumber
        popupTenthText:  (idAppMain.isVariantId == 6) ? stringInfo.sSTR_XMDATA_CALL_SIRI_TO_ENABLE_SERVICES_CANADA : stringInfo.sSTR_XMDATA_CALL888_539_SIRI_TO_ENABLE_SERVICES //subscriptionData.PhoneNumber === "" ? stringInfo.sSTR_XMDATA_CALL888_539_SIRI_TO_ENABLE_SERVICES : sSTR_XMDATA_CALL + ":" + subscriptionData.PhoneNumber
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
            console.log("[QML] XMDataSubscriptionStatus.qml :: onSignalShowSystemPopup :: visible = " + visible)
            if(visible)
                close();
        }
    }
}

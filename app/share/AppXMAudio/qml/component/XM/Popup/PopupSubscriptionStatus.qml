/**
 * FileName: XMDataSubscriptionStatus.qml
 * Author: David.Bae
 * Time: 2012-04-27 15:20
 *
 * - 2012-04-27 Initial Created by David
 */

import Qt 4.7
import "../../QML/DH" as MComp

FocusScope{
    id:idRadioPopupSubscriptionStatusQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus:true

    property bool checkBTConnectStatus: false

    property string sSXMID:"-----------"
    property string sSXMNum: "8006432112"

    MComp.MPopupTypeSubscription{
        id: idRadioPopupSubscriptionStatus

        //Text
        popupFirstText: "SXM"/*stringInfo.sSTR_XMRADIO_SIRIUSXM*/+" "+stringInfo.sSTR_XMRADIO_AUDIO+" : "+subscriptionStatusText(SUBSCRIPTION.SubAudio)
        popupSecondText: "SXM"/*stringInfo.sSTR_XMRADIO_SIRIUSXM*/+" "+stringInfo.sSTR_XMRADIO_TRAFFIC+" : "+subscriptionStatusText(SUBSCRIPTION.SubTraffic);
        popupThirdText: "SXM"/*stringInfo.sSTR_XMRADIO_SIRIUSXM*/+" "+ stringInfo.sSTR_XMRADIO_WEATHER+" : "+subscriptionStatusText(SUBSCRIPTION.SubWeather)
        popupFourthText: "SXM"/*stringInfo.sSTR_XMRADIO_SIRIUSXM*/+" "+ stringInfo.sSTR_XMRADIO_STOCK+" : "+subscriptionStatusText(SUBSCRIPTION.SubStock)
        popupFifthText: "SXM"/*stringInfo.sSTR_XMRADIO_SIRIUSXM*/+" "+ stringInfo.sSTR_XMRADIO_SPORTS+" : "+subscriptionStatusText(SUBSCRIPTION.SubSports)
        popupSixthText: "SXM"/*stringInfo.sSTR_XMRADIO_SIRIUSXM*/+" "+ stringInfo.sSTR_XMRADIO_FUEL_PRICES+" : "+subscriptionStatusText(SUBSCRIPTION.SubFuelPrice)
        popupSeventhText: "SXM"/*stringInfo.sSTR_XMRADIO_SIRIUSXM*/+" "+ stringInfo.sSTR_XMRADIO_MOVIE_TIMES+" : "+subscriptionStatusText(SUBSCRIPTION.SubMovieTimes)
        popupEighthText: "SXM"/*stringInfo.sSTR_XMRADIO_SIRIUSXM*/+" "+ stringInfo.sSTR_XMRADIO_AGW+" : "+subscriptionStatusText(SUBSCRIPTION.SubAGW)

        //Button Text
        popupNinthText: stringInfo.sSTR_XMRADIO_RADIOID + " : " + ((SUBSCRIPTION.SiriusXMID == "") ? sSXMID : SUBSCRIPTION.SiriusXMID)
        popupTenthText: stringInfo.sSTR_XMRADIO_CALL888_539_SIRI_TO_ENABLE_SERVICES;

        popupFirstBtnText: stringInfo.sSTR_XMRADIO_OK
        popupSecondBtnText: stringInfo.sSTR_XMRADIO_CALL

        secondBtnEnable: checkBTConnectStatus

        onPopupFirstBtnClicked: {
            console.log("## Button clicked ##");
            idAppMain.gotoBackScreen(false);
        }
        onPopupSecondBtnClicked: {
            if (UIListener.HandleGetBTCallStart() == false)
            {
                console.log("## Button clicked BTCallStart## -> false");
                UIListener.DoOutGoingBTCall(sSXMNum/*SUBSCRIPTION.PhoneNumber*/);
            }
            else
            {
                console.log("## Button clicked BTCallStart## -> true");
                idAppMain.gotoBackScreen(false);
                setAppMainScreen("PopupRadioWarning1Line", true);
                idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_CALL_CONNECT);
                idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(false);
                idRadioPopupWarning1Line.item.onPopupWarning1LineWidthExtension(true);
            }
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupSubscriptionStatus - BackKey Clicked");
            idAppMain.gotoBackScreen(false);
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupSubscriptionStatus - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            UIListener.HandleHomeKey();
        }
    }

    function setPopupSubscriptionStatusClose()
    {
        idRadioPopupSubscriptionStatus.visible = false;
    }

    function subscriptionStatusText(i_status)
    {
        switch(i_status)
        {
        case 0: //XM_SUBSTATUS_NOT_SUBSCRIBED
            return stringInfo.sSTR_XMRADIO_UNSUBSCRIBED;
            break;
        case 1: //XM_SUBSTATUS_SUBSCRIBED
            return stringInfo.sSTR_XMRADIO_SUBSCRIBED;
            break;
        case 2: //XM_SUBSTATUS_SUSPEND_ALERT
            return stringInfo.sSTR_XMRADIO_SUSPEND_ALERT;
            break;
        case 3: //XM_SUBSTATUS_SUSPENDED
            return stringInfo.sSTR_XMRADIO_SUSPENDED;
            break;
        case 4: //XM_SUBSTATUS_INVALID
            return stringInfo.sSTR_XMRADIO_INVALID;
            break;
        }
    }

    function setBTConnectStatus(b_status)
    {
        if(b_status)
            checkBTConnectStatus = true;
        else
            checkBTConnectStatus = false;

        console.log("Set BT Connect Status --------> "+b_status+" "+checkBTConnectStatus);
    }
}

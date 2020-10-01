import Qt 4.7
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioPopupAlertQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property string alertFirstText : ""
    property string alertSecondText : ""
    property string alertThirdtext : ""
    property string alertChnID : ""
    property bool   alertThirdTextUsed : false

    MComp.MPopupTypeText{
        id: idRadioPopupAlertBox

        popupLineCnt : alertThirdTextUsed ? 3 : 2
        popupFirstText: alertFirstText
        popupSecondText: alertThirdTextUsed ? alertSecondText : stringInfo.sSTR_XMRADIO_IS_NOW_PLAYING
        popupThirdText: alertThirdTextUsed ? stringInfo.sSTR_XMRADIO_IS_NOW_PLAYING : null
        popupXMTextSize: true

        popupBtnCnt: 2

        popupFirstBtnText: stringInfo.sSTR_XMRADIO_TUNE
        popupSecondBtnText: stringInfo.sSTR_XMRADIO_IGNORE

        /* Popup List Button Click */
        onPopupFirstBtnClicked: {
            console.log("PopupAlert - Tune Clicked")
            UIListener.HandleChannelSelectByID(alertChnID);
            idAppMain.gotoBackScreen(false);
            idAppMain.gotoFirstScreen();
        }
        onPopupSecondBtnClicked: {
            console.log("PopupAlert - Ignore Clicked")
            idAppMain.gotoBackScreen(false);
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupAlert - BackKey Clicked");
            idAppMain.gotoBackScreen(false);
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupAlert - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            UIListener.HandleHomeKey();
        }
    }

    function onPopupAlertFirst(firsttext)
    {
        alertFirstText = firsttext;
    }

    function onPopupAlertSecond(secondtext)
    {
        alertSecondText = secondtext;
    }

    function onPopupAlertThird(thirdtext)
    {
        alertThirdtext = thirdtext;
    }

    function onPopupAlertChnID(chnID)
    {
        alertChnID = chnID;
    }

    function onPopupAlertThirdTextUsed(b_statue)
    {
        alertThirdTextUsed = b_statue;
    }
}

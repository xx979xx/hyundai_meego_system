import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

FocusScope {
    id: idRadioPopupMsg1LineQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property string msg1LineTitle : ""
    property string msg1LineFirst : ""
    property string msg1LineSelect : ""
    property bool   secondBtnUsed : false

    MComp.MPopupTypeText{
        id: idRadioPopupMsg1

        popupLineCnt : 1
        popupFirstText: msg1LineFirst

        popupBtnCnt: 2

        popupFirstBtnText: stringInfo.sSTR_XMRADIO_YES
        popupSecondBtnText: stringInfo.sSTR_XMRADIO_NO

        onPopupFirstBtnClicked: {
            console.log("## First Button clicked ##")
            if(msg1LineSelect == "Favorite")
            {
                if(idAppMain.gSXMFavoriteList == "SONG")
                    ATSeek.handleFavoriteDeleteAll(1);
                else if(idAppMain.gSXMFavoriteList == "ARTIST")
                    ATSeek.handleFavoriteDeleteAll(2);

                idAppMain.gotoBackScreen(false);
                XMOperation.favoriteDeletefinished();
            }
            else if(msg1LineSelect == "List")
            {
                idAppMain.gotoBackScreen(false);
                XMOperation.onListSkip();
            }
        }
        onPopupSecondBtnClicked: {
            console.log("## Second Button clicked ##")
            idAppMain.selectAllcancelandok();
            idAppMain.gotoBackScreen(false);
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupMsg1Line - BackKey Clicked");
            idAppMain.selectAllcancelandok();
            idAppMain.gotoBackScreen(false);
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupMsg1Line - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            UIListener.HandleHomeKey();
        }
    }

    function onPopupMsg1LineTitle(title)
    {
        msg1LineTitle = title;
    }

    function onPopupMsg1LineFirst(firsttext)
    {
        msg1LineFirst = firsttext;
    }

    function onPopupMsg1LineSelect(selecttext)
    {
        msg1LineSelect = selecttext;
    }
}

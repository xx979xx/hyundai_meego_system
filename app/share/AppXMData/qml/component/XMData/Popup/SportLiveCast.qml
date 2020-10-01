import Qt 4.7
import "../../QML/DH" as MComp
import "../Common" as XMCommon

MComp.MPopupTypeList{
    id: idPopupLiveCast

    property int homeCH: 0
    property int visitingCH: 0
    property int nationalCH: 0

    popupLineCnt: 3
    popupBtnCnt: 1

    popupFirstBtnText: stringInfo.sSTR_XMDATA_CANCEL

    idListModel: idListModel

    onPopuplistItemClicked: {
        console.log("selectedItemIndex", selectedItemIndex)
        var chNumber;
        if(selectedItemIndex == 0){
            if(homeCH > 0)
                chNumber = homeCH;
            else
            {
                console.debug("homeCH is Null.")
                return;
            }
        }
        else if(selectedItemIndex == 1){
            if(visitingCH > 0)
                chNumber = visitingCH;
            else
            {
                console.debug("visitingCH is Null.")
                return;
            }
        }
        else{
            if(nationalCH > 0)
                chNumber = nationalCH;
            else
            {
                console.debug("nationalCH is Null.")
                return;
            }
        }
        console.debug("homeCH: " + homeCH + "visitingCH: " + visitingCH + "nationalCH: " + nationalCH)

        if(chNumber > 0)
        {
            sportsDataManager.reqSendSXMToAudio(chNumber, false)
            if(!UIListener.HandleGoToSXMAudio()){
                showNotConnectedYet("NotifyUISH event sending failed");
            }
        }
    }

    onPopupFirstBtnClicked: {
//            idDataMPopuList.visible = false;
        onBack();
    }
    onHardBackKeyClicked: {
//        onBack();
    }

    ListModel {
        id: idListModel
        ListElement { listFirstItem: ""; msgValue: true;}
        ListElement { listFirstItem: ""; msgValue: true;}
        ListElement { listFirstItem: ""; msgValue: true;}
    }

//    onBackKeyPressed: {/*setModelList(); */onBack() /*gotoBackScreen()*/}
    onHomeKeyPressed: {
        UIListener.HandleHomeKey();
    }


    function setModelString(){
        var i;
        //msgModel
        for(i = 0; i < idListModel.count; i++)
        {
            //console.log("["+i+"]:" + idPopupMsgModel.get(i).msgName);
            switch(i){
            case 0:{
                console.log("["+i+"]:" + homeCH);
                idListModel.get(i).listFirstItem = "Home Broadcast";
                if(homeCH > 0)
                    idListModel.get(i).msgValue = true;
                else
                    idListModel.get(i).msgValue = false;
                //idListModel.get(i).msgValue = homeCH;
                break;
            }
            case 1:{
                console.log("["+i+"]:" + visitingCH);
                idListModel.get(i).listFirstItem = "Away Broadcast";
                if(visitingCH > 0)
                    idListModel.get(i).msgValue = true;
                else
                    idListModel.get(i).msgValue = false;
                break;
            }
            case 2:{
                console.log("["+i+"]:" + nationalCH);
                idListModel.get(i).listFirstItem = "National Broadcast";
                //idListModel.get(i).msgValue = nationalCH;
                if(nationalCH > 0)
                    idListModel.get(i).msgValue = true;
                else
                    idListModel.get(i).msgValue = false;
                break;
            }
            default:
                break;
            }
        }
    }

    function doCheckFocus()
    {
        if(visible){
            console.debug("onVisibleChanged homeCH: " + homeCH + "visitingCH: " + visitingCH + "nationalCH: " + nationalCH);

            if(homeCH == 0)
            {
                if(visitingCH == 0)
                {
                    listView.currentIndex = 2;
                }
                else
                {
                    listView.currentIndex = 1;
                }
            }
            else{
                listView.currentIndex = 0;
            }

            listView.currentItem.focus = true;
            listView.currentItem.forceActiveFocus();
            setModelString();
        }
    }

    onVisibleChanged: {
        if(visible){
            console.debug("onVisibleChanged homeCH: " + homeCH + "visitingCH: " + visitingCH + "nationalCH: " + nationalCH);

            if(homeCH == 0)
            {
                if(visitingCH == 0)
                {
                    listView.currentIndex = 2;
                }
                else
                {
                    listView.currentIndex = 1;
                }
            }
            else{
                listView.currentIndex = 0;
            }

            listView.currentItem.focus = true;
            listView.currentItem.forceActiveFocus();
            setModelString();
        }
    }

    Connections{
        target:UIListener
        onTemporalModeMaintain:{
            if(!mbTemporalmode)
            {
                if(visible)
                {
                    onBack();
                }
            }
        }

        onSignalShowSystemPopup:{
            console.log("onSignalShowSystemPopup")
            if(visible)
                onBack();
        }
    }

}

/**
 * FileName: Case_C_ChannelName.qml
 * Author: David.Bae
 * Time: 2012-05-11 17:07
 *
 * - 2012-05-11 Initial Created by David
 */
import Qt 4.7

// System Import
import "../../QML/DH" as MComp

FocusScope{
    id: idCase_C_ChannelName

    property string firstLineText;
    property string secondLineText;

    signal close();
    signal button1Clicked();
    signal button2Clicked();

    MComp.MPopupTypeList{
        id: idDataMPopuList

        popupLineCnt: 2
        popupBtnCnt: 1

        popupFirstBtnText: stringInfo.sSTR_XMDATA_CANCEL

        idListModel: idListModel

        onPopuplistItemClicked: {
            console.log("selectedItemIndex", selectedItemIndex)
            if(selectedItemIndex == 0){
                button1Clicked();
            }
            else{
                button2Clicked();
            }
        }

        onPopupFirstBtnClicked: {
            close();
        }

        onHardBackKeyClicked: {
            close();
        }

        ListModel {
            id: idListModel
            ListElement{listFirstItem: "test1"; msgValue: true;}
            ListElement{listFirstItem: "test2"; msgValue: true;}
        }

    }

    onVisibleChanged: {
        if(visible)
            setPopupListModelString();
    }

    function setPopupListModelString(){
        var i;
        //List
        for(i = 0; i < idListModel.count; i++)
        {
            //console.log("["+i+"]:" + idRadioPopupListModel.get(i).msgName);
            switch(i){
            case 0: { idListModel.get(i).listFirstItem = firstLineText; break; }
            case 1: { idListModel.get(i).listFirstItem = secondLineText; break; }
            default: break;
            }
        }
    }

    Connections{
        target:UIListener
        onTemporalModeMaintain:{
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
}

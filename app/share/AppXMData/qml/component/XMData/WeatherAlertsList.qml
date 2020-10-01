import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "./Popup" as XMPopup

FocusScope{
    id:container

    property alias indexForWSADetailPopup: idList.currentIndex

    Component {
        id: idListDelegate
        XMDelegate.XMWeatherSecurityNAlertsDelegate{
        }
    }

    XMList.XMDataNormalList{//[ITS 185394]
        id: idList
        focus: true
        anchors.fill: parent
        listModel: WSAlertsList
        listDelegate: idListDelegate
        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_WSA_NO_INFO
        KeyNavigation.down: idList;

        onVisibleChanged: {
            if(visible)
            {
                listView.positionViewAtIndex(currentIndex, ListView.Contain);
            }
        }

        onCountChanged: {
            if(visible)
            {
                if(count == 0)
                {
                    upFocusAndLock(true);
                    idMenuBar.focusInitLeft();
                }else
                {
                    upFocusAndLock(false);
                    var tempIndex = currentIndex
                    currentIndexInitDelegate();
                    idList.currentIndex = tempIndex;
                }
            }
        }
    }

    function doMoveDetailItemRow(row){
        if(row < 0 || row > idList.count)
            row = 0;
        idList.currentIndex = -1;
        idList.currentIndex = row;
    }

    function currentIndexInitDelegate()
    {
        idList.currentIndex = -1;
    }
    function initCurrentIndex()
    {
        idList.currentIndex = 0
        idList.listView.positionViewAtIndex(idList.currentIndex, ListView.Visible);
    }
    function resetCurrentIndex(){
        if(idList.count == 0)
        {
            idMenuBar.idBandTop.forceActiveFocus();
            upFocusAndLock(true);
        }else
        {
            upFocusAndLock(false);
            idList.currentIndex = 0
            idList.listView.currentItem.forceActiveFocus();
            idList.listView.positionViewAtIndex(idList.currentIndex, ListView.Beginning);
        }
    }

    function reCheckFocusLock(){
        if(idList.count == 0)
        {
            upFocusAndLock(true);
        }else
        {
            upFocusAndLock(false);
        }
    }
}

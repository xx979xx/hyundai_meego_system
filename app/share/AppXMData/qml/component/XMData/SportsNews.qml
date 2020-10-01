import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Label Import
import "./Common" as XMCommon
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "../XMData" as MXData

FocusScope {
    id:container

    x:0; y:0;
    focus: true //false
    property alias listCount: idList.count

    Component{
        id: idListDelegate
        XMDelegate.XMSportsNewsDelegate{
            y: 0;
            width:idList.width;
        }
    }

    XMList.XMDataNormalList{
        id: idList
        focus: true
        anchors.fill: parent
        listModel: sportsNewsListModel
        listDelegate: idListDelegate

        sectionShow: false;

        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_NO_SPORTS_INFORMATION

        Connections{
            target : sportsDataManager
            onCheckForFocus:{
                if(idList.visible)
                {
                    if(idList.count == 0)
                    {
                        upFocusAndLock(true);
                    }else
                    {
                        upFocusAndLock(false);
                        idList.listView.positionViewAtIndex(0, ListView.Visible);
                        idList.listView.currentIndex = 0;
                        if(isLeftMenuEvent)
                            idList.forceActiveFocus();
                    }
                }
            }
        }
    }
}

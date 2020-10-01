/**
 * FileName: SportsScoreHeadToHead.qml
 * Author: David.Bae
 * Time: 2012-06-04 18:04
 *
 * - 2012-06-04 Initial Created by David
 */
import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Label Import
import "./Common" as XMCommon
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "../XMData" as MXData
//import "../../component/XMData/Common" as XMCommon

FocusScope {
    id:container    

    x:0; y:0;
    focus: true //false
    property alias listCount: idList.count

    XMCommon.StringInfo { id: stringInfo }

    Component{
        id: idListDelegate
        XMDelegate.XMSportsScheduleHeadToHeadDelegate{
            y: 0;
            width:idList.width;
        }
    }


    XMList.XMSportDataNormalList{
        id: idList
        focus: true
        anchors.fill: parent
        listModel:sportsSchduleListModel
        listDelegate: idListDelegate

        sectionShow: true;
        sectionProperty: "SectionName"
        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_SPORTS_NO_SCHEDULE
        sportKeyLongProperty : true;

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

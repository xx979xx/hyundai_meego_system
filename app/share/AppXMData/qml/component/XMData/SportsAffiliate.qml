/**
 * FileName: SportsAffiliate.qml
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
//import "../../component/XMData/Common" as XMCommon

FocusScope {
    id:container
    x:0; y:0;
    focus: true //false

    XMCommon.StringInfo { id: stringInfo }

    property alias listModel: idList.listModel

    property int leagueID : 0;
    property int sportsID: 0;

    Component{
        id: idListDelegate
        XMDelegate.XMSportsAffiliateListDelegate{
            //x:50;
            x:0; y:0
            width:ListView.view.width-35; height: 92
            onAffiliateSelected: {
                 selectAffiliate(affiliateID, affiliateName, false, 0, -1);
            }
        }
    }

    XMList.XMSportsList/*XMNormalList*/{
        id: idList
        focus: true
        width: parent.width;
        height: parent.height;
        listDelegate: idListDelegate
        listModel:sportsLeagueListModel

        sectionX: 0
        sectionShow: true;
        sectionProperty: "sportID"

        function keyDown() {
            return idList;
        }
        KeyNavigation.down: keyDown();

        Connections{
            target : sportsDataManager
            onCheckForFocus:{
                if(idList.visible)
                {
                    if(idList.count == 0)
                    {
                        leftFocusAndLock(true);
                    }else
                    {
                        leftFocusAndLock(false);
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

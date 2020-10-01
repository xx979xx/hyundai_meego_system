/**
 * FileName: SportsAllLeague.qml
 * Author: David.Bae
 * Time: 2012-05-25 17:19
 *
 * - 2012-05-25 Initial Created by David
 */
import Qt 4.7

// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "../QML/DH" as MComp
import "./ListElement" as XMListElement
import "./Popup" as MPopup
import "./Javascript/Definition.js" as MDefinition
import "./Menu" as MMenu

FocusScope {
    id:container
    focus: true

    property alias listModel: idList.listModel
    property alias listView: idList.listView
    property string selectedBrand : "";
    property string selectedType : "";

    Component{
        id: idListDelegate
        XMDelegate.XMSportsRootListDelegate
        {
            onSportsListSelected: {
                selectRootAffiliate(sportID, sportName);
            }
        }
    }
    XMList.XMDataNormalList{
        id: idList
        x:0;y:0
        focus: true
        width: parent.width;
        height: parent.height;
        listDelegate: idListDelegate
        listModel: sportsListModel//sportsLeagueListModel;

        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_NO_AFFILIATION        

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

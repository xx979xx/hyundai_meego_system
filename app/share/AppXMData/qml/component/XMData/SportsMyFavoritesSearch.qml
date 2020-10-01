/**
 * FileName: SportsMyFavoritesSearch.qml
 * Author: David.Bae
 * Time: 2012-06-14 14:04
 *
 * - 2012-06-14 Initial Created by David
 */
import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "./Javascript/Definition.js" as MDefinition
import "../XMData/Popup" as MPopup

FocusScope{
    id:container
    width:systemInfo.lcdWidth;
    height:systemInfo.lcdHeight-systemInfo.titleAreaHeight;
    focus: true

    property alias listModel: idList.listModel

    function init()
    {
        //do nothing
    }

    Component.onCompleted: {
        init();
    }

    onVisibleChanged: {
        if(container.visible==true){
            init();
        }
    }

    Component{
        id: idListDelegate
        XMDelegate.XMSportsFavoriteSearchListDelegate {
            width:idList.width;
            onAddSportTeamToFavorites: {
                console.log("Add Favorite selected.. lID:" + lID + ", uID:" + uID + ", lName:" + lName + ", tID:" + tID + ", tName:" + tName + ", nName:" + nName + ", aName:" + aName)
                if(sportsDataManager.addFavoriteTeam(index, lID, uID, lName, tID, tName, nName, aName))
                    showAddedToFavorite(sportsDataManager.getRegisterFavoriteCount());
            }
            onDelSportTeamToFavorites: {
                console.log("DEL Favorite selected.. tID:" + tID)
                if(sportsDataManager.delFavoriteTeam(index, lID, uID, lName, tID, tName, nName, aName))
                {
                    showDeletedSuccessfully();
                }
            }
        }
    }

    XMList.XMDataNormalList{
        id:idList
        x:0;y:0
        focus: true
        width: parent.width;
        height: parent.height;
        listModel: sportsTeamListModel
        listDelegate: idListDelegate

        sectionX: 33;
        sectionShow: false;
        sectionProperty: "leagueName";
        showSearchCacheBuffer: false

        onCountChanged: {
            if(visible)
            {
                idMenuBar.foundItemCount = count;
                idMenuBar.imageSearchItemIcon = imageInfo.imgFolderXMData + "icon_sports.png"
            }
        }

        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_SPORTS_NO_SEARCH_RESULT;
    }

    Binding {
        target: sportsDataManager; property: "searchPredicate"; value: idMenuBar.textSearchTextInput; when: idMenuBar.intelliUpdate
    }

    function showListIsFull()
    {
        idListIsFullPopUp.show();
    }

    function hideListIsFull()
    {
        if(idListIsFullPopUp.visible)
            idListIsFullPopUp.hide();
    }

    MPopup.Case_E_Warning{
        id:idListIsFullPopUp
        x: 0
        y: -systemInfo.titleAreaHeight;
        z: 0
        visible : false;
        focus:false;
        detailText1: stringInfo.sSTR_XMDATA_LIST_IS_FULL;
        detailText2: stringInfo.sSTR_XMDATA_UPMOST_10_ITEMS_CAN_BE_ADDED;

        onClose: {
            hide();
        }
        function show(){
            idMenuBar.z = -2;
            idListIsFullPopUp.z = idMenuBar.z+2;
            idList.focus = false;
            idListIsFullPopUp.visible = true;
            idListIsFullPopUp.focus = true;
        }
        function hide(){
            idListIsFullPopUp.z = idMenuBar.z-1;
            idMenuBar.z = 1;
            idListIsFullPopUp.visible = false;
            idListIsFullPopUp.focus = false;
            idList.focus = true;
            idList.forceActiveFocus();
        }
    }
}

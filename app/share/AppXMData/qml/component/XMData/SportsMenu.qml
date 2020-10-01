/**
 * FileName: SportsMenu.qml
 * Author: David.Bae
 * Time: 2012-05-25 17:19
 *
 * - 2012-05-25 Initial Created by David
 */

import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./Menu" as MMenu
import "./Common" as XMCommon
import "../XMData/Popup" as MXPopup
import "./Common" as XMMComp

// Because Loader is a focus scope, converted from FocusScope to Item.
FocusScope {
    id:idSportMenu
    objectName: "sportsMenu"
    property int sportsID: 0;
    property bool selSportFav: false

    SportsLabelDefinition {id: sportsLabel }

    width:systemInfo.lcdWidth;
    height:systemInfo.lcdHeight;

    property string szSportMode:"sportAllSports"
    property int viewMode: 0             // 0 : HeadToHead_Score 1: HeadToHead_Schedule 2: RankedList
    property bool checkDRSStatus: idAppMain.isDRSChange

    property bool clockTime: interfaceManager.DBIsClockTimeSaving;

    property string szAffiliateName: ""
    property int nAffiliateID: 0
    property bool bModeflag: false
    property int ntID: 0
    property int nuID: 0
    property bool bClockChangeNews: false

    focus:true;

    onVisibleChanged: {
        UIListener.consolMSG("SportMenu visible = " + visible);
        if(visible == false)
        {
            idDrsScreen.hide();
            sportsDataManager.isMainMenuUpdated();
        }
    }

    FocusScope{
        id:idCenterFocusScope
        y:0;
        width:parent.width;
        height: parent.height-y;
        focus:true;

        FocusScope{
            id:idMainMenuAndListFocusScope
            y:systemInfo.titleAreaHeight;
            width:parent.width;
            height: parent.height-y;

            XMDataLeftMenuGroup{
                id:idLeftMenuFocusScope
                x:0; y:0;
                KeyNavigation.right: idSportsListArea
                countOfButton: 2; //MovieTimes has 3 Left Menu(

                button1Text: stringInfo.sSTR_XMDATA_ALL_SPORTS;
                button1Active: szSportMode == "sportAllSports"
                onButton1Clicked: {
                    selectLeague();
                }
                button2Text: stringInfo.sSTR_XMDATA_FAVORITE
                button2Active: szSportMode == "sportsFavorite"
                onButton2Clicked: {
                    selectFavorite();
                }
            }
            //Main Menu Right List
            FocusScope{
                id:idSportsListArea
                x:idLeftMenuFocusScope.width;
                width:parent.width - idLeftMenuFocusScope.width
                height:idMainMenuAndListFocusScope.height;
                KeyNavigation.left: idLeftMenuFocusScope
                focus:true;

                //All League
                Loader{
                    id:idAllLeague
                    anchors.fill: parent

                    function hide()
                    {
                        idAllLeague.focus = false;
                        idAllLeague.visible = false;
                    }

                    function show()
                    {
                        if(idFavorite.visible)
                            idFavorite.hide();
                        if(idSportsAffiliateListArea.visible)
                            idSportsAffiliateListArea.hide();
                        if(idScoreHeadToHead.visible)
                            idScoreHeadToHead.hide();
                        if(idScheduleHeadToHead.visible)
                            idScheduleHeadToHead.hide();
                        if(idNews.visible)
                            idNews.hide();
                        if(idScoreRankedList.visible)
                            idScoreRankedList.hide();
                        if(idAllLeague.source == "")
                            idAllLeague.source = "SportsAllLeague.qml"
                        idAllLeague.visible = true;

                        if(checkDRSStatus == false)
                        {
                            idAllLeague.forceActiveFocus();
                        }
                        else
                        {
                            idAllLeague.focus = true;
                        }
                    }
                    XMRectangleForDebug{}
                }

                //Affiliation List
                Loader{
                    id:idSportsAffiliateListArea
                    anchors.fill: parent
                    focus: false
                    visible: false

                    function hide()
                    {
                        idSportsAffiliateListArea.focus = false;
                        idSportsAffiliateListArea.visible = false;
//                        idSportsAffiliateListArea.source = ""
                        if(szSportMode == "sportsFavorite")
                            idFavorite.show();
                        else
                            idAllLeague.show();
                        idMenuBar.resetTitle();
                    }
                    function show()
                    {
                        if(idSportsAffiliateListArea.source == "")
                            idSportsAffiliateListArea.source = "SportsAffiliate.qml"
                        idAllLeague.hide();
                        idSportsAffiliateListArea.visible = true;
                        idSportsAffiliateListArea.focus = true;
                        if(checkDRSStatus == false)
                        {
                            idSportsAffiliateListArea.forceActiveFocus();
                        }
                    }
                }
                //Favorite List
                Loader{
                    id:idFavorite
                    anchors.fill: parent

                    function hide()
                    {
                        idFavorite.focus = false;
                        idFavorite.visible = false;
//                        idFavorite.source = ""
                    }

                    function show(){
                        if(idAllLeague.visible)
                            idAllLeague.hide();
                        if(idSportsAffiliateListArea.visible)
                            idSportsAffiliateListArea.hide();
                        if(idScheduleHeadToHead.visible)
                            idScheduleHeadToHead.hide();
                        if(idScoreHeadToHead.visible)
                            idScoreHeadToHead.hide();
                        if(idScoreRankedList.visible)
                            idScoreRankedList.hide();

                        if(idMenuBar.sportScoreBtnFlag)
                            idMenuBar.sportScoreBtnFlag = false;
                        if(idFavorite.source == "")
                            idFavorite.source = "SportsMyFavorites.qml"
                        idFavorite.visible = true;

                        if(checkDRSStatus == false)
                        {
                            idFavorite.forceActiveFocus();
                        }
                        else
                        {
                            idFavorite.focus = true;
                        }
                    }
                    XMRectangleForDebug{}
                }
            }
        } //idMainMenuAndListFocusScope

        Loader{
            id: idScoreHeadToHead
            x:0; y:systemInfo.titleAreaHeight;
            width:parent.width
            height:parent.height-y;
            focus: false
            visible: false

            function hide()
            {
                idMenuBar.resetTitle();
                idMenuBar.sportScoreBtnFlag = false;
                if(selSportFav)
                    idMenuBar.menuBtnFlag = true;
                else
                    idMenuBar.menuBtnFlag = false;
                idScoreHeadToHead.focus = false;
                idScoreHeadToHead.source = ""
                idMainMenuAndListFocusScope.focus = true;
                idMainMenuAndListFocusScope.visible = true;
                idScoreHeadToHead.visible = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.forceActiveFocus();
                }
            }
            function show(affiliateName)
            {
                viewMode = 0;
                idMenuBar.sportScoreBtnFlag = true;
                idMenuBar.menuBtnFlag = true;
                idMenuBar.sportScroeBtnText = stringInfo.sSTR_XMDATA_SPORTS_SCHEDULE;

                idMainMenuAndListFocusScope.visible = false;
                idMenuBar.textTitle = affiliateName
                idScoreHeadToHead.source = "SportsScoreHeadToHead.qml"
                idScoreHeadToHead.visible = true;
                idSportsAffiliateListArea.visible = false;
                idSportsAffiliateListArea.focus = false;
                idScoreHeadToHead.focus = true;
                if(checkDRSStatus == false)
                {
                    idMenuBar.focusInitLeft();
                    idScoreHeadToHead.forceActiveFocus();
                }
            }
        }

        Loader{
            id: idScheduleHeadToHead
            x:0; y:systemInfo.titleAreaHeight;
            width:parent.width
            height:parent.height-y;
            focus: false
            visible: false

            function hide()
            {
                idMenuBar.resetTitle();
                idMenuBar.sportScoreBtnFlag = false;
                if(selSportFav)
                    idMenuBar.menuBtnFlag = true;
                else
                    idMenuBar.menuBtnFlag = false;
                idScheduleHeadToHead.focus = false;
                idScheduleHeadToHead.source = ""
                idMainMenuAndListFocusScope.focus = true;
                idMainMenuAndListFocusScope.visible = true;
                idScheduleHeadToHead.visible = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.forceActiveFocus();
                }
            }

            function show(affiliateName)
            {
                viewMode = 1;
                idMenuBar.sportScoreBtnFlag = true;
                idMenuBar.menuBtnFlag = true;
                idMenuBar.sportScroeBtnText = stringInfo.sSTR_XMDATA_SPORTS_SCORE;

                idMainMenuAndListFocusScope.visible = false;
                idMenuBar.textTitle = affiliateName
                idScheduleHeadToHead.source = "SportsScheduleHeadToHead.qml"
                idScheduleHeadToHead.visible = true;
                idSportsAffiliateListArea.visible = false;
                idSportsAffiliateListArea.focus = false;
                idScheduleHeadToHead.focus = true;
                if(checkDRSStatus == false)
                {
                    idScheduleHeadToHead.forceActiveFocus();
                }
            }
        }

        Loader{
            id: idNews
            x:0; y:systemInfo.titleAreaHeight;
            width:parent.width
            height:parent.height-y;
            focus: false
            visible: false

            function hide()
            {
                idNews.focus = false;
                if(idNews.item != null)
                {
                    idNews.item.visible = false;
                    idNews.source = ""
                }
                idNews.visible = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.forceActiveFocus();
                }
            }
            function show()
            {
                idMenuBar.sportScoreBtnFlag = false;//viewMode == 0 ? true : viewMode == 1 ? true : false;
                idMenuBar.menuBtnFlag = false;
                idMenuBar.sportScroeBtnText = stringInfo.sSTR_XMDATA_SPORTS_SCORE;

                idMainMenuAndListFocusScope.visible = false;

                idScheduleHeadToHead.visible = false;
                idScoreHeadToHead.visible = false;
                idScoreRankedList.visible = false;

                idNews.source = "SportsNews.qml"
                idNews.visible = true;
                idSportsAffiliateListArea.visible = false;
                idSportsAffiliateListArea.focus = false;
                idNews.focus = true;
                idNews.forceActiveFocus();
                sportsDataManager.checkForFocusForElement(false);
            }
        }

        Loader{
            id: idScoreRankedList
            x:0; y:systemInfo.titleAreaHeight;
            width:parent.width
            height:parent.height-y;
            focus: false
            visible: false
            property string titleString: ""

            function hide()
            {
                idMenuBar.resetTitle();
                idMenuBar.menuBtnFlag = false;
                idScoreRankedList.focus = false;
                idScoreRankedList.source = "";
                idMainMenuAndListFocusScope.focus = true;
                idMainMenuAndListFocusScope.visible = true;
                idScoreRankedList.visible = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.forceActiveFocus();
                }
                upFocusAndLock(false);
            }
            function show(affiliateName)
            {
                viewMode = 2;
                idMenuBar.sportScoreBtnFlag = false;
                idMenuBar.menuBtnFlag = true;
                titleString = affiliateName;

                idMainMenuAndListFocusScope.visible = false;
                idMenuBar.textTitle = titleString
                idMenuBar.focusInitLeft();
                idScoreRankedList.source = "SportsScoreRankedList.qml"
                idScoreRankedList.visible = true;
                idSportsAffiliateListArea.visible = false;
                idSportsAffiliateListArea.focus = false;
                idScoreRankedList.focus = true;
                if(checkDRSStatus == false)
                {
                    idScoreRankedList.forceActiveFocus();
                }
            }
        }

        Loader{
            id: idRankedDetailItem
            x:0; y:systemInfo.titleAreaHeight;
            width:parent.width
            height:parent.height-y;
            focus: false
            visible: false

            function hide()
            {
                idMenuBar.menuBtnFlag = true;
                idRankedDetailItem.focus = false;
                idRankedDetailItem.source = ""
                idScoreRankedList.focus = true;
                idScoreRankedList.visible = true;
                idMenuBar.textTitle = idScoreRankedList.titleString;
                idRankedDetailItem.visible = false;
                if(checkDRSStatus == false)
                {
                    idScoreRankedList.forceActiveFocus();
                    sportsDataManager.checkForFocusForElement(false);
                }
            }
            function show()
            {
                idMenuBar.menuBtnFlag = false;
                idScoreRankedList.visible = false;
                idSportsAffiliateListArea.visible = false;
                idSportsAffiliateListArea.focus = false;

                idRankedDetailItem.source = "SportsRankedListDetail.qml"
                idRankedDetailItem.visible = true;
                idRankedDetailItem.focus = true;
                idRankedDetailItem.forceActiveFocus();
                idRankedDetailItem.item.onCheckFocus();
            }
        }

        //Search League
        Loader{
            id:idFavoritesSearch
            x:0; y:systemInfo.titleAreaHeight;
            width:parent.width
            height:parent.height-y;
            focus: false
            visible: false

            function hide()
            {
                idMenuBar.resetTitle();
                idMenuBar.visibleSearchTextInput = false;
                idFavoritesSearch.focus = false;
                idFavoritesSearch.source = ""
                idMainMenuAndListFocusScope.focus = true;
                idMainMenuAndListFocusScope.visible = true;
                idFavoritesSearch.visible = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.forceActiveFocus();
                }
            }
            function show()
            {
                idMenuBar.textTitle = stringInfo.sSTR_XMDATA_SEARCH
                idMenuBar.visibleSearchTextInput = true;
                idMainMenuAndListFocusScope.focus = false;
                idMainMenuAndListFocusScope.visible = false;
                idFavoritesSearch.source = "SportsMyFavoritesSearch.qml"
                idFavoritesSearch.visible = true;
                idFavoritesSearch.focus = true;
            }
        }//Search League

        //Delete Favorite
        Loader{
            id:idDeleteFavorite
            x:0; y:systemInfo.titleAreaHeight;
            width:parent.width
            height:parent.height-y;
            focus: false
            visible: false

            function hide()
            {
                idMenuBar.resetTitle();
                idDeleteFavorite.focus = false;
                idDeleteFavorite.source = ""
                idMainMenuAndListFocusScope.visible = true;
                idMenuBar.deleteAllNoFlag = false;
                idDeleteFavorite.visible = false;
                if(isToastPopupVisible() == false)
                {
                    idMainMenuAndListFocusScope.focus = true;
                    if(checkDRSStatus == false)
                    {
                        idCenterFocusScope.forceActiveFocus();
                    }
                }
                sportsDataManager.updateListFavoriteRoleOfFavoriteList();
            }
            function show()
            {
                idMainMenuAndListFocusScope.focus = false;
                idMainMenuAndListFocusScope.visible = false;
                idDeleteFavorite.source = "SportsMyFavoritesDeleteTeam.qml"
                idDeleteFavorite.visible = true;
                idMenuBar.deleteAllNoFlag = true;
                idDeleteFavorite.focus = true;
                idDeleteFavorite.forceActiveFocus();
            }

            Connections{
                target: idDeleteFavorite.item
                onClose:{
                    onBack();
                }
                onShowDeleteAllPopup: {
                    idDeleteAllQuestion.show();
                }
            }
        }//Delete Favorite

        //Reorder Favorite
        Loader{
            id:idReorderFavorite
            x:0; y:systemInfo.titleAreaHeight;
            width:parent.width
            height:parent.height-y;
            focus: false
            visible: false

            function hide()
            {
                if(idReorderFavorite.item != null)
                {
                    if(idReorderFavorite.item.isHide())
                    {
                        idMenuBar.resetTitle();
                        idMenuBar.menuBtnFlag = true;
                        idReorderFavorite.focus = false;
                        idReorderFavorite.source = ""
                        idMainMenuAndListFocusScope.focus = true;
                        idMainMenuAndListFocusScope.visible = true;
                        idReorderFavorite.visible = false;
                        if(checkDRSStatus == false)
                        {
                            idCenterFocusScope.forceActiveFocus();
                        }
                        sportsDataManager.updateListFavoriteRoleOfFavoriteList();
                        return true;
                    }else
                    {
                        return false;
                    }
                }
            }

            function show()
            {
                sportsDataManager.initReorderDataModelAndView();
                idMenuBar.menuBtnFlag = false;
                idMainMenuAndListFocusScope.focus = false;
                idMainMenuAndListFocusScope.visible = false;
                idReorderFavorite.source = "SportsMyFavoritesReorderTeam.qml"
                idReorderFavorite.visible = true;
                idReorderFavorite.focus = true;
                idReorderFavorite.forceActiveFocus();
            }
        }

        MXPopup.SportLiveCast{
            id:idPopupLiveCast
            focus:false;
            visible:false;

            function hide()
            {
                if(viewMode == 2)
                {
                    idScoreRankedList.focus = true;
                }else
                {
                    idScoreHeadToHead.focus = true;
                }

                idPopupLiveCast.visible = false;
                idPopupLiveCast.focus = false;
                idCenterFocusScope.forceActiveFocus();
            }
            function show(hCH,vCH,nCH)
            {
                homeCH = hCH;
                visitingCH = vCH;
                nationalCH = nCH;

                idPopupLiveCast.visible = true;
                idPopupLiveCast.focus = true;
                idPopupLiveCast.forceActiveFocus();
                idPopupLiveCast.doCheckFocus();
            }
        }

        MXPopup.Case_D_DeleteAllQuestion{
            id:idDeleteAllQuestion
            visible : false;
            text: stringInfo.sSTR_XMDATA_DELETE_ALL_MESSAGE
            property string targetId;
            property QtObject target;
            onClose: {
                sportsDataManager.rollbackDeleteItems();
                hide();
            }
            onButton1Clicked: {
                //Delete All?
                sportsDataManager.deleteAllFavoriteList();
                reallyDeletedSuccessfully();
                idDeleteAllQuestion.visible = false;
                idDeleteAllQuestion.focus = false;
                onBack();
            }
            function show(){
                idCenterFocusScope.focus = false;
                idDeleteAllQuestion.visible = true;
                idDeleteAllQuestion.focus = true;
                idDeleteAllQuestion.forceActiveFocus();
            }
            function hide(){
                idDeleteAllQuestion.visible = false;
                idDeleteAllQuestion.focus = false;
                //[ITS 185180]
                idDeleteFavorite.focus = true;
                idDeleteFavorite.forceActiveFocus();
            }
        }
    }


    XMMComp.XMMBand
    {
        id: idMenuBar
        z: -1
        textTitle: stringInfo.sSTR_XMDATA_SPORTS
        menuBtnFlag: false
        sportFavText: selSportFav
        sportScoreBtnFlag: false
        intelliKey: sportsDataManager.dIntelliKey
        contentItem: idCenterFocusScope
        checkDRSVisible: (checkDRSStatus && visible)

        function resetTitle()
        {
            if(idAllLeague.visible == true){
                textTitle = stringInfo.sSTR_XMDATA_SPORTS
            }
            else if(idFavorite.visible == true){
                textTitle = stringInfo.sSTR_XMDATA_SPORTS

            }
            else{
                if(idSportsAffiliateListArea.visible == true)
                {
                    textTitle = stringInfo.sSTR_XMDATA_SPORTS;
                }else
                {
                    textTitle = stringInfo.sSTR_XMDATA_SPORTS;
                }
            }
        }
    }

    XMDataDRS
    {
        id: idDrsScreen
        x:0; y:0;
        z: parent.z+1
        width:systemInfo.lcdWidth;
        height:systemInfo.contentAreaHeight;
        focus: false
        visible: checkDRSStatus

        function show()
        {
            stopToastPopup();
            idDrsScreen.visible = true;
            UIListener.consolMSG("SportsMenu idDrsScreen show");
        }
        function hide()
        {
            idDrsScreen.visible = false;
        }
    }

    //Option Menu   
    Loader{id:idOptionMenu; z: parent.z+1}

    Component{
        id:idCompOptionMenuForAllLeague

        MMenu.SportsOptionMenuForAllLeague {
            id:idOptionMenuForAllLeague
            onMenuHided: {
                idOptionMenuForAllLeague.focus = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.focus = true;

                    if(idScoreRankedList.visible && idScoreRankedList.item.listCount == 0)
                    {
                        sportsDataManager.checkForFocusForElement(false);
                    }
                    //[ITS 185631]
                    if((idScheduleHeadToHead.visible && idScheduleHeadToHead.item.listCount == 0) ||
                            (idScoreHeadToHead.visible && idScoreHeadToHead.item.listCount ==0))
                    {
                        sportsDataManager.checkForFocusForElement(false);
                    }
                }
            }
            onOptionMenuSchedule: {
                if(idScheduleHeadToHead.visible || idScoreHeadToHead.visible)
                {
                    onScoreScheduleToggle();
                }else if(idScoreRankedList.visible)
                {
                    idNews.show();
                }
            }

            onOptionMenuNewsItem: {
                if(idScoreRankedList.visible)
                {
                    sportsDataManager.reqSendSXMToAudio(0,true)
                    if(!UIListener.HandleGoToSXMAudio()){
                        showNotConnectedYet("NotifyUISH event sending failed");
                    }
                }else
                {
                    idNews.show();
                }
            }

            onOptionMenuGoToSXMRadio: {
                sportsDataManager.reqSendSXMToAudio(0,true)
                if(!UIListener.HandleGoToSXMAudio()){
                    showNotConnectedYet("NotifyUISH event sending failed");
                }
            }
        }
    }

    Component{
        id:idCompOptionMenuForFavorite
        MMenu.SportsOptionMenuForFavorite {
            id:idOptionMenuForFavorite
            onMenuHided: {
                idOptionMenuForFavorite.focus = false;
                if(checkDRSStatus == false)
                {
                    idCenterFocusScope.focus = true;
                    if(idDeleteFavorite.visible)
                    {
                        idDeleteFavorite.focus = true;
                        idDeleteFavorite.item.moveFocusToList();
                    }
                    else
                    {
                        idMainMenuAndListFocusScope
                        idSportsListArea.focus = true;
                    }
                }
            }
            onOptionMenuSearch:{
                idFavoritesSearch.show();
            }
            onOptionMenuReorder: {
                idReorderFavorite.show();
            }

            onOptionMenuDelete: {
                idDeleteFavorite.show();
            }
            onOptionMenuCancelDelete: {
                onBack();
            }
        }
    }

    Keys.onPressed: {
        console.log("[QML] SportsMenu.qml Key Pressed")
        if( idAppMain.isMenuKey(event) ) {
            onOptionOnOff();
        }else if(idAppMain.isBackKey(event)){
            if(onBack() == true)
            {
                stopToastPopup();
                gotoBackScreen(false);//CCP
            }
        }
    }


    onCheckDRSStatusChanged: {
        if(visible)
        {
            if(checkDRSStatus == true && idDrsScreen.visible == false)
            {
                if(idFavoritesSearch.visible)
                {
                    idFavoritesSearch.item.hideListIsFull();
                }
                if(idPopupLiveCast.visible)
                {
                    idPopupLiveCast.hide();
                }
                else if(idDeleteAllQuestion.visible)
                {
                    idDeleteAllQuestion.hide();
                }
                else
                {
                    idSportsListArea.focus = true;
                }
                idDrsScreen.show();
            }
            else if(checkDRSStatus == false && idDrsScreen.visible == true)
            {
                idDrsScreen.hide();
            }
        }
    }

    function onOptionOnOff()
    {
        console.log("[QML] SportsMenu: call menu")
        if(checkDRSStatus == true) {return;}
        if(idFavoritesSearch.visible) return;
        if(idReorderFavorite.visible) return;
        if(idDeleteAllQuestion.visible == true) return;
        if(idPopupLiveCast.visible) return;

        if(idScoreHeadToHead.visible || idScheduleHeadToHead.visible || idScoreRankedList.visible){
            idOptionMenu.visible = true;
            idOptionMenu.sourceComponent = idCompOptionMenuForAllLeague;
            idOptionMenu.item.showMenu();
            idCenterFocusScope.focus = false;
            idOptionMenu.focus = true;
        }else if(szSportMode == "sportsFavorite" && !idNews.visible){

            idOptionMenu.sourceComponent = idCompOptionMenuForFavorite;

            if(idDeleteFavorite.visible)
                idOptionMenu.item.menuForDelete = true;
            else
                idOptionMenu.item.menuForDelete = false;

            idOptionMenu.item.showMenu();
            idCenterFocusScope.focus = false;
            idOptionMenu.focus = true;
            if(idFavorite.item.listCount == 0)
            {
                idOptionMenu.item.optionMenu.menu1Enabled = false
                idOptionMenu.item.optionMenu.menu2Enabled = false
            }
            else
            {
                idOptionMenu.item.optionMenu.menu1Enabled = true
                idOptionMenu.item.optionMenu.menu2Enabled = true
            }
        }
    }

    function onBack()
    {
//        stopToastPopup();//Smoke Test Faile case
        if(idDeleteFavorite.visible){
            idDeleteFavorite.hide();
            return false;
        }
        if(idPopupLiveCast.visible){
            idPopupLiveCast.hide();
            return false;
        }

        if(idReorderFavorite.visible){
            if(!idReorderFavorite.hide())
            {
                return false;
            }
            return false;
        }

        if(idScoreHeadToHead.visible || idScheduleHeadToHead.visible)
        {
            idScoreHeadToHead.hide();
            idScheduleHeadToHead.hide();
            if(selSportFav)
            {
                idFavorite.show();
                idScheduleHeadToHead.hide();
                idScoreHeadToHead.hide();
                idNews.hide();
                selSportFav = false;
            }
            else
            {
                idSportsAffiliateListArea.show();
                idScheduleHeadToHead.hide();
                idScoreHeadToHead.hide();
                idNews.hide();
            }

            upFocusAndLock(false);//[ITS 205812]

            return false;
        }

        if(idNews.visible)
        {
            idNews.hide();
            if(viewMode == 0)
            {
                idScoreHeadToHead.show(idMenuBar.textTitle);
                if(idScoreHeadToHead.item.listCount == 0)
                    upFocusAndLock(true);
                else
                    upFocusAndLock(false);
            }else if(viewMode == 1)
            {
                idScheduleHeadToHead.show(idMenuBar.textTitle);
                if(idScheduleHeadToHead.item.listCount == 0)
                    upFocusAndLock(true);
                else
                    upFocusAndLock(false);
            }else if(viewMode == 2)
            {
                idScoreRankedList.show(idScoreRankedList.titleString);
                if(idScoreRankedList.item.listCount == 0)
                    upFocusAndLock(true);
                else
                    upFocusAndLock(false);
            }

            if(bClockChangeNews)
            {
                sportsDataManager.checkForFocusForElement(false);
                bClockChangeNews = false;
            }
            return false;
        }

        if(idScoreRankedList.visible)
        {
            idSportsAffiliateListArea.show();
            idScoreRankedList.hide();
            return false;
        }

        if(idRankedDetailItem.visible){
            idRankedDetailItem.hide();
            return false;
        }

        if(idSportsAffiliateListArea.visible){
            idSportsAffiliateListArea.hide();
            return false;
        }

        if(idFavoritesSearch.visible){            
            idFavoritesSearch.hide();
            return false;
        }
        return true;
    }

    function selectLeague()
    {
        szSportMode = "sportAllSports"

        idMainMenuAndListFocusScope.focus = true;
        idSportsListArea.focus = true;
        idMenuBar.menuBtnFlag = false;
        idAllLeague.show();
        idAllLeague.item.listView.positionViewAtIndex(0, ListView.view);
        idAllLeague.item.listView.currentIndex = 0;

        if(checkDRSStatus)
        {
            idDrsScreen.show();
        }
    }

    function selectFavorite()
    {
        szSportMode = "sportsFavorite"
        sportsID = 0

        idMainMenuAndListFocusScope.focus = true;
        idSportsListArea.focus = true;
        idMenuBar.menuBtnFlag = true;
        idFavorite.show();
        idFavorite.item.listView.positionViewAtIndex(0, ListView.view);
        idFavorite.item.listView.currentIndex = 0;
    }

    function searchTeamForFavorite()
    {
        idFavoritesSearch.show();
    }

    function selectRootAffiliate(sportID, sportName)
    {
        sportsID = sportID;
        sportsDataManager.selectSportList(sportID);
        idSportsAffiliateListArea.show();
        sportsDataManager.checkForFocusForElement(false);
    }

    function selectAffiliate(affiliateID, affiliateName, selFav, teamID, uID)
    {        
        console.log("[QML] affiliateID = " + affiliateID + ", affiliateName = " + affiliateName + ", selFav = " + selFav + ", teamID = " + teamID + ", uID = " + uID + ", sportsID = " + sportsID)

        nAffiliateID = affiliateID;
        szAffiliateName = affiliateName;
        bModeflag = selFav;
        ntID = teamID;
        nuID = uID;

        sportsDataManager.selectAffiliateList(affiliateID, selFav, teamID,uID);

        if(sportsID == sportsLabel.iSPORTS_MOTORSPORT || sportsID == sportsLabel.iSPORTS_GOLF)
        {
            idScoreRankedList.show(affiliateName);
        }else
        {
            idScoreHeadToHead.show(affiliateName);
        }
        sportsDataManager.checkForFocusForElement(false);
    }

    function selectRankedListItem(UniqKey)
    {
        sportsDataManager.selectLinkedListItem(UniqKey);
        idRankedDetailItem.show();
    }

    function onScoreScheduleToggle()
    {
        if(idNews.visible == true)
        {
            idNews.hide();
            idScoreHeadToHead.show(idMenuBar.textTitle);
            if(idScoreHeadToHead.item.listCount == 0)
                upFocusAndLock(true);
            else
                upFocusAndLock(false);
        }else if(idScoreHeadToHead.visible == true)
        {
            idScoreHeadToHead.visible = false;
            idScheduleHeadToHead.show(idMenuBar.textTitle);
            if(idScheduleHeadToHead.item.listCount == 0)
                upFocusAndLock(true);
            else
                upFocusAndLock(false);
        }else
        {
            idScheduleHeadToHead.visible = false;
            idScoreHeadToHead.show(idMenuBar.textTitle);
            if(idScoreHeadToHead.item.listCount == 0)
                upFocusAndLock(true);
            else
                upFocusAndLock(false);
        }
    }
    function getStringFromEpoch(epoch)
    {
        var day = new Date();
        day.setTime(epoch*1000);

        var dayUTC = new Date(day.getUTCFullYear(), day.getUTCMonth(), day.getUTCDate(), day.getUTCHours(), day.getUTCMinutes(), day.getUTCSeconds(), day.getUTCMilliseconds());

        return Qt.formatDate(dayUTC, "ddd, MMM dd");
    }

    function leftFocusAndLock(isLock)
    {
        if(isLock == true)
        {
            if(idLeftMenuFocusScope.visible)
                idLeftMenuFocusScope.forceActiveFocus();
            idLeftMenuFocusScope.KeyNavigation.right = null;
        }else{
            idLeftMenuFocusScope.KeyNavigation.right = idSportsListArea;
        }
    }

    function upFocusAndLock(isLock)
    {
        if(isLock == true)
        {
            if(checkDRSStatus == false)
            {
                if(idCenterFocusScope.visible)
                {
                    idCenterFocusScope.KeyNavigation.up.forceActiveFocus();
                }
            }
            if(idMenuBar.contentItem != null)
            {
                idMenuBar.contentItem.KeyNavigation.up.KeyNavigation.down = null;
                idMenuBar.contentItem = null;
            }
        }else{
            idMenuBar.contentItem = idCenterFocusScope;
            if(checkDRSStatus == false)
            {
                idMenuBar.contentItem.KeyNavigation.up.KeyNavigation.down = idCenterFocusScope;
            }
        }
    }
    function checkFocusOfMovementEnd()
    {
        checkFocusOfScreen();
    }

    function checkFocusOfScreen()
    {
        if(idCenterFocusScope.visible == true && (idLeftMenuFocusScope.activeFocus == true || idMenuBar.contentItem.KeyNavigation.up.activeFocus == true)){
            idCenterFocusScope.focus = true;
            if(idMainMenuAndListFocusScope.visible == true){
                idMainMenuAndListFocusScope.focus = true;
                idSportsListArea.focus = true;
            }else if(idNews.visible == true) {
                idNews.focus = true;
            }else if(idScoreHeadToHead.visible == true){
                idScoreHeadToHead.focus = true;
            }else if(idScheduleHeadToHead.visible == true){
                idScheduleHeadToHead.focus = true;
            }else if(idScoreRankedList.visible == true){
                idScoreRankedList.focus = true;
            }else if(idRankedDetailItem.visible == true){
                idRankedDetailItem.focus = true;
            }else if(idFavoritesSearch.visible == true){
                idFavoritesSearch.focus = true;
            }
        }
    }

    function initLeftMenuFocus()
    {
        idLeftMenuFocusScope.initFirstFocus();
    }

    onClockTimeChanged:{
        if(idScoreHeadToHead.visible || idScheduleHeadToHead.visible || idNews.visible)
        {            
            sportsDataManager.selectAffiliateList(nAffiliateID, bModeflag, ntID,nuID);
            sportsDataManager.checkForFocusForElement(false);
        }
    }

    Connections {
        target : idAppMain
        onToastPopupClose:{
            if(visible)
            {
                UIListener.consolMSG("SportMenu onToastPopupClose");
                idMainMenuAndListFocusScope.focus = true;
                idCenterFocusScope.forceActiveFocus();
            }
        }
    }
}

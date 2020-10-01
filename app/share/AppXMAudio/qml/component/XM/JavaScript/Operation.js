/**
 * FileName: RadioOperation.js
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

function toFirstScreen() {
    /* Main and Sub-Main */
//    idRadioMain.visible = false;
    idRadioList.visible = false;
    idRadioSearch.visible = false;
    idRadioGameZone.visible = false;
    idRadioFavorite.visible = false;
    idRadioGameSet.visible = false;
    idRadioGameActive.visible = false;
    idRadioEPG.visible = false;
    idRadioFeaturedFavorites.visible = false;
    idRadioEngineering.visible = false;
    idRadioDealerMode.visible = false;
    idRadioFavoriteActive.visible = false;
    /* PopUp */
    idRadioPopupAddToFavorite.visible = false;
    idRadioPopupDim1Line.visible = false;
    idRadioPopupDim2Line.visible = false;
    idRadioPopupDim1Line5Second.visible = false;
    idRadioPopupWarning1Line.visible = false;
    idRadioPopupWarning2Line.visible = false;
    idRadioPopupDRSWarning1Line.visible = false;
    idRadioPopupIRWarning2Line.visible = false;
    idRadioPopupMsg1Line.visible = false;
    idRadioPopupAlert.visible = false;
    idRadioPopupEPGInfo2Btn.visible = false;
    idRadioPopupEPGInfo3Btn.visible = false;
    idRadioPopupSubscriptionStatus.visible = false;
    idRadioPopupEPGInfoPreservedProgram.visible = false;
    /* Option Menu */
    idRadioOptionMenu.visible = false;
    idRadioOptionMenuSub.visible = false;
    idRadioDeleteMenu.visible = false;
    idRadioCancelMenu.visible = false;
    idRadioListMenu.visible = false;
    idRadioEPGMenu.visible = false;

    //Favorites List - Delete list initial
    if(gSXMFavoriteDelete == "DELETE")
    {
        gSXMFavoriteDelete = "LIST";
        gSXMFavoriteList = "SONG";
    }

    setPropertyChanges("AppRadioMain", false);
}

//jdh20131005 : ITS 183500, 190995, 191330, 191645, 193821
//Popup visible false, Don't used Previous Main Stack(Display changed - List,EPG,Favorites List), change focus position
function closePopupAndOptionMenu()
{
    /* PopUp */
    idRadioPopupAddToFavorite.visible = false;
    idRadioPopupDim1Line.visible = false;
    idRadioPopupDim2Line.visible = false;
    idRadioPopupDim1Line5Second.visible = false;
    idRadioPopupWarning1Line.visible = false;
    idRadioPopupWarning2Line.visible = false;
    idRadioPopupDRSWarning1Line.visible = false;
    idRadioPopupIRWarning2Line.visible = false;
    if(idRadioPopupMsg1Line.visible == true)
    {
        idAppMain.selectAllcancelandok();
    }
    idRadioPopupMsg1Line.visible = false;
    idRadioPopupAlert.visible = false;
    idRadioPopupEPGInfo2Btn.visible = false;
    idRadioPopupEPGInfo3Btn.visible = false;
    idRadioPopupSubscriptionStatus.visible = false;
    idRadioPopupEPGInfoPreservedProgram.visible = false;
    /* Option Menu */
    if(idRadioOptionMenuSub.visible == true)
        idAppMain.optionMenuAllOff();
    else if(idRadioOptionMenu.visible == true && idRadioOptionMenuSub.visible == false)
        idAppMain.optionMenuAllHide();
    idRadioDeleteMenu.visible = false;
    idRadioCancelMenu.visible = false;
    idRadioListMenu.visible = false;
    idRadioEPGMenu.visible = false;

    setPreviousMainAndClosePopupMenu(idAppMain.preMainScreen, false);
}

function setPreviousMainAndClosePopupMenu(mainScreen, saveCurrentScreen) {
    if( saveCurrentScreen == true )
        setPreSelectedMainScreen();
    else
    {
        switch(idAppMain.state)
        {
            /* PopUp */
        case "PopupRadioAddToFavorite":         idRadioPopupAddToFavorite.visible = false; break;
        case "PopupRadioDim1Line":              idRadioPopupDim1Line.visible = false; break;
        case "PopupRadioDim2Line":              idRadioPopupDim2Line.visible = false; break;
        case "PopupRadioDim1Line5Second":       idRadioPopupDim1Line5Second.visible = false; break;
        case "PopupRadioWarning1Line":          idRadioPopupWarning1Line.visible = false; break;
        case "PopupRadioWarning2Line":          idRadioPopupWarning2Line.visible = false; break;
        case "PopupDRSWarning1Line":            idRadioPopupDRSWarning1Line.visible = false; break;
        case "PopupRadioIRWarning2Line":        idRadioPopupIRWarning2Line.visible = false; break;
        case "PopupRadioMsg1Line":              idRadioPopupMsg1Line.visible = false; break;
        case "PopupRadioAlert":                 idRadioPopupAlert.visible = false; break;
        case "PopupRadioEPGInfo2Btn":           idRadioPopupEPGInfo2Btn.visible = false; break;
        case "PopupRadioEPGInfo3Btn":           idRadioPopupEPGInfo3Btn.visible = false; break;
        case "PopupRadioSubscriptionStatus":    idRadioPopupSubscriptionStatus.visible = false; break;
        case "PopupRadioEPGInfoPreservedProgram":idRadioPopupEPGInfoPreservedProgram.visible = false; break;
        case "PopupRadioAdvisory1Line":         idRadioPopupAdvisory1Line.visible = false; break;
            /* Option Menu */
        case "AppRadioOptionMenu":              idRadioOptionMenu.visible = false; break;
        case "AppRadioOptionMenuSub":           idRadioOptionMenuSub.visible = false; break;
        case "AppRadioFavDeleteMenu":           idRadioDeleteMenu.visible = false; break;
        case "AppRadioFavCancelMenu":           idRadioCancelMenu.visible = false; break;
        case "AppRadioListMenu":                idRadioListMenu.visible = false; break;
        case "AppRadioEPGMenu":                 idRadioEPGMenu.visible = false; break;

        default: if( idAppMain.state != "" ) console.log(" (saveCurrentScreen == false)  Error!! " + idAppMain.state); break;
        }
    }

    console.log("################ setPropertyChanges ################ "+ idAppMain.state + " " + mainScreen);

    idAppMain.state = mainScreen;
    idAppMain.focus = true;

    UIListener.HandleAppState(mainScreen);
}

//****************************** # BackKey Processing #
function backKeyProcessing(bTouchBack) {
    console.log("BackKey Processing : " + idAppMain.state + "Back Status : " + bTouchBack);
    switch(idAppMain.state)
    {
    case "AppRadioMain":{
        UIListener.HandleBackKey(bTouchBack);
        break;
    }
    default:{
        setAppMainScreen(preSelectedMainScreen(), false);
        break;
    }
    }
}

//****************************** # Getting ID of Current State Item (for focus move?) #
function currentStateID()
{
    console.log("currentStateID() : " + idAppMain.state);
    switch(idAppMain.state)
    {
        /* Main and Sub-Main */
    case "AppRadioMain":                    return idRadioMain;
    case "AppRadioList":                    return idRadioList;
    case "AppRadioSearch":                  return idRadioSearch;
    case "AppRadioGameZone":                return idRadioGameZone;
    case "AppRadioFavorite":                return idRadioFavorite;
    case "AppRadioGameSet":                 return idRadioGameSet;
    case "AppRadioGameActive":              return idRadioGameActive;
    case "AppRadioEPG":                     return idRadioEPG;
    case "AppRadioFeaturedFavorites":       return idRadioFeaturedFavorites;
    case "AppRadioEngineering":             return idRadioEngineering;
    case "AppRadioDealerMode":              return idRadioDealerMode;
    case "AppRadioFavoriteActive":          return idRadioFavoriteActive;
        /* PopUp */
    case "PopupRadioAddToFavorite":         return idRadioPopupAddToFavorite;
    case "PopupRadioDim1Line":              return idRadioPopupDim1Line;
    case "PopupRadioDim2Line":              return idRadioPopupDim2Line;
    case "PopupRadioDim1Line5Second":       return idRadioPopupDim1Line5Second;
    case "PopupRadioWarning1Line":          return idRadioPopupWarning1Line;
    case "PopupRadioWarning2Line":          return idRadioPopupWarning2Line;
    case "PopupDRSWarning1Line":            return idRadioPopupDRSWarning1Line;
    case "PopupRadioIRWarning2Line":        return idRadioPopupIRWarning2Line;
    case "PopupRadioMsg1Line":              return idRadioPopupMsg1Line;
    case "PopupRadioAlert":                 return idRadioPopupAlert;
    case "PopupRadioEPGInfo2Btn":           return idRadioPopupEPGInfo2Btn;
    case "PopupRadioEPGInfo3Btn":           return idRadioPopupEPGInfo3Btn;
    case "PopupRadioSubscriptionStatus":    return idRadioPopupSubscriptionStatus;
    case "PopupRadioEPGInfoPreservedProgram":return idRadioPopupEPGInfoPreservedProgram;
    case "PopupRadioAdvisory1Line":         return idRadioPopupAdvisory1Line;
        /* Option Menu */
    case "AppRadioOptionMenu":              return idRadioOptionMenu;
    case "AppRadioOptionMenuSub":           return idRadioOptionMenuSub;
    case "AppRadioFavDeleteMenu":           return idRadioDeleteMenu;
    case "AppRadioFavCancelMenu":           return idRadioCancelMenu;
    case "AppRadioListMenu":                return idRadioListMenu;
    case "AppRadioEPGMenu":                 return idRadioListMenu;

    default: if( idAppMain.state != "" ) console.log("currentStateID() Warning!! " + idAppMain.state); break;
    }
}

//****************************** # PropertyChanges for States ( Changing Main Screen ) #//
function setPropertyChanges(mainScreen, saveCurrentScreen) {
    //    var beforeTime = 0

    //    UIListener.clearCache();

    if( saveCurrentScreen == true )
        setPreSelectedMainScreen();
    else
    {
        switch(idAppMain.state)
        {
            /* Main and Sub-Main */
        case "AppRadioMain":
            if(mainScreen != "AppRadioMain")
            {
                idRadioMain.visible = false;
            }
            break;
        case "AppRadioList":                    idRadioList.visible = false; break;
        case "AppRadioSearch":                  idRadioSearch.visible = false; break;
        case "AppRadioGameZone":                idRadioGameZone.visible = false; break;
        case "AppRadioFavorite":                idRadioFavorite.visible = false; break;
        case "AppRadioGameSet":                 idRadioGameSet.visible = false; break;
        case "AppRadioGameActive":              idRadioGameActive.visible = false; break;
        case "AppRadioEPG":                     idRadioEPG.visible = false; break;
        case "AppRadioFeaturedFavorites":       idRadioFeaturedFavorites.visible = false; break;
        case "AppRadioEngineering":             idRadioEngineering.visible = false; break;
        case "AppRadioDealerMode":              idRadioDealerMode.visible = false; break;
        case "AppRadioFavoriteActive":          idRadioFavoriteActive.visible = false; break;
            /* PopUp */
        case "PopupRadioAddToFavorite":         idRadioPopupAddToFavorite.visible = false; break;
        case "PopupRadioDim1Line":              idRadioPopupDim1Line.visible = false; break;
        case "PopupRadioDim2Line":              idRadioPopupDim2Line.visible = false; break;
        case "PopupRadioDim1Line5Second":       idRadioPopupDim1Line5Second.visible = false; break;
        case "PopupRadioWarning1Line":          idRadioPopupWarning1Line.visible = false; break;
        case "PopupRadioWarning2Line":          idRadioPopupWarning2Line.visible = false; break;
        case "PopupDRSWarning1Line":            idRadioPopupDRSWarning1Line.visible = false; break;
        case "PopupRadioIRWarning2Line":        idRadioPopupIRWarning2Line.visible = false; break;
        case "PopupRadioMsg1Line":              idRadioPopupMsg1Line.visible = false; break;
        case "PopupRadioAlert":                 idRadioPopupAlert.visible = false; break;
        case "PopupRadioEPGInfo2Btn":           idRadioPopupEPGInfo2Btn.visible = false; break;
        case "PopupRadioEPGInfo3Btn":           idRadioPopupEPGInfo3Btn.visible = false; break;
        case "PopupRadioSubscriptionStatus":    idRadioPopupSubscriptionStatus.visible = false; break;
        case "PopupRadioEPGInfoPreservedProgram":idRadioPopupEPGInfoPreservedProgram.visible = false; break;
        case "PopupRadioAdvisory1Line":         idRadioPopupAdvisory1Line.visible = false; break;
            /* Option Menu */
        case "AppRadioOptionMenu":              idRadioOptionMenu.visible = false; break;
        case "AppRadioOptionMenuSub":           idRadioOptionMenuSub.visible = false; break;
        case "AppRadioFavDeleteMenu":           idRadioDeleteMenu.visible = false; break;
        case "AppRadioFavCancelMenu":           idRadioCancelMenu.visible = false; break;
        case "AppRadioListMenu":                idRadioListMenu.visible = false; break;
        case "AppRadioEPGMenu":                 idRadioEPGMenu.visible = false; break;

        default: if( idAppMain.state != "" ) console.log(" (saveCurrentScreen == false) Error!! " + idAppMain.state); break;
        }
    }

    console.log("################ setPropertyChanges ################ "+ idAppMain.state + " " + mainScreen);

    idAppMain.state = mainScreen; // change state
    idAppMain.focus = true;       // Focus for Current Screen

    //****************************** # Main Screen  #//
    switch(mainScreen)
    {
        /* Main and Sub-Main */
    case "AppRadioMain":{
        if( idRadioMain.status == Loader.Null )
            idRadioMain.source = "../component/XM/Main/XMAudioMain.qml";

        idAppMain.prevScreeID = "AppRadioMain";
        idAppMain.preMainScreen = "AppRadioMain";
        idRadioMain.visible = true;
        idRadioMain.focus = true;
        UIListener.HandleSetTuneKnobKeyOperation(0);
        UIListener.HandleSetSeekTrackKeyOperation(0);
        break;
    }
    case "AppRadioList":{
        if( idRadioList.status == Loader.Null )
        {
            idRadioList.visible = false;
            idRadioList.source = "../component/XM/List/XMAudioList.qml"
            idRadioList.item.forceActiveFocus();
        }

        if(idRadioList.visible == false)
        {
            if (PLAYInfo.CategoryLock)
            {
                UIListener.HandleListView("LISTlock");
                idRadioList.item.setListCategory(PLAYInfo.ChnCategory);
            }
            else
            {
                UIListener.HandleListView("LISTunlock");
                idRadioList.item.setListCategory(stringInfo.sSTR_XMRADIO_All_CHANNELS);
            }
            idRadioList.item.setListChannel(PLAYInfo.ChnName == "" ? "" : PLAYInfo.ChnName);
            idRadioList.item.setListList();
            idAppMain.prevScreeID = idAppMain.preMainScreen;
            idAppMain.preMainScreen = "AppRadioList";
            idRadioList.visible = true;
            UIListener.HandleSetTuneKnobKeyOperation(1);
            UIListener.HandleSetSeekTrackKeyOperation(1);
        }
        idRadioList.focus = true;
        break;
    }
    case "AppRadioSearch":{
        if( idRadioSearch.status == Loader.Null )
        {
            idRadioSearch.visible = false;
            idRadioSearch.source = "../component/XM/DirectTune/XMAudioSearch.qml";
            idRadioSearch.item.forceActiveFocus();
        }

        if(idRadioSearch.visible == false)
        {
            idAppMain.prevScreeID = idAppMain.preMainScreen;
            idAppMain.preMainScreen = "AppRadioSearch";
            idRadioSearch.visible = true;
            UIListener.HandleSetTuneKnobKeyOperation(4);
            UIListener.HandleSetSeekTrackKeyOperation(4);
        }
        idRadioSearch.focus = true;
        break;
    }
    case "AppRadioGameZone":{
        if( idRadioGameZone.status == Loader.Null )
        {
            idRadioGameZone.visible = false;
            idRadioGameZone.source = "../component/XM/GameZone/XMAudioGameZone.qml";
            idRadioGameZone.item.forceActiveFocus();
        }

        if(idRadioGameZone.visible == false)
        {
            idAppMain.prevScreeID = idAppMain.preMainScreen;
            idAppMain.preMainScreen = "AppRadioGameZone";
            SPSeek.handleGameZoneListView();
            idRadioGameZone.item.setGameZoneCategory(PLAYInfo.ChnCategory == "" ? stringInfo.sSTR_XMRADIO_All_CHANNELS : SPSeek.handleGameZoneCategorySelect(0));
            idRadioGameZone.item.setGameZoneChannel(PLAYInfo.ChnName == "" ? "" : PLAYInfo.ChnName)
            idRadioGameZone.visible = true;
            UIListener.HandleSetTuneKnobKeyOperation(6);
            UIListener.HandleSetSeekTrackKeyOperation(6);
        }
        idRadioGameZone.focus = true;
        break;
    }
    case "AppRadioFavorite":{
        if( idRadioFavorite.status == Loader.Null )
        {
            idRadioFavorite.visible = false;
            idRadioFavorite.source = "../component/XM/FavoritesList/XMAudioFavorite.qml";
            idRadioFavorite.item.forceActiveFocus();
        }

        if(idRadioFavorite.visible == false)
        {
            idAppMain.prevScreeID = idAppMain.preMainScreen;
            idAppMain.preMainScreen = "AppRadioFavorite";
            idRadioFavorite.visible = true;
            UIListener.HandleSetTuneKnobKeyOperation(5);
            UIListener.HandleSetSeekTrackKeyOperation(5);
        }
        idRadioFavorite.focus = true;
        if(idRadioFavorite.visible == true)
            idRadioFavorite.item.setFavoriteListCount();
        break;
    }
    case "AppRadioGameSet":{
        if( idRadioGameSet.status == Loader.Null )
        {
            idRadioGameSet.source = "../component/XM/GameZone/XMAudioGameSet.qml";
            idRadioGameSet.item.forceActiveFocus();
        }

        if(idRadioGameSet.visible == false)
        {
            idAppMain.prevScreeID = idAppMain.preMainScreen;
            idAppMain.preMainScreen = "AppRadioGameSet";
            idRadioGameSet.item.onSetGameAlert(SPSeek.handleGetGameOnOff());
            idRadioGameSet.visible = true;
            UIListener.HandleSetTuneKnobKeyOperation(7);
            UIListener.HandleSetSeekTrackKeyOperation(7);
        }
        idRadioGameSet.focus = true;
        idRadioGameSet.item.resetGameMemoryUse();
        break;
    }
    case "AppRadioGameActive":{
        if( idRadioGameActive.status == Loader.Null )
        {
            idRadioGameActive.source = "../component/XM/GameZone/XMAudioGameActive.qml";
            idRadioGameActive.item.forceActiveFocus();
        }

        if(idRadioGameActive.visible == false)
        {
            idAppMain.prevScreeID = idAppMain.preMainScreen;
            idAppMain.preMainScreen = "AppRadioGameActive";
            idRadioGameActive.visible = true;
            UIListener.HandleSetTuneKnobKeyOperation(10);
            UIListener.HandleSetSeekTrackKeyOperation(10);
        }

        idRadioGameActive.focus = true;
        break;
    }
    case "AppRadioEPG":{
        if( idRadioEPG.status == Loader.Null )
        {
            idRadioEPG.visible = false;
            idRadioEPG.source = "../component/XM/EPG/XMAudioEPG.qml";
            idRadioEPG.item.forceActiveFocus();
        }

        if(idRadioEPG.visible == false)
        {
            idAppMain.prevScreeID = idAppMain.preMainScreen;
            idAppMain.preMainScreen = "AppRadioEPG";

            if (PLAYInfo.CategoryLock)
            {
                UIListener.HandleListView("EPGlock");
                idRadioEPG.item.setEPGCategory(PLAYInfo.ChnCategory);
            }
            else
            {
                UIListener.HandleListView("EPGunlock");
                idRadioEPG.item.setEPGCategory(stringInfo.sSTR_XMRADIO_All_CHANNELS);
            }
            EPGInfo.handleEPGProgramListByChannelID(); //Program List
            idRadioEPG.item.setEPGChannel(PLAYInfo.ChnName == "" ? "" : PLAYInfo.ChnName);
            idRadioEPG.item.setEPGCurrentDate();
            idRadioEPG.visible = true;
            idRadioEPG.item.sxm_epg_chnindex = UIListener.doCheckCurrentItem(2);
            idRadioEPG.item.selectEPGMain();
            UIListener.HandleSetTuneKnobKeyOperation(2);
            UIListener.HandleSetSeekTrackKeyOperation(2);
        }
        idRadioEPG.focus = true;
        gEPGCategoryIndex = -1;
        break;
    }
    case "AppRadioFeaturedFavorites":{
        if( idRadioFeaturedFavorites.status == Loader.Null )
        {
            idRadioFeaturedFavorites.visible = false;
            idRadioFeaturedFavorites.source = "../component/XM/FeaturedFavorites/XMAudioFeaturedFavorites.qml";
            idRadioFeaturedFavorites.item.forceActiveFocus();
        }

        if(idRadioFeaturedFavorites.visible == false)
        {
            idAppMain.prevScreeID = idAppMain.preMainScreen;
            idAppMain.preMainScreen = "AppRadioFeaturedFavorites";
            FFManager.handleFeaturedFavoritesView(gFFavoritesBandIndex);
            idRadioFeaturedFavorites.visible = true;
            idRadioFeaturedFavorites.item.setFeaturedFavoritesBandCont(PLAYInfo.ChnName == "" ? "" : PLAYInfo.ChnName);
            UIListener.HandleSetTuneKnobKeyOperation(3);
            UIListener.HandleSetSeekTrackKeyOperation(3);
        }
        idRadioFeaturedFavorites.focus = true;
        break;
    }

    case "AppRadioEngineering":{
        if( idRadioEngineering.status == Loader.Null )
        {
            idRadioEngineering.visible = false;
            idRadioEngineering.source = "../component/XM/EngineeringMode/EngineeringListMain.qml";
            idRadioEngineering.item.forceActiveFocus();
        }

        if(idRadioEngineering.visible == false)
        {
            idAppMain.prevScreeID = idAppMain.preMainScreen;
            idAppMain.preMainScreen = "AppRadioEngineering";
            idRadioEngineering.visible = true;
            UIListener.HandleSetTuneKnobKeyOperation(0);
            UIListener.HandleSetSeekTrackKeyOperation(0);
        }
        idRadioEngineering.focus = true;
        break;
    }

    case "AppRadioDealerMode":{
        if( idRadioDealerMode.status == Loader.Null )
        {
            idRadioDealerMode.visible = false;
            idRadioDealerMode.source = "../component/XM/EngineeringMode/DealerModeMain.qml";
            idRadioDealerMode.item.forceActiveFocus();
        }

        if(idRadioDealerMode.visible == false)
        {
            idAppMain.prevScreeID = idAppMain.preMainScreen;
            idAppMain.preMainScreen = "AppRadioDealerMode";
            idRadioDealerMode.visible = true;
            UIListener.HandleSetTuneKnobKeyOperation(0);
            UIListener.HandleSetSeekTrackKeyOperation(0);
        }
        idRadioDealerMode.focus = true;
        break;
    }

    case "AppRadioFavoriteActive":{
        if( idRadioFavoriteActive.status == Loader.Null )
        {
            idRadioFavoriteActive.source = "../component/XM/FavoritesList/XMAudioFavoriteActive.qml";
            idRadioFavoriteActive.item.forceActiveFocus();
        }

        if(idRadioFavoriteActive.visible == false)
        {
            idAppMain.prevScreeID = idAppMain.preMainScreen;
            idAppMain.preMainScreen = "AppRadioFavoriteActive";
            idRadioFavoriteActive.visible = true;
            UIListener.HandleSetTuneKnobKeyOperation(11);
            UIListener.HandleSetSeekTrackKeyOperation(11);
        }
        idRadioFavoriteActive.focus = true;
        break;
    }
    /* PopUp */
    case "PopupRadioAddToFavorite":{
        if( idRadioPopupAddToFavorite.status == Loader.Null )
        {
            idRadioPopupAddToFavorite.visible = false;
            idRadioPopupAddToFavorite.source = "../component/XM/Popup/PopupAddToFavorite.qml";
            idRadioPopupAddToFavorite.item.forceActiveFocus();
        }

        if(idRadioPopupAddToFavorite.visible == false)
        {
            idRadioPopupAddToFavorite.visible = true;

            //Add to favorite Popup String Translation
            idRadioPopupAddToFavorite.item.setAddToFavoriteModelString();
        }
        idRadioPopupAddToFavorite.focus = true;
        break;
    }
    case "PopupRadioDim1Line":{
        if( idRadioPopupDim1Line.status == Loader.Null )
        {
            idRadioPopupDim1Line.visible = false;
            idRadioPopupDim1Line.source = "../component/XM/Popup/PopupDim1Line.qml";
            idRadioPopupDim1Line.item.forceActiveFocus();
        }

        if(idRadioPopupDim1Line.visible == false)
        {
            idRadioPopupDim1Line.visible = true;
        }
        idRadioPopupDim1Line.focus = true;
        break;
    }
    case "PopupRadioDim2Line":{
        if( idRadioPopupDim2Line.status == Loader.Null )
        {
            idRadioPopupDim2Line.visible = false;
            idRadioPopupDim2Line.source = "../component/XM/Popup/PopupDim2Line.qml";
            idRadioPopupDim2Line.item.forceActiveFocus();
        }

        if(idRadioPopupDim2Line.visible == false)
        {
            idRadioPopupDim2Line.visible = true;
        }
        idRadioPopupDim2Line.focus = true;
        break;
    }
    case "PopupRadioDim1Line5Second":{
        if( idRadioPopupDim1Line5Second.status == Loader.Null )
        {
            idRadioPopupDim1Line5Second.visible = false;
            idRadioPopupDim1Line5Second.source = "../component/XM/Popup/PopupDim1Line5Second.qml";
            idRadioPopupDim1Line5Second.item.forceActiveFocus();
        }

        if(idRadioPopupDim1Line5Second.visible == false)
        {
            idRadioPopupDim1Line5Second.visible = true;
        }
        idRadioPopupDim1Line5Second.focus = true;
        break;
    }
    case "PopupRadioWarning1Line":{
        if( idRadioPopupWarning1Line.status == Loader.Null )
        {
            idRadioPopupWarning1Line.visible = false;
            idRadioPopupWarning1Line.source = "../component/XM/Popup/PopupWarning1Line.qml";
            idRadioPopupWarning1Line.item.forceActiveFocus();
        }

        if(idRadioPopupWarning1Line.visible == false)
        {
            idRadioPopupWarning1Line.visible = true;
        }
        idRadioPopupWarning1Line.focus = true;
        break;
    }
    case "PopupRadioWarning2Line":{
        if( idRadioPopupWarning2Line.status == Loader.Null )
        {
            idRadioPopupWarning2Line.visible = false;
            idRadioPopupWarning2Line.source = "../component/XM/Popup/PopupWarning2Line.qml";
            idRadioPopupWarning2Line.item.forceActiveFocus();
        }

        if(idRadioPopupWarning2Line.visible == false)
        {
            idRadioPopupWarning2Line.visible = true;
        }
        idRadioPopupWarning2Line.focus = true;
        break;
    }
    case "PopupDRSWarning1Line":{
        if( idRadioPopupDRSWarning1Line.status == Loader.Null )
        {
            idRadioPopupDRSWarning1Line.visible = false;
            idRadioPopupDRSWarning1Line.source = "../component/XM/Popup/PopupDRSWarning1Line.qml";
            idRadioPopupDRSWarning1Line.item.forceActiveFocus();
        }

        if(idRadioPopupDRSWarning1Line.visible == false)
        {
            idRadioPopupDRSWarning1Line.visible = true;
        }
        idRadioPopupDRSWarning1Line.focus = true;
        break;
    }
    case "PopupRadioIRWarning2Line":{
        if( idRadioPopupIRWarning2Line.status == Loader.Null )
        {
            idRadioPopupIRWarning2Line.visible = false;
            idRadioPopupIRWarning2Line.source = "../component/XM/Popup/PopupIRWarning2Line.qml";
            idRadioPopupIRWarning2Line.item.forceActiveFocus();
        }

        if(idRadioPopupIRWarning2Line.visible == false)
        {
            idRadioPopupIRWarning2Line.visible = true;
        }
        idRadioPopupIRWarning2Line.focus = true;
        break;
    }
    case "PopupRadioMsg1Line":{
        if( idRadioPopupMsg1Line.status == Loader.Null )
        {
            idRadioPopupMsg1Line.visible = false;
            idRadioPopupMsg1Line.source = "../component/XM/Popup/PopupMsg1Line.qml";
            idRadioPopupMsg1Line.item.forceActiveFocus();
        }

        if(idRadioPopupMsg1Line.visible == false)
        {
            idRadioPopupMsg1Line.visible = true;
        }
        idRadioPopupMsg1Line.focus = true;
        break;
    }
    case "PopupRadioAlert":{
        if( idRadioPopupAlert.status == Loader.Null )
        {
            idRadioPopupAlert.visible = false;
            idRadioPopupAlert.source = "../component/XM/Popup/PopupAlert.qml";
            idRadioPopupAlert.item.forceActiveFocus();
        }

        if(idRadioPopupAlert.visible == false)
        {
            idRadioPopupAlert.visible = true;
        }
        idRadioPopupAlert.focus = true;
        break;
    }
    case "PopupRadioEPGInfo2Btn":{
        if( idRadioPopupEPGInfo2Btn.status == Loader.Null )
        {
            idRadioPopupEPGInfo2Btn.visible = false;
            idRadioPopupEPGInfo2Btn.source = "../component/XM/Popup/PopupEPGInfo2Btn.qml";
            idRadioPopupEPGInfo2Btn.item.forceActiveFocus();
        }

        if(idRadioPopupEPGInfo2Btn.visible == false)
        {
            idRadioPopupEPGInfo2Btn.visible = true;
        }
        idRadioPopupEPGInfo2Btn.focus = true;
        break;
    }
    case "PopupRadioEPGInfo3Btn":{
        if( idRadioPopupEPGInfo3Btn.status == Loader.Null )
        {
            idRadioPopupEPGInfo3Btn.visible = false;
            idRadioPopupEPGInfo3Btn.source = "../component/XM/Popup/PopupEPGInfo3Btn.qml";
            idRadioPopupEPGInfo3Btn.item.forceActiveFocus();
        }

        if(idRadioPopupEPGInfo3Btn.visible == false)
        {
            idRadioPopupEPGInfo3Btn.visible = true;
        }
        idRadioPopupEPGInfo3Btn.focus = true;
        break;
    }
    case "PopupRadioSubscriptionStatus":{
        if( idRadioPopupSubscriptionStatus.status == Loader.Null )
        {
            idRadioPopupSubscriptionStatus.visible = false;
            if(UIListener.HandleGetVariantID() == 6) // Canada
                idRadioPopupSubscriptionStatus.source = "../component/XM/Popup/PopupSubscriptionStatusCanada.qml";
            else
                idRadioPopupSubscriptionStatus.source = "../component/XM/Popup/PopupSubscriptionStatus.qml";
            idRadioPopupSubscriptionStatus.item.forceActiveFocus();
        }

        if(idRadioPopupSubscriptionStatus.visible == false)
        {
            idRadioPopupSubscriptionStatus.visible = true;
            idRadioPopupSubscriptionStatus.item.setBTConnectStatus(UIListener.HandleGetBTConnectionStatus());
        }
        idRadioPopupSubscriptionStatus.focus = true;
        break;
    }
    case "PopupRadioEPGInfoPreservedProgram":{
        if( idRadioPopupEPGInfoPreservedProgram.status == Loader.Null )
        {
            idRadioPopupEPGInfoPreservedProgram.visible = false;
            idRadioPopupEPGInfoPreservedProgram.source = "../component/XM/Popup/PopupEPGInfoPreservedProgram.qml";
            idRadioPopupEPGInfoPreservedProgram.item.forceActiveFocus();
        }

        if(idRadioPopupEPGInfoPreservedProgram.visible == false)
        {
            idRadioPopupEPGInfoPreservedProgram.visible = true;
        }
        idRadioPopupEPGInfoPreservedProgram.focus = true;
        break;
    }
    case "PopupRadioAdvisory1Line":{
        if( idRadioPopupAdvisory1Line.status == Loader.Null )
        {
            idRadioPopupAdvisory1Line.visible = false;
            idRadioPopupAdvisory1Line.source = "../component/XM/Popup/PopupAdvisory1Line.qml";
            idRadioPopupAdvisory1Line.item.forceActiveFocus();
        }

        if(idRadioPopupAdvisory1Line.visible == false)
        {
            idRadioPopupAdvisory1Line.visible = true;
        }
        idRadioPopupAdvisory1Line.focus = true;
        break;
    }
    /*Option Menu */
    case "AppRadioOptionMenu":{
        if( idRadioOptionMenu.status == Loader.Null )
        {
            idRadioOptionMenu.visible = false;
//            if(UIListener.HandleGetVariantID() == 6) // Canada
//                idRadioOptionMenu.source = "../component/XM/OptionMenu/XMAudioOptionMenuCanada.qml";
//            else
                idRadioOptionMenu.source = "../component/XM/OptionMenu/XMAudioOptionMenu.qml";
            idRadioOptionMenu.item.forceActiveFocus();
        }

        if(idRadioOptionMenu.visible == false)
        {
            //Add to favorite - enable/disable
            idRadioOptionMenu.item.onSetAddToFavoriteDim(UIListener.HandleCheckAddToFavorite());
            //Option Menu string translation
            idRadioOptionMenu.item.setOptionMenuModelString();
            idRadioOptionMenu.visible = true;
        }
        idRadioOptionMenu.focus = true;
        break;
    }
    case "AppRadioOptionMenuSub":{
        if( idRadioOptionMenuSub.status == Loader.Null )
        {
            idRadioOptionMenuSub.visible = false;
//            if(UIListener.HandleGetVariantID() == 6) // Canada
//                idRadioOptionMenuSub.source = "../component/XM/OptionMenu/XMAudioOptionMenuSubCanada.qml";
//            else
                idRadioOptionMenuSub.source = "../component/XM/OptionMenu/XMAudioOptionMenuSub.qml";
            idRadioOptionMenuSub.item.forceActiveFocus();
        }

        if(idRadioOptionMenuSub.visible == false)
        {
            idRadioOptionMenuSub.item.onSetArtistSongAlert(ATSeek.handleGetAlertOnOff());

            //Option Menu string translation
            idRadioOptionMenuSub.item.setOptionMenuModelString();
            idRadioOptionMenuSub.visible = true;
        }
        idRadioOptionMenuSub.focus = true;
        break;
    }
    case "AppRadioFavDeleteMenu":{
        if( idRadioDeleteMenu.status == Loader.Null )
        {
            idRadioDeleteMenu.visible = false;
            idRadioDeleteMenu.source = "../component/XM/OptionMenu/XMAudioFavoriteDeleteMenu.qml";
            idRadioDeleteMenu.item.forceActiveFocus();
        }

        if(idRadioDeleteMenu.visible == false)
        {
            idRadioDeleteMenu.visible = true;

            //Delete Menu string translation
            idRadioDeleteMenu.item.setDeleteMenuModelString();
        }
        idRadioDeleteMenu.focus = true;
        break;
    }
    case "AppRadioFavCancelMenu":{
        if( idRadioCancelMenu.status == Loader.Null )
        {
            idRadioCancelMenu.visible = false;
            idRadioCancelMenu.source = "../component/XM/OptionMenu/XMAudioFavoriteCancelMenu.qml";
            idRadioCancelMenu.item.forceActiveFocus();
        }

        if(idRadioCancelMenu.visible == false)
        {
            idRadioCancelMenu.visible = true;

            //Cancel Menu string translation
            idRadioCancelMenu.item.setCancelMenuModelString();
        }
        idRadioCancelMenu.focus = true;
        break;
    }
    case "AppRadioListMenu":{
        if( idRadioListMenu.status == Loader.Null )
        {
            idRadioListMenu.visible = false;
            idRadioListMenu.source = "../component/XM/OptionMenu/XMAudioListMenu.qml";
            idRadioListMenu.item.forceActiveFocus();
        }

        if(idRadioListMenu.visible == false)
        {
            idRadioListMenu.visible = true;

            //List Menu string translation
            idRadioListMenu.item.setListMenuModelString();
        }
        idRadioListMenu.focus = true;
        break;
    }
    case "AppRadioEPGMenu":{
        if( idRadioEPGMenu.status == Loader.Null )
        {
            idRadioEPGMenu.visible = false;
            idRadioEPGMenu.source = "../component/XM/OptionMenu/XMAudioEPGMenu.qml";
            idRadioEPGMenu.item.forceActiveFocus();
        }

        if(idRadioEPGMenu.visible == false)
        {
            idRadioEPGMenu.visible = true;

            //List Menu string translation
            idRadioEPGMenu.item.setEPGMenuModelString();
        }
        idRadioEPGMenu.focus = true;
        break;
    }

    default:
        break;
    }

    UIListener.HandleAppState(mainScreen);
}

function setPopupOptionMenu()
{
    console.log("############ setPopupOptionMenu() ############"+ idAppMain.preMainScreen);
    if(idAppMain.preMainScreen == "")
        idAppMain.preMainScreen = "AppRadioMain";

    switch(idAppMain.preMainScreen)
    {
    case "AppRadioMain":
    {
        console.log("preSelectedMainScreen() == AppRadioMain")
        setAppMainScreen( "AppRadioOptionMenu" , true);
        break;
    }
    case "AppRadioList":
    {
        console.log("preSelectedMainScreen() == AppRadioList")
        setAppMainScreen( "AppRadioListMenu" , true);
        break;
    }
    case "AppRadioSearch":
    {
        //TODO
        break;
    }
    case "AppRadioGameZone":
    {
        //TODO
        break;
    }
    case "AppRadioFavorite":
    {
        console.log("preSelectedMainScreen() == AppRadioFavorite")
        if(gSXMFavoriteDelete == "DELETE")
            setAppMainScreen( "AppRadioFavDeleteMenu" , true);
        else
            setAppMainScreen( "AppRadioFavCancelMenu" , true);
        break;
    }
    case "AppRadioGameSet":
    {
        //TODO
        break;
    }
    case "AppRadioGameActive":
    {
        //TODO
        break;
    }
    case "AppRadioEPG":
    {
        console.log("preSelectedMainScreen() == AppRadioEPG")
        setAppMainScreen( "AppRadioEPGMenu" , true);
        break;
    }
    case "AppRadioFeaturedFavorites":
    {
        //TODO
        break;
    }
    case "AppRadioEngineering":
    {
        //TODO
        break;
    }
    case "AppRadioDealerMode":
    {
        //TODO
        break;
    }
    default:
    {
        console.log("preSelectedMainScreen() == No find String")
        setAppMainScreen( "AppRadioOptionMenu" , true);
        break;
    }
    }
}

function setFocusToXMAudioList()
{
    console.log("################ currentStateID() : " + idAppMain.state);
    switch(idAppMain.state)
    {
        /* Main and Sub-Main */
    case "AppRadioMain":                    return idRadioMain.forceActiveFocus();
    case "AppRadioList":                    return idRadioList.forceActiveFocus();
    case "AppRadioSearch":                  return idRadioSearch.forceActiveFocus();
    case "AppRadioGameZone":                return idRadioGameZone.forceActiveFocus();
    case "AppRadioFavorite":                return idRadioFavorite.forceActiveFocus();
    case "AppRadioGameSet":                 return idRadioGameSet.forceActiveFocus();
    case "AppRadioGameActive":              return idRadioGameActive.forceActiveFocus();
    case "AppRadioEPG":                     return idRadioEPG.forceActiveFocus();
    case "AppRadioFeaturedFavorites":       return idRadioFeaturedFavorites.forceActiveFocus();
    case "AppRadioEngineering":             return idRadioEngineering.forceActiveFocus();
    case "AppRadioDealerMode":              return idRadioDealerMode.forceActiveFocus();
    case "AppRadioFavoriteActive":          return idRadioFavoriteActive.forceActiveFocus();
    default:                                return idRadioMain.forceActiveFocus();
    }
}

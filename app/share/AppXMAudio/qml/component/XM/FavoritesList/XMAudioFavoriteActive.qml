/**
 * FileName: RadioPresetList.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MComponent {
    id: idRadioFavoriteActiveQml
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    //****************************** # Property #
    property Item topBand: idRadioFavoriteActiveBand

    MComp.MBigBand {
        id: idRadioFavoriteActiveBand
        x: 0; y: 0

        tabBtnFlag: (gSXMFavoriteDelete == "LIST") ? true : false;
        tabBtnCount: 2
        tabBtnText: stringInfo.sSTR_XMRADIO_UPPERLIST
        tabBtnText2: stringInfo.sSTR_XMRADIO_ACTIVE
        selectedBand: stringInfo.sSTR_XMRADIO_ACTIVE
        refreshLoadingFlag: false;
        onTabBtn1Clicked: {
            giveForceFocus(2);
            idAppMain.gSXMFavoirtesBand = "song";
            setAppMainScreen("AppRadioFavorite", false);
            XMOperation.onFavoriteList();
        }
        onTabBtn2Clicked: {
            giveForceFocus(2);
        }
        onBackBtnClicked: {
            giveForceFocus(2);
            setFavoriteActiveClose();
            setAppMainScreen( "AppRadioMain" , false);
        }

        KeyNavigation.down: (idRadioFavoriteActiveList.favoriteActiveListCount == 0) ? idRadioFavoriteActiveBand : idRadioFavoriteActiveDisplay

        onTuneLeftKeyPressed: {
            if(idRadioFavoriteActiveBand.activeFocus)
            {
                checkFocusFavoritesActiveListAndBand();
            }
        }
        onTuneRightKeyPressed: {
            if(idRadioFavoriteActiveBand.activeFocus)
            {
                checkFocusFavoritesActiveListAndBand();
            }
        }
    }

    //****************************** # Favorite Delete ListView #
    MComp.MComponent{
        id:idRadioFavoriteActiveDisplay
        focus : true

        XMAudioFavoriteActiveList {
            id: idRadioFavoriteActiveList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
            width: systemInfo.lcdWidth; height: systemInfo.contentAreaHeight
            focus : true
        }
    }

    onBackKeyPressed: {
        setFavoriteActiveClose();
        setAppMainScreen( "AppRadioMain" , false);
    }
    onHomeKeyPressed: {
        UIListener.HandleHomeKey();
    }

    onVisibleChanged: {
        if(idRadioFavoriteActive.visible)
        {
            if(idRadioFavoriteActiveList.favoriteActiveListCount == 0)
            {
                changeFocusToFavoritesActiveAndBand();
            }
            else
            {
                idRadioFavoriteActiveBand.giveForceFocus(2);
                idRadioFavoriteActiveList.onInitFavoritesActive();
                changeFocusToFavoritesActiveList();
            }
        }
        else
        {
            idRadioFavoriteActiveList.aFavoritesActiveListModel.currentIndex = -1;
        }
    }

    //****************************** # Function #
    function setFavoriteActiveClose()
    {
        idRadioFavoriteActive.visible = false;
        UIListener.HandleSetTuneKnobKeyOperation(0);
        UIListener.HandleSetSeekTrackKeyOperation(0);
    }

    function changeFocusToFavoritesActiveList(){
        idRadioFavoriteActiveBand.focus = false;
        idRadioFavoriteActiveDisplay.focus = true;
    }

    function changeFocusToFavoritesActiveAndBand(){
        idRadioFavoriteActiveDisplay.focus = false;
        idRadioFavoriteActiveBand.focus = true;
        idRadioFavoriteActiveBand.giveForceFocus(2);
        return idRadioFavoriteActiveBand;
    }

    function checkFocusFavoritesActiveListAndBand(){
        if(idRadioFavoriteActiveList.favoriteActiveListCount == 0)
        {
            idRadioFavoriteActiveBand.focus = true;
        }
        else
        {
            idRadioFavoriteActiveList.onFavoritesActivePosUpdate();
            changeFocusToFavoritesActiveList();
        }
    }
}

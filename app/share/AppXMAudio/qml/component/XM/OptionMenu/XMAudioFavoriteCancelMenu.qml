/**
 * FileName: RadioOptionMenu.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp

MComp.MOptionMenu{
    id: idMCancelMenu
    x: 0; y:0; z: 10

    //****************************** # Item Model #
    linkedModels: ListModel { id : idRadioFavoriteCancelMenuModel }

    //****************************** # Item Clicked #
    onMenu0Click: {
        console.log(">>>>>>>>>>>>>  Cancel")
        if( gSXMFavoriteDelete == "DELETE" )
        {
            if( gSXMFavoriteList == "SONG" )
            {
                ATSeek.handleFavoriteDeselect(1);
                idRadioFavorite.item.setFavoriteListSong();
            }
            else if( gSXMFavoriteList == "ARTIST" )
            {
                ATSeek.handleFavoriteDeselect(2);
                idRadioFavorite.item.setFavoriteListArtist();
            }

            idRadioFavorite.item.sxm_favorite_deletecount = ATSeek.handleFavoriteGetCheckCount((idAppMain.gSXMFavoriteList == "SONG") ? 1 : 2);
        }

        idMCancelMenu.hideOptionMenu();
        setAppMainScreen("AppRadioFavorite", false);
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        console.log("XMAudioFavoriteCancelMenu - BackKey Clicked");
        idMCancelMenu.hideOptionMenu();
    }
    /* CCP Menu Key */
    onClickMenuKey: {
        console.log("XMAudioFavoriteCancelMenu - MenuKey Clicked");
        idMCancelMenu.hideOptionMenu();
    }

    onOptionMenuFinished:{
        console.log("XMAudioFavoriteCancelMenu - optionMenuFinished() ")
        idMCancelMenu.hideOptionMenu();
    }

    onLeftKeyMenuClose:{
        console.log("XMAudioFavoriteCancelMenu - leftKeyMenuClose() ")
        idMCancelMenu.hideOptionMenu();
    }

    function setCancelMenuModelString(){
        var data1 = {"name" : stringInfo.sSTR_XMRADIO_CANCEL, "opType":""};

        idRadioFavoriteCancelMenuModel.clear();
        idRadioFavoriteCancelMenuModel.append(data1);
    }
}

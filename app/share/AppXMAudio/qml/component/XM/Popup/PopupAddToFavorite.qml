import Qt 4.7
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioPopupAddToFavoriteQml
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property int retValue : 0
    property int mFavArtistNum : 0
    property int mFavSongNum : 0
    property int mFavTempNum : 50
    property int mAlertCount : 0
    property int mRemainCount : 0

    MComp.MPopupTypeList{
        id: idRadioMAddToFavorite

        idListModel:idRadioAddToFavoriteListModel
        ListModel {
            id : idRadioAddToFavoriteListModel

            ListElement { listFirstItem: "Favorite Artist"}
            ListElement { listFirstItem: "Favorite Song"}
            ListElement { listFirstItem: "Favorite Artist + Song"}
        }

        popupBtnCnt: 1
        popupFirstBtnText: stringInfo.sSTR_XMRADIO_ONLY_CANCEL

        // Loading Completed!!
        Component.onCompleted: {
            setAddToFavoriteModelString()
        }

        /* Popup List Click */
        onPopuplistItemClicked:{
            console.debug("select Add to Favorite Popup index : " + selectedItemIndex )
            idAppMain.gotoBackScreen(false);
            retValue = ATSeek.handleFavorite(selectedItemIndex);
            mFavArtistNum = ATSeek.handleFavoriteArtistNum();
            mFavSongNum = ATSeek.handleFavoriteSongNum();
            mAlertCount = mFavArtistNum + mFavSongNum;
            mRemainCount = mFavTempNum - mAlertCount;
            console.log("select Add to Favorite - return value:",retValue);

            switch(retValue)
            {
            case 0x00: //FAVORITE_LIST_WRITE_FAIL
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_SONG_ALERTS_NOT_AVAILABLE);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Favorites Artist
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 0x01: //FAVORITE_LIST_WRITE_SUCCESS_ARTIST
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_ALERT_SAVED);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }
            case 0x08: //FAVORITE_LIST_ARTIST_ALREADY
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_ALERT_ALREADY_SAVED);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }
            case 0x100: //FAVORITE_LIST_ARTIST_INVALID
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_NOT_AVAILABLE);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }

            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Favorites Song
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 0x02: //FAVORITE_LIST_WRITE_SUCESS_SONG
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_SONG_ALERT_SAVED);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }
            case 0x10: //FAVORITE_LIST_SONG_ALREADY
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_SONG_ALERT_ALREADY_SAVED);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }
            case 0x200: //FAVORITE_LIST_SONG_INVALID
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_SONG_NOT_AVAILABLE);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }

            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Favorites Artist + Song
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 0x03: //FAVORITE_LIST_WRITE_SUCCESS_ARTIST + FAVORITE_LIST_WRITE_SUCESS_SONG
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_SONG_ALERT_SAVED);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }
            case 0x11: //FAVORITE_LIST_WRITE_SUCCESS_ARTIST + FAVORITE_LIST_SONG_ALREADY
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_ALERT_SAVED+" / "+stringInfo.sSTR_XMRADIO_SONG_ALERT_ALREADY_SAVED);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }
            case 0x201: //FAVORITE_LIST_WRITE_SUCCESS_ARTIST + FAVORITE_LIST_SONG_INVALID
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_ALERT_SAVED+" / "+stringInfo.sSTR_XMRADIO_SONG_NOT_AVAILABLE);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }

            case 0x0a: //FAVORITE_LIST_ARTIST_ALREADY + FAVORITE_LIST_WRITE_SUCESS_SONG
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_ALERT_ALREADY_SAVED+" / "+stringInfo.sSTR_XMRADIO_SONG_ALERT_SAVED);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }
            case 0x18: //FAVORITE_LIST_ARTIST_ALREADY + FAVORITE_LIST_SONG_ALREADY
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_SONG_ALERT_ALREADY_SAVED);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }
            case 0x208: //FAVORITE_LIST_ARTIST_ALREADY + FAVORITE_LIST_SONG_INVALID
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_ALERT_ALREADY_SAVED+" / "+stringInfo.sSTR_XMRADIO_SONG_NOT_AVAILABLE);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }

            case 0x102: //FAVORITE_LIST_ARTIST_INVALID + FAVORITE_LIST_WRITE_SUCESS_SONG
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_NOT_AVAILABLE+" / "+stringInfo.sSTR_XMRADIO_SONG_ALERT_SAVED);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }
            case 0x110: //FAVORITE_LIST_ARTIST_INVALID + FAVORITE_LIST_SONG_ALREADY
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_NOT_AVAILABLE+" / "+stringInfo.sSTR_XMRADIO_SONG_ALERT_ALREADY_SAVED);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }
            case 0x300: //FAVORITE_LIST_ARTIST_INVALID + FAVORITE_LIST_SONG_INVALID
            {
                setAppMainScreen("PopupRadioDim2Line", true);
                idRadioPopupDim2Line.item.onPopupDim2LineFirst(stringInfo.sSTR_XMRADIO_ARTIST_SONG_ALERTS_NOT_AVAILABLE);
                idRadioPopupDim2Line.item.onPopupDim2LineSecond(mAlertCount+" "+stringInfo.sSTR_XMRADIO_USED+" / "+mRemainCount+" "+stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_EMPTY);
                break;
            }

            case 0x60: //"Artist Alert Memory Full / Song Alert Memory Full
            {
                setAppMainScreen("PopupRadioWarning2Line", true);
                idRadioPopupWarning2Line.item.onPopupWarning2LineFirst(stringInfo.sSTR_XMRADIO_ALERT_MEMORY_FULL);
                idRadioPopupWarning2Line.item.onPopupWarning2LineSecond(stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_FULL2);
                idRadioPopupWarning2Line.item.onPopupWarning2LineWrap(true);
                break;
            }

            default:
                console.log("Not found return value", retValue);
                break;
            }
        }

        /* Popup List Button Click */
        onPopupFirstBtnClicked: {
            console.log("PopupAddToFavorite - OK Clicked");
            idAppMain.gotoBackScreen(false);
        }

        /* CCP Back Key */
        onHardBackKeyClicked: {
            console.log("PopupAddToFavorite - BackKey Clicked");
            idAppMain.gotoBackScreen(false);
        }
        /* CCP Home Key */
        onHomeKeyPressed: {
            console.log("PopupAddToFavorite - HomeKey Clicked");
            idAppMain.gotoBackScreen(false);
            UIListener.HandleHomeKey();
        }

        onVisibleChanged: {
            if(idRadioMAddToFavorite.visible == true)
                setAddToFavoriteModelString();
        }
    }

    function setAddToFavoriteModelString(){
        var i;
        for(i = 0; i < idRadioAddToFavoriteListModel.count; i++)
        {
            switch(i){
            case 0: { idRadioAddToFavoriteListModel.get(i).listFirstItem = stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_ARTIST/*stringInfo.sSTR_XMRADIO_SAVE_ARTIST_ALERT*/; break; }
            case 1: { idRadioAddToFavoriteListModel.get(i).listFirstItem = stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_SONG/*stringInfo.sSTR_XMRADIO_SAVE_SONG_ALERT*/; break; }
            case 2: { idRadioAddToFavoriteListModel.get(i).listFirstItem = stringInfo.sSTR_XMRADIO_ADD_TO_FAVORITES_ARTIST_SONG/*stringInfo.sSTR_XMRADIO_SAVE_ARTIST_SONG_ALERT*/; break; }
            default: break;
            }
        }
    }
}

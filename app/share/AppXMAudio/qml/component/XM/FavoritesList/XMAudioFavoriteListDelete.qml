/**
 * FileName: RadioPresetList.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../XM/Delegate" as XMMComp

FocusScope {
    id: idRadioFavoriteListDeleteQml
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.contentAreaHeight

    //****************************** # Property #
    property alias favoriteDeleteListView: idRadioFavoriteDeleteListView
    property int favoriteDeleteListCount: idRadioFavoriteDeleteListView.count
    property int overFavoritesDeleteContentCount: 0
    property bool movementStartedFavoritesDeleteFlag: false

    //    property int scrollEndDifX: 21
    property int scrollY: 15
    property int scrollEndDifY: 15
    property int scrollWidth: 13

    //****************************** # Favorite Delete ListView #
    MComp.MListView{
        id: idRadioFavoriteDeleteListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: (gSXMFavoriteList == "SONG") ? FAVORITESong : FAVORITEArtist
        delegate: XMMComp.MFavoriteDeleteDelegate{
            id: idMFavoriteDeleteDelegate

            mChListFirstText : (gSXMFavoriteList == "SONG") ? FavTitle : FavArtist
            bChListThirdText : FavDelete

            onClickOrKeySelected: {
                gFavoriteDeleteIndex =  sxm_favorite_deleteindex
                console.log("### gFavoriteDeleteIndex Item click ###", gFavoriteDeleteIndex, FavDelete)

                if(gSXMFavoriteList == "SONG")
                {
                    if( ATSeek.handleFavoriteGetCheck(1, gFavoriteDeleteIndex) == true )
                        ATSeek.handleFavoriteSetCheck(1, gFavoriteDeleteIndex, false);
                    else
                        ATSeek.handleFavoriteSetCheck(1, gFavoriteDeleteIndex, true);
                }
                else if(gSXMFavoriteList == "ARTIST")
                {
                    if( ATSeek.handleFavoriteGetCheck(2, gFavoriteDeleteIndex) == true )
                        ATSeek.handleFavoriteSetCheck(2, gFavoriteDeleteIndex, false);
                    else
                        ATSeek.handleFavoriteSetCheck(2, gFavoriteDeleteIndex, true);
                }

                sxm_favorite_deletecount = ATSeek.handleFavoriteGetCheckCount((gSXMFavoriteList == "SONG") ? 1 : 2);
                if(sxm_favorite_deletecount > 0){ idRadioDeleteEdit.setfocusPosition(1); }
                else{ idRadioDeleteEdit.setfocusPosition(2); }
            }
        }

        onContentYChanged: { overFavoritesDeleteContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedFavoritesDeleteFlag = false;
        }
        onMovementStarted: { movementStartedFavoritesDeleteFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idRadioFavoriteDeleteListView.visible && movementStartedFavoritesDeleteFlag)
                {
                    if((gSXMFavoriteDelete == "DELETE") && (idAppMain.state == "AppRadioFavorite") && (idRadioFavoriteListDeleteQml.favoriteDeleteListCount > 0))
                    {
                        idRadioFavoriteDeleteListView.forceActiveFocus();
                    }

                    movementStartedFavoritesDeleteFlag = false;
                }
            }
        }

        KeyNavigation.right: idRadioDeleteEdit
    }

    //****************************** # Scroll Bar #
    MComp.MScroll {
        id: idFavoriteDeleteScroll
        scrollArea: idRadioFavoriteDeleteListView;
        x: 1015; y: idRadioFavoriteDeleteListView.y + scrollY; z:1
        width: scrollWidth; height: idRadioFavoriteDeleteListView.height - scrollY - scrollEndDifY
        visible: idRadioFavoriteDeleteListView.count > 6
    }

    //****************************** # Edit Mode #
    MComp.MEditMode {
        id: idRadioDeleteEdit

        buttonNumber : 4
        buttonText1 : stringInfo.sSTR_XMRADIO_DELETE
        buttonText2 : stringInfo.sSTR_XMRADIO_DELETE_ALL
        buttonText3 : stringInfo.sSTR_XMRADIO_UNMARK_ALL
        buttonText4 : stringInfo.sSTR_XMRADIO_ONLY_CANCEL

        buttonEnabled1 : (sxm_favorite_deletecount > 0) ? true : false
        buttonEnabled2 : (idRadioFavoriteDeleteListView.count > 0) ? true : false
        buttonEnabled3 : (sxm_favorite_deletecount > 0) ? true : false
        buttonEnabled4 : true

        onClickButton1: {
            console.log("Delete clicked")
            if(gSXMFavoriteList == "SONG")
                ATSeek.handleFavoriteDelete(1);
            else if(gSXMFavoriteList == "ARTIST")
                ATSeek.handleFavoriteDelete(2);

            setPreFavoriteList();
            setAppMainScreen( "AppRadioFavorite" , false);
            sxm_favorite_deletecount = ATSeek.handleFavoriteGetCheckCount((gSXMFavoriteList == "SONG") ? 1 : 2);

            setAppMainScreen("PopupRadioDim1Line", true);
            idRadioPopupDim1Line.item.onPopupDim1LineFirst(stringInfo.sSTR_XMRADIO_DELETED_SUCCESSFULLY);
        }
        onClickButton2: {
            console.log("Delete All clicked")
            idAppMain.selectAll();
            idRadioFavoriteDeleteListView.forceActiveFocus();
            idRadioDeleteEdit.setfocusPosition(2);
            setAppMainScreen("PopupRadioMsg1Line", true);
            idRadioPopupMsg1Line.item.onPopupMsg1LineTitle(stringInfo.sSTR_XMRADIO_DELETE_ALL);
            idRadioPopupMsg1Line.item.onPopupMsg1LineFirst(stringInfo.sSTR_XMRADIO_DELETE_ALL_FAVORITE);
            idRadioPopupMsg1Line.item.onPopupMsg1LineSelect("Favorite")
        }
        onClickButton3: {
            var beforeContentY = 0;
            beforeContentY = idRadioFavoriteDeleteListView.contentY

            console.log("Deselect clicked")
            if(gSXMFavoriteList == "SONG")
                ATSeek.handleFavoriteDeselect(1);
            else if(gSXMFavoriteList == "ARTIST")
                ATSeek.handleFavoriteDeselect(2);

            idRadioFavoriteDeleteListView.contentY = beforeContentY
            sxm_favorite_deletecount = ATSeek.handleFavoriteGetCheckCount((gSXMFavoriteList == "SONG") ? 1 : 2);
            idRadioFavoriteDeleteListView.forceActiveFocus();
            idRadioDeleteEdit.setfocusPosition(2);
        }
        onClickButton4: {
            console.log("Cancel clicked")
            if( gSXMFavoriteDelete == "DELETE" )
            {
                if( gSXMFavoriteList == "SONG" )
                {
                    ATSeek.handleFavoriteDeselect(1);
                    setFavoriteListSong();
                }
                else if( gSXMFavoriteList == "ARTIST" )
                {
                    ATSeek.handleFavoriteDeselect(2);
                    setFavoriteListArtist();
                }

                sxm_favorite_deletecount = ATSeek.handleFavoriteGetCheckCount((gSXMFavoriteList == "SONG") ? 1 : 2);
                idRadioFavoriteSongArtistDisplay.forceActiveFocus();
            }
            idRadioDeleteEdit.setfocusPosition(2);
        }

        KeyNavigation.left: idRadioFavoriteDeleteListView
    }

    onVisibleChanged: {
        if(visible) {
            if(idRadioFavoriteDeleteListView.count > 0)
            {
                if(gSXMFavoriteList == "SONG")
                    ATSeek.handleFavoriteDeselect(1);
                else if(gSXMFavoriteList == "ARTIST")
                    ATSeek.handleFavoriteDeselect(2);

                idRadioFavoriteDeleteListView.currentIndex = 0;
                idRadioFavoriteDeleteListView.focus = true;
                setEditModeFocus(); // ITS 234705
            }
        }
    }

    function setEditModeFocus()
    {
        if(sxm_favorite_deletecount > 0) { idRadioDeleteEdit.setfocusPosition(1); }
        else { idRadioDeleteEdit.setfocusPosition(2); }
    }
}

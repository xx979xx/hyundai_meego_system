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
    id: idRadioFavoriteListArtistQml
    x: 0; y: 0
    width: systemInfo.lcdWidth-277; height: systemInfo.contentAreaHeight

    //****************************** # Property #
    property int artistListCount : idRadioFavoriteArtistListView.count
    property int overFavoritesArtistContentCount: 0
    property bool movementStartedFavoritesArtistFlag: false

    property int scrollEndDifX: 23
    property int scrollY: 33
    property int scrollEndDifY: 44
    property int scrollWidth: 13

    property string favoriteListArtistTextColor: colorInfo.brightGrey
    
    //****************************** # Favorite Artist ListView #
    MComp.MListView{
        id: idRadioFavoriteArtistListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: FAVORITEArtist
        delegate: XMMComp.MFavoriteListDelegate{
            id: idMFavoriteListDelegate

            mChListFirstText : (gSXMFavoriteList == "SONG") ? FavTitle : FavArtist

            onClickOrKeySelected: {
                gFavoriteArtistIndex =  sxm_favorite_artistindex
                console.log("### gFavoriteArtistIndex Item click ###", gFavoriteArtistIndex)
            }
        }

        onContentYChanged: { overFavoritesArtistContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedFavoritesArtistFlag = false;
        }
        onMovementStarted: { movementStartedFavoritesArtistFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idRadioFavoriteArtistListView.visible && movementStartedFavoritesArtistFlag)
                {
                    if((gSXMFavoriteList == "ARTIST") && (gSXMFavoriteDelete != "DELETE") && (idAppMain.state == "AppRadioFavorite") && (idRadioFavoriteListArtistQml.artistListCount > 0))
                    {
                        idRadioFavoriteSongArtistDisplay.focus = true;
                        idRadioFavoriteListSongArtistDisplay.focus = true;
                        idRadioFavoriteListArtist.focus = true;
                    }

                    movementStartedFavoritesArtistFlag = false;
                }
            }
        }
    }

    // "There is no favorite artist" Text Display
    Text {
        id: idRadioFavoriteListViewText
        x:13; y:273-(font.pixelSize/2)
        width: 980; height: 32
        font.pixelSize: 32
        font.family : systemInfo.font_NewHDR
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: favoriteListArtistTextColor
        text : stringInfo.sSTR_XMRADIO_NO_FAVORITE_ARTIST_LIST
        visible: (idRadioFavoriteArtistListView.count == 0) ? true : false
    }

    //****************************** # Scroll Bar #
    MComp.MScroll{
        id: idFavoriteArtistScroll
        scrollArea: idRadioFavoriteArtistListView;
        x: 1280 - 277 - scrollEndDifX; y: idRadioFavoriteArtistListView.y + scrollY; z:1
        width: scrollWidth; height: idRadioFavoriteArtistListView.height - scrollY - scrollEndDifY
        visible: idRadioFavoriteArtistListView.count > 6
    }

    function onInitListArtist()
    {
        if(idRadioFavoriteArtistListView.count > 0)
        {
            idRadioFavoriteArtistListView.currentIndex = 0;
            idRadioFavoriteArtistListView.positionViewAtIndex(0, ListView.Beginning);
        }
    }
}

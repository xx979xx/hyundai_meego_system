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
    id: idRadioFavoriteListSongQml
    x: 0; y: 0
    width: systemInfo.lcdWidth-277; height: systemInfo.contentAreaHeight

    //****************************** # Property #
    property int songListCount : idRadioFavoriteSongListView.count
    property int overFavoritesSongContentCount: 0
    property bool movementStartedFavoritesSongFlag: false

    property int scrollEndDifX: 23
    property int scrollY: 33
    property int scrollEndDifY: 44
    property int scrollWidth: 13

    property string favoriteListSongTextColor: colorInfo.brightGrey
    
    //****************************** # Favorite Song ListView #
    MComp.MListView{
        id: idRadioFavoriteSongListView
        clip: true
        focus: true
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        orientation: ListView.Vertical
        cacheBuffer: 99999
        highlightMoveSpeed: 99999
        model: FAVORITESong
        delegate: XMMComp.MFavoriteListDelegate{
            id: idMFavoriteListDelegate

            mChListFirstText : (gSXMFavoriteList == "SONG") ? FavTitle : FavArtist

            onClickOrKeySelected: {
                gFavoriteSongIndex =  sxm_favorite_songindex
                console.log("### gFavoriteSongIndex Item click ###", gFavoriteSongIndex)
            }
        }

        onContentYChanged: { overFavoritesSongContentCount = contentY/(contentHeight/count) }
        onVisibleChanged: {
            if((visible == true)&&(contentY != 0))
                contentY = 0;
            movementStartedFavoritesSongFlag = false;
        }
        onMovementStarted: { movementStartedFavoritesSongFlag = true; }
        onMovementEnded: {
            if(isSuppportAutoFocusByScroll)
            {
                if(idRadioFavoriteSongListView.visible && movementStartedFavoritesSongFlag)
                {
                    if((gSXMFavoriteList == "SONG") && (gSXMFavoriteDelete != "DELETE") && (idAppMain.state == "AppRadioFavorite") && (idRadioFavoriteListSongQml.songListCount > 0))
                    {
                        idRadioFavoriteSongArtistDisplay.focus = true;
                        idRadioFavoriteListSongArtistDisplay.focus = true;
                        idRadioFavoriteListSong.focus = true;
                    }

                    movementStartedFavoritesSongFlag = false;
                }
            }
        }
    }

    // "There is no favorite song" Text Display
    Text {
        id: idRadioFavoriteListViewText
        x:13; y:273-(font.pixelSize/2)
        width: 980; height: 32
        font.pixelSize: 32
        font.family : systemInfo.font_NewHDR
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: favoriteListSongTextColor
        text : stringInfo.sSTR_XMRADIO_NO_FAVORITE_SONG_LIST
        visible: (idRadioFavoriteSongListView.count == 0) ? true : false
    }

    //****************************** # Scroll Bar #
    MComp.MScroll{
        id: idFavoriteSongScroll
        scrollArea: idRadioFavoriteSongListView;
        x: 1280 - 277 - scrollEndDifX; y: idRadioFavoriteSongListView.y + scrollY; z:1
        width: scrollWidth; height: idRadioFavoriteSongListView.height - scrollY - scrollEndDifY
        visible: idRadioFavoriteSongListView.count > 6
    }

    function onInitListSong()
    {
        if(idRadioFavoriteSongListView.count > 0)
        {
            idRadioFavoriteSongListView.currentIndex = 0;
            idRadioFavoriteSongListView.positionViewAtIndex(0, ListView.Beginning);
        }
    }
}

/**
 * FileName: RadioMain.qml
 * Author: HYANG
 * Time: 2012-02
 *
 * - 2012-02 Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idRadioFavoriteQml
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    state : (gSXMFavoriteDelete == "DELETE") ? "DELETE" : ((gSXMFavoriteList == "SONG") ? "SONG" : "ARTIST")

    //****************************** # Property #
    //property string sxm_favorite_band : "song"  //"artist"
    property int    sxm_favorite_songindex : 0
    property int    sxm_favorite_artistindex : 0
    property int    sxm_favorite_deleteindex : 0
    property int    sxm_favorite_deletecount : ATSeek.handleFavoriteGetCheckCount((gSXMFavoriteList == "SONG") ? 1 : 2)
    property int    sxm_favorite_listcount : 0
    property Item topBand: idRadioFavoriteBand

    property string bandSubTitleTextColor: colorInfo.blue
    
    //****************************** # SXM Favorite List - Title #
    MComp.MBigBand {
        id: idRadioFavoriteBand
        x: 0; y: 0

        titleText: stringInfo.sSTR_XMRADIO_DELETE
        subTitleText: (gSXMFavoriteDelete == "DELETE") ? "("+sxm_favorite_deletecount+")" : ""
        subTitleTextX: 46 + titleTextWidth + 15
        subTitleTextColor: bandSubTitleTextColor
        subTitleTextSize: 30

        //****************************** # Tab button OFF #
        selectedBand: stringInfo.sSTR_XMRADIO_UPPERLIST
        tabBtnCount: 2
        tabBtnFlag: (gSXMFavoriteDelete == "DELETE") ? false : true;
        tabBtnText: stringInfo.sSTR_XMRADIO_UPPERLIST
        tabBtnText2: stringInfo.sSTR_XMRADIO_ACTIVE
        menuBtnFlag: true
        menuBtnText: stringInfo.sSTR_XMRADIO_MENU
        menuBtnEnabledFlag: (gSXMFavoriteDelete == "DELETE") || (gSXMFavoriteList == "SONG" && (idRadioFavoriteListSong.songListCount > 0)) || (gSXMFavoriteList == "ARTIST" && (idRadioFavoriteListArtist.artistListCount > 0)) ? true : false

        onTabBtn1Clicked: {
            giveForceFocus(1);
        }
        onTabBtn2Clicked: {
            giveForceFocus(2);
            setAppMainScreen("AppRadioFavoriteActive", false);
        }
        //****************************** # button clicked or key selected #
        onBackBtnClicked: {
            console.log("### Favorite List - Back Btn Clicked ###")
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
            else if( gSXMFavoriteDelete == "LIST" )
            {
                setFavoriteListClose();
                setAppMainScreen( "AppRadioMain" , false);
            }
        }

        onMenuBtnClicked: {
            console.log("### Favorite List - Menu Btn Clicked ###")
            if(gSXMFavoriteDelete == "DELETE")
                setAppMainScreen( "AppRadioFavCancelMenu" , true);
            else
            {
                if(gSXMFavoriteList == "SONG")
                {
                    setFavoriteListSongFocus();
                }
                else
                {
                    setFavoriteListArtistFocus();
                }
                setAppMainScreen( "AppRadioFavDeleteMenu" , true);
            }
        }

        KeyNavigation.down: (gSXMFavoriteDelete == "DELETE") ? idRadioFavoriteDeleteDisplay : idRadioFavoriteSongArtistDisplay

        onMenuBtnEnabledFlagChanged: {
            if(menuBtnEnabledFlag == false)  giveForceFocus(1);
        }

        Connections{
            target: idAppMain

            onSelectAll:{
                sxm_favorite_deletecount = (gSXMFavoriteList == "SONG") ? ATSeek.handleFavoriteSongNum() : ATSeek.handleFavoriteArtistNum();
            }
            onSelectAllcancelandok:{
                sxm_favorite_deletecount = ATSeek.handleFavoriteGetCheckCount((gSXMFavoriteList == "SONG") ? 1 : 2);
            }
        }
    }

    //****************************** # SXM Radio - Display Area #
    MComp.MComponent{
        id:idRadioFavoriteSongArtistDisplay
        focus: true

        //****************************** # SXM Favorite List - Song/Artist #
        XMAudioFavoriteSongArtist{
            id: idRadioFavoriteSongArtist
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
            focus: true

            Keys.onPressed: { if(event.key == Qt.Key_Up) setForceFocusChangeFavoritesBand(); }
            KeyNavigation.right: ((gSXMFavoriteList == "SONG" && idRadioFavoriteListSong.songListCount > 0) || (gSXMFavoriteList == "ARTIST" && idRadioFavoriteListArtist.artistListCount > 0)) ? idRadioFavoriteListSongArtistDisplay : null
        }

        MComp.MComponent{
            id: idRadioFavoriteListSongArtistDisplay

            //****************************** # SXM Favorite List - Song #
            XMAudioFavoriteListSong{
                id: idRadioFavoriteListSong
                x: 277; y: systemInfo.headlineHeight-systemInfo.statusBarHeight

                KeyNavigation.left: idRadioFavoriteSongArtist
            }

            //****************************** # SXM Favorite List - Artist #
            XMAudioFavoriteListArtist{
                id: idRadioFavoriteListArtist
                x: 277; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
                focus: true

                KeyNavigation.left: idRadioFavoriteSongArtist
            }
        }
    }

    //****************************** # SXM Radio - Display Area #
    MComp.MComponent{
        id:idRadioFavoriteDeleteDisplay

        //****************************** # SXM Favorite List - Delete #
        XMAudioFavoriteListDelete{
            id: idRadioFavoriteListDelete
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
            focus: true

            Keys.onPressed: {
                if(event.key == Qt.Key_Up) setForceFocusChangeDeleteBand();
            }
        }
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        console.log("XMAudioFavorite - BackKey Clicked")
        setFavoriteListBack();
    }
    /* CCP Home Key */
    onHomeKeyPressed: {
        console.log("XMAudioFavorite - HomeKey Clicked");
        setFavoriteListClose();
        UIListener.HandleHomeKey();
    }
    /* CCP Menu Key */
    onClickMenuKey: {
        console.log("XMAudioFavorite - MenuKey Clicked");
        if(gSXMFavoriteDelete == "DELETE")
        {
            idAppMain.releaseTouchPressed();
            setAppMainScreen( "AppRadioFavCancelMenu" , true);
        }
        else
        {
            if(idRadioFavoriteBand.menuBtnEnabledFlag == true)
            {
                idAppMain.releaseTouchPressed();
                if(gSXMFavoriteList == "SONG")
                {
                    setFavoriteListSongFocus();
                }
                else
                {
                    setFavoriteListArtistFocus();
                }
                setAppMainScreen( "AppRadioFavDeleteMenu" , true);
            }
        }
    }

    onVisibleChanged: {
        if(idRadioFavorite.visible)
        {
            idRadioFavoriteBand.giveForceFocus(1);
            if(gSXMFavoriteDelete == "LIST")
            {
                idRadioFavoriteSongArtistDisplay.focus = true
            }
            else if(gSXMFavoriteDelete == "DELETE")
            {
                idRadioFavoriteBand.giveForceFocus(6/*MenuBtn*/);
                if(idRadioFavoriteListDelete.favoriteDeleteListCount == 0) idRadioFavoriteBand.focus = true
                else  idRadioFavoriteDeleteDisplay.focus = true;
            }
        }
    }

    // ITS 196950 # by WSH(131018)
    function setFavoriteListBack()
    {
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
        else if( gSXMFavoriteDelete == "LIST" )
        {
            setFavoriteListClose();
            setAppMainScreen( "AppRadioMain" , false);
        }
    }

    function setFavoriteListClose()
    {
        idRadioFavorite.visible = false;
        UIListener.HandleSetTuneKnobKeyOperation(0);
        UIListener.HandleSetSeekTrackKeyOperation(0);
    }

    function setPreFavoriteList()
    {
        if(gSXMFavoriteDelete == "DELETE")
        {
            if(gSXMFavoriteList == "SONG")
            {
                setFavoriteListSong();
                setFavoriteListSongFocus();
            }
            else
            {
                setFavoriteListArtist();
                setFavoriteListArtistFocus();
            }
        }
    }

    function setFavoriteListSong()
    {
        idRadioFavoriteListSong.onInitListSong();
        gSXMFavoriteDelete = "LIST";
        gSXMFavoriteList = "SONG";
    }

    function setFavoriteListArtist()
    {
        idRadioFavoriteListArtist.onInitListArtist();
        gSXMFavoriteDelete = "LIST";
        gSXMFavoriteList = "ARTIST";
    }

    function setFavoriteDelete()
    {
        gSXMFavoriteDelete = "DELETE";
    }

    function setFavoriteListCount()
    {
        sxm_favorite_listcount = (gSXMFavoriteList == "SONG") ? ATSeek.handleFavoriteSongNum() : ATSeek.handleFavoriteArtistNum()
    }

    function setFavoriteListSongFocus()
    {
        if(idRadioFavoriteListSong.songListCount > 0)
        {
            idRadioFavoriteSongArtistDisplay.focus = true;
            idRadioFavoriteSongArtist.idRadioFavoritesSong.focus = true;
            idRadioFavoriteListSongArtistDisplay.focus = true;
            idRadioFavoriteListSong.focus = true;
        }
        else
        {
            //idRadioFavoriteListSongArtistDisplay.focus = false;
            idRadioFavoriteSongArtistDisplay.focus = true;
            idRadioFavoriteSongArtist.idRadioFavoritesSong.forceActiveFocus();
        }
    }

    function setFavoriteListArtistFocus()
    {
        if(idRadioFavoriteListArtist.artistListCount > 0)
        {
            idRadioFavoriteSongArtistDisplay.focus = true;
            idRadioFavoriteSongArtist.idRadioFavoritesArtist.focus = true;
            idRadioFavoriteListSongArtistDisplay.focus = true;
            idRadioFavoriteListArtist.focus = true;
        }
        else
        {
            //idRadioFavoriteListSongArtistDisplay.focus = false;
            idRadioFavoriteSongArtistDisplay.focus = true;
            idRadioFavoriteSongArtist.idRadioFavoritesArtist.forceActiveFocus();
        }
    }

    function setFavoriteListSongList()
    {
        idRadioFavoriteSongArtist.changeFavoriteSongList();
    }

    function setFavoriteListArtistList()
    {
        idRadioFavoriteSongArtist.changeFavoriteArtistList();
    }

    function setFavoriteListChangeStyle()
    {
        idRadioFavoriteSongArtist.changeFavoriteListChangeStyle();
    }

    function setForceFocusChangeFavoritesBand()
    {
        idRadioFavoriteBand.giveForceFocus(1);
        idRadioFavoriteBand.focus = true;
    }

    function setForceFocusChangeDeleteBand()
    {
        idRadioFavoriteBand.giveForceFocus(6); //BigBand
        idRadioFavoriteBand.focus = true;
    }

    states: [
        State{
            name: "SONG"
            PropertyChanges{target: idRadioFavoriteListSong; opacity: 1; focus: true}
            PropertyChanges{target: idRadioFavoriteListArtist; opacity: 0; focus: false}
            PropertyChanges{target: idRadioFavoriteSongArtistDisplay; opacity: 1; focus: true}
            PropertyChanges{target: idRadioFavoriteDeleteDisplay; opacity: 0; focus: false}
        },
        State{
            name: "ARTIST"
            PropertyChanges{target: idRadioFavoriteListArtist; opacity: 1; focus: true}
            PropertyChanges{target: idRadioFavoriteListSong; opacity: 0; focus: false}
            PropertyChanges{target: idRadioFavoriteSongArtistDisplay; opacity: 1; focus: true}
            PropertyChanges{target: idRadioFavoriteDeleteDisplay; opacity: 0; focus: false}
        },
        State{
            name: "DELETE"
            PropertyChanges{target: idRadioFavoriteSongArtistDisplay; opacity: 0; focus: false}
            PropertyChanges{target: idRadioFavoriteListSong; opacity: 0; focus: false}
            PropertyChanges{target: idRadioFavoriteListArtist; opacity: 0; focus: false}
            PropertyChanges{target: idRadioFavoriteDeleteDisplay; opacity: 1; focus: true}
        }
    ]

    transitions: [
        Transition{
            ParallelAnimation{ PropertyAnimation{properties: "opacity"; duration: 0; easing.type: "InCubic"} }
        }
    ]
}

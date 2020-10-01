/**
 * FileName: RadioFmFrequencyDial.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp

FocusScope {
    id: idRadioFavoriteSongArtist
    x: 0; y: 0

    property alias idRadioFavoritesSong : idRadioFavoriteSong
    property alias idRadioFavoritesArtist : idRadioFavoriteArtist

    //****************************** # Background Image #
    Image{
        x: 0; y: 0
        source: imageInfo.imgFolderMusic+"music_tab_bg.png"
    }

    // Song Button
    MComp.MButton{
        id: idRadioFavoriteSong
        x: 0; y: 0
        width: 276; height: 277
        visible: true
        active: (idAppMain.gSXMFavoirtesBand == "song") ? true : false
        fgImageX: 92; fgImageY: 69
        fgImageWidth: 73; fgImageHeight: 73
        fgImage: imageInfo.imgFolderRadio_SXM+"icon_list_song_n.png"
        fgImagePress: idRadioFavoriteSong.activeFocus ? imageInfo.imgFolderRadio_SXM+"icon_list_song_p.png" : (idAppMain.gSXMFavoirtesBand == "song") ? imageInfo.imgFolderRadio_SXM+"icon_list_song_s.png" : imageInfo.imgFolderRadio_SXM+"icon_list_song_p.png"
        fgImageActive: imageInfo.imgFolderRadio_SXM+"icon_list_song_s.png"
        fgImageFocus: imageInfo.imgFolderRadio_SXM+"icon_list_song_f.png"
        bgImage: ""
        bgImagePress: imageInfo.imgFolderRadio_SXM+"fav_tab_01_p.png"
        bgImageFocus: imageInfo.imgFolderRadio_SXM+"fav_tab_01_f.png"
        firstText: stringInfo.sSTR_XMRADIO_SONGS
        firstTextX: 17; firstTextY: 235-166+96
        firstTextWidth:223
        firstTextSize: 40
        firstTextStyle: systemInfo.font_NewHDR
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextPressColor: idRadioFavoriteSong.activeFocus ? colorInfo.brightGrey : (idAppMain.gSXMFavoirtesBand == "song") ? colorInfo.blue : colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.blue
        focus: (idAppMain.gSXMFavoirtesBand == "song") && idRadioFavoriteSong.active
        onClickOrKeySelected: {
            //console.log("[0]--------------------------------- Song Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
            idRadioFavoriteArtist.firstTextStyle = systemInfo.font_NewHDR;
            idRadioFavoriteSong.firstTextStyle = systemInfo.font_NewHDB;
            changeFavoriteSongList();
            setFavoriteListSongFocus();
        }

        onWheelRightKeyPressed: {
            idRadioFavoriteArtist.focus = true;
        }

        onActiveFocusChanged: {
            //console.log("Song onActiveFocusChanged ---------------> "+idRadioFavoriteSongArtist.focus+" "+idRadioFavoriteSong.focus+" "+idRadioFavoriteSong.activeFocus+" "+idRadioFavoriteArtist.focus+" "+idRadioFavoriteArtist.activeFocus)
            if(idRadioFavoriteSongArtist.focus == true)
            {
                //console.log("[0-0]--------------------------------- Song Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
                if(idRadioFavoriteSong.activeFocus == true)
                {
                    //console.log("[0-1]--------------------------------- Song Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
                    idRadioFavoriteArtist.firstTextColor = colorInfo.brightGrey;
                    idRadioFavoriteArtist.firstTextSelectedColor = colorInfo.blue;
                    idRadioFavoriteArtist.fgImage = imageInfo.imgFolderRadio_SXM+"icon_list_artist_p.png"
                    idRadioFavoriteArtist.fgImageActive = imageInfo.imgFolderRadio_SXM+"icon_list_artist_s.png"
                    idRadioFavoriteArtist.firstTextStyle = (idAppMain.gSXMFavoirtesBand != "song") ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;

                    idRadioFavoriteSong.firstTextColor = colorInfo.white;
                    idRadioFavoriteSong.firstTextSelectedColor = colorInfo.white;
                    idRadioFavoriteSong.fgImage = imageInfo.imgFolderRadio_SXM+"icon_list_song_f.png"
                    idRadioFavoriteSong.fgImageActive = imageInfo.imgFolderRadio_SXM+"icon_list_song_f.png"
                    idRadioFavoriteSong.firstTextStyle = (idAppMain.gSXMFavoirtesBand == "song") ? systemInfo.font_NewHDB : systemInfo.font_NewHDR
                }
                else if(idRadioFavoriteSong.activeFocus == false)
                {
                    if(idRadioFavoriteSong.firstTextStyle == systemInfo.font_NewHDB/*idAppMain.gSXMFavoirtesBand == "song"*/)
                    {
                        //console.log("[0-2]--------------------------------- Song Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
                        idRadioFavoriteSong.firstTextColor = colorInfo.brightGrey;
                        idRadioFavoriteSong.firstTextSelectedColor = colorInfo.blue;
                        idRadioFavoriteSong.fgImage = imageInfo.imgFolderRadio_SXM+"icon_list_song_p.png"
                        idRadioFavoriteSong.fgImageActive = imageInfo.imgFolderRadio_SXM+"icon_list_song_s.png"
                        idRadioFavoriteSong.firstTextStyle = systemInfo.font_NewHDB
                    }
                    else
                    {
                        //console.log("[0-3]--------------------------------- Song Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
                        idRadioFavoriteSong.firstTextColor = colorInfo.brightGrey;
                        idRadioFavoriteSong.firstTextSelectedColor = colorInfo.brightGrey;
                        idRadioFavoriteSong.fgImage = imageInfo.imgFolderRadio_SXM+"icon_list_song_p.png"
                        idRadioFavoriteSong.fgImageActive = imageInfo.imgFolderRadio_SXM+"icon_list_song_p.png"
                        idRadioFavoriteSong.firstTextStyle = systemInfo.font_NewHDR
                    }
                }
            }
            else
            {
                //console.log("[0-4]--------------------------------- Song Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
                idRadioFavoriteSong.firstTextColor = colorInfo.brightGrey;
                idRadioFavoriteSong.firstTextSelectedColor = colorInfo.blue;
                idRadioFavoriteSong.fgImage = imageInfo.imgFolderRadio_SXM+"icon_list_song_p.png"
                idRadioFavoriteSong.fgImageActive = imageInfo.imgFolderRadio_SXM+"icon_list_song_s.png"
                idRadioFavoriteSong.firstTextStyle = (idAppMain.gSXMFavoirtesBand == "song") ? systemInfo.font_NewHDB : systemInfo.font_NewHDR
            }
        }
    }

    Image{
        id : idFavoritesListLine
        x: 0; y: 277
        source: imageInfo.imgFolderXMData+"line_left_list_l.png"
    }

    // Artist Button
    MComp.MButton{
        id: idRadioFavoriteArtist
        x: 0; y: 277
        width: 276; height: 277
        visible: true
        active: (idAppMain.gSXMFavoirtesBand == "song") ? false : true
        fgImageX: 92; fgImageY: 74
        fgImageWidth: 73; fgImageHeight: 73
        fgImage: imageInfo.imgFolderRadio_SXM+"icon_list_artist_n.png"
        fgImagePress: idRadioFavoriteArtist.activeFocus ? imageInfo.imgFolderRadio_SXM+"icon_list_artist_p.png" : (idAppMain.gSXMFavoirtesBand == "artist") ? imageInfo.imgFolderRadio_SXM+"icon_list_artist_s.png" : imageInfo.imgFolderRadio_SXM+"icon_list_artist_p.png"
        fgImageActive: imageInfo.imgFolderRadio_SXM+"icon_list_artist_s.png"
        fgImageFocus: imageInfo.imgFolderRadio_SXM+"icon_list_artist_f.png"
        bgImage: ""
        bgImagePress: imageInfo.imgFolderRadio_SXM+"fav_tab_02_p.png"
        bgImageFocus: imageInfo.imgFolderRadio_SXM+"fav_tab_02_f.png"
        firstText: stringInfo.sSTR_XMRADIO_ARTISTS
        firstTextX: 17; firstTextY: 170
        firstTextWidth:223
        firstTextSize: 40
        firstTextStyle: systemInfo.font_NewHDR
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextPressColor: idRadioFavoriteArtist.activeFocus ? colorInfo.brightGrey : (idAppMain.gSXMFavoirtesBand == "artist") ? colorInfo.blue : colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.blue
        focus: (idAppMain.gSXMFavoirtesBand == "artist") && idRadioFavoriteArtist.active
        onClickOrKeySelected: {
            //console.log("[1]--------------------------------- Artist Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
            idRadioFavoriteSong.firstTextStyle = systemInfo.font_NewHDR;
            idRadioFavoriteArtist.firstTextStyle = systemInfo.font_NewHDB;
            changeFavoriteArtistList();
            setFavoriteListArtistFocus();
        }

        onWheelLeftKeyPressed: {
            idRadioFavoriteSong.focus = true;
        }

        onActiveFocusChanged: {
            //console.log("Artist onActiveFocusChanged ---------------> "+idRadioFavoriteSongArtist.focus+" "+idRadioFavoriteSong.focus+" "+idRadioFavoriteSong.activeFocus+" "+idRadioFavoriteArtist.focus+" "+idRadioFavoriteArtist.activeFocus)
            if(idRadioFavoriteSongArtist.focus == true)
            {
                //console.log("[1-0]--------------------------------- Artist Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
                if(idRadioFavoriteArtist.activeFocus == true)
                {
                    //console.log("[1-1]--------------------------------- Artist Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
                    idRadioFavoriteSong.firstTextColor = colorInfo.brightGrey;
                    idRadioFavoriteSong.firstTextSelectedColor = colorInfo.blue;
                    idRadioFavoriteSong.fgImage = imageInfo.imgFolderRadio_SXM+"icon_list_song_p.png"
                    idRadioFavoriteSong.fgImageActive = imageInfo.imgFolderRadio_SXM+"icon_list_song_s.png"
                    idRadioFavoriteSong.firstTextStyle = (idAppMain.gSXMFavoirtesBand != "artist") ? systemInfo.font_NewHDB : systemInfo.font_NewHDR

                    idRadioFavoriteArtist.firstTextColor = colorInfo.white;
                    idRadioFavoriteArtist.firstTextSelectedColor = colorInfo.white;
                    idRadioFavoriteArtist.fgImage = imageInfo.imgFolderRadio_SXM+"icon_list_artist_f.png"
                    idRadioFavoriteArtist.fgImageActive = imageInfo.imgFolderRadio_SXM+"icon_list_artist_f.png"
                    idRadioFavoriteArtist.firstTextStyle = (idAppMain.gSXMFavoirtesBand == "artist") ? systemInfo.font_NewHDB : systemInfo.font_NewHDR
                }
                else if(idRadioFavoriteArtist.activeFocus == false)
                {
                    if(idRadioFavoriteArtist.firstTextStyle == systemInfo.font_NewHDB/*idAppMain.gSXMFavoirtesBand == "artist"*/)
                    {
                        //console.log("[1-2]--------------------------------- Artist Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
                        idRadioFavoriteArtist.firstTextColor = colorInfo.brightGrey;
                        idRadioFavoriteArtist.firstTextSelectedColor = colorInfo.blue;
                        idRadioFavoriteArtist.fgImage = imageInfo.imgFolderRadio_SXM+"icon_list_artist_p.png"
                        idRadioFavoriteArtist.fgImageActive = imageInfo.imgFolderRadio_SXM+"icon_list_artist_s.png"
                        idRadioFavoriteArtist.firstTextStyle = systemInfo.font_NewHDB
                    }
                    else
                    {
                        //console.log("[1-3]--------------------------------- Artist Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
                        idRadioFavoriteArtist.firstTextColor = colorInfo.brightGrey;
                        idRadioFavoriteArtist.firstTextSelectedColor = colorInfo.brightGrey;
                        idRadioFavoriteArtist.fgImage = imageInfo.imgFolderRadio_SXM+"icon_list_artist_p.png"
                        idRadioFavoriteArtist.fgImageActive = imageInfo.imgFolderRadio_SXM+"icon_list_artist_p.png"
                        idRadioFavoriteArtist.firstTextStyle = systemInfo.font_NewHDR
                    }
                }
            }
            else
            {
                //console.log("[1-4]--------------------------------- Artist Tab Selected!!!!! Band="+idAppMain.gSXMFavoirtesBand)
                idRadioFavoriteArtist.firstTextColor = colorInfo.brightGrey;
                idRadioFavoriteArtist.firstTextSelectedColor = colorInfo.blue;
                idRadioFavoriteArtist.fgImage = imageInfo.imgFolderRadio_SXM+"icon_list_artist_p.png"
                idRadioFavoriteArtist.fgImageActive = imageInfo.imgFolderRadio_SXM+"icon_list_artist_s.png"
                idRadioFavoriteArtist.firstTextStyle = (idAppMain.gSXMFavoirtesBand == "artist") ? systemInfo.font_NewHDB : systemInfo.font_NewHDR
            }
        }
    }

    function changeFavoriteSongList()
    {
        idAppMain.gSXMFavoirtesBand = "song"
        setFavoriteListSong();

        sxm_favorite_listcount = (gSXMFavoriteList == "SONG") ? ATSeek.handleFavoriteSongNum() : ATSeek.handleFavoriteArtistNum();
    }

    function changeFavoriteArtistList()
    {
        idAppMain.gSXMFavoirtesBand = "artist"
        setFavoriteListArtist();

        sxm_favorite_listcount = (gSXMFavoriteList == "SONG") ? ATSeek.handleFavoriteSongNum() : ATSeek.handleFavoriteArtistNum();
    }

    function changeFavoriteListChangeStyle()
    {
        if(idRadioFavoriteSongArtist.activeFocus == false)
        {
            idRadioFavoriteSong.firstTextStyle = systemInfo.font_NewHDB;
            idRadioFavoriteArtist.firstTextStyle = systemInfo.font_NewHDR;
        }
    }
}

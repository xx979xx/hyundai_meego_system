/**
 * FileName: MChListDelegate.qml
 * Author: HYANG
 * Time: 2012-02-02
 *
 * - 2012-02-02 Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idMFavoriteListDelegate
    x: 0; y: 0
    width: 993; height: 92

    //****************************** # Preperty #
    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderMusic+"tab_list_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderMusic+"tab_list_p.png"
    property string bgImageFocus: imageInfo.imgFolderMusic+"tab_list_f.png"

    property string firstTextColor: colorInfo.brightGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: colorInfo.brightGrey
    property string firstTextFocusSelectedColor: colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.blue

    property string mChListFirstText: ""

    //****************************** # Default/Selected/Press Image #
    Image{
        id: normalImage
        x: 4; y: 0
        source: bgImage
    }

    //****************************** # Focus Image #
    BorderImage {
        id: focusImage
        x: 4; y: 0
        width: 976
        source: bgImageFocus;
        visible: showFocus && idMFavoriteListDelegate.activeFocus;
    }

    //****************************** # Index (FirstText) #
    MComp.DDScrollTicker{
        id: firstText
        text: mChListFirstText
        x: 4+49; y: 90-44-(firstText.fontSize /2)-(firstText.fontSize/(3*2))
        width: 844; height: firstText.fontSize+(firstText.fontSize/3)
        fontFamily : systemInfo.font_NewHDR;
        fontSize: 40
        color: firstTextColor
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerFocus: (idMFavoriteListDelegate.activeFocus && idAppMain.focusOn)
        visible: true
    }

    //****************************** # Line Image #
    Image{
        x: 10; y: idMFavoriteListDelegate.height
        source: imageInfo.imgFolderMusic+"tab_list_line.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyReleased: {
        if(gSXMFavoriteList == "SONG")
        {
            if(index == idMFavoriteListDelegate.ListView.view.currentIndex) idMFavoriteListDelegate.state = "selectedSong";
            else idMFavoriteListDelegate.state = "keyRelease";
        }
        else if(gSXMFavoriteList == "ARTIST")
        {
            if(index == idMFavoriteListDelegate.ListView.view.currentIndex) idMFavoriteListDelegate.state = "selectedArtist";
            else idMFavoriteListDelegate.state = "keyRelease";
        }
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        if(gSXMFavoriteList == "SONG")
            sxm_favorite_songindex = index;
        else if(gSXMFavoriteList == "ARTIST")
            sxm_favorite_artistindex = index;

        idMFavoriteListDelegate.ListView.view.currentIndex = index;
        idMFavoriteListDelegate.ListView.view.focus = true;
        idMFavoriteListDelegate.ListView.view.forceActiveFocus();
    }

    //****************************** # State #
    states: [
        State {
            name: 'selectedSong'; when: (index == idMFavoriteListDelegate.ListView.view.currentIndex)
            PropertyChanges {target: firstText; color: idMFavoriteListDelegate.activeFocus? firstTextFocusSelectedColor : firstTextColor;}
        },
        State {
            name: 'selectedArtist'; when: (index == idMFavoriteListDelegate.ListView.view.currentIndex)
            PropertyChanges {target: firstText; color: idMFavoriteListDelegate.activeFocus? firstTextFocusSelectedColor : firstTextColor;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: firstTextColor;}
        }
    ]

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event))
        {
            if(gSXMFavoriteList == "SONG")
            {
                if(idRadioFavoriteSongListView.flicking || idRadioFavoriteSongListView.moving)   return;
            }
            else
            {
                if(idRadioFavoriteArtistListView.flicking || idRadioFavoriteArtistListView.moving)   return;
            }

            if( idMFavoriteListDelegate.ListView.view.currentIndex )
            {
                idMFavoriteListDelegate.ListView.view.decrementCurrentIndex();
                if(idMFavoriteListDelegate.ListView.view.currentIndex%6 == 5)
                    idMFavoriteListDelegate.ListView.view.positionViewAtIndex(idMFavoriteListDelegate.ListView.view.currentIndex-5, ListView.Beginning);
            }
            else
            {
                if(ListView.view.count < 7)
                    return;

                idMFavoriteListDelegate.ListView.view.positionViewAtIndex(idMFavoriteListDelegate.ListView.view.count-1, idMFavoriteListDelegate.ListView.view.Visible);
                idMFavoriteListDelegate.ListView.view.currentIndex = idMFavoriteListDelegate.ListView.view.count-1;
            }
        }
        else if(idAppMain.isWheelRight(event))
        {
            if(gSXMFavoriteList == "SONG")
            {
                if(idRadioFavoriteSongListView.flicking || idRadioFavoriteSongListView.moving)   return;
            }
            else
            {
                if(idRadioFavoriteArtistListView.flicking || idRadioFavoriteArtistListView.moving)   return;
            }

            if( idMFavoriteListDelegate.ListView.view.count-1 != idMFavoriteListDelegate.ListView.view.currentIndex )
            {
                idMFavoriteListDelegate.ListView.view.incrementCurrentIndex();
                if(idMFavoriteListDelegate.ListView.view.currentIndex%6 == 0)
                    idMFavoriteListDelegate.ListView.view.positionViewAtIndex(idMFavoriteListDelegate.ListView.view.currentIndex, ListView.Beginning);
            }
            else
            {
                if(ListView.view.count < 7)
                    return;

                idMFavoriteListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                idMFavoriteListDelegate.ListView.view.currentIndex = 0;
            }
        }
    }
}

/**
 * FileName: MFavoriteActiveDelegate.qml
 * Author: HYANG
 * Time: 2013-07
 *
 * - 2013-07 Initial Created by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MComponent {
    id: idMFavoriteActiveDelegate
    x: 0; y: 0
    width: 1246; height: 92

    //****************************** # Preperty #
    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderGeneral+"list_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderGeneral+"list_p.png"
    property string bgImageFocus: imageInfo.imgFolderGeneral+"list_f.png"

    property string iconTitleImage : imageInfo.imgFolderRadio_SXM+"ico_list_song_n.png"
    property string iconSelectedTitleImage : imageInfo.imgFolderRadio_SXM+"ico_list_song_s.png"
    property string iconArtistImage : imageInfo.imgFolderRadio_SXM+"ico_list_artist_n.png"
    property string iconSelectedArtistImage : imageInfo.imgFolderRadio_SXM+"ico_list_artist_s.png"

    property string firstTextColor: colorInfo.brightGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: colorInfo.brightGrey
    property string firstTextFocusSelectedColor: colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.blue

    property string secondTextColor: colorInfo.dimmedGrey
    property string secondTextPressColor: colorInfo.brightGrey
    property string secondTextFocusPressColor: colorInfo.brightGrey
    property string secondTextFocusSelectedColor: colorInfo.brightGrey
    property string secondTextSelectedColor: colorInfo.brightGrey

    property string thirdTextColor: colorInfo.dimmedGrey
    property string thirdTextPressColor: colorInfo.brightGrey
    property string thirdTextFocusPressColor: colorInfo.brightGrey
    property string thirdTextFocusSelectedColor: colorInfo.brightGrey
    property string thirdTextSelectedColor: colorInfo.brightGrey

    property string mListFirstText: ""
    property string mListSecondText: ""
    property string mListThirdText: ""
    property int nListIconType : 0

    property int bgStartX: 14

    //****************************** # Default/Selected/Press Image #
    Image{
        id: idNormalImage
        x: bgStartX; y: 0
        source: bgImage
    }

    //****************************** # Focus Image #
    BorderImage {
        id: idFocusImage
        x: bgStartX; y: 0
        source: bgImageFocus;
        visible: {
            if((idMFavoriteActiveDelegate.state=="keyPress") || (idMFavoriteActiveDelegate.state=="pressed"))
                return false;
            return showFocus && idMFavoriteActiveDelegate.activeFocus;
        }
    }

    //****************************** # Icon Image in List #
    Image{
        id: idIconImage
        x: 37; y: 90-43-23
        source: (nListIconType==2)? iconTitleImage : iconArtistImage
    }

    //****************************** # Index (FirstText) #
    MComp.DDScrollTicker{
        id: idFirstText
        text: mListFirstText
        x: 37+64; y: 90-44-(idFirstText.fontSize /2)-(idFirstText.fontSize/(3*2))
        width: 694; height: idFirstText.fontSize+(idFirstText.fontSize/3)
        fontFamily : systemInfo.font_NewHDR;
        fontSize: 40
        color: firstTextColor
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerFocus: (idMFavoriteActiveDelegate.activeFocus && idAppMain.focusOn)
    }

    //****************************** # Index (SecondText) #
    Text{
        id: idSecondText
        text: mListSecondText
        x: 37+64+694+26; y: 90-44-(font.pixelSize/2)
        width: 80; height: 35
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: secondTextColor
        elide: Text.ElideRight
    }

    //****************************** # Index (ThirdText) #
    MComp.DDScrollTicker{
        id: idThirdText
        text: mListThirdText
        x: 37+64+694+26+80+26; y: 90-44-(idThirdText.fontSize/2)-(idThirdText.fontSize/(3*2))
        width: 320; height: idThirdText.fontSize+(idThirdText.fontSize/3)
        fontSize: 32
        fontFamily: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: thirdTextColor
        tickerFocus: (idMFavoriteActiveDelegate.activeFocus && idAppMain.focusOn)
    }

    //****************************** # Line Image #
    Image{
        x: 0; y: idMFavoriteActiveDelegate.height
        source: imageInfo.imgFolderGeneral+"list_line.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMFavoriteActiveDelegate.ListView.view.flicking == false && idMFavoriteActiveDelegate.ListView.view.moving == false)
            idMFavoriteActiveDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(mListThirdText == PLAYInfo.ChnName) idMFavoriteActiveDelegate.state = "selected";
        else if((mListThirdText != PLAYInfo.ChnName) && (index == idMFavoriteActiveDelegate.ListView.view.currentIndex)) idMFavoriteActiveDelegate.state = "selectedFocus";
        else idMFavoriteActiveDelegate.state = "keyRelease";
    }
    onCancel:{
        if(mListThirdText == PLAYInfo.ChnName) idMFavoriteActiveDelegate.state = "selected";
        else if((mListThirdText != PLAYInfo.ChnName) && (index == idMFavoriteActiveDelegate.ListView.view.currentIndex)) idMFavoriteActiveDelegate.state = "selectedFocus";
        else idMFavoriteActiveDelegate.state = "keyRelease";
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        idMFavoriteActiveDelegate.ListView.view.currentIndex = index;
        idMFavoriteActiveDelegate.ListView.view.focus = true;

        XMOperation.setPreviousScanStop();
        idRadioFavoriteActiveQml.setFavoriteActiveClose();
        setAppMainScreen("AppRadioMain", false);
        ATSeek.handleATSeekSelect(index);
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: idNormalImage; source: bgImagePress;}
            PropertyChanges {target: idIconImage; source: idMFavoriteActiveDelegate.activeFocus ? (nListIconType==2) ? iconTitleImage : iconArtistImage : (nListIconType==2) ? ((mListThirdText == PLAYInfo.ChnName) ? iconSelectedTitleImage : iconTitleImage) : ((mListThirdText == PLAYInfo.ChnName) ? iconSelectedArtistImage : iconArtistImage);}
            PropertyChanges {target: idFirstText; color: idMFavoriteActiveDelegate.activeFocus ? firstTextPressColor : (mListThirdText == PLAYInfo.ChnName) ? firstTextSelectedColor : firstTextPressColor;}
            PropertyChanges {target: idSecondText; color: idMFavoriteActiveDelegate.activeFocus ? secondTextPressColor : (mListThirdText == PLAYInfo.ChnName) ? secondTextSelectedColor : secondTextPressColor;}
            PropertyChanges {target: idThirdText; color: idMFavoriteActiveDelegate.activeFocus ? thirdTextPressColor : (mListThirdText == PLAYInfo.ChnName) ? thirdTextSelectedColor : thirdTextPressColor;}
            PropertyChanges {target: idFirstText; fontFamily: (mListThirdText == PLAYInfo.ChnName) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'selected'; when: (mListThirdText == PLAYInfo.ChnName)
            PropertyChanges {target: idIconImage; source: (nListIconType==2) ? (showFocus && idMFavoriteActiveDelegate.activeFocus ? iconTitleImage : iconSelectedTitleImage) : (showFocus && idMFavoriteActiveDelegate.activeFocus ? iconArtistImage : iconSelectedArtistImage);}
            PropertyChanges {target: idFirstText; color: (showFocus && idMFavoriteActiveDelegate.activeFocus) ? firstTextFocusSelectedColor : firstTextSelectedColor;}
            PropertyChanges {target: idSecondText; color: (showFocus && idMFavoriteActiveDelegate.activeFocus) ? secondTextFocusSelectedColor : secondTextColor;}
            PropertyChanges {target: idThirdText; color: (showFocus && idMFavoriteActiveDelegate.activeFocus) ? thirdTextFocusSelectedColor : thirdTextColor;}
            PropertyChanges {target: idFirstText; fontFamily: systemInfo.font_NewHDB;}
        },
        State {
            name: 'selectedFocus'; when: ((mListThirdText != PLAYInfo.ChnName) && (index == idMFavoriteActiveDelegate.ListView.view.currentIndex))
            PropertyChanges {target: idIconImage; source: (nListIconType==2) ? (idMFavoriteActiveDelegate.activeFocus ? iconTitleImage : iconTitleImage) : (idMFavoriteActiveDelegate.activeFocus ? iconArtistImage : iconArtistImage);}
            PropertyChanges {target: idFirstText; color: idMFavoriteActiveDelegate.activeFocus ? firstTextFocusSelectedColor : firstTextColor;}
            PropertyChanges {target: idSecondText; color: idMFavoriteActiveDelegate.activeFocus ? secondTextFocusSelectedColor : secondTextColor;}
            PropertyChanges {target: idThirdText; color: idMFavoriteActiveDelegate.activeFocus ? thirdTextFocusSelectedColor : thirdTextColor;}
        },
        State {
            name: 'keyPress'; when: idFocusImage.active
            PropertyChanges {target: idNormalImage; source: bgImageFocusPress;}
            PropertyChanges {target: idIconImage; source: (nListIconType==2) ? iconTitleImage : iconArtistImage;}
            PropertyChanges {target: idFirstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: idSecondText; color: secondTextFocusPressColor;}
            PropertyChanges {target: idThirdText; color: thirdTextFocusPressColor;}
            PropertyChanges {target: idFirstText; fontFamily: (mListThirdText == PLAYInfo.ChnName) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: idNormalImage; source: bgImage;}
            PropertyChanges {target: idIconImage; source: (nListIconType==2) ? iconTitleImage : iconArtistImage;}
            PropertyChanges {target: idFirstText; color: firstTextColor;}
            PropertyChanges {target: idSecondText; color: secondTextColor;}
            PropertyChanges {target: idThirdText; color: thirdTextColor;}
        }
    ]

    //****************************** # Wheel (CCP) #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event))
            onFavoritesActiveListLeft();
        else if(idAppMain.isWheelRight(event))
            onFavoritesActiveListRight();
    }

    //****************************** # Tune knob #
    onTuneLeftKeyPressed: {
        if(idAppMain.state == "AppRadioFavoriteActive" && !(UIListener.HandleGetShowPopupFlag() == true))
            onFavoritesActiveListLeft();
    }
    onTuneRightKeyPressed: {
        if(idAppMain.state == "AppRadioFavoriteActive" && !(UIListener.HandleGetShowPopupFlag() == true))
            onFavoritesActiveListRight();
    }
    onTuneEnterKeyPressed: {
        if(idAppMain.state == "AppRadioFavoriteActive" && !(UIListener.HandleGetShowPopupFlag() == true))
            onFavoritesActiveListTuneEnterKeyOperation();
    }

    //****************************** # Function #
    function onFavoritesActiveListTuneEnterKeyOperation(){
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        idMFavoriteActiveDelegate.ListView.view.currentIndex = index;
        idMFavoriteActiveDelegate.ListView.view.focus = true;

        idRadioFavoriteActiveQml.setFavoriteActiveClose();

        // System Popup check
        if(UIListener.HandleGetShowPopupFlag() == true)
        {
            UIListener.HandleSystemPopupClose();
        }

        XMOperation.setPreviousScanStop();
        setAppMainScreen("AppRadioMain", false);
        ATSeek.handleATSeekSelect(index);
    }
}

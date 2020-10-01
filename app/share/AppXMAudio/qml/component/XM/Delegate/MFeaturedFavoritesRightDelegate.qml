/**
 * FileName: MChListDelegate.qml
 * Author: HYANG
 * Time: 2012-02-02
 *
 * - 2012-02-02 Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MComponent {
    id: idMFFListRightDelegate
    x: 0; y: 0
    width: 585; height: 89

    //****************************** # Preperty #
    property string playImage: imageInfo.imgFolderGeneral+"icon_play.gif"
    property string playStopImage: imageInfo.imgFolderGeneral+"ico_play_02.png"

    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderGeneral+"bg_menu_tab_r_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderGeneral+"bg_menu_tab_r_p.png"
    property string bgImageFocus: imageInfo.imgFolderGeneral+"bg_menu_tab_r_f.png"

    property string firstTextColor: colorInfo.blue
    property string firstTextPressColor: colorInfo.blue
    property string firstTextFocusPressColor: colorInfo.blue
    property string firstTextFocusSelectedColor: colorInfo.blue
    property string firstTextSelectedColor: colorInfo.blue

    property string secondTextColor: colorInfo.brightGrey
    property string secondTextPressColor: colorInfo.brightGrey
    property string secondTextFocusPressColor: colorInfo.brightGrey
    property string secondTextFocusSelectedColor: colorInfo.brightGrey
    property string secondTextSelectedColor: colorInfo.blue

    property string mChListFirstText: ""
    property string mChListSecondText: ""

    //****************************** # Default/Selected/Press Image #
    Image{
        id: normalImage
        x: 1; y: -3
        source: bgImage
    }

    //****************************** # Focus Image #
    BorderImage {
        id: focusImage
        x: 1; y: -3
        source: bgImageFocus;
        visible: {
            if((idMFFListRightDelegate.state=="keyPress") || (idMFFListRightDelegate.state=="pressed"))
                return false;
            return showFocus && idMFFListRightDelegate.activeFocus;
        }
    }

    //****************************** # Playing / PlayingStop Icon #
    AnimatedImage {
        id : idPlayIconImg
        x: 10+7; y: 89-24-43; //z: checkFFPlayingIconState() ? 1 : 0
        anchors.verticalCenter: parent.verticalCenter
        source: playImage
        playing : true
        visible : checkFFPlayingIconState()
    }
    Image{
        id: idPlayStopIconImg
        x: 10+7; y: 89-24-43; //z: checkFFPlayingStopIconState() ? 1 : 0
        anchors.verticalCenter: parent.verticalCenter
        source: playStopImage
        visible : checkFFPlayingStopIconState()
    }

    //****************************** # Channel Number (FirstText) #
    Text{
        id: firstText
        text: mChListFirstText
        x: (checkFFPlayingIconState() || checkFFPlayingStopIconState()) ? 10+7+7+47 : 10+14
        y: 89-42-(font.pixelSize/2)
        width: 58; height: 35
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: firstTextColor
    }

    MComp.DDScrollTicker{
        id: secondText
        text: mChListSecondText
        x: (checkFFPlayingIconState() || checkFFPlayingStopIconState()) ? 10+7+7+47+58+10 : 10+14+58+10
        y: 89-42-(secondText.fontSize/2)-(secondText.fontSize/(3*2))
        width: (checkFFPlayingIconState() || checkFFPlayingStopIconState()) ? 365 : 412
        height: secondText.fontSize+(secondText.fontSize/3)
        fontSize: 32
        fontFamily: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: secondTextColor
        tickerFocus: (idMFFListRightDelegate.activeFocus && idAppMain.focusOn)
    }

    //****************************** # Line Image #
    Image{
        x: 10; y: idMFFListRightDelegate.height
        source: imageInfo.imgFolderGeneral+"line_menu_list.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMFFListRightDelegate.ListView.view.flicking == false && idMFFListRightDelegate.ListView.view.moving == false)
            idMFFListRightDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(mChListFirstText == PLAYInfo.ChnNum) idMFFListRightDelegate.state = "selected";
        else if((mChListFirstText != PLAYInfo.ChnNum) && (index == idMFFListRightDelegate.ListView.view.currentIndex)) idMFFListRightDelegate.state = "selectedFocus";
        else idMFFListRightDelegate.state = "keyRelease";
    }
    onCancel:{
        if(mChListFirstText == PLAYInfo.ChnNum) idMFFListRightDelegate.state = "selected";
        else if((mChListFirstText != PLAYInfo.ChnNum) && (index == idMFFListRightDelegate.ListView.view.currentIndex)) idMFFListRightDelegate.state = "selectedFocus";
        else idMFFListRightDelegate.state = "keyRelease";
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        sxm_ffavorites_bandcontindex = index;
        setFeaturedFavoritesBandCont(mChListSecondText);
        idMFFListRightDelegate.ListView.view.currentIndex = index;
        idMFFListRightDelegate.ListView.view.focus = true;
        idMFFListRightDelegate.ListView.view.forceActiveFocus();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: idMFFListRightDelegate.activeFocus ? firstTextPressColor : (mChListFirstText == PLAYInfo.ChnNum) ? firstTextSelectedColor : firstTextPressColor;}
            PropertyChanges {target: secondText; color: idMFFListRightDelegate.activeFocus ? secondTextPressColor : (mChListFirstText == PLAYInfo.ChnNum) ? secondTextSelectedColor : secondTextPressColor;}
            PropertyChanges {target: firstText; font.family: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
            PropertyChanges {target: secondText; fontFamily: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'selected'; when: (mChListFirstText == PLAYInfo.ChnNum)
            PropertyChanges {target: firstText; color: (showFocus && idMFFListRightDelegate.activeFocus) ? firstTextFocusSelectedColor : firstTextSelectedColor;}
            PropertyChanges {target: secondText; color: (showFocus && idMFFListRightDelegate.activeFocus) ? secondTextFocusSelectedColor : secondTextSelectedColor;}
            PropertyChanges {target: firstText; font.family: systemInfo.font_NewHDB;}
            PropertyChanges {target: secondText; fontFamily: systemInfo.font_NewHDB;}
        },
        State {
            name: 'selectedFocus'; when: ((mChListFirstText != PLAYInfo.ChnNum) && (index == idMFFListRightDelegate.ListView.view.currentIndex))
            PropertyChanges {target: firstText; color: idMFFListRightDelegate.activeFocus ? firstTextFocusSelectedColor : firstTextColor;}
            PropertyChanges {target: secondText; color: idMFFListRightDelegate.activeFocus ? secondTextFocusSelectedColor : secondTextColor;}
        },
        State {
            name: 'keyPress'; when: focusImage.active
            PropertyChanges {target: normalImage; source: bgImageFocusPress;}
            PropertyChanges {target: firstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: secondText; color: secondTextFocusPressColor;}
            PropertyChanges {target: firstText; font.family: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
            PropertyChanges {target: secondText; fontFamily: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: firstTextColor;}
            PropertyChanges {target: secondText; color: secondTextColor;}
        }
    ]

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event))
            onFFBandContListLeft();
        else if(idAppMain.isWheelRight(event))
            onFFBandContListRight();
    }

    onTuneLeftKeyPressed: {
        if(idAppMain.state == "AppRadioFeaturedFavorites" && !(UIListener.HandleGetShowPopupFlag() == true))
            onFFBandContListLeft();
    }
    onTuneRightKeyPressed: {
        if(idAppMain.state == "AppRadioFeaturedFavorites" && !(UIListener.HandleGetShowPopupFlag() == true))
            onFFBandContListRight();
    }
    onTuneEnterKeyPressed: {
        if(idAppMain.state == "AppRadioFeaturedFavorites" && !(UIListener.HandleGetShowPopupFlag() == true))
            setFFBandContListTuneEnterKeyOperation();
    }

    function setFFBandContListTuneEnterKeyOperation()
    {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        sxm_ffavorites_bandcontindex = index;
        setFeaturedFavoritesBandCont(mChListSecondText);
        idMFFListRightDelegate.ListView.view.currentIndex = index;
        idMFFListRightDelegate.ListView.view.focus = true;
        idMFFListRightDelegate.ListView.view.forceActiveFocus();

        sxm_ffavorites_curlist = "right";
        gFFavoritesBandContIndex =  sxm_ffavorites_bandcontindex;

        idRadioFeaturedFavoritesQml.setFeaturedFavoritesClose();

        // System Popup check
        if(UIListener.HandleGetShowPopupFlag() == true)
        {
            UIListener.HandleSystemPopupClose();
        }

        XMOperation.setPreviousScanStop();
        setAppMainScreen("AppRadioMain", false);
        FFManager.handleFeaturedFavoritesSelect(gFFavoritesBandContIndex);
    }

    function setFFTuneEnterDelegate()
    {
        setFFBandContListTuneEnterKeyOperation();
    }
    function setFFTuneLeftDelegate()
    {
        onFFBandContListLeft();
    }
    function setFFTuneRightDelegate()
    {
        onFFBandContListRight();
    }

    function checkFFPlayingIconState()
    {
        if(idRadioFeaturedFavorites.visible == false) return false;

        //console.log("[0]-----------------------ChnNum="+PLAYInfo.ChnNum+" Adv="+PLAYInfo.SubAdvisory+" Pause="+PLAYInfo.bPaused+" PlayMode="+gSXMPlayMode)
        if(mChListFirstText == PLAYInfo.ChnNum)
        {
            if( (PLAYInfo.SubAdvisory == "") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_WEAK_SIGNAL") ||
                    ((PLAYInfo.SubAdvisory != "STR_XMRADIO_ANTENNA_DISCONNECTED") && (PLAYInfo.SubAdvisory != "STR_XMRADIO_ANTENNA_SHORTED") && (PLAYInfo.SubAdvisory != "STR_XMRADIO_LOSS_OF_SIGNAL")) )
            {
                if((PLAYInfo.bPaused == false) || (gSXMPlayMode == "Play" && PLAYInfo.bPaused == true))
                    return true;
                else
                    return false;
            }
        }

        return false;
    }
    function checkFFPlayingStopIconState()
    {
        if(idRadioFeaturedFavorites.visible == false) return false;

        //console.log("[1]-----------------------ChnNum="+PLAYInfo.ChnNum+" Adv="+PLAYInfo.SubAdvisory+" Pause="+PLAYInfo.bPaused+" PlayMode="+gSXMPlayMode)
        if(mChListFirstText == PLAYInfo.ChnNum)
        {
            if( (PLAYInfo.SubAdvisory != "") && (PLAYInfo.SubAdvisory != "STR_XMRADIO_WEAK_SIGNAL") &&
                    ((PLAYInfo.SubAdvisory == "STR_XMRADIO_ANTENNA_DISCONNECTED") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_ANTENNA_SHORTED") || (PLAYInfo.SubAdvisory == "STR_XMRADIO_LOSS_OF_SIGNAL")) )
            {
                return true;
            }
            else //exclusive goog, excellent, check antenna, antenna short, No signal
            {
                if((PLAYInfo.bPaused == false) || (gSXMPlayMode == "Play" && PLAYInfo.bPaused == true))
                    return false;
                else
                    return true;
            }
        }

        return false;
    }
}

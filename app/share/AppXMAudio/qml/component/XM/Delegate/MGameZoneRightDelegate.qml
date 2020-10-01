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
    id: idMGameZoneRightDelegate
    x: 0; y: 0
    width: 585; height: 108

    //****************************** # Preperty #
    property string playImage: imageInfo.imgFolderGeneral+"icon_play.gif"
    property string playStopImage: imageInfo.imgFolderGeneral+"ico_play_02.png"

    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderRadio_Dab+"list_dab_epg_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderRadio_Dab+"list_dab_epg_p.png"
    property string bgImageFocus: imageInfo.imgFolderRadio_Dab+"list_dab_epg_f.png"

    property string mChListArt: ""
    property string mChListFirstText: ""
    property string mChListSecondText: ""
    property string mChListThirdText: ""

    //****************************** # First Text Info #
    property string firstTextColor: colorInfo.blue
    property string firstTextPressColor: colorInfo.blue
    property string firstTextFocusPressColor: colorInfo.blue
    property string firstTextFocusSelectedColor: colorInfo.blue
    property string firstTextSelectedColor: colorInfo.blue

    property int firstTextX: 17
    property int firstTextY: idMGameZoneRightDelegate.height-(36+17)-(firstTextSize/2)
    property int firstTextWdith: 70
    property int firstTextHeight: 32
    property int firstTextSize: 32
    property string firstTextStyle: systemInfo.font_NewHDR

    //****************************** # Second Text Info #
    property string secondTextColor: colorInfo.dimmedGrey
    property string secondTextPressColor:  colorInfo.dimmedGrey
    property string secondTextFocusPressColor:  colorInfo.dimmedGrey
    property string secondTextFocusSelectedColor : colorInfo.dimmedGrey
    property string secondTextSelectedColor: colorInfo.dimmedGrey

    //****************************** # Third Text Info #
    property string thirdTextColor: colorInfo.brightGrey
    property string thirdTextPressColor:  colorInfo.brightGrey
    property string thirdTextFocusPressColor:  colorInfo.brightGrey
    property string thirdTextFocusSelectedColor : colorInfo.brightGrey
    property string thirdTextSelectedColor: colorInfo.blue

    //****************************** # Line Image Info #
    property int lineImgX: 10
    property int lineImgY: idMGameZoneRightDelegate.height
    property string lineImgSource: imageInfo.imgFolderGeneral+"line_menu_list.png"

    //****************************** # Default/Selected/Press Image #
    Image{
        id: normalImage
        x: 1; y: -3
        height: idMGameZoneRightDelegate.height+6
        source: bgImage
    }

    //****************************** # Focus Image #
    BorderImage {
        id: focusImage
        x: 1; y: -3
        height: idMGameZoneRightDelegate.height+6
        source: bgImageFocus;
        visible: {
            if((idMGameZoneRightDelegate.state=="keyPress") || (idMGameZoneRightDelegate.state=="pressed"))
                return false;
            return showFocus && idMGameZoneRightDelegate.activeFocus;
        }
    }

    //****************************** # Playing / PlayingStop Icon #
    AnimatedImage {
        id : idPlayIconImg
        x: 10+7; y: 108-23-54; //z: checkGameZonePlayingIconState() ? 1: 0
        anchors.verticalCenter: parent.verticalCenter
        source: playImage
        playing : true
        visible : checkGameZonePlayingIconState()
    }
    Image{
        id: idPlayStopIconImg
        x: 10+7; y: 108-23-54; //z: checkGameZonePlayingStopIconState() ? 1 : 0
        anchors.verticalCenter: parent.verticalCenter
        source: playStopImage
        visible : checkGameZonePlayingStopIconState()
    }

    //****************************** # Channel Number (FirstText) #
    Text{
        id: firstText
        text: mChListFirstText
        x: (checkGameZonePlayingIconState() || checkGameZonePlayingStopIconState()) ? 10+firstTextX+47 : 10+firstTextX
        y: firstTextY
        width: firstTextWdith; height: firstTextHeight
        font.pixelSize: firstTextSize
        font.family: firstTextStyle
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: firstTextColor
        elide: Text.ElideRight
    }

    //****************************** # Channel Artist (SecondText) #
    MComp.DDScrollTicker{
        id: secondText
        text: mChListSecondText
        x: (checkGameZonePlayingIconState() || checkGameZonePlayingStopIconState()) ? 10+17+70+28+47 : 10+17+70+28
        y: 107-73-(secondText.fontSize/2)-(secondText.fontSize/(3*2))
        width: (checkGameZonePlayingIconState() || checkGameZonePlayingStopIconState()) ? 372-47 : 372
        height: secondText.fontSize+(secondText.fontSize/3)
        fontSize: 28
        fontFamily: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: secondTextColor
        tickerFocus: (idMGameZoneRightDelegate.activeFocus && idAppMain.focusOn)
    }

    //****************************** # Channel Title (ThirdText) #
    MComp.DDScrollTicker{
        id: thirdText
        text: mChListThirdText
        x: (checkGameZonePlayingIconState() || checkGameZonePlayingStopIconState()) ? 10+17+70+28+47 : 10+17+70+28
        y: 107-36-(thirdText.fontSize/2)-(thirdText.fontSize/(3*2))
        width: (checkGameZonePlayingIconState() || checkGameZonePlayingStopIconState()) ? 372-47 : 372
        height: thirdText.fontSize+(thirdText.fontSize/3)
        fontSize: 32
        fontFamily: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: thirdTextColor
        tickerFocus: (idMGameZoneRightDelegate.activeFocus && idAppMain.focusOn)
    }

    //****************************** # Line Image #
    Image{
        x: lineImgX; y: lineImgY
        source: lineImgSource
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMGameZoneRightDelegate.ListView.view.flicking == false && idMGameZoneRightDelegate.ListView.view.moving == false)
            idMGameZoneRightDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(mChListFirstText == PLAYInfo.ChnNum) idMGameZoneRightDelegate.state = "selected";
        else if((mChListFirstText != PLAYInfo.ChnNum) && (index == idMGameZoneRightDelegate.ListView.view.currentIndex)) idMGameZoneRightDelegate.state = "selectedFocus";
        else idMGameZoneRightDelegate.state = "keyRelease";
    }
    onCancel:{
        if(mChListFirstText == PLAYInfo.ChnNum) idMGameZoneRightDelegate.state = "selected";
        else if((mChListFirstText != PLAYInfo.ChnNum) && (index == idMGameZoneRightDelegate.ListView.view.currentIndex)) idMGameZoneRightDelegate.state = "selectedFocus";
        else idMGameZoneRightDelegate.state = "keyRelease";
    }
    onCancelCCPPressed: {
        if(idMGameZoneRightDelegate.state == "keyPress")
        {
            if(mChListFirstText == PLAYInfo.ChnNum) idMGameZoneRightDelegate.state = "selected";
            else if((mChListFirstText != PLAYInfo.ChnNum) && (index == idMGameZoneRightDelegate.ListView.view.currentIndex)) idMGameZoneRightDelegate.state = "selectedFocus";
            else idMGameZoneRightDelegate.state = "keyRelease";
        }
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        sxm_gamezone_chnindex = index;
        setGameZoneChannel(mChListSecondText);
        idMGameZoneRightDelegate.ListView.view.currentIndex = index;
        idMGameZoneRightDelegate.ListView.view.focus = true;
        idMGameZoneRightDelegate.ListView.view.forceActiveFocus();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: idMGameZoneRightDelegate.activeFocus ? firstTextPressColor : (mChListFirstText == PLAYInfo.ChnNum) ? firstTextSelectedColor : firstTextPressColor;}
            PropertyChanges {target: secondText; color: idMGameZoneRightDelegate.activeFocus ? secondTextPressColor : (mChListFirstText == PLAYInfo.ChnNum) ? secondTextSelectedColor : secondTextPressColor;}
            PropertyChanges {target: thirdText; color: idMGameZoneRightDelegate.activeFocus ? thirdTextPressColor : (mChListFirstText == PLAYInfo.ChnNum) ? thirdTextSelectedColor : thirdTextPressColor;}
            PropertyChanges {target: firstText; font.family: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
            PropertyChanges {target: secondText; fontFamily: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
            PropertyChanges {target: thirdText; fontFamily: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'selected'; when: (mChListFirstText == PLAYInfo.ChnNum)
            PropertyChanges {target: firstText; color: (showFocus && idMGameZoneRightDelegate.activeFocus) ? firstTextFocusSelectedColor : firstTextSelectedColor;}
            PropertyChanges {target: secondText; color: (showFocus && idMGameZoneRightDelegate.activeFocus) ? secondTextFocusSelectedColor : secondTextSelectedColor;}
            PropertyChanges {target: thirdText; color: (showFocus && idMGameZoneRightDelegate.activeFocus) ? thirdTextFocusSelectedColor : thirdTextSelectedColor;}
            PropertyChanges {target: firstText; font.family: systemInfo.font_NewHDB;}
            PropertyChanges {target: secondText; fontFamily: systemInfo.font_NewHDB;}
            PropertyChanges {target: thirdText; fontFamily: systemInfo.font_NewHDB;}
        },
        State {
            name: 'selectedFocus'; when: ((mChListFirstText != PLAYInfo.ChnNum) && (index == idMGameZoneRightDelegate.ListView.view.currentIndex))
            PropertyChanges {target: firstText; color: idMGameZoneRightDelegate.activeFocus ? firstTextFocusSelectedColor : firstTextColor;}
            PropertyChanges {target: secondText; color: idMGameZoneRightDelegate.activeFocus ? secondTextFocusSelectedColor : secondTextColor;}
            PropertyChanges {target: thirdText; color: idMGameZoneRightDelegate.activeFocus ? thirdTextFocusSelectedColor : thirdTextColor;}
        },
        State {
            name: 'keyPress'; when: focusImage.active
            PropertyChanges {target: normalImage; source: bgImageFocusPress;}
            PropertyChanges {target: firstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: secondText; color: secondTextFocusPressColor;}
            PropertyChanges {target: thirdText; color: thirdTextFocusPressColor;}
            PropertyChanges {target: firstText; font.family: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
            PropertyChanges {target: secondText; fontFamily: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
            PropertyChanges {target: thirdText; fontFamily: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: firstTextColor;}
            PropertyChanges {target: secondText; color: secondTextColor;}
            PropertyChanges {target: thirdText; color: thirdTextColor;}
        }
    ]

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event))
            onGAMEZONEChannelListLeft();
        else if(idAppMain.isWheelRight(event))
            onGAMEZONEChannelListRight();
    }

    onTuneLeftKeyPressed: {
        if(idAppMain.state == "AppRadioGameZone" && !(UIListener.HandleGetShowPopupFlag() == true))
            onGAMEZONEChannelListLeft();
    }
    onTuneRightKeyPressed: {
        if(idAppMain.state == "AppRadioGameZone" && !(UIListener.HandleGetShowPopupFlag() == true))
            onGAMEZONEChannelListRight();
    }
    onTuneEnterKeyPressed: {
        if(idAppMain.state == "AppRadioGameZone" && !(UIListener.HandleGetShowPopupFlag() == true))
            setGameZoneChListTuneEnterKeyOperation();
    }

    function setGameZoneChListTuneEnterKeyOperation()
    {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        sxm_gamezone_chnindex = index;
        setGameZoneChannel(mChListSecondText);
        idMGameZoneRightDelegate.ListView.view.currentIndex = index;
        idMGameZoneRightDelegate.ListView.view.focus = true;
        idMGameZoneRightDelegate.ListView.view.forceActiveFocus();

        sxm_gamezone_curlist = "right";
        gGameZoneChnIndex =  sxm_gamezone_chnindex;

        idRadioGameZoneQml.setGameZoneClose();

        // System Popup check
        if(UIListener.HandleGetShowPopupFlag() == true)
        {
            UIListener.HandleSystemPopupClose();
        }

        XMOperation.setPreviousScanStop();
        setAppMainScreen("AppRadioMain", false);
        SPSeek.handleGameZoneChannelSelect(gGameZoneChnIndex);
    }

    function setGameZoneTuneEnterDelegate()
    {
        setGameZoneChListTuneEnterKeyOperation();
    }
    function setGameZoneTuneLeftDelegate()
    {
        onGAMEZONEChannelListLeft();
    }
    function setGameZoneTuneRightDelegate()
    {
        onGAMEZONEChannelListRight();
    }

    function checkGameZonePlayingIconState()
    {
        if(idRadioGameZone.visible == false) return false;

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
    function checkGameZonePlayingStopIconState()
    {
        if(idRadioGameZone.visible == false) return false;

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

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
    id: idMListRightDelegate
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
    property string firstTextFocusSelectedColor : colorInfo.blue
    property string firstTextSelectedColor: colorInfo.blue

    property string secondTextColor: colorInfo.brightGrey
    property string secondTextPressColor:  colorInfo.brightGrey
    property string secondTextFocusPressColor:  colorInfo.brightGrey
    property string secondTextFocusSelectedColor : colorInfo.brightGrey
    property string secondTextSelectedColor: colorInfo.blue

    property string mChListFirstText: ""
    property string mChListSecondText: ""
    property int    mChListThirdText: 0

    property bool bSeekPrevLongPressed : false
    property bool bSeekNextLongPressed : false

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
            if((idMListRightDelegate.state=="keyPress") || (idMListRightDelegate.state=="pressed"))
                return false;
            return showFocus && idMListRightDelegate.activeFocus;
        }
    }

    //****************************** # Playing / PlayingStop Icon #
    AnimatedImage {
        id : idPlayIconImg
        x: 10+7; y: 89-24-43; //z: checkListPlayingIconState() ? 1: 0
        anchors.verticalCenter: parent.verticalCenter
        source: playImage
        playing : true
        visible : checkListPlayingIconState()
    }
    Image{
        id: idPlayStopIconImg
        x: 10+7; y: 89-24-43; //z: checkListPlayingStopIconState() ? 1 : 0
        anchors.verticalCenter: parent.verticalCenter
        source: playStopImage
        visible : checkListPlayingStopIconState()
    }

    //****************************** # Channel Number (FirstText) #
    Text{
        id: firstText
        text: mChListFirstText
        x: (checkListPlayingIconState() || checkListPlayingStopIconState()) ? 10+7+7+47 : 10+14
        y: 89-43-(font.pixelSize/2)-(font.pixelSize/(3*2))
        width: 58; height: font.pixelSize+(font.pixelSize/3)
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: firstTextColor
    }

    //****************************** # Channel Name (SecondText) #
    MComp.DDScrollTicker{
        id: secondText
        text: mChListSecondText
        x: (checkListPlayingIconState() || checkListPlayingStopIconState()) ? 10+7+7+47+58+10 : 10+14+58+10
        y: 89-43-(secondText.fontSize/2)-(secondText.fontSize/(3*2))
        width: (checkListPlayingIconState() || checkListPlayingStopIconState()) ? (mChListThirdText ? 262 : 365) : (mChListThirdText ? 309 : 412)
        height: secondText.fontSize+(secondText.fontSize/3)
        fontSize: 32
        fontFamily: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: secondTextColor
        tickerFocus: (idMListRightDelegate.activeFocus && idAppMain.focusOn)
    }

    //****************************** # Skip Button #
    MComp.MButton{
        id: idSkipButton
        x: 10+401; y: 89-67
        focus: true
        buttonName: "Skip"
        width: 108; height: 49
        fgImage: imageInfo.imgFolderRadio_SXM+"bg_skip.png"
        fgImageWidth: 108; fgImageHeight: 49
        active: true
        visible: mChListThirdText ? true : false

        bPlayBeepFlag: false

        firstText: mChListThirdText ? stringInfo.sSTR_XMRADIO_SKIPPED : ""
        firstTextX: 5; firstTextY: 24
        firstTextWidth: 98
        firstTextSize: 20
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: mChListThirdText ? colorInfo.dimmedGrey : colorInfo.brightGrey
        firstTextPressColor: mChListThirdText ? colorInfo.dimmedGrey : colorInfo.brightGrey
        firstTextFocusPressColor: mChListThirdText ? colorInfo.dimmedGrey : colorInfo.brightGrey
        firstTextSelectedColor: mChListThirdText ? colorInfo.dimmedGrey : colorInfo.brightGrey
    }

    //****************************** # Line Image #
    Image{
        x: 10; y: idMListRightDelegate.height
        source: imageInfo.imgFolderGeneral+"line_menu_list.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMListRightDelegate.ListView.view.flicking == false && idMListRightDelegate.ListView.view.moving == false)
            idMListRightDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(mChListFirstText == PLAYInfo.ChnNum) idMListRightDelegate.state = "selected";
        else if((mChListFirstText != PLAYInfo.ChnNum) && (index == idMListRightDelegate.ListView.view.currentIndex)) idMListRightDelegate.state = "selectedFocus";
        else idMListRightDelegate.state = "keyRelease";
    }
    onCancel:{
        if(mChListFirstText == PLAYInfo.ChnNum) idMListRightDelegate.state = "selected";
        else if((mChListFirstText != PLAYInfo.ChnNum) && (index == idMListRightDelegate.ListView.view.currentIndex)) idMListRightDelegate.state = "selectedFocus";
        else idMListRightDelegate.state = "keyRelease";
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        sxm_list_chnindex = index;
        setListChannel(mChListSecondText);
        idMListRightDelegate.ListView.view.currentIndex = index;
        idMListRightDelegate.ListView.view.focus = true;
        idMListRightDelegate.ListView.view.forceActiveFocus();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: idMListRightDelegate.activeFocus ? firstTextPressColor : (mChListFirstText == PLAYInfo.ChnNum) ? firstTextSelectedColor : firstTextPressColor;}
            PropertyChanges {target: secondText; color: idMListRightDelegate.activeFocus ? secondTextPressColor : (mChListFirstText == PLAYInfo.ChnNum) ? secondTextSelectedColor : secondTextPressColor;}
            PropertyChanges {target: firstText; font.family: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
            PropertyChanges {target: secondText; fontFamily: (mChListFirstText == PLAYInfo.ChnNum) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'selected'; when: (mChListFirstText == PLAYInfo.ChnNum)
            PropertyChanges {target: firstText; color: (showFocus && idMListRightDelegate.activeFocus) ? firstTextFocusSelectedColor : firstTextSelectedColor;}
            PropertyChanges {target: secondText; color: (showFocus && idMListRightDelegate.activeFocus) ? secondTextFocusSelectedColor : secondTextSelectedColor;}
            PropertyChanges {target: firstText; font.family: systemInfo.font_NewHDB;}
            PropertyChanges {target: secondText; fontFamily: systemInfo.font_NewHDB;}
        },
        State {
            name: 'selectedFocus'; when: ((mChListFirstText != PLAYInfo.ChnNum) && (index == idMListRightDelegate.ListView.view.currentIndex))
            PropertyChanges {target: firstText; color: idMListRightDelegate.activeFocus? firstTextFocusSelectedColor : firstTextColor;}
            PropertyChanges {target: secondText; color: idMListRightDelegate.activeFocus? secondTextFocusSelectedColor : secondTextColor;}
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
            onLISTChannelListLeft();
        else if(idAppMain.isWheelRight(event))
            onLISTChannelListRight();
    }

    onTuneLeftKeyPressed: {
        if(!(UIListener.HandleGetShowPopupFlag() == true) && !(idAppMain.state == "PopupRadioWarning1Line"))
            onLISTChannelListLeft();
    }
    onTuneRightKeyPressed: {
        if(!(UIListener.HandleGetShowPopupFlag() == true) && !(idAppMain.state == "PopupRadioWarning1Line"))
            onLISTChannelListRight();
    }
    onTuneEnterKeyPressed: {
        if(!(UIListener.HandleGetShowPopupFlag() == true) && !(idAppMain.state == "PopupRadioWarning1Line"))
            setTuneEnterKeyOperation();
    }

    function setTuneEnterKeyOperation()
    {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        sxm_list_chnindex = index
        setListChannel(mChListSecondText)
        idMListRightDelegate.ListView.view.currentIndex = index
        idMListRightDelegate.ListView.view.focus = true
        idMListRightDelegate.ListView.view.forceActiveFocus()

        sxm_list_curlist = "right"
        gChannelIndex =  sxm_list_chnindex

        idRadioListQml.setListClose();

        // System Popup check
        if(UIListener.HandleGetShowPopupFlag() == true)
        {
            UIListener.HandleSystemPopupClose();
        }

        XMOperation.setPreviousScanStop();
        setAppMainScreen("AppRadioMain", false);
        UIListener.HandleChannelSelect(gChannelIndex);
    }

    function setTuneEnterDelegate()
    {
        setTuneEnterKeyOperation();
    }
    function setTuneLeftDelegate()
    {
        onLISTChannelListLeft();
    }
    function setTuneRightDelegate()
    {
        onLISTChannelListRight();
    }

    function checkListPlayingIconState()
    {
        if(idRadioList.visible == false) return false;

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
    function checkListPlayingStopIconState()
    {
        if(idRadioList.visible == false) return false;

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

/**
 * FileName: MGameActiveListDelegate.qml
 * Author: WSH
 * Time: 2013-07-25
 *
 * - 2013-07-25 Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MComponent {
    id: idMGameAcitveDelegate
    x: 0; y: 0
    width: 1246; height: 92

    //****************************** # Preperty #
    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderGeneral+"list_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderGeneral+"list_p.png"
    property string bgImageFocus: imageInfo.imgFolderGeneral+"list_f.png"

    //****************************** # First Text Info #
    property string firstTextColor: colorInfo.brightGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: colorInfo.brightGrey
    property string firstTextFocusSelectedColor: colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.blue

    property int firstTextX: 101
    property int firstTextY: idMGameAcitveDelegate.height-43-(firstTextSize/2)
    property int firstTextWdith: 694
    property int firstTextHeight: 43
    property int firstTextSize: 40
    property string firstTextStyle: systemInfo.font_NewHDB

    //****************************** # Second Text Info #
    property string secondTextColor: colorInfo.dimmedGrey
    property string secondTextPressColor: colorInfo.brightGrey
    property string secondTextFocusPressColor: colorInfo.brightGrey
    property string secondTextFocusSelectedColor: colorInfo.brightGrey
    property string secondTextSelectedColor: colorInfo.brightGrey

    property int secondTextX: firstTextX+firstTextWdith+26
    property int secondTextY: firstTextY
    property int secondTextWdith: 80
    property int secondTextHeight: 35
    property int secondTextSize: 32
    property string secondTextStyle: systemInfo.font_NewHDR

    //****************************** # Third Text Info #
    property string thirdTextColor: colorInfo.dimmedGrey
    property string thirdTextPressColor:  colorInfo.brightGrey
    property string thirdTextFocusPressColor:  colorInfo.brightGrey
    property string thirdTextFocusSelectedColor:  colorInfo.brightGrey
    property string thirdTextSelectedColor: colorInfo.brightGrey

    property int thirdTextX: secondTextX+secondTextWdith+26
    property int thirdTextY: firstTextY
    property int thirdTextWdith: 302
    property int thirdTextHeight: 35
    property int thirdTextSize: 32
    property string thirdTextStyle: systemInfo.font_NewHDR

    property string mChListFirstText: ""
    property string mChListSecondText: ""
    property string mChListThirdText: ""

    //****************************** # Default/Selected/Press Image #
    Image{
        id: normalImage
        x: 15; y: 0
        source: bgImage
    }

    //****************************** # Focus Image #
    BorderImage {
        id: focusImage
        x: 15; y: 0
        source: bgImageFocus;
        visible: {
            if((idMGameAcitveDelegate.state=="keyPress") || (idMGameAcitveDelegate.state=="pressed"))
                return false;
            return showFocus && idMGameAcitveDelegate.activeFocus;
        }
    }

    //****************************** # Index (FirstText) #
    MComp.DDScrollTicker{
        id: firstText
        text: mChListFirstText
        x: firstTextX; y: firstTextY-(firstText.fontSize/(3*2))
        width: firstTextWdith; height: firstText.fontSize+(firstText.fontSize/3)
        fontSize: firstTextSize
        fontFamily: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: firstTextColor
        tickerFocus: (idMGameAcitveDelegate.activeFocus && idAppMain.focusOn)
    }

    //****************************** # Index (SecondText) #
    Text{
        id: secondText
        text: mChListSecondText
        x: secondTextX; y: secondTextY
        width: secondTextWdith; height: secondTextHeight
        font.pixelSize: secondTextSize
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: secondTextColor
        elide: Text.ElideRight
    }

    //****************************** # Index (thirdTextText) #
    MComp.DDScrollTicker{
        id: thirdText
        text: mChListThirdText
        x: thirdTextX; y: thirdTextY-(thirdText.fontSize/(3*2))
        width: thirdTextWdith; height: thirdText.fontSize+(thirdText.fontSize/3)
        fontSize: thirdTextSize
        fontFamily: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: thirdTextColor
        tickerFocus: (idMGameAcitveDelegate.activeFocus && idAppMain.focusOn)
    }

    //****************************** # Line Image #
    Image{
        x: 0; y: idMGameAcitveDelegate.height
        source: imageInfo.imgFolderGeneral+"list_line.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMGameAcitveDelegate.ListView.view.flicking == false && idMGameAcitveDelegate.ListView.view.moving == false)
            idMGameAcitveDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(mChListThirdText == PLAYInfo.ChnName) idMGameAcitveDelegate.state = "selected";
        else if((mChListThirdText != PLAYInfo.ChnName) && (index == idMGameAcitveDelegate.ListView.view.currentIndex)) idMGameAcitveDelegate.state = "selectedFocus";
        else idMGameAcitveDelegate.state = "keyRelease";
    }
    onCancel:{
        if(mChListThirdText == PLAYInfo.ChnName) idMGameAcitveDelegate.state = "selected";
        else if((mChListThirdText != PLAYInfo.ChnName) && (index == idMGameAcitveDelegate.ListView.view.currentIndex)) idMGameAcitveDelegate.state = "selectedFocus";
        else idMGameAcitveDelegate.state = "keyRelease";
    }
    onCancelCCPPressed: {
        if(idMGameAcitveDelegate.state == "keyPress")
        {
            if(mChListThirdText == PLAYInfo.ChnName) idMGameAcitveDelegate.state = "selected";
            else if((mChListThirdText != PLAYInfo.ChnName) && (index == idMGameAcitveDelegate.ListView.view.currentIndex)) idMGameAcitveDelegate.state = "selectedFocus";
            else idMGameAcitveDelegate.state = "keyRelease";
        }
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        selectedAcitveItem = index;
        idMGameAcitveDelegate.ListView.view.currentIndex = index;
        idMGameAcitveDelegate.ListView.view.focus = true;
        idMGameAcitveDelegate.ListView.view.forceActiveFocus();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: idMGameAcitveDelegate.activeFocus ? firstTextPressColor : (mChListThirdText == PLAYInfo.ChnName) ? firstTextSelectedColor : firstTextPressColor;}
            PropertyChanges {target: secondText; color: idMGameAcitveDelegate.activeFocus ? secondTextPressColor : (mChListThirdText == PLAYInfo.ChnName) ? secondTextSelectedColor : secondTextPressColor;}
            PropertyChanges {target: thirdText; color: idMGameAcitveDelegate.activeFocus ? thirdTextPressColor : (mChListThirdText == PLAYInfo.ChnName) ? thirdTextSelectedColor : thirdTextPressColor;}
            PropertyChanges {target: firstText; fontFamily: (mChListThirdText == PLAYInfo.ChnName) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'selected'; when: (mChListThirdText == PLAYInfo.ChnName)
            PropertyChanges {target: firstText; color: (showFocus && idMGameAcitveDelegate.activeFocus) ? firstTextFocusSelectedColor : firstTextSelectedColor}
            PropertyChanges {target: secondText; color: (showFocus && idMGameAcitveDelegate.activeFocus) ? secondTextFocusSelectedColor : secondTextColor}
            PropertyChanges {target: thirdText; color: (showFocus && idMGameAcitveDelegate.activeFocus) ? thirdTextFocusSelectedColor : thirdTextColor}
            PropertyChanges {target: firstText; fontFamily: systemInfo.font_NewHDB;}
        },
        State {
            name: 'selectedFocus'; when: ((mChListThirdText != PLAYInfo.ChnName) && (index == idMGameAcitveDelegate.ListView.view.currentIndex))
            PropertyChanges {target: firstText; color: idMGameAcitveDelegate.activeFocus ? firstTextFocusSelectedColor : firstTextColor}
            PropertyChanges {target: secondText; color: idMGameAcitveDelegate.activeFocus ? secondTextFocusSelectedColor : secondTextColor}
            PropertyChanges {target: thirdText; color: idMGameAcitveDelegate.activeFocus ? thirdTextFocusSelectedColor : thirdTextColor}
        },
        State {
            name: 'keyPress'; when: focusImage.active
            PropertyChanges {target: normalImage; source: bgImageFocusPress;}
            PropertyChanges {target: firstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: secondText; color: secondTextFocusPressColor;}
            PropertyChanges {target: thirdText; color: thirdTextFocusPressColor;}
            PropertyChanges {target: firstText; fontFamily: (mChListThirdText == PLAYInfo.ChnName) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: firstTextColor;}
            PropertyChanges {target: secondText; color: secondTextColor;}
            PropertyChanges {target: thirdText; color: thirdTextColor;}
        }
    ]

    //****************************** # Wheel (CCP) #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event))
            onGAMEActiveListLeft();
        else if(idAppMain.isWheelRight(event))
            onGAMEActiveListRight();
    }

    //****************************** # Tune knob #
    onTuneLeftKeyPressed: {
        if(idAppMain.state == "AppRadioGameActive" && !(UIListener.HandleGetShowPopupFlag() == true))
            onGAMEActiveListLeft();
    }
    onTuneRightKeyPressed: {
        if(idAppMain.state == "AppRadioGameActive" && !(UIListener.HandleGetShowPopupFlag() == true))
            onGAMEActiveListRight();
    }
    onTuneEnterKeyPressed: {
        if(idAppMain.state == "AppRadioGameActive" && !(UIListener.HandleGetShowPopupFlag() == true))
            onGAMEActiveListTuneEnterKeyOperation();
    }

    //****************************** # Function #
    function onGAMEActiveListTuneEnterKeyOperation(){
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        selectedAcitveItem = index;
        idMGameAcitveDelegate.ListView.view.currentIndex = index;
        idMGameAcitveDelegate.ListView.view.focus = true;
        idMGameAcitveDelegate.ListView.view.forceActiveFocus();

        idRadioGameActiveQml.setGameActiveClose();

        // System Popup check
        if(UIListener.HandleGetShowPopupFlag() == true)
        {
            UIListener.HandleSystemPopupClose();
        }

        XMOperation.setPreviousScanStop();
        setAppMainScreen("AppRadioMain", false);
        SPSeek.handleSPSeekChannelSelect(selectedAcitveItem);
    }
}

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
    id: idMEPGLeftDelegate
    x: 0; y: 0
    width: 585; height: 89

    //****************************** # Preperty #
    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderGeneral+"bg_menu_tab_l_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderGeneral+"bg_menu_tab_l_p.png"
    property string bgImageFocus: imageInfo.imgFolderGeneral+"bg_menu_tab_l_f.png"

    property string firstTextColor: colorInfo.dimmedGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: colorInfo.brightGrey
    property string firstTextFocusSelectedColor : colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.blue
    property string firstTextDisableColor: colorInfo.disableGrey

    property string secondTextColor: colorInfo.brightGrey
    property string secondTextPressColor:  colorInfo.brightGrey
    property string secondTextFocusPressColor:  colorInfo.brightGrey
    property string secondTextFocusSelectedColor : colorInfo.brightGrey
    property string secondTextSelectedColor: colorInfo.blue
    property string secondTextDisableColor: colorInfo.disableGrey

    property string mChListFirstText: ""
    property string mChListSecondText: ""
    property bool mChListThirdText: true

    //****************************** # Default/Selected/Press Image #
    Image{
        id: normalImage
        x: 43-9; y: -3
        source: bgImage
    }

    //****************************** # Focus Image #
    BorderImage {
        id: focusImage
        x: 43-9; y: -3
        source: bgImageFocus;
        visible: {
            if((idMEPGLeftDelegate.state=="keyPress") || (idMEPGLeftDelegate.state=="pressed"))
                return false;
            return showFocus && idMEPGLeftDelegate.activeFocus;
        }
    }

    //****************************** # Index (FirstText) #
    Text{
        id: firstText
        text: mChListFirstText
        x: 43+14; y: 89-45-(font.pixelSize/2)
        width: 70; height: 43
        font.pixelSize: 40
        font.family: systemInfo.font_NewHDB
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: (mChListThirdText == false) ? firstTextDisableColor : firstTextColor
        //elide: Text.ElideRight
    }

    //****************************** # Index (SecondText) #
    Text{
        id: secondText
        text: mChListSecondText
        x: 43+14+70+10; y: 89-45-(font.pixelSize/2)
        width: 399; height: 43
        font.pixelSize: 40
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: (mChListThirdText == false) ? secondTextDisableColor : secondTextColor
    }

    //****************************** # Line Image #
    Image{
        x: 43; y: idMEPGLeftDelegate.height
        source: imageInfo.imgFolderGeneral+"line_menu_list.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMEPGLeftDelegate.ListView.view.flicking == false && idMEPGLeftDelegate.ListView.view.moving == false)
            idMEPGLeftDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(mChListSecondText == sxm_epg_curchn) idMEPGLeftDelegate.state = "selected";
        else if((index == 0) && (sxm_epg_curchn == "")) idMEPGLeftDelegate.state = "selected";
        else idMEPGLeftDelegate.state = "keyRelease";
    }
    onCancel:{
        if(mChListSecondText == sxm_epg_curchn) idMEPGLeftDelegate.state = "selected";
        else if((index == 0) && (sxm_epg_curchn == "")) idMEPGLeftDelegate.state = "selected";
        else idMEPGLeftDelegate.state = "keyRelease";
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        changeEPGChannelTimer.stop();
        if(index != sxm_epg_chnindex)
        {
            idMEPGLeftDelegate.ListView.view.currentIndex = index;
            idMEPGLeftDelegate.ListView.view.focus = true;
            changeEPGChannelList(index);
            initEPGMainFocusPosition(false);
        }
        else
        {
            setForceFocusToProgram();
        }
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: idEPGChannelListView.activeFocus ? firstTextPressColor : ((mChListSecondText == sxm_epg_curchn) || ((index == 0) && (sxm_epg_curchn == ""))) ? firstTextSelectedColor : firstTextPressColor;}
            PropertyChanges {target: secondText; color: idEPGChannelListView.activeFocus ? secondTextPressColor : ((mChListSecondText == sxm_epg_curchn) || ((index == 0) && (sxm_epg_curchn == ""))) ? secondTextSelectedColor : secondTextPressColor;}
            PropertyChanges {target: secondText; font.family: idMEPGLeftDelegate.activeFocus ? systemInfo.font_NewHDR : (mChListSecondText == sxm_epg_curchn) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'selected'; when: (mChListSecondText == sxm_epg_curchn) || ((index == 0) && (sxm_epg_curchn == ""))
            PropertyChanges {target: firstText; color: (showFocus && idEPGChannelListView.activeFocus) ? firstTextFocusSelectedColor : firstTextSelectedColor;}
            PropertyChanges {target: secondText; color: (showFocus && idEPGChannelListView.activeFocus) ? secondTextFocusSelectedColor : secondTextSelectedColor;}
            PropertyChanges {target: secondText; font.family: idEPGChannelListView.activeFocus ? systemInfo.font_NewHDR : systemInfo.font_NewHDB;}
        },
        State {
            name: 'keyPress'; when: focusImage.active
            PropertyChanges {target: normalImage; source: bgImageFocusPress;}
            PropertyChanges {target: firstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: secondText; color: secondTextFocusPressColor;}
            PropertyChanges {target: secondText; font.family: systemInfo.font_NewHDR}
        },
        State {
            name: 'keyReleaseWheel';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: (mChListThirdText == false) ? firstTextDisableColor : firstTextColor;}
            PropertyChanges {target: secondText; color: (mChListThirdText == false) ? secondTextDisableColor : secondTextColor;}
            PropertyChanges {target: secondText; font.family: systemInfo.font_NewHDR}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: (mChListThirdText == false) ? firstTextDisableColor : firstTextColor;}
            PropertyChanges {target: secondText; color: (mChListThirdText == false) ? secondTextDisableColor : secondTextColor;}
            PropertyChanges {target: secondText; font.family: systemInfo.font_NewHDR}
        }
    ]

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event)) {
            idMEPGLeftDelegate.state = "keyReleaseWheel";
            onEPGChannelListLeft(index);
        }
        else if(idAppMain.isWheelRight(event)) {
            idMEPGLeftDelegate.state = "keyReleaseWheel";
            onEPGChannelListRight(index);
        }
    }
}

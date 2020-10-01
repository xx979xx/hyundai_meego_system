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
    id: idMGameZoneLeftDelegate
    x: 0; y: 0
    width: 585; height: 107

    //****************************** # Preperty #
    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderRadio_Dab+"list_dab_epg_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderRadio_Dab+"list_dab_epg_p.png"
    property string bgImageFocus: imageInfo.imgFolderRadio_Dab+"list_dab_epg_f.png"

    property string mChListFirstText: ""

    //****************************** # First Text Info #
    property string firstTextColor: colorInfo.brightGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: colorInfo.brightGrey
    property string firstTextFocusSelectedColor : colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.blue

    property int firstTextX: 43+14
    property int firstTextY: idMGameZoneLeftDelegate.height/2-(firstTextSize/2)
    property int firstTextWdith: 479
    property int firstTextHeight: 40
    property int firstTextSize: 40

    //****************************** # Line Image Info #
    property int lineImgX: 43
    property int lineImgY: idMGameZoneLeftDelegate.height
    property string lineImgSource: imageInfo.imgFolderGeneral+"line_menu_list.png"

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
        height: 112
        source: bgImageFocus;
        visible: {
            if((idMGameZoneLeftDelegate.state=="keyPress") || (idMGameZoneLeftDelegate.state=="pressed"))
                return false;
            return showFocus && idMGameZoneLeftDelegate.activeFocus;
        }
    }

    //****************************** # Index (FirstText) #
    Text{
        id: firstText
        text: mChListFirstText
        x: firstTextX; y: firstTextY
        width: firstTextWdith; height: firstTextHeight
        font.pixelSize: firstTextSize
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: (idMGameZoneLeftDelegate.activeFocus)? firstTextColor : (index == gGameZoneCatIndex)? firstTextSelectedColor : firstTextColor
        elide: Text.ElideRight
    }

    //****************************** # Line Image #
    Image{
        x: lineImgX; y: lineImgY
        source: lineImgSource
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMGameZoneLeftDelegate.ListView.view.flicking == false && idMGameZoneLeftDelegate.ListView.view.moving == false)
            idMGameZoneLeftDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(mChListFirstText == sxm_gamezone_currcat) idMGameZoneLeftDelegate.state = "selected";
        else idMGameZoneLeftDelegate.state = "keyRelease";
    }
    onCancel:{
        if(mChListFirstText == sxm_gamezone_currcat) idMGameZoneLeftDelegate.state = "selected";
        else idMGameZoneLeftDelegate.state = "keyRelease";
    }
    onCancelCCPPressed: {
        if(idMGameZoneLeftDelegate.state == "keyPress")
        {
            if(mChListFirstText == sxm_gamezone_currcat) idMGameZoneLeftDelegate.state = "selected";
            else idMGameZoneLeftDelegate.state = "keyRelease";
        }
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        changeGameZoneCategoryTimer.stop();
        if(index != sxm_gamezone_catindex)
        {
            sxm_gamezone_catindex = index;
            idMGameZoneLeftDelegate.ListView.view.currentIndex = index;
            idMGameZoneLeftDelegate.ListView.view.focus = true;

            changeGameZoneCateogy(index);
        }
        changeFocusToChannelList();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: idMGameZoneLeftDelegate.activeFocus ? firstTextPressColor : (mChListFirstText == sxm_gamezone_currcat) ? firstTextSelectedColor : firstTextPressColor;}
            PropertyChanges {target: firstText; font.family: idMGameZoneLeftDelegate.activeFocus ? systemInfo.font_NewHDR : (mChListFirstText == sxm_gamezone_currcat) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'selected'; when: (mChListFirstText == sxm_gamezone_currcat)
            PropertyChanges {target: firstText; color: (showFocus && idGAMEZONECategoryListView.activeFocus) ? firstTextFocusSelectedColor : firstTextSelectedColor;}
            PropertyChanges {target: firstText; font.family: (showFocus && idGAMEZONECategoryListView.activeFocus) ? systemInfo.font_NewHDR : systemInfo.font_NewHDB;}
        },
        State {
            name: 'keyPress'; when: focusImage.active
            PropertyChanges {target: normalImage; source: bgImageFocusPress;}
            PropertyChanges {target: firstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: firstText; font.family: systemInfo.font_NewHDR}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: firstTextColor;}
            PropertyChanges {target: firstText; font.family: systemInfo.font_NewHDR}
        }
    ]

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event))
            onGAMEZONECategoryListLeft(index);
        else if(idAppMain.isWheelRight(event))
            onGAMEZONECategoryListRight(index);
    }

    onTuneLeftKeyPressed: {
        if(changeGameZoneCategoryTimer.running == true || (idMGameZoneLeftDelegate.ListView.view.flicking == true || idMGameZoneLeftDelegate.ListView.view.moving == true))
        {
            return;
        }

        if(idMGameZoneLeftDelegate.ListView.view.activeFocus)
        {
            if(idAppMain.state == "AppRadioGameZone" && !(UIListener.HandleGetShowPopupFlag() == true))
            {
                changeFocusToChannelList();
            }
        }
    }
    onTuneRightKeyPressed: {
        if(changeGameZoneCategoryTimer.running == true || (idMGameZoneLeftDelegate.ListView.view.flicking == true || idMGameZoneLeftDelegate.ListView.view.moving == true))
        {
            return;
        }

        if(idMGameZoneLeftDelegate.ListView.view.activeFocus)
        {
            if(idAppMain.state == "AppRadioGameZone" && !(UIListener.HandleGetShowPopupFlag() == true))
            {
                changeFocusToChannelList();
            }
        }
    }
}

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
    id: idMFFListLeftDelegate
    x: 0; y: 0
    width: 585; height: 89

    //****************************** # Preperty #
    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderGeneral+"bg_menu_tab_l_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderGeneral+"bg_menu_tab_l_p.png"
    property string bgImageFocus: imageInfo.imgFolderGeneral+"bg_menu_tab_l_f.png"

    property string firstTextColor: colorInfo.brightGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: colorInfo.brightGrey
    property string firstTextFocusSelectedColor: colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.blue

    property string mChListFirstText: ""

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
            if((idMFFListLeftDelegate.state=="keyPress") || (idMFFListLeftDelegate.state=="pressed"))
                return false;
            return showFocus && idMFFListLeftDelegate.activeFocus;
        }
    }

    //****************************** # Index (FirstText) #
    Text{
        id: firstText
        text: mChListFirstText
        x: 43+12; y: 89-42-(font.pixelSize/2)
        width: 479; height: 43
        font.pixelSize: 40
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: firstTextColor
        elide: Text.ElideRight
    }

    //****************************** # Line Image #
    Image{
        x: 43; y: idMFFListLeftDelegate.height
        source: imageInfo.imgFolderGeneral+"line_menu_list.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMFFListLeftDelegate.ListView.view.flicking == false && idMFFListLeftDelegate.ListView.view.moving == false)
            idMFFListLeftDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(index == sxm_ffavorites_bandindex) idMFFListLeftDelegate.state = "selected";
        else idMFFListLeftDelegate.state = "keyRelease";
    }
    onCancel:{
        if(index == sxm_ffavorites_bandindex) idMFFListLeftDelegate.state = "selected";
        else idMFFListLeftDelegate.state = "keyRelease";
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        changeFeaturedFavoritesBandTimer.stop();
        if(index != sxm_ffavorites_bandindex)
        {
            idMFFListLeftDelegate.ListView.view.currentIndex = index;
            idMFFListLeftDelegate.ListView.view.focus = true;

            changeFFBandList(index, true);
        }
        changeFocusToContList();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: idMFFListLeftDelegate.activeFocus ? firstTextPressColor : (index == sxm_ffavorites_bandindex) ? firstTextSelectedColor : firstTextPressColor;}
            PropertyChanges {target: firstText; font.family: idMFFListLeftDelegate.activeFocus ? systemInfo.font_NewHDR : (index == sxm_ffavorites_bandindex) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'selected'; when: (index == sxm_ffavorites_bandindex)
            PropertyChanges {target: firstText; color: (showFocus && idFFBandListView.activeFocus) ? firstTextFocusSelectedColor : firstTextSelectedColor;}
            PropertyChanges {target: firstText; font.family: (showFocus && idFFBandListView.activeFocus) ? systemInfo.font_NewHDR : systemInfo.font_NewHDB;}
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
            onFFBandListLeft(index);
        else if(idAppMain.isWheelRight(event))
            onFFBandListRight(index);
    }

    onTuneLeftKeyPressed: {
        if(changeFeaturedFavoritesBandTimer.running == true || (idMFFListLeftDelegate.ListView.view.flicking == true || idMFFListLeftDelegate.ListView.view.moving == true))
        {
            return;
        }

        if(idMFFListLeftDelegate.ListView.view.activeFocus)
        {
            if(idAppMain.state == "AppRadioFeaturedFavorites" && !(UIListener.HandleGetShowPopupFlag() == true))
            {
                changeFocusToContList();
            }
        }
    }
    onTuneRightKeyPressed: {
        if(changeFeaturedFavoritesBandTimer.running == true || (idMFFListLeftDelegate.ListView.view.flicking == true || idMFFListLeftDelegate.ListView.view.moving == true))
        {
            return;
        }

        if(idMFFListLeftDelegate.ListView.view.activeFocus)
        {
            if(idAppMain.state == "AppRadioFeaturedFavorites" && !(UIListener.HandleGetShowPopupFlag() == true))
            {
                changeFocusToContList();
            }
        }
    }
}

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
    id: idMListLeftDelegate
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
    property string firstTextFocusSelectedColor : colorInfo.brightGrey
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
            if((idMListLeftDelegate.state=="keyPress") || (idMListLeftDelegate.state=="pressed"))
                return false;
            return showFocus && idMListLeftDelegate.activeFocus;
        }
    }

    //****************************** # Index (FirstText) #
    Text{
        id: firstText
        text: mChListFirstText
        x: 43+12; y: 89-45-(font.pixelSize/2)
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
        x: 43; y: idMListLeftDelegate.height
        source: imageInfo.imgFolderGeneral+"line_menu_list.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMListLeftDelegate.ListView.view.flicking == false && idMListLeftDelegate.ListView.view.moving == false)
            idMListLeftDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(mChListFirstText == idAppMain.sxm_list_currcat) idMListLeftDelegate.state = "selected";
        else idMListLeftDelegate.state = "keyRelease";
    }
    onCancel:{
        if(mChListFirstText == idAppMain.sxm_list_currcat) idMListLeftDelegate.state = "selected";
        else idMListLeftDelegate.state = "keyRelease";
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        changeListCategoryTimer.stop();
        if(index != sxm_list_catindex)
        {
            idMListLeftDelegate.ListView.view.currentIndex = index;
            idMListLeftDelegate.ListView.view.focus = true;

            changeChannelListCategory(index);
        }
        setListForceFocusChannelList();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: idMListLeftDelegate.activeFocus ? firstTextPressColor : (mChListFirstText == idAppMain.sxm_list_currcat) ? firstTextSelectedColor : firstTextPressColor;}
            PropertyChanges {target: firstText; font.family: idMListLeftDelegate.activeFocus ? systemInfo.font_NewHDR : (mChListFirstText == idAppMain.sxm_list_currcat) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;} // WSH(131104)
        },
        State {
            name: 'selected'; when: (mChListFirstText == idAppMain.sxm_list_currcat)
            PropertyChanges {target: firstText; color:  (showFocus && idLISTCategoryListView.activeFocus) ? firstTextFocusSelectedColor : firstTextSelectedColor;}
            PropertyChanges {target: firstText; font.family: (showFocus && idLISTCategoryListView.activeFocus) ? systemInfo.font_NewHDR : systemInfo.font_NewHDB;}
        },
        State {
            name: 'keyPress'; when: focusImage.active
            PropertyChanges {target: normalImage; source: bgImageFocusPress;}
            PropertyChanges {target: firstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: firstText; font.family: systemInfo.font_NewHDR;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: firstTextColor;}
            PropertyChanges {target: firstText; font.family: systemInfo.font_NewHDR;}
        }
    ]

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event))
            onLISTCategoryListLeft(index);
        else if(idAppMain.isWheelRight(event))
            onLISTCategoryListRight(index);
    }

    onTuneLeftKeyPressed: {
        if(changeListCategoryTimer.running == true || (idMListLeftDelegate.ListView.view.flicking == true || idMListLeftDelegate.ListView.view.moving == true))
        {
            return;
        }

        if(idMListLeftDelegate.ListView.view.activeFocus)
        {
            if(!(UIListener.HandleGetShowPopupFlag() == true) && !(idAppMain.state == "PopupRadioWarning1Line"))
            {
                setListForceFocusChannelList();
            }
        }
    }
    onTuneRightKeyPressed: {
        if(changeListCategoryTimer.running == true || (idMListLeftDelegate.ListView.view.flicking == true || idMListLeftDelegate.ListView.view.moving == true))
        {
            return;
        }

        if(idMListLeftDelegate.ListView.view.activeFocus)
        {
            if(!(UIListener.HandleGetShowPopupFlag() == true) && !(idAppMain.state == "PopupRadioWarning1Line"))
            {
                setListForceFocusChannelList();
            }
        }
    }
}

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
    id: idMEPGCategoryDelegate
    x: 0; y: 0
    width: 1246; height: 92

    //****************************** # Preperty #
    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderGeneral+"list_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderGeneral+"list_p.png"
    property string bgImageFocus: imageInfo.imgFolderGeneral+"list_f.png"

    property string firstTextColor: colorInfo.brightGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: colorInfo.brightGrey
    property string firstTextFocusSelectedColor: colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.blue

    property string mChListFirstText: ""

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
            if((idMEPGCategoryDelegate.state=="keyPress") || (idMEPGCategoryDelegate.state=="pressed"))
                return false;
            return showFocus && idMEPGCategoryDelegate.activeFocus;
        }
    }

    //****************************** # Index (FirstText) #
    Text{
        id: firstText
        text: mChListFirstText
        x: 101; y: 90-44-(font.pixelSize/2)
        width: 1070; height: 43
        font.pixelSize: 40
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: (showFocus && idMEPGCategoryDelegate.activeFocus) ? colorInfo.brightGrey : firstTextColor
        elide: Text.ElideRight
    }

    //****************************** # Line Image #
    Image{
        x: 0; y: idMEPGCategoryDelegate.height
        source: imageInfo.imgFolderGeneral+"list_line.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMEPGCategoryDelegate.ListView.view.flicking == false && idMEPGCategoryDelegate.ListView.view.moving == false)
            idMEPGCategoryDelegate.state = "pressed";
    }
    onSelectKeyReleased: {
        idMEPGCategoryDelegate.state = "keyRelease";
    }
    onCancel:{
        idMEPGCategoryDelegate.state = "keyRelease";
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        selectedEPGCatItem = index;
        setEPGCategory(mChListFirstText);
        idMEPGCategoryDelegate.ListView.view.currentIndex = index;
        idMEPGCategoryDelegate.ListView.view.focus = true;
        idMEPGCategoryDelegate.ListView.view.forceActiveFocus();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: firstTextPressColor;}
        },
        State {
            name: 'keyPress'; when: focusImage.active
            PropertyChanges {target: normalImage; source: bgImageFocusPress;}
            PropertyChanges {target: firstText; color: firstTextFocusPressColor;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: idMEPGCategoryDelegate.activeFocus ? firstTextFocusPressColor : firstTextColor;}
        }
    ]

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event))
            onEPGCategoryListLeft(index);
        else if(idAppMain.isWheelRight(event))
            onEPGChannelListRight(index);
    }
}

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
    id: idMSetTeamRightDelegate
    x: 0; y: 0
    width: 585; height: 89

    //****************************** # Preperty #
    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderGeneral+"bg_menu_tab_r_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderGeneral+"bg_menu_tab_r_p.png"
    property string bgImageFocus: imageInfo.imgFolderGeneral+"bg_menu_tab_r_f.png"

    property string firstTextColor: colorInfo.brightGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: colorInfo.brightGrey
    property string firstTextFocusSelectedColor : colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.blue

    property string mChListFirstText: ""
    property bool   bChListSecondText: false

    //****************************** # Line Image Info #
    property int lineImgX: 10
    property int lineImgY: idMSetTeamRightDelegate.height
    property string lineImgSource: imageInfo.imgFolderGeneral+"line_menu_list.png"

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
            if((idMSetTeamRightDelegate.state=="keyPress") || (idMSetTeamRightDelegate.state=="pressed"))
                return false;
            return showFocus && idMSetTeamRightDelegate.activeFocus;
        }
    }

    //****************************** # Index (FirstText) #
    MComp.DDScrollTicker{
        id: firstText
        x: 10+20; y: 89-42-(firstText.fontSize/2)-(firstText.fontSize/(3*2))
        width: 453; height: firstText.fontSize+(firstText.fontSize/3)
        text: mChListFirstText
        fontFamily : systemInfo.font_NewHDR
        fontSize: 40
        color: (showFocus && idMSetTeamRightDelegate.activeFocus) ? firstTextFocusSelectedColor : firstTextColor
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerFocus: (idMSetTeamRightDelegate.activeFocus && idAppMain.focusOn)
    }

    //****************************** # Check Box #
    MComp.MCheckBox {
        id: idSetTeamTeamcheck
        x: 10+20+453; y: 20
        visible: true
        state: (bChListSecondText == true) ? "on" : "off"
        notUsedCheckBox: true

        Item {
            id: idCheckBoxImage
            anchors.verticalCenter: parent.verticalCenter
            Image {
                id: checkImageOff
                source: imageInfo.imgFolderGeneral+"checkbox_uncheck.png"
                visible: (idSetTeamTeamcheck.state == "off")
            }
            Image {
                id: checkImageOn
                source: imageInfo.imgFolderGeneral+"checkbox_check.png"
                visible: (idSetTeamTeamcheck.state == "on")
            }
        }
    }

    //****************************** # Line Image #
    Image{
        x: lineImgX; y: lineImgY
        source: lineImgSource
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMSetTeamRightDelegate.ListView.view.flicking == false && idMSetTeamRightDelegate.ListView.view.moving == false)
            idMSetTeamRightDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(index == idMSetTeamRightDelegate.ListView.view.currentIndex) idMSetTeamRightDelegate.state = "selected";
        else idMSetTeamRightDelegate.state = "keyRelease";
    }
    onCancel:{
        if(index == idMSetTeamRightDelegate.ListView.view.currentIndex) idMSetTeamRightDelegate.state = "selected";
        else idMSetTeamRightDelegate.state = "keyRelease";
    }
    onCancelCCPPressed: {
        if(idMSetTeamRightDelegate.state == "keyPress")
        {
            if(index == idMSetTeamRightDelegate.ListView.view.currentIndex) idMSetTeamRightDelegate.state = "selected";
            else idMSetTeamRightDelegate.state = "keyRelease";
        }
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        sxm_setteam_teamindex = index;
        idMSetTeamRightDelegate.ListView.view.currentIndex = index;
        idMSetTeamRightDelegate.ListView.view.focus = true;
        idMSetTeamRightDelegate.ListView.view.forceActiveFocus();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: idMSetTeamRightDelegate.activeFocus ? firstTextPressColor : (index == idMSetTeamRightDelegate.ListView.view.currentIndex) ? firstTextPressColor : firstTextPressColor;}
        },
        State {
            name: 'selected'; when: (index == idMSetTeamRightDelegate.ListView.view.currentIndex)
            PropertyChanges {target: firstText; color: (showFocus && idMSetTeamRightDelegate.activeFocus) ? firstTextFocusSelectedColor : firstTextColor;}
        },
        State {
            name: 'keyPress'; when: focusImage.active
            PropertyChanges {target: normalImage; source: bgImageFocusPress;}
            PropertyChanges {target: firstText; color: firstTextFocusPressColor;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: firstTextColor;}
        }
    ]

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event))
            onSETEAMTeamListLeft(index);
        else if(idAppMain.isWheelRight(event))
            onSETTEAMTeamListRight(index);
    }
}

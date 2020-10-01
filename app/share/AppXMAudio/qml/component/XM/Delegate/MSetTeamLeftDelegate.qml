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
    id: idMSetTeamLeftDelegate
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

    property int firstTextX: 43+14
    property int firstTextY: idMSetTeamLeftDelegate.height-43-(firstTextSize/2)
    property int firstTextWdith: 479
    property int firstTextHeight: 43
    property int firstTextSize: 40

    property string mChListFirstText: ""
    property bool   bChListSecondText: false

    //****************************** # Line Image Info #
    property int lineImgX: 43
    property int lineImgY: idMSetTeamLeftDelegate.height
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
        source: bgImageFocus;
        visible: {
            if((idMSetTeamLeftDelegate.state=="keyPress") || (idMSetTeamLeftDelegate.state=="pressed"))
                return false;
            return showFocus && idMSetTeamLeftDelegate.activeFocus;
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
        color: firstTextColor
        elide: Text.ElideRight
    }

    //****************************** # Line Image #
    Image{
        x: lineImgX; y: lineImgY
        source: lineImgSource
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMSetTeamLeftDelegate.ListView.view.flicking == false && idMSetTeamLeftDelegate.ListView.view.moving == false)
            idMSetTeamLeftDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(index == sxm_setteam_leagueindex) idMSetTeamLeftDelegate.state = "selected";
        else idMSetTeamLeftDelegate.state = "keyRelease";
    }
    onCancel:{
        if(index == sxm_setteam_leagueindex) idMSetTeamLeftDelegate.state = "selected";
        else idMSetTeamLeftDelegate.state = "keyRelease";
    }
    onCancelCCPPressed: {
        if(idMSetTeamLeftDelegate.state == "keyPress")
        {
            if(index == sxm_setteam_leagueindex) idMSetTeamLeftDelegate.state = "selected";
            else idMSetTeamLeftDelegate.state = "keyRelease";
        }
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        changeSetTeamLeagueTimer.stop();
        if(index != sxm_setteam_leagueindex)
        {
            sxm_setteam_leagueindex = index;
            sxm_setteam_curleague = mChListFirstText;
            sxm_setteam_leaguealert = bChListSecondText;
            idMSetTeamLeftDelegate.ListView.view.currentIndex = index;
            idMSetTeamLeftDelegate.ListView.view.focus = true;

            changeSetTeamLeague(index);
        }
        changeFocusToTeamList();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: idMSetTeamLeftDelegate.activeFocus ? firstTextPressColor : (index == sxm_setteam_leagueindex) ? firstTextSelectedColor : firstTextPressColor;}
            PropertyChanges {target: firstText; font.family: idMSetTeamLeftDelegate.activeFocus ? systemInfo.font_NewHDR : (index == sxm_setteam_leagueindex) ? systemInfo.font_NewHDB : systemInfo.font_NewHDR;}
        },
        State {
            name: 'selected'; when: (index == sxm_setteam_leagueindex)
            PropertyChanges {target: firstText; color: (showFocus && idSETTEAMLeagueListView.activeFocus) ? firstTextFocusSelectedColor : firstTextSelectedColor;}
            PropertyChanges {target: firstText; font.family: (showFocus && idSETTEAMLeagueListView.activeFocus) ? systemInfo.font_NewHDR : systemInfo.font_NewHDB;}
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
            onSETTEAMLeagueListLeft(index);
        else if(idAppMain.isWheelRight(event))
            onSETTEAMLeagueListRight(index);
    }
}

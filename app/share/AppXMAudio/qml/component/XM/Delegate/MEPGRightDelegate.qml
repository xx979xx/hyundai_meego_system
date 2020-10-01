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
    id: idMEPGRightDelegate
    x: 0; y: 0
    width: 585; height: 107

    //****************************** # Preperty #
    //property int selectIndex: sxm_list_chnindex

    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderRadio_Dab+"list_dab_epg_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderRadio_Dab+"list_dab_epg_p.png"
    property string bgImageFocus: imageInfo.imgFolderRadio_Dab+"list_dab_epg_f.png"

    property string firstTextColor: colorInfo.blue
    property string firstTextPressColor: colorInfo.blue
    property string firstTextFocusPressColor: colorInfo.brightGrey
    property string firstTextFocusSelectedColor: colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.blue

    property string thirdTextColor: colorInfo.brightGrey
    property string thirdTextPressColor:  colorInfo.brightGrey
    property string thirdTextFocusPressColor:  colorInfo.brightGrey
    property string thirdTextFocusSelectedColor: colorInfo.brightGrey
    property string thirdTextSelectedColor: colorInfo.brightGrey

    property string mChListFirstText: ""
    property string mChListSecondText: ""
    property string mChListThirdText: ""
    property bool mChListProgicon: false
    property bool mChListSeriesicon: false

    //****************************** # Default/Selected/Press Image #
    Image{
        id: normalImage
        x: 1; y: -3
        height: idMEPGRightDelegate.height+6
        source: bgImage
    }

    //****************************** # Focus Image #
    BorderImage {
        id: focusImage
        x: 1; y: -3
        height: idMEPGRightDelegate.height+6
        source: bgImageFocus;
        visible: {
            if((idMEPGRightDelegate.state=="keyPress") || (idMEPGRightDelegate.state=="pressed"))
                return false;
            return showFocus && idMEPGRightDelegate.activeFocus;
        }
    }

    //****************************** # Program StartTime (FirstText) #
    Text{
        id: firstText
        text: mChListFirstText + " ~ " + mChListSecondText
        x: 10+24; y: 107-74-(font.pixelSize/2)
        width: 406; height: 28
        font.pixelSize: 26
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: firstTextColor
        elide: Text.ElideRight
    }

    //****************************** # Program Title (thirdText) #
    MComp.DDScrollTicker{
        id: thirdText
        text: mChListThirdText
        x: 10+24; y: 107-33-(thirdText.fontSize/2)-(thirdText.fontSize/(3*2))
        width: 406; height: thirdText.fontSize+(thirdText.fontSize/3)
        fontSize: 36
        fontFamily: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: thirdTextColor
        tickerFocus: (idMEPGRightDelegate.activeFocus && idAppMain.focusOn)
    }

    //****************************** # Line Image #
    Image{
        x: 10; y: idMEPGRightDelegate.height
        source: imageInfo.imgFolderGeneral+"line_menu_list.png"
    }
    Image {
        id : idReservceImg
        x : 10 + 24 + 406 + 20
        y : 107-35-38
        source :  imageInfo.imgFolderRadio_Dab +"icon_reserve.png"
        visible : alertcheckimage()
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMEPGRightDelegate.ListView.view.flicking == false && idMEPGRightDelegate.ListView.view.moving == false)
            idMEPGRightDelegate.state = "keyPress";
    }
    onSelectKeyReleased: {
        if(index == idMEPGRightDelegate.ListView.view.currentIndex) idMEPGRightDelegate.state = "selected";
        else idMEPGRightDelegate.state = "keyRelease";
    }
    onCancel:{
        if(index == idMEPGRightDelegate.ListView.view.currentIndex) idMEPGRightDelegate.state = "selected";
        else idMEPGRightDelegate.state = "keyRelease";
    }
    onClickOrKeySelected: {
        console.log("[QML]XMAudioEPGProgramList::onClickOrKeySelected():: idRadioEPGQml.epglistMovingState");
        if(idRadioEPGQml.epglistMovingState == true) return;
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        sxm_epg_proindex = index;
        idMEPGRightDelegate.ListView.view.currentIndex = index;
        idMEPGRightDelegate.ListView.view.focus = true;
        idMEPGRightDelegate.ListView.view.forceActiveFocus();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: idMEPGRightDelegate.activeFocus ? (index == idMEPGRightDelegate.ListView.view.currentIndex) ? firstTextFocusSelectedColor : firstTextPressColor : firstTextPressColor;}
            PropertyChanges {target: thirdText; color: idMEPGRightDelegate.activeFocus ? (index == idMEPGRightDelegate.ListView.view.currentIndex) ? thirdTextFocusSelectedColor : thirdTextPressColor : thirdTextPressColor;}
        },
        State {
            name: 'selected'; when: (index == idMEPGRightDelegate.ListView.view.currentIndex)
            PropertyChanges {target: firstText; color: (showFocus && idMEPGRightDelegate.activeFocus) ? firstTextFocusSelectedColor : firstTextSelectedColor;}
            PropertyChanges {target: thirdText; color: (showFocus && idMEPGRightDelegate.activeFocus) ? thirdTextFocusSelectedColor : thirdTextColor;}
        },
        State {
            name: 'keyPress'; when: focusImage.active
            PropertyChanges {target: normalImage; source: bgImageFocusPress;}
            PropertyChanges {target: firstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: thirdText; color: thirdTextFocusPressColor;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: firstTextColor;}
            PropertyChanges {target: thirdText; color: thirdTextColor;}
        }
    ]

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event))
            onEPGProgramListLeft(index);
        else if(idAppMain.isWheelRight(event))
            onEPGProgramListRight(index);
    }

    Connections {
        target: idAppMain

        onAlertcheckimagesiganl: {
            if (index == selectedIndex) {
                idReservceImg.visible = alertcheckimage();
            }
        }
    }

    function alertcheckimage()
    {
        if (EPGInfo.handleGetEpgProgramAlert(index))
        {
            return true;
        }

        return false;
    }
}

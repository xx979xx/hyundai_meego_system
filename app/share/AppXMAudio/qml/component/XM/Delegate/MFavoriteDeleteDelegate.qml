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
    id: idMFavoriteDeleteDelegate
    x: 0; y: 0
    width: 1030; height: 92

    //****************************** # Preperty #
    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderGeneral+"edit_list_01_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderGeneral+"edit_list_01_p.png"
    property string bgImageFocus: imageInfo.imgFolderGeneral+"edit_list_01_f.png"

    property string firstTextColor: colorInfo.brightGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: colorInfo.brightGrey
    property string firstTextFocusSelectedColor: colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.blue

    property string mChListFirstText: ""
    property bool   bChListThirdText: false
    property bool mUIonlycheck: false

    //****************************** # Default/Selected/Press Image #
    Image{
        id: normalImage
        x: 14; y: 0
        source: bgImage
    }

    //****************************** # Focus Image #
    BorderImage {
        id: focusImage
        x: 14; y: 0
        source: bgImageFocus;
        visible: showFocus && idMFavoriteDeleteDelegate.activeFocus
    }

    //****************************** # Index (FirstText) #
    MComp.DDScrollTicker{
        id: firstText
        text: mChListFirstText
        x: 37+64; y: 90-44-(firstText.fontSize /2)-(firstText.fontSize/(3*2))
        width: 829; height: firstText.fontSize+(firstText.fontSize/3)
        fontFamily : systemInfo.font_NewHDR;
        fontSize: 40
        color: firstTextColor
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerFocus: (idMFavoriteDeleteDelegate.activeFocus && idAppMain.focusOn)
        visible: true
    }

    //****************************** # Check Box #
    MComp.MCheckBox {
        id: idRadioDeleteCheck
        x: 939; y: 20
        visible: true
        state: ((bChListThirdText == true) || (mUIonlycheck == true)) ? "on" : "off"
        notUsedCheckBox: true

        Item {
            id: idCheckBoxImage
            anchors.verticalCenter: parent.verticalCenter
            Image {
                id: checkImageOff
                source: imageInfo.imgFolderGeneral+"checkbox_uncheck.png"
                visible: (idRadioDeleteCheck.state == "off")
            }
            Image {
                id: checkImageOn
                source: imageInfo.imgFolderGeneral+"checkbox_check.png"
                visible: (idRadioDeleteCheck.state == "on")
            }
        }
    }

    //****************************** # Line Image #
    Image{
        x: 0; y: idMFavoriteDeleteDelegate.height
        source: imageInfo.imgFolderGeneral+"edit_list_line.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMFavoriteDeleteDelegate.ListView.view.flicking == false && idMFavoriteDeleteDelegate.ListView.view.moving == false)
            idMFavoriteDeleteDelegate.state = "pressed";
    }
    onSelectKeyReleased: {
        if(index == idMFavoriteDeleteDelegate.ListView.view.currentIndex) idMFavoriteDeleteDelegate.state = "selected";
        else idMFavoriteDeleteDelegate.state = "keyRelease";
    }
    onCancel:{
        if(index == idMFavoriteDeleteDelegate.ListView.view.currentIndex) idMFavoriteDeleteDelegate.state = "selected";
        else idMFavoriteDeleteDelegate.state = "keyRelease";
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        sxm_favorite_deleteindex = index;
        idMFavoriteDeleteDelegate.ListView.view.currentIndex = index;
        idMFavoriteDeleteDelegate.ListView.view.focus = true;
        idMFavoriteDeleteDelegate.ListView.view.forceActiveFocus();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: firstTextPressColor;}
            PropertyChanges {target: focusImage; visible: false;}
        },
        State {
            name: 'selected'; when: (index == idMFavoriteDeleteDelegate.ListView.view.currentIndex)
            PropertyChanges {target: firstText; color: (showFocus && idMFavoriteDeleteDelegate.activeFocus) ? firstTextFocusSelectedColor : firstTextColor;}
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
        {
            if(idRadioFavoriteDeleteListView.flicking || idRadioFavoriteDeleteListView.moving)   return;
            if( idMFavoriteDeleteDelegate.ListView.view.currentIndex )
            {
                idMFavoriteDeleteDelegate.ListView.view.decrementCurrentIndex();
                if(idMFavoriteDeleteDelegate.ListView.view.currentIndex%6 == 5)
                    idMFavoriteDeleteDelegate.ListView.view.positionViewAtIndex(idMFavoriteDeleteDelegate.ListView.view.currentIndex-5, ListView.Beginning);
            }
            else
            {
                if(ListView.view.count < 7)
                    return;

                idMFavoriteDeleteDelegate.ListView.view.positionViewAtIndex(idMFavoriteDeleteDelegate.ListView.view.count-1, idMFavoriteDeleteDelegate.ListView.view.Visible);
                idMFavoriteDeleteDelegate.ListView.view.currentIndex = idMFavoriteDeleteDelegate.ListView.view.count-1;
            }
        }
        else if(idAppMain.isWheelRight(event))
        {
            if(idRadioFavoriteDeleteListView.flicking || idRadioFavoriteDeleteListView.moving)   return;
            if( idMFavoriteDeleteDelegate.ListView.view.count-1 != idMFavoriteDeleteDelegate.ListView.view.currentIndex )
            {
                idMFavoriteDeleteDelegate.ListView.view.incrementCurrentIndex();
                if(idMFavoriteDeleteDelegate.ListView.view.currentIndex%6 == 0)
                    idMFavoriteDeleteDelegate.ListView.view.positionViewAtIndex(idMFavoriteDeleteDelegate.ListView.view.currentIndex, ListView.Beginning);
            }
            else
            {
                if(ListView.view.count < 7)
                    return;

                idMFavoriteDeleteDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                idMFavoriteDeleteDelegate.ListView.view.currentIndex = 0;
            }
        }
    }

    Connections{
        target: idAppMain
        onSelectAll:{
            mUIonlycheck = true;
        }
        onSelectAllcancelandok:{
            mUIonlycheck = false;
        }
    }
}

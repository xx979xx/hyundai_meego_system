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
    id: idMSkipDelegate
    x: 0; y: 0
    width: 1246; height: 92

    //****************************** # Preperty #
    property string bgImage: ""
    property string bgImagePress: imageInfo.imgFolderGeneral+"list_p.png"
    property string bgImageFocusPress: imageInfo.imgFolderGeneral+"list_p.png"
    property string bgImageFocus: imageInfo.imgFolderGeneral+"list_f.png"

    property string firstTextColor: colorInfo.blue
    property string firstTextPressColor: colorInfo.blue
    property string firstTextFocusPressColor: colorInfo.blue
    property string firstTextFocusSelectedColor: colorInfo.blue
    property string firstTextSelectedColor: colorInfo.blue

    property string secondTextColor: colorInfo.brightGrey
    property string secondTextPressColor: colorInfo.brightGrey
    property string secondTextFocusPressColor: colorInfo.brightGrey
    property string secondTextFocusSelectedColor: colorInfo.brightGrey
    property string secondTextSelectedColor: colorInfo.blue

    property string mChListFirstText: ""
    property string mChListSecondText: ""
    property bool   bChListThirdText: false

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
            if((idMSkipDelegate.state=="keyPress") || (idMSkipDelegate.state=="pressed"))
                return false;
            return showFocus && idMSkipDelegate.activeFocus;
        }
    }

    //****************************** # Index (FirstText) #
    Text{
        id: firstText
        text: mChListFirstText
        x: 102; y: 90-44-(font.pixelSize/2)
        width: 100; height: 43
        font.pixelSize: 40
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: firstTextColor
        elide: Text.ElideRight
    }

    //****************************** # Index (SecondText) #
    Text{
        id: secondText
        text: mChListSecondText
        x: 102+100; y: 90-44-(font.pixelSize/2)
        width: 969; height: 43
        font.pixelSize: 40
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: (showFocus && idMSkipDelegate.activeFocus) ? secondTextFocusPressColor : secondTextColor
        elide: Text.ElideRight
    }

    //****************************** # Check Box #
    MComp.MCheckBox{
        id: idSkipChanelcheck
        x: 102+100+969+20; y: 22
        visible: ((idAppMain.sxm_list_currcat == stringInfo.sSTR_XMRADIO_All_CHANNELS) && (index == 0 || index == 1)) ? false : true
        state: (bChListThirdText == true) ? "on" : "off"
        notUsedCheckBox: true

        Item {
            id: idCheckBoxImage
            anchors.verticalCenter: parent.verticalCenter
            visible: ((idAppMain.sxm_list_currcat == stringInfo.sSTR_XMRADIO_All_CHANNELS) && (index == 0 || index == 1)) ? false : true
            Image {
                id: checkImageOff
                source: imageInfo.imgFolderGeneral+"checkbox_uncheck.png"
                visible: (idSkipChanelcheck.state == "off")
            }
            Image {
                id: checkImageOn
                source: imageInfo.imgFolderGeneral+"checkbox_check.png"
                visible: (idSkipChanelcheck.state == "on")
            }
        }
    }

    //****************************** # Line Image #
    Image{
        x: 0; y: idMSkipDelegate.height
        source: imageInfo.imgFolderGeneral+"list_line.png"
    }

    //****************************** # Signal Handler #
    onSelectKeyPressed: {
        if(idMSkipDelegate.ListView.view.flicking == false && idMSkipDelegate.ListView.view.moving == false)
            idMSkipDelegate.state = "pressed";
    }
    onSelectKeyReleased: {
        idMSkipDelegate.state = "keyRelease";
    }
    onCancel:{
        idMSkipDelegate.state = "keyRelease";
    }
    onClickOrKeySelected: {
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

        selectedSkipItem = index;
        idMSkipDelegate.ListView.view.currentIndex = index;
        idMSkipDelegate.ListView.view.focus = true;
        idMSkipDelegate.ListView.view.forceActiveFocus();
    }

    //****************************** # State #
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: normalImage; source: bgImagePress;}
            PropertyChanges {target: firstText; color: firstTextPressColor;}
            PropertyChanges {target: secondText; color: secondTextPressColor;}
        },
        State {
            name: 'keyPress'; when: focusImage.active
            PropertyChanges {target: normalImage; source: bgImageFocusPress;}
            PropertyChanges {target: firstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: secondText; color: secondTextFocusPressColor;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: normalImage; source: bgImage;}
            PropertyChanges {target: firstText; color: idMSkipDelegate.activeFocus ? firstTextFocusPressColor : firstTextColor;}
            PropertyChanges {target: secondText; color: idMSkipDelegate.activeFocus ? secondTextFocusPressColor : secondTextColor;}
        }
    ]

    //****************************** # Wheel in ListView #
    Keys.onPressed: {
        if(idAppMain.isWheelLeft(event))
            onLISTSkipListLeft(index);
        else if(idAppMain.isWheelRight(event))
            onLISTSkipListRight(index);
    }
}

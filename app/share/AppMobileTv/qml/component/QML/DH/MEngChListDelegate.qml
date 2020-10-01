/**
 * FileName: MChListDelegate.qml
 * Author: HYANG
 * Time: 2012-05
 *
 * - 2012-05 Initial Created by HYANG
 * - 2012-07-25 added presetList bigSize
 * - 2012-08-22 added TextScroll
 * - 2012-09-19 change text color
 * - 2012-11-20 GUI modify(selected image delete) Save, edit icon add
 * - 2013-01-05 Preser Order
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent {
    id: idMEngChListDelegate
    //x: 43-10 ; y: 2
    width: 422 ; height: 88

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    // # Delegate Info
    property bool active: false
    property bool focusMove: false
    property bool focusImgVisible: showFocus && idMEngChListDelegate.activeFocus

    // # Image Path
    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string imgFolderRadio_Hd : imageInfo.imgFolderRadio_Hd
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderDmb : imageInfo.imgFolderDmb

    // # Button Image
    property string bgImage: ""
    property string bgImagePress: imgFolderDmb+"ch_list_p.png"
    property string bgImageFocus: imgFolderDmb+"ch_list_f.png"

    // # First Text Info
    property string firstTextColor: colorInfo.dimmedGrey
    property string firstTextPressColor: colorInfo.dimmedGrey
    property string firstTextFocusColor: colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.selectedBlue//idMEngChListDelegate.showFocus ? colorInfo.brightGrey : "#7CBDFF"  //RGB(124, 189, 255)//colorInfo.brightGrey

    // # Second Text Info
    property string secondTextColor: colorInfo.brightGrey
    property string secondTextPressColor:  colorInfo.brightGrey;
    property string secondTextFocusColor: colorInfo.brightGrey
    property string secondTextSelectedColor: colorInfo.selectedBlue/// idMEngChListDelegate.showFocus ? colorInfo.brightGrey : "#7CBDFF" //RGB(124, 189, 255)// colorInfo.brightGrey

    property bool isViewingChannel: false

    property string mChListFirstText: ""
    property string mChListSecondText: ""

    // # Line Image #
    Image{
        x: 43; y: 89
        source: imgFolderGeneral+"line_ch.png"
    }

    Item{
        id: idLayoutItem
        x: 0
        y: 0
        width:parent.width
        height:parent.height

        // # Default Image
        Image{
            id: idBgImg
            x: 30//44-7
            y: -1
            source: bgImage
        }

        // # Button Focus Image
        BorderImage {
            id: idFocusImage
            x: 30//44-7
            y: -1
            source: bgImageFocus;
            visible: focusImgVisible//showFocus && idMEngChListDelegate.activeFocus
        }

        // # FirstText(Index)
        Text{
            id: firstText
            //text: (presetOrder)? parseInt(idMEngChListDelegate.y/idMEngChListDelegate.height)+1 : (mChListFirstText == "") ? index+1 : mChListFirstText
            text: (mChListFirstText == "") ? index+1 : mChListFirstText
            x: 33; y: 89-44-40/2
            width: 58; height: 40
            font.pixelSize: 40
            font.family: idAppMain.fontsB
            verticalAlignment: Text.AlignVCenter
	    horizontalAlignment: Text.AlignHCenter
            color: firstTextColor
        }

        // # SecondText(Channel)
        Text{
            id: secondText
            text: mChListSecondText
            x: firstText.x+58+15
            y: 89-44-40/2
            width: 337
            height: 40
            font.pixelSize: 40
            font.family: idAppMain.fontsB
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: secondTextColor
        }

    }
    
    // ### Jog Event
    Keys.onUpPressed: { 

// Set focus for Band
        if(CommParser.m_bIsFullScreen == false)
        {
            idENGModeBand.focusBackBtn()
        }
        event.accepted = true;
	return;
    }

    onUpKeyReleased: {
        if(idAppMain.upKeyReleased == true && CommParser.m_bIsFullScreen == false && idAppMain.state != "PopupSearching")
        {
            idDmbENGModeMain.lastFocusId = "idENDModeListView";
            idENGModeBand.focus = true;
            focusMove = true;
            idMEngChListDelegate.state="keyRelease"
        }
        idAppMain.upKeyReleased = false;
    }

    Keys.onDownPressed:{ // No Movement
        event.accepted = true;
        return;
    }

    onWheelLeftKeyPressed: {
//         if( idMEngChListDelegate.ListView.view.currentIndex )
//        {
//            idMEngChListDelegate.ListView.view.decrementCurrentIndex();
//        }
//        else
//        {
//            idMEngChListDelegate.ListView.view.positionViewAtIndex(idMEngChListDelegate.ListView.view.count-1, ListView.Visible);
//            idMEngChListDelegate.ListView.view.currentIndex = idMEngChListDelegate.ListView.view.count-1;
//        }

//         CommParser.onChannelSelectedByIndex(idMEngChListDelegate.ListView.view.currentIndex, false, false);
        if(idMEngChListDelegate.ListView.view.flicking || idMEngChListDelegate.ListView.view.moving) return;
        if( idMEngChListDelegate.ListView.view.currentIndex )
        {
            idMEngChListDelegate.ListView.view.decrementCurrentIndex();
        }
        else
        {
            idMEngChListDelegate.ListView.view.positionViewAtIndex(idMEngChListDelegate.ListView.view.count-1, ListView.Visible);
            idMEngChListDelegate.ListView.view.currentIndex = idMEngChListDelegate.ListView.view.count-1;
        }

        if(idMEngChListDelegate.ListView.view.count > 6)
        {
            if(idMEngChListDelegate.ListView.view.currentIndex%6 == 5)
                idMEngChListDelegate.ListView.view.positionViewAtIndex(idMEngChListDelegate.ListView.view.currentIndex-5, ListView.Beginning);
        }
        CommParser.onChannelSelectedByIndex(idMEngChListDelegate.ListView.view.currentIndex, false, false);
    }

    onWheelRightKeyPressed: {
//        if( idMEngChListDelegate.ListView.view.count-1 != idMEngChListDelegate.ListView.view.currentIndex )
//        {
//            idMEngChListDelegate.ListView.view.incrementCurrentIndex();
//        }
//        else
//        {
//            idMEngChListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
//            idMEngChListDelegate.ListView.view.currentIndex = 0;
//        }
//        CommParser.onChannelSelectedByIndex(idMEngChListDelegate.ListView.view.currentIndex, false, false);
        if(idMEngChListDelegate.ListView.view.flicking || idMEngChListDelegate.ListView.view.moving) return;
        if( idMEngChListDelegate.ListView.view.count-1 != idMEngChListDelegate.ListView.view.currentIndex )
        {
            idMEngChListDelegate.ListView.view.incrementCurrentIndex();
        }
        else
        {
            idMEngChListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
            idMEngChListDelegate.ListView.view.currentIndex = 0;
        }

        if(idMEngChListDelegate.ListView.view.count > 6)
        {
            if(idMEngChListDelegate.ListView.view.currentIndex%6 == 0)
                idMEngChListDelegate.ListView.view.positionViewAtIndex(idMEngChListDelegate.ListView.view.currentIndex, ListView.Beginning);
        }
        CommParser.onChannelSelectedByIndex(idMEngChListDelegate.ListView.view.currentIndex, false, false);
    }
    
    // ### Touch Release Event
    onClickReleased: {
        if(playBeepOn && idAppMain.inputModeDMB == "touch" /* && pressAndHoldFlagDMB == false*/) idAppMain.playBeep();
    }
    
    // ### Key Enter / Touch Click
    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            //console.log(" [QML]  onClickOrKeySelected : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! index="+index)

            idMEngChListDelegate.ListView.view.currentIndex = index;
            idMEngChListDelegate.ListView.view.positionViewAtIndex(index, ListView.Visible);
            idMEngChListDelegate.ListView.view.focus = true
            idMEngChListDelegate.ListView.view.forceActiveFocus()

            CommParser.onChannelSelectedByIndex(idMEngChListDelegate.ListView.view.currentIndex, false, false);
        }
    }
    
    // ### Delegate Event
    onActiveFocusChanged: {
//        console.log(" [QML] onActiveFocusChanged:: activeFocus="+idMEngChListDelegate.activeFocus)
//        console.log(" [QML] onActiveFocusChanged::currentIndex = "+idMEngChListDelegate.ListView.view.currentIndex+" index="+index+" m_iPresetListIndex"+CommParser.m_iPresetListIndex)

        if(idMEngChListDelegate.activeFocus)
        {
            if(idMEngChListDelegate.ListView.view.currentIndex == CommParser.m_iPresetListIndex)
            {
                focusMove = false;
                idMEngChListDelegate.state="keyRelease"
            }
        }
        else
        {

            if(index == CommParser.m_iPresetListIndex /*&& ((idAppMain.upKeyLongPressed == true ||idAppMain.downKeyLongPressed == true))*/)
            {
                if((idAppMain.upKeyLongPressed == true ||idAppMain.downKeyLongPressed == true)){
                    focusMove = true;
                    idMEngChListDelegate.state="keyRelease"
                }else{
                    focusMove = true;
                    idMEngChListDelegate.state="Refresh"
                }
            }
        }
    }
    
    // # State
    states: [
        State {
            name: 'pressed'; when: isMousePressed() && idMEngChListDelegate.ListView.view.currentIndex == index
            PropertyChanges {target: idBgImg; source: bgImagePress;}
//            PropertyChanges {target:  firstText; color: firstTextPressColor}
//            PropertyChanges {target:  secondText; color: secondTextPressColor}
        },
        State {
            name: 'selected'; // when: CommParser.m_iPresetListIndex == index && idAppMain.inputMode == "jog"
            PropertyChanges {target:  firstText; color: firstTextColor}
            PropertyChanges {target:  secondText; color: secondTextColor}
        },
        State {
	    name: 'focused'; when: CommParser.m_iPresetListIndex == index &&  idAppMain.inputMode == "touch"// && (!presetOrder)
            PropertyChanges {target:  firstText; color: firstTextSelectedColor}
            PropertyChanges {target:  secondText; color: secondTextSelectedColor}
        },
        State {
            name: 'keyPress'; when: idFocusImage.active
            PropertyChanges {target: idBgImg; source: bgImagePress;}
            PropertyChanges {target:  firstText; color: firstTextPressColor;}
            PropertyChanges {target:  secondText; color: secondTextPressColor;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: idBgImg; source: bgImage;}
            PropertyChanges {target:  firstText; color: (CommParser.m_iPresetListIndex == index && focusMove == true && idFocusImage.visible == false) ? firstTextSelectedColor : firstTextColor;}
            PropertyChanges {target:  secondText; color: (CommParser.m_iPresetListIndex == index && focusMove == true && idFocusImage.visible == false)  ? secondTextSelectedColor : secondTextColor;}
        },
        State {
            name: 'Refresh';
            PropertyChanges {target: idBgImg; source: bgImage;}
            PropertyChanges {target:  firstText; color: (CommParser.m_iPresetListIndex == index && focusMove == true && idFocusImage.visible == false) ? firstTextSelectedColor : firstTextColor;}
            PropertyChanges {target:  secondText; color: (CommParser.m_iPresetListIndex == index && focusMove == true && idFocusImage.visible == false)  ? secondTextSelectedColor : secondTextColor;}
        }
    ]
}


/**
 * FileName: MBand.qml
 * Author: HYANG
 * Time: 2012-04
 *
 * - 2012-04 Initial Created by HYANG
 *   (tab count changed only one, BT Tab added)
 */

import QtQuick 1.1
import "../system" as MSystem

MComponent {
    id: container
    width: systemInfo.lcdWidth; height: systemInfo.modeAreaHeight
    enableClick: false;
    focus: false

//    onActiveFocusChanged: {
//        console.log("MBand onActiveFocusChanged :" + activeFocus);
//    }

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }

    //****************************** # Preperty #
    property string titleText: "" //[user control] Title`s Label Text
    property string signalText: ""  //[user control]
    property int curListNumber: 0  //[user control] current item number of list
    property int totListNumber: 0  //[user control] total item number of list
    property bool listNumberFlag: false   //[user control] list number On/Off
    property string firstTabText: ""    //[user control] Text in band button
    property alias backKeyButton: idBackKey

    //****************************** # Signal (when button clicked) #
    signal backKeyClicked();

    //****************************** # Band Background Image #
    Image{
        x: 0; y: 0
        width: container.width; height: container.height
        source: systemInfo.imageInternal+"bg_title.png"
    }

    Row {
        x: 0; y: 0
        spacing: 0
        layoutDirection: (cppToqml.IsArab)? Qt.RightToLeft : Qt.LeftToRight

        Item {
            id: leftMarginItem
            height: container.height
            width: 46
        }

        //****************************** # Title Text #
        Item {
           width: 845; height:container.height
           MText{
               id: txtTitle
               width: parent.width; height: container.height-3
               text: titleText
               font.family: stringInfo.fontName
               verticalAlignment: Text.AlignVCenter;
               font.pointSize : systemInfo.normalFontSize
           }
       }

        Item {
           width: 99; height: container.height
       }

        //****************************** # List Number Text #
        Item {
           width: 146; height: container.height
           MText{
               id: txtListNumber
               anchors.verticalCenter: parent.verticalCenter
               text: (cppToqml.IsArab)? totListNumber+"/"+curListNumber : curListNumber+"/"+totListNumber
               width: 146; height: 30
               font.family: stringInfo.fontName
               font.pointSize : systemInfo.listNumberFontSize
               horizontalAlignment: Text.AlignHCenter
               verticalAlignment: Text.AlignVCenter
               color:  "#7CBDFF" //RGB(124,189,255)
               visible: listNumberFlag
           }

        }

        //****************************** # BackKey button #
        MButton{
            id: idBackKey
            width: systemInfo.widthBackKey; height: systemInfo.heightBackKey
            bgImage: systemInfo.bgImageBackKey
            bgImagePress: systemInfo.bgImagePressBackKey
            bgImageFocusPress: systemInfo.bgImageFocusPressBackKey
            bgImageFocus: systemInfo.bgImageFocusBackKey

            onClickOrKeySelected: {
                backKeyClicked()
            }

        }

    }
}

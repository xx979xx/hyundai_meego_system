/**
 * FileName: MDimCheck.qml
 * Author: WSH
 * Time: 2012-03-08
 *
 * - 2012-03-08 Modified by WSH
 * - 2013-01-03 Updated Component (MComponent.qml) by WSH
 */

import QtQuick 1.1

MComponent {
    id: idDimCheck
    x: iconX; y: iconY
//    width: 45; height: 45
    anchors.verticalCenter: parent.verticalCenter

    //--------------------- Active Info(Property) ##
    property bool flagToggle: (state=="on")? true : false

    //--------------------- Icon Info(Property) ##
    property int iconX: 0
    property int iconY: 0
    property string bgImage: imageInfo.imgFolderGeneral+"ico_check_n.png"
    property string bgImageSelected: imageInfo.imgFolderGeneral+"ico_check_s.png"

    //--------------------- (signal) #
    signal dimUnchecked()
    signal dimChecked()

    //--------------------- Click Event(Function) #
    onClickOrKeySelected: { if(idDimCheck.mEnabled) toggle() }
    function toggle() {
        if (idDimCheck.state == "on"){
            idDimCheck.state = "off";
            dimUnchecked();
        }
        else if(idDimCheck.state == "off"){
            idDimCheck.state = "on";
            dimChecked();
        } // End if
    } // End function

    //-------------------- View the background
//    Image {
//        id: imgDimCheckOff
//        source: bgImage
//    } // End Image

//    //-------------------- View the Button
//    Image {
//        id: imgDimCheckOn
//        source: bgImageSelected
//        visible: false
//    } // End Image

    states: [
//        State { name: "on" ; PropertyChanges { target: imgDimCheckOn; visible: true } },
//        State { name: "off"; PropertyChanges { target: imgDimCheckOn; visible: false } }
    ]
} // End MComponent

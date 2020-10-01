/**
 * FileName: MDimCheck.qml
 * Author: WSH
 * Time: 2012-03-08
 *
 * - 2012-03-08 Modified by WSH
 */
import QtQuick 1.0

MComponent {
    id: idDimCheck
    x: iconX; y: iconY
    width: 45; height: 45
    anchors.verticalCenter: parent.verticalCenter

    //--------------------- Active Info(Property) ##
    property bool flagToggle: (state=="on")? true : false

    //--------------------- Icon Info(Property) ##
    property int iconX: 0
    property int iconY: 0
    property string bgImage: imgFolderGeneral+"ico_check_n.png"
    property string bgImageSelected: imgFolderGeneral+"ico_check_s.png"

    //--------------------- Image Path Info(Property) #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    //--------------------- (signal) #
    signal dimUnchecked()
    signal dimChecked()

    //--------------------- Click Event(Function) #
    onClickOrKeySelected: { if(!idDimCheck.dimmed) toggle() }
    function toggle() {
        if (idDimCheck.state == "on"){
            idDimCheck.state = "off";
            dimUnchecked();
        }
        else if(idDimCheck.state == "off"){
            idDimCheck.state = "on";
            dimChecked();
        } // End if
        flagToggle = !flagToggle
    } // End function

    //-------------------- View the background
    Image {
        id: imgDimCheckOff
        source: bgImage
    } // End Image

    //-------------------- View the Button
    Image {
        id: imgDimCheckOn
        source: bgImageSelected
        visible: false
    } // End Image

    states: [
        State { name: "on" ; PropertyChanges { target: imgDimCheckOn; visible: true } },
        State { name: "off"; PropertyChanges { target: imgDimCheckOn; visible: false } }
    ]
} // End MComponent

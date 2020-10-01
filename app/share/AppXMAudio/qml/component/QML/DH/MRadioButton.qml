/**
 * FileName: MRadioButton.qml
 * Author: WSH
 * Time: 2012-03-09
 *
 * - 2012-03-13 Modified by WSH
 */

import QtQuick 1.1

MComponent {
    id: container
    x: iconX; y: iconY
    width: 45; height: 45

    //--------------------- SelectedIndex Info(Property) ##
    property int selectedIndex: 0

    //--------------------- Active Info(Property) ##
    property bool active: false

    //--------------------- Icon Info(Property) ##
    property int iconX: 0
    property int iconY: 0
    property string bgImage: imgFolderGeneral + "ico_radio_n.png"
    property string bgImageSelected: imgFolderGeneral + "ico_radio_s.png"
    property string imgFillMode: Image.TileHorizontally

    //--------------------- Image Path Info(Property) #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral

    //-------------------- View the background
    Image {
        id: imgRadioBtn
        source: bgImage
        fillMode: imgFillMode
        anchors.fill: parent
        smooth: true
    } // End Image

    //-------------------- Click Event
    onClickOrKeySelected:{ selectedIndex = index }

    states: [
        State {
            name: "on"; when: container.active
            PropertyChanges { target: imgRadioBtn; source: bgImageSelected }
        },
        State {
            name: "off"; when: !(idRadioButton.active)
            PropertyChanges { target: imgRadioBtn; source: bgImage }
        }
    ]
} // End MComponent

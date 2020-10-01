/**
 * FileName: MButton.qml
 * Author: Problem Kang
 * Time: 2012-02-03 11:20
 *
 * - 2012-02-03 Initial Crated by Problem Kang
 */

import Qt 4.7
import "../../system/DH" as MSystem

MComponent {
    id: container

    width:187
    height:185

    property bool active: false
    property string buttonName: ""

    property string bgImageFocusPress: imgFolderHome+"ico_home_f.png"

    //Image Info
    property int fgImageX: 0
    property int fgImageY: 0
    property int fgImageWidth: 185
    property int fgImageHeight: 184
    property string buttonImage:""
    property string buttonImagePress: ""
    property string buttonImageActive: ""
    property string buttonImageFocus: ""
    property string buttonImageFocusPress: ""

    property int textLine: 1

    //first Text Info
    property string firstText: ""
    property int firstTextSize: 28
    property int firstTextX: 0
    property int firstTextY: textLine==1?30:27
    property int firstTextWidth: 185
    property int firstTextHeight: firstTextSize+10
    property string firstTextStyle: systemInfo.hdb
    property string firstTextAlies: "Center"
    property string firstTextColor: colorInfo.brightGrey
    property string firstTextPressColor : colorInfo.bandBlue
    property string firstTextFocusPressColor : firstTextPressColor

    opacity: enabled ? 1.0 : 0.5

    Image {
        id: imgFgImage
        x: fgImageX
        y: fgImageY
        width: fgImageWidth
        height: fgImageHeight
        source: buttonImage
    }

    //First Text
    Text {
        id: txtFirstText
        text: firstText
        x:firstTextX
        y:firstTextY-(firstTextSize/2)
        width: firstTextWidth
        height: firstTextHeight
        color:firstTextColor
        font.family: firstTextStyle
        font.pixelSize: firstTextSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: {
            if(firstTextAlies=="Right"){Text.AlignRight}
            else if(firstTextAlies=="Left"){Text.AlignLeft}
            else if(firstTextAlies=="Center"){Text.AlignHCenter}
            else {Text.AlignHCenter}
        }
        clip: true //jyjeon_20120221
        //****************************** # End #
    }

    //Focus Image
    Image {
        anchors.fill: parent
        id: idFocusImage
        source: bgImageFocusPress
        visible: showFocus && container.activeFocus
    }

    onSelectKeyPressed: container.state="keyPress"
    onSelectKeyReleased:container.state="keyReless"
    //onClickOrKeySelected: container.state="keyPress"

    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: imgFgImage; source: buttonImagePress;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
        },
        State {
            name: 'active'; when: container.active
            PropertyChanges {target: imgFgImage; source: buttonImagePress;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
        },
        State {
            name: 'keyPress';
            PropertyChanges {target: imgFgImage; source: buttonImagePress;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
        },
        State {
            name: 'keyReless';
            PropertyChanges {target: imgFgImage; source: buttonImage;}
            PropertyChanges {target: txtFirstText; color: firstTextColor;}
        },
        State {
            name: 'dimmed'; when: container.dimmed
            PropertyChanges {target: txtFirstText; color: firstDimmedTextColor;}
        }
    ]
}

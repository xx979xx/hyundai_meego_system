/**
 * FileName: MButton.qml
 * Author: Problem Kang
 * Time: 2012-02-03 11:20
 *
 * - 2012-02-03 Initial Crated by Problem Kang
 */

import Qt 4.7
import "../system" as MSystem

MComponent {
    id: container

    MSystem.ColorInfo { id: colorInfo }
    MSystem.StringInfo { id: stringInfo }

    signal keyOrTouchPressed();
    signal touchReleased();

    //****************************** # For active(button select) by HYANG #
    property bool active: false
    property string buttonName: ""
    //****************************** # End #

    //Button Image // by WSH
    property int buttonWidth: container.width//: parent.width - problem Kang
    property int buttonHeight: container.height//: parent.height - problem Kang
    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""
    property string bgImageFocusPress: bgImagePress

    //Image inside Button // by WSH
    property int fgImageX: 0
    property int fgImageY: 0
    //****************************** # For image (visible) by HYANG #
    property int fgImageWidth: 0
    property int fgImageHeight: 0
    property bool fgImageVisible: true
    //****************************** # End #
    property string fgImage:""
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: fgImage
    property string fgImageFocusPress: fgImage

    //first Text Info
    property string firstText: ""
    property int firstTextSize: 24//28
    property int firstTextX: 0
    property int firstTextY: 0
    property int firstTextWidth: buttonWidth
    property int firstTextHeight: buttonHeight//30//+10 // # because text position wrong by HYANG(120522)
    property string firstTextStyle: stringInfo.fontName
    property string firstTextPressStyle: stringInfo.fontName
    property string firstTextAlies: "Center"
    //****************************** # For text (elide, visible) by HYANG #
    property string firstTextElide: "None"      // ex) "Right" >> ABCDEFG..
    property bool firstTextVisible: true
    //****************************** # End #
    property bool firstTextEnabled: true // <<---------- Added by WSH (Enabled)
    property string firstTextColor: colorInfo.brightGrey
    property string firstTextPressColor: colorInfo.brightGrey
    property string firstTextFocusPressColor: colorInfo.selected//colorInfo.brightGrey
    property string firstTextSelectedColor: colorInfo.brightGrey//colorInfo.selected
    property string firstDimmedTextColor: colorInfo.dimmedGrey
    property bool firstTextBold: false

    property bool isSelected: false

    property int txtPaintedWidth: txtFirstText.paintedWidth

    opacity: mEnabled ? 1.0 : 0.5

    //Button Image
    Image{
        id:backGround
        source: (container.isSelected)? bgImageActive : bgImage
        anchors.fill: parent
        z:0
    }

    //Focus Image
    Image {
        anchors.fill: backGround
        id: idFocusImage
        source: bgImageFocus
        width: parent.width
        visible: mEnabled && container.activeFocus
        z:1
    }

    //Image inside Button
    Image {
        id: imgFgImage
        x: fgImageX
        y: fgImageY
        width: fgImageWidth
        height: fgImageHeight
        source: fgImage
        visible: fgImageVisible
        z:3
    }

    //Text
    Text {
        id: txtFirstText
        text: firstText
        x:firstTextX
        y:firstTextY
        width: firstTextWidth
        height: firstTextHeight
        color: (container.activeFocus)? firstTextPressColor: firstTextColor
        font.family: (container.activeFocus)? firstTextPressStyle: firstTextStyle
        font.pointSize : firstTextSize
        font.bold: firstTextBold
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: {
            if (firstTextAlies=="Right") {Text.AlignRight}
            else if (firstTextAlies=="Left") {Text.AlignLeft}
            else if (firstTextAlies=="Center") {Text.AlignHCenter}
            else {Text.AlignHCenter}
        }

        wrapMode: Text.WordWrap //elide: Text.ElideRight
        visible: firstTextVisible
        clip: true

        enabled: firstTextEnabled
        z:4
    }

    onSelectKeyPressed: {
        //console.log("[MButton Test] onSelectKeyPressed");
        if (container.dimmed) {
            container.state="dimmed";
        }else if (container.mEnabled) {
            //console.log("[QML] MButton onSelectKeyPressed. state:"+ container.state);
            container.state="keyPress";
            keyOrTouchPressed();
        }else{
            container.state="disabled"
        }
    }

    onSelectKeyReleased: {
        //console.log("[MButton Test] onSelectKeyReleased");
        if (container.dimmed) {
            container.state="dimmed"
        }else if (container.mEnabled) {
            if (active==true) {
                //console.log("[MButton Test] onSelectKeyReleased - set active");
                //container.state="active"
            }else{
                //console.log("[MButton Test] onSelectKeyReleased - set keyReless");
                container.state="keyReless";
            }
            //console.log("[MButton Test] state:" + container.state);
        }else{
            container.state = "disabled"
        }
    }

    onPressed: {
        //console.log("[MButton Test] onPressed");
        keyOrTouchPressed();
    }

    onReleased: {
        //console.log("[MButton Test] onReleased - set released");
        container.state="released";
        //console.log("[MButton Test] state:" + container.state);
        touchReleased();
    }

    onExited: {
        //console.log("[MButton Test] onExited - set released");
        container.state="released";
        //console.log("[MButton Test] state:" + container.state);
    }

    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: backGround; source: bgImagePress;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
            PropertyChanges {target: idFocusImage; opacity: 0;}
            //PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
        },
        State {
            name: 'released'; when: container.state=="released"
            PropertyChanges {target: idFocusImage; opacity: 1;}
        },
        State {
            name: 'active'; when: container.isSelected
            PropertyChanges {target: backGround; source: bgImageActive;}
            PropertyChanges {target: imgFgImage; source: fgImageActive;}
            PropertyChanges {target: idFocusImage; opacity: 1;}
            //PropertyChanges {target: txtFirstText; color: firstTextSelectedColor;}
        },
        State {
            name: 'keyPress'; //when: container.state=="keyPress" // problem Kang
            PropertyChanges {target: backGround; source: bgImagePress;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
            PropertyChanges {target: idFocusImage; opacity: 0;}
            //PropertyChanges {target: txtFirstText; color: firstTextSelectedColor;}
        },
        State {
            name: 'keyReless';
//            PropertyChanges {target: backGround; source: bgImage;}
//            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: idFocusImage; opacity: 1;}
            //PropertyChanges {target: txtFirstText; color: firstTextColor;}
        },
        State {
            name: 'dimmed'; when: container.dimmed
            PropertyChanges {target: txtFirstText; color: firstDimmedTextColor;}
        },
        State {
            name: 'disabled'; when: !mEnabled;//!container.enabled
            PropertyChanges {target: txtFirstText; color: colorInfo.disableGrey;}
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
        }
    ]
}

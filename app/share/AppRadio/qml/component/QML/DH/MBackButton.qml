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

    //****************************** # For active(button select) by HYANG #
    property bool active: false
    property string buttonName: ""
    //****************************** # End #

    //button Info(width,height)
    property int buttonWidth: parent.width
    property int buttonHeight: parent.height
    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""
    property string bgImageFocusPress: ""

    //Image Info
    property int fgImageX: 0
    property int fgImageY: 0
    property string fgImage:""
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: fgImage
    property string fgImageFocusPress: fgImage

    //first Text Info
    property string firstText: ""
    property int firstTextSize: 0
    property int firstTextX: 0
    property int firstTextY: 0
    property int firstTextWidth: 0
    property int firstTextHeight: firstTextSize
    property string firstTextStyle: systemInfo.hdr// //"HDR"
    property string firstTextAlies: "Left"
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor : firstTextColor
    property string firstTextFocusPressColor : firstTextPressColor
    property string firstTextSelectedColor: firstTextColor

    //second Text Info
    property string secondText: ""
    property int secondTextSize: 0
    property int secondTextX: 0
    property int secondTextY: 0
    property int secondTextWidth: 0
    property int secondTextHeight: secondTextSize
    property string secondTextStyle: systemInfo.hdr////"HDR"
    property string secondTextAlies: "Left"
    property string secondTextColor: colorInfo.subTextGrey
    property string secondTextPressColor : secondTextColor
    property string secondTextFocusPressColor : secondTextPressColor
    property string secondTextSelectedColor: secondTextColor

    //third Text Info
    property string thirdText: ""
    property int thirdTextSize: 0
    property int thirdTextX: 0
    property int thirdTextY: 0
    property int thirdTextWidth: 0
    property int thirdTextHeight: thirdTextSize
    property string thirdTextStyle: systemInfo.hdr// //"HDR"
    property string thirdTextAlies: "Left"
    property string thirdTextColor: colorInfo.subTextGrey
    property string thirdTextPressColor : thirdTextColor
    property string thirdTextFocusPressColor : thirdTextPressColor
    property string thirdTextSelectedColor: thirdTextColor

    //BackGround Image
    Image{
        id:backGround
        source: bgImage
        anchors.fill: parent
    }

    Image {
        id: imgFgImage
        x:fgImageX
        y:fgImageY
        source: fgImage
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
        } //jyjon_20120302
    }

    //Second Text
    Text {
        id: txtSecondText
        text: secondText
        x:secondTextX
        y:secondTextY-(secondTextSize/2)
        width: secondTextWidth
        height: secondTextHeight
        color:secondTextColor
        font.family: secondTextStyle
        font.pixelSize: secondTextSize
        verticalAlignment: Text.AlignVCenter //jyjon_20120302
        horizontalAlignment: {
            if(secondTextAlies=="Right"){Text.AlignRight}
            else if(secondTextAlies=="Left"){Text.AlignLeft}
            else if(secondTextAlies=="Center"){Text.AlignHCenter}
            else {Text.AlignHCenter}
        } //jyjon_20120302
    }

    //Third Text
    Text {
        id: txtThirdText
        text: thirdText
        x:thirdTextX
        y:thirdTextY-(secondTextSize/2)
        width: thirdTextWidth
        height: thirdTextHeight
        color: thirdTextColor
        font.family: thirdTextStyle
        font.pixelSize: thirdTextSize
        verticalAlignment: Text.AlignVCenter //jyjon_20120302
        horizontalAlignment: {
            if(thirdTextAlies=="Right"){Text.AlignRight}
            else if(thirdTextAlies=="Left"){Text.AlignLeft}
            else if(thirdTextAlies=="Center"){Text.AlignHCenter}
            else {Text.AlignHCenter}
        } //jyjon_20120302
    }

    //Focus Image
    BorderImage {
        id: idFocusImage
        source: bgImageFocus;
        //fillMode: imgFillMode
        visible: showFocus && container.activeFocus
    }

    onSelectKeyPressed: container.state="keyPress"
    onSelectKeyReleased: container.state="keyReless"

    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: backGround; source: bgImagePress;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextPressColor;}
        },
        State {
            name: 'active'; when: container.active
            PropertyChanges {target: backGround; source: bgImageActive;}
            PropertyChanges {target: imgFgImage; source: fgImageActive;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextPressColor;}
        },
        State {
            name: 'keyPress';
            PropertyChanges {target: backGround; source: bgImageFocusPress;}
            PropertyChanges {target: imgFgImage; source: fgImageFocusPress;}
            PropertyChanges {target: txtFirstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextFocusPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextFocusPressColor;}
        },
        State {
            name: 'keyReless';
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: txtFirstText; color: firstTextColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextPressColor;}
        }
    ]
}

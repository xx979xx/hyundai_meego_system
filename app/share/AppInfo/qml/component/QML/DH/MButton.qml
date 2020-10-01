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
    //****************************** # For image (visible) by HYANG #
    property int fgImageWidth: 0
    property int fgImageHeight: 0
    property bool fgImageVisible: false
    //****************************** # End #
    property string fgImage:""
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: fgImage
    property string fgImageFocusPress: fgImage

    //****************************** # UnderText Info by HYANG #
    property string underText: ""
    property int underTextSize: 0
    property int underTextX: 0
    property int underTextY: 0
    property int underTextWidth: 0
    property int underTextHeight: underTextSize
    property string underTextStyle: "HDR"
    property string underTextAlies: "Left"
    //****************************** # For text (elide, visible) by HYANG #
    property string underTextElide: "None"      // ex) "Right" >> ABCDEFG..
    property bool underTextVisible: true
    //****************************** # End #
    property bool underTextEnabled: true // <<---------- Added by WSH (Enabled)
    property string underTextColor: colorInfo.subTextGrey
    property string underTextPressColor : underTextColor
    property string underTextFocusPressColor : underTextPressColor
    property string underTextSelectedColor: "Black"
    property string underDimmedTextColor: "red"//colorInfo.dimmedGrey

    //first Text Info
    property string firstText: ""
    property int firstTextSize: 0
    property int firstTextX: 0
    property int firstTextY: 0
    property int firstTextWidth: 0
    property int firstTextHeight: firstTextSize
    property string firstTextStyle: "HDR"
    property string firstTextAlies: "Left"
    //****************************** # For text (elide, visible) by HYANG #
    property string firstTextElide: "None"      // ex) "Right" >> ABCDEFG..
    property bool firstTextVisible: true
    //****************************** # End #
    property bool firstTextEnabled: true // <<---------- Added by WSH (Enabled)
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor : firstTextColor
    property string firstTextFocusPressColor : firstTextPressColor
    property string firstTextSelectedColor: "Black"
    property string firstDimmedTextColor: "red"//colorInfo.dimmedGrey

    //second Text Info
    property string secondText: ""
    property int secondTextSize: 0
    property int secondTextX: 0
    property int secondTextY: 0
    property int secondTextWidth: 0
    property int secondTextHeight: secondTextSize
    property string secondTextStyle: "HDR"
    property string secondTextAlies: "Left"
    //****************************** # For text (elide, visible) by HYANG #
    property string secondTextElide: "None"
    property bool secondTextVisible: true
    //****************************** # End #
    property bool secondTextEnabled: true // <<---------- Added by WSH (Enabled)
    property string secondTextColor: colorInfo.subTextGrey
    property string secondTextPressColor : secondTextColor
    property string secondTextFocusPressColor : secondTextPressColor
    property string secondTextSelectedColor: "Black"

    //third Text Info
    property string thirdText: ""
    property int thirdTextSize: 0
    property int thirdTextX: 0
    property int thirdTextY: 0
    property int thirdTextWidth: 0
    property int thirdTextHeight: thirdTextSize
    property string thirdTextStyle: "HDR"
    property string thirdTextAlies: "Left"
    //****************************** # For text (elide, visible) by HYANG #
    property string thirdTextElide: "None"
    property bool thirdTextVisible: true
    //****************************** # End #
    property bool thirdTextEnabled: true // <<---------- Added by WSH (Enabled)
    property string thirdTextColor: colorInfo.subTextGrey
    property string thirdTextPressColor : thirdTextColor
    property string thirdTextFocusPressColor : thirdTextPressColor
    property string thirdTextSelectedColor: "Black"

    //BackGround Image
    Image{
        id:backGround
        source: bgImage
        anchors.fill: parent
    }

    //****************************** # For UnderText by HYANG
    Text {
        id: txtUnderText
        text: underText
        x: underTextX
        y: underTextY-(underTextSize/2)
        width: underTextWidth
        height: underTextHeight
        color: underTextColor
        font.family: underTextStyle
        font.pixelSize: underTextSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: {
            if(underTextAlies=="Right"){Text.AlignRight}
            else if(underTextAlies=="Left"){Text.AlignLeft}
            else if(underTextAlies=="Center"){Text.AlignHCenter}
            else {Text.AlignHCenter}
        }
        elide: {
            if(underTextElide=="Right"){Text.ElideRight}
            else if(underTextElide=="Left"){Text.ElideLeft}
            else if(underTextElide=="Center"){Text.ElideMiddle}
            else /*if(underTextElide=="None")*/{Text.ElideNone}
        }
        visible: underTextVisible
        clip: true
        enabled: underTextEnabled
    }
    //****************************** # UnderText End #

    Image {
        id: imgFgImage
        x: fgImageX
        y: fgImageY
        width: fgImageWidth
        height: fgImageHeight
        source: fgImage
        visible: fgImageVisible
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
        //****************************** # For text (elide, visible) by HYANG #
        elide: {
            if(firstTextElide=="Right"){Text.ElideRight}
            else if(firstTextElide=="Left"){Text.ElideLeft}
            else if(firstTextElide=="Center"){Text.ElideMiddle}
            else /*if(firstTextElide=="None")*/{Text.ElideNone}
        }
        visible: firstTextVisible
        clip: true //jyjeon_20120221
        //****************************** # End #
        enabled: firstTextEnabled // <<---------- Added by WSH (Enabled)
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
        //****************************** # For text (elide, visible) by HYANG #
        elide: {
            if(secondTextElide=="Right"){Text.ElideRight}
            else if(secondTextElide=="Left"){Text.ElideLeft}
            else if(secondTextElide=="Center"){Text.ElideMiddle}
            else /*if(secondTextElide=="None")*/{Text.ElideNone}
        } //jyjon_20120302
        visible: secondTextVisible
        clip: true //jyjeon_20120221
        //****************************** # End #
        enabled: secondTextEnabled // <<---------- Added by WSH (Enabled)
    }

    //Third Text
    Text {
        id: txtThirdText
        text: thirdText
        x:thirdTextX
        y:thirdTextY-(thirdTextSize/2)
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
        //****************************** # For text (elide, visible) by HYANG #
        elide: {
            if(thirdTextElide=="Right"){Text.ElideRight}
            else if(thirdTextElide=="Left"){Text.ElideLeft}
            else if(thirdTextElide=="Center"){Text.ElideMiddle}
            else /*if(thirdTextElide=="None")*/{Text.ElideNone}
        } //jyjon_20120302
        visible: thirdTextVisible
	clip: true //jyjeon_20120221
        //****************************** # End #
        enabled: thirdTextEnabled // <<---------- Added by WSH (Enabled)
    }

    //Focus Image
    Image {
        anchors.fill: backGround
        id: idFocusImage
        source: bgImageFocus
        visible: showFocus && container.activeFocus
    }

    onSelectKeyPressed: (container.dimmed)? container.state="dimmed" : container.state="pressed"
    onSelectKeyReleased: (container.dimmed)? container.state="dimmed" : container.state="released"
    onStateChanged: {console.debug("---------------------------------->> onStateChanged :" + state)}
    onReleased: {container.state=="released";}

    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: backGround; source: bgImagePress;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
            PropertyChanges {target: idFocusImage; opacity: 0;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextPressColor;}
        },
        State {
            name: 'released'; when: container.state=="released"
            PropertyChanges {target: idFocusImage; opacity: 1;}
        },
        State {
            name: 'active'; when: container.active
            PropertyChanges {target: backGround; source: bgImageActive;}
            PropertyChanges {target: imgFgImage; source: fgImageActive;}
            PropertyChanges {target: idFocusImage; opacity: 1;}
            PropertyChanges {target: txtFirstText; color: firstTextSelectedColor;}
            PropertyChanges {target: txtSecondText; color: secondTextSelectedColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextSelectedColor;}
        },
        State {
            name: 'keyPress';
            PropertyChanges {target: backGround; source: bgImageFocusPress;}
            PropertyChanges {target: imgFgImage; source: fgImageFocusPress;}
            PropertyChanges {target: idFocusImage; opacity: 0;}
            PropertyChanges {target: txtFirstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextFocusPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextFocusPressColor;}
        },
        State {
            name: 'keyReless';
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: idFocusImage; opacity: 1;}
            PropertyChanges {target: txtFirstText; color: firstTextColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextPressColor;}
        },
        State {
            name: 'dimmed'; when: container.dimmed
            PropertyChanges {target: txtFirstText; color: firstDimmedTextColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: txtThirdText; color: thirdTextPressColor;}
        }
    ]
}

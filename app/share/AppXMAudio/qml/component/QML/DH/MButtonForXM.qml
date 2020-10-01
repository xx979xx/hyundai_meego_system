/**
 * FileName: MButton.qml
 * Author: Problem Kang
 * Time: 2012-02-03 11:20
 *
 * - 2012-02-03 Initial Crated by Problem Kang
 * - 2012-08-21 delete underText by HYANG
 * - 2012-08-22 change "Text" -> "MScrollText" (add ScrollEnable, ScrollInterval, ScrollOnewayMode) by HYANG
 * - 2013-01-03 Updated Component (MComponent.qml) by WSH
 * - 2013-01-03 Changed property (#TextDisable -> #TextEnabled) by WSH
 *    : # (first, second, third)
 * - 2013-01-03 Modified property value (#TextDisableColor) by WSH
 * - 2013-01-03 Deleted state ('dimmed') by WSH
 * - 2013-01-03 Modified state ('disabled') by WSH
 */

import Qt 4.7
import "../../QML/DH" as MComp

MComponent {
    id: container

    //****************************** # For active(button select) by HYANG #
    property bool active: false
    property string buttonName: ""
    property bool buttonEnabled: true  //# button enabled/disabled on/off - by HYANG (130128)
    enabled: buttonEnabled
    property bool bPlayBeepFlag: true

    //Button Image // by WSH
    property int buttonWidth: 0//: parent.width - problem Kang
    property int buttonHeight: 0//: parent.height - problem Kang
    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""
    property string bgImageFocusPress: ""

    //****************************** # Line Image
    property int lineImageX: 0
    property int lineImageY: 0
    property bool lineImageVisible: true
    property string lineImage:""
    property string lineImagePress: lineImage
    property string lineImageActive: lineImage
    property string lineImageFocus: lineImage
    property string lineImageFocusPress: lineImage

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
    property int firstTextSize: 0
    property int firstTextX: 0
    property int firstTextY: 0
    property int firstTextWidth: 0
    //property int firstTextHeight: firstTextSize//+10 // # because text position wrong by HYANG(120522)
    property string firstTextStyle: systemInfo.font_NewHDR
    property string firstTextAlies: "Left"
    property string firstTextVerticalAlies: "Center"
    //****************************** # For text (elide, visible) by HYANG #
    property string firstTextElide: "None"          //# Elide ("Left","Right","Center","None")  ex) "Right" >> ABCDEFG..
    property bool firstTextVisible: true            //# Visible (true, false)
    property bool firstTextScrollEnable: false      //# Scroll Enable (true, false)
    property int firstTextScrollInterval: 0         //# Scroll Move Interval (number high-slow, number low-fast)
    property bool firstTextScrollOnewayMode: true   //# Scroll OndewayModeFlag (true-one side, false-both side)
    //****************************** # End #
    property bool firstTextEnabled: true // true(enabled), false(disabled) <<-- Modified by WSH (130103)
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor : firstTextColor
    property string firstTextFocusPressColor : firstTextPressColor
    property string firstTextSelectedColor: "Black"
    property string firstTextDisableColor: colorInfo.disableGrey // <<--------- Modified by WSH (130103)
    property string firstTextFocusColor : firstTextColor  //# HYANG (121122)

    property bool focusImageVisible: idFocusImage.visible  //# for FocusText - HYANG (121122)
    opacity: enabled ? 1.0 : 0.5

    //Button Image // by WSH
    Image{
        id:backGround
        source: bgImage
    }

    //****************************** # Line Image
    Image {
        id: idLineImage
        x: lineImageX
        y: lineImageY
        source: lineImage
    }

    //*****# Focus Image - position move by HYANG (121029)
    Image {
        id: idFocusImage
        source: bgImageFocus
        visible: showFocus && container.activeFocus
    }

    Image {
        id: imgFgImage
        x: fgImageX
        y: fgImageY
        width: fgImageWidth
        height: fgImageHeight
        source: fgImage
        visible: fgImageVisible
    }

    MComp.DDScrollTicker{
        id: txtFirstText
        text: firstText
        x:firstTextX
        y:firstTextY -(firstTextSize) - (firstTextSize/4)
        width: firstTextWidth
        color: firstTextColor
        fontFamily: firstTextStyle
        fontSize: firstTextSize
        horizontalAlignment: {
            if(firstTextAlies=="Right"){Text.AlignRight}
            else if(firstTextAlies=="Left"){Text.AlignLeft}
            else if(firstTextAlies=="Center"){Text.AlignHCenter}
            else {Text.AlignHCenter}
        }
        verticalAlignment: {
            if(firstTextVerticalAlies == "Top"){Text.AlignTop}
            else if(firstTextVerticalAlies == "Bottom"){Text.AlignBottom}
            else if(firstTextVerticalAlies == "Center"){Text.AlignVCenter}
            else {Text.AlignVCenter}
        }
        visible: firstTextVisible
        tickerFocus: (container.activeFocus && idAppMain.focusOn)
    }

    onSelectKeyPressed: {
        if(container.mEnabled){
            console.log("[QML] MButton onSelectKeyPressed. state:"+ container.state);
            container.state="pressed";
        }else{
            container.state="disabled"
        }
    }

    onSelectKeyReleased: {
        if(container.mEnabled){
            if(active==true){
                container.state="active"
            }else{
                container.state="keyReless";
            }
        }else{
            container.state = "disabled"
        }
    }

    // ITS 233085
    onCancel: {
        if(container.mEnabled){
            if(container.state == "active" || container.state == "pressed"){
                container.state="keyReless";
            }
        }
    }

    onClickOrKeySelected: {
        console.debug("------ [MButton] [onClickOrKeySelected] ")
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch" && container.state!="disabled" && bPlayBeepFlag) idAppMain.playBeep();
    }

    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: backGround; source: bgImagePress;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
            PropertyChanges {target: idFocusImage; visible: false;}
        },
        State {
            name: 'active'; when: container.active
            PropertyChanges {target: backGround; source: bgImageActive;}
            PropertyChanges {target: imgFgImage; source: fgImageActive;}
            PropertyChanges {target: txtFirstText; color: firstTextSelectedColor;}
        },
        State {
            name: 'keyPress'; when: container.state=="keyPress" // problem Kang
            PropertyChanges {target: backGround; source: bgImageFocusPress;}
            PropertyChanges {target: imgFgImage; source: fgImageFocusPress;}
            PropertyChanges {target: txtFirstText; color: firstTextFocusPressColor;}
        },
        State {
            name: 'keyReless';
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: txtFirstText; color: focusImageVisible? firstTextFocusColor : firstTextColor;}
        },
        State {
            name: 'disabled'; when: !mEnabled; // Modified by WSH(130103)
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: txtFirstText; color: firstTextEnabled? firstTextColor : firstTextDisableColor;}
        }
    ]
}

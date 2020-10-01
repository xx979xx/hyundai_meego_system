/**
 * FileName: MButton.qml
 * Author: Problem Kang
 * Time: 2012-02-03 11:20
 *
 * - 2012-02-03 Initial Crated by Problem Kang
 * - 2012-08-21 delete underText by HYANG
 * - 2012-08-22 change "Text" -> "MScrollText" (add ScrollEnable, ScrollInterval, ScrollOnewayMode) by HYANG
 */

import Qt 4.7
//import "../DH" as MSystem
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES

DHAVN_AhaStationComponent{
    id: container

    //****************************** # For active(button select) by HYANG #
    property bool active: false
    property string buttonName: ""
    //****************************** # End #

    //Button Image // by WSH
    property int buttonWidth//: parent.width - problem Kang
    property int buttonHeight//: parent.height - problem Kang
    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""
    property string bgImageFocusPress: ""

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
    property int firstTextHeight: firstTextSize//+10 // # because text position wrong by HYANG(120522)
    property string firstTextStyle: "NewHDR"
    property string firstTextAlies: "Left"
    property string firstTextVerticalAlies: "Center"
    //****************************** # For text (elide, visible) by HYANG #
    property string firstTextElide: "None"          //# Elide ("Left","Right","Center","None")  ex) "Right" >> ABCDEFG..
    property bool firstTextVisible: true            //# Visible (true, false)
    property bool firstTextScrollEnable: false      //# Scroll Enable (true, false)
    property int firstTextScrollInterval: 0         //# Scroll Move Interval (number high-slow, number low-fast)
    property bool firstTextScrollOnewayMode: true   //# Scroll OndewayModeFlag (true-one side, false-both side)
    //****************************** # End #
    property bool firstTextEnabled: true // <<---------- Added by WSH (Enabled)
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor : firstTextColor
    property string firstTextFocusPressColor : firstTextPressColor
    property string firstTextSelectedColor: "Black"
    property string firstDimmedTextColor: colorInfo.dimmedGrey
    property string firstTextFocusColor : firstTextColor  //# HYANG (121122)

    //second Text Info
    property string secondText: ""
    property int secondTextSize: 0
    property int secondTextX: 0
    property int secondTextY: 0
    property int secondTextWidth: 0
    property int secondTextHeight: secondTextSize//+10
    property string secondTextStyle: "NewHDR"
    property string secondTextAlies: "Left"
    property string secondTextVerticalAlies: "Center"
    //****************************** # For text (elide, visible) by HYANG #
    property string secondTextElide: "None"         //# Elide ("Left","Right","Center","None")
    property bool secondTextVisible: true           //# Visible (true, false)
    property bool secondTextScrollEnable: false     //# Scroll Enable (true, false)
    property int secondTextScrollInterval: 0        //# Scroll Move Interval (number high-slow, number low-fast)
    property bool secondTextScrollOnewayMode: true  //# Scroll OndewayModeFlag (true-one side, false-both side)
    //****************************** # End #
    property bool secondTextEnabled: true // <<---------- Added by WSH (Enabled)
    property string secondTextColor: colorInfo.subTextGrey
    property string secondTextPressColor : secondTextColor
    property string secondTextFocusPressColor : secondTextPressColor
    property string secondTextSelectedColor: "Black"
    property string secondTextFocusColor : secondTextPressColor  //# HYANG (121122)

    //third Text Info
    property string thirdText: ""
    property int thirdTextSize: 0
    property int thirdTextX: 0
    property int thirdTextY: 0
    property int thirdTextWidth: 0
    property int thirdTextHeight: thirdTextSize+10
    property string thirdTextStyle: "NewHDR"
    property string thirdTextAlies: "Left"
    property string thirdTextVerticalAlies: "Center"
    //****************************** # For text by HYANG #
    property string thirdTextElide: "None"          //# Elide ("Left","Right","Center","None")
    property bool thirdTextVisible: true            //# Visible (true, false)
    property bool thirdTextScrollEnable: false      //# Scroll Enable (true, false)
    property int thirdTextScrollInterval: 0         //# Scroll Move Interval (number high-slow, number low-fast)
    property bool thirdTextScrollOnewayMode: true   //# Scroll OndewayModeFlag (true-one side, false-both side)
    //****************************** # End #
    property bool thirdTextEnabled: true // <<---------- Added by WSH (Enabled)
    property string thirdTextColor: colorInfo.subTextGrey
    property string thirdTextPressColor : thirdTextColor
    property string thirdTextFocusPressColor : thirdTextPressColor
    property string thirdTextSelectedColor: "Black"
    property string thirdTextFocusColor : thirdTextPressColor  //# HYANG (121122)

    //hsryu added
    property bool focusImageVisible: false//idFocusImage.activeFocus  //# for FocusText - HYANG (121122)
    property bool pressImageVisible: false  //wsuk.kim 130816 ITS_0182685 depress when pressed with CCP/Tune Knob
    opacity: enabled ? 1.0 : 0.5

    //Button Image // by WSH
    Image{
        id:backGround
        source: bgImage
        anchors.fill: parent
    }

    //*****# Focus Image - position move by HYANG (121029)
    Image {
        anchors.fill: backGround
        id: idFocusImage
        source: bgImageFocus
        visible: focusImageVisible//showFocus && container.activeFocus
    }

//wsuk.kim 130816 ITS_0182685 depress when pressed with CCP/Tune Knob
    Image {
        anchors.fill: backGround
        source: bgImageFocusPress
        visible: pressImageVisible
    }
//wsuk.kim 130816 ITS_0182685 depress when pressed with CCP/Tune Knob

    //Image inside Button // by WSH
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
    DHAVN_AhaStationScrollText{   //# change from "Text" to "MScrollText" by HYANG
        id: txtFirstText
        text: firstText
        x:firstTextX
        y:firstTextY-(firstTextSize/2) - (firstTextSize/8) //# - (firstTextSize/8) Text(Alphabet "g") truncation problem by HYANG (0620)
        width: firstTextWidth
        height: firstTextHeight + (firstTextSize/4)  //# + (firstTextSize/4) - Text(Alphabet "g") truncation problem by HYANG (0620)
        textColor: firstTextColor
        fontfamily: firstTextStyle
        fontpixelSize: firstTextSize
        verticalAlignment:{ //jyjon_2012-08-02
            if(firstTextVerticalAlies == "Top"){Text.AlignTop}
            else if(firstTextVerticalAlies == "Bottom"){Text.AlignBottom}
            else if(firstTextVerticalAlies == "Center"){Text.AlignVCenter}
            else {Text.AlignVCenter}
        }
        horizontalAlignment: {
            if(firstTextAlies=="Right"){Text.AlignRight}
            else if(firstTextAlies=="Left"){Text.AlignLeft}
            else if(firstTextAlies=="Center"){Text.AlignHCenter}
            else {Text.AlignHCenter}
        }
        //****************************** # For text (scroll Enable, scroll move interval, scroll way mode, elide, visible) by HYANG #
        scrollEnable: firstTextScrollEnable
        interval: firstTextScrollInterval
        onewayMode: firstTextScrollOnewayMode
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
    DHAVN_AhaStationScrollText{   //# change from "Text" to "MScrollText" by HYANG
        id: txtSecondText
        text: secondText
        x:secondTextX
        y:secondTextY-(secondTextSize/2) - (secondTextSize/8)
        width: secondTextWidth
        height: secondTextHeight + (secondTextSize/4)
        textColor: secondTextColor
        fontfamily: secondTextStyle
        fontpixelSize: secondTextSize
        verticalAlignment:{ //jyjon_2012-08-02
            if(secondTextVerticalAlies == "Top"){Text.AlignTop}
            else if(secondTextVerticalAlies == "Bottom"){Text.AlignBottom}
            else if(secondTextVerticalAlies == "Center"){Text.AlignVCenter}
            else {Text.AlignVCenter}
        }

        horizontalAlignment: {
            if(secondTextAlies=="Right"){Text.AlignRight}
            else if(secondTextAlies=="Left"){Text.AlignLeft}
            else if(secondTextAlies=="Center"){Text.AlignHCenter}
            else {Text.AlignHCenter}
        } //jyjon_20120302

        //****************************** # For text (scroll Enable, scroll move interval, scroll way mode, elide, visible) by HYANG #
        scrollEnable: secondTextScrollEnable
        interval: secondTextScrollInterval
        onewayMode: secondTextScrollOnewayMode
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
    DHAVN_AhaStationScrollText{   //# change from "Text" to "MScrollText" by HYANG
        id: txtThirdText
        text: thirdText
        x:thirdTextX
        y:thirdTextY-(thirdTextSize/2) - (thirdTextSize/8)
        width: thirdTextWidth
        height: thirdTextHeight + (thirdTextSize/4)
        textColor: thirdTextColor
        fontfamily: thirdTextStyle
        fontpixelSize: thirdTextSize
        verticalAlignment:{ //jyjon_2012-0802
            if(thirdTextVerticalAlies == "Top"){Text.AlignTop}
            else if(thirdTextVerticalAlies == "Bottom"){Text.AlignBottom}
            else if(thirdTextVerticalAlies == "Center"){Text.AlignVCenter}
            else {Text.AlignVCenter}
        }
        horizontalAlignment: {
            if(thirdTextAlies=="Right"){Text.AlignRight}
            else if(thirdTextAlies=="Left"){Text.AlignLeft}
            else if(thirdTextAlies=="Center"){Text.AlignHCenter}
            else {Text.AlignHCenter}
        } //jyjon_20120302
        //****************************** # For text (scroll Enable, scroll move interval, scroll way mode, elide, visible) by HYANG #
        scrollEnable: thirdTextScrollEnable
        interval: thirdTextScrollInterval
        onewayMode: thirdTextScrollOnewayMode
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

    onSelectKeyPressed: {
        if(container.dimmed){
            container.state="dimmed";
        }else if(container.mEnabled) {
            console.log("[QML] MButton onSelectKeyPressed. state:"+ container.state);
            container.state="keyPress";
        }else{
            container.state="disabled"
        }
    }

    onSelectKeyReleased: {
        if(container.dimmed){
            container.state="dimmed"
        }else if(container.mEnabled){
            if(active==true){
                container.state="active"
            }else{
                container.state="keyReless";
            }
        }else{
            container.state = "disabled"
        }
    }

    //jyjeon_20120723 : move from MComponent [[
    onClickOrKeySelected: {
        console.debug("------ [MButton] [onClickOrKeySelected] ")
        if(playBeepOn && container.state!="disabled") idAppMain.playBeep();
        //event.accepted = true; //jyjeon_20120606
    }

    onPressAndHold: {
        console.debug("------ [MButton] [onPressAndHold] ")
        if(playBeepOn && container.state!="disabled") idAppMain.playBeep();
        //event.accepted = true; //jyjeon_20120606
    }
    //jyjeon_20120723 ]]

    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: backGround; source: bgImagePress;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
//            PropertyChanges {target: txtFirstText; textColor: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY;}
//            PropertyChanges {target: txtSecondText; textColor: secondTextPressColor;}
//            PropertyChanges {target: txtThirdText; textColor: thirdTextPressColor;}
            PropertyChanges {target: txtFirstText; textColor: firstTextPressColor;}
            PropertyChanges {target: txtSecondText; textColor: secondTextPressColor;}
            PropertyChanges {target: txtThirdText; textColor: thirdTextPressColor;}
        },
        State {
            name: 'active'; when: container.active
            PropertyChanges {target: backGround; source: bgImageActive;}
            PropertyChanges {target: imgFgImage; source: fgImageActive;}
            PropertyChanges {target: txtFirstText; textColor: firstTextSelectedColor;}
            PropertyChanges {target: txtSecondText; textColor: secondTextSelectedColor;}
            PropertyChanges {target: txtThirdText; textColor: thirdTextSelectedColor;}
        },
        State {
            name: 'keyPress'; when: container.state=="keyPress" // problem Kang
            PropertyChanges {target: backGround; source: bgImageFocusPress;}
            PropertyChanges {target: imgFgImage; source: fgImageFocusPress;}
            PropertyChanges {target: txtFirstText; textColor: firstTextFocusPressColor;}
            PropertyChanges {target: txtSecondText; textColor: secondTextFocusPressColor;}
            PropertyChanges {target: txtThirdText; textColor: thirdTextFocusPressColor;}
        },
        State {
            name: 'keyReless';
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: txtFirstText; textColor: focusImageVisible? firstTextFocusColor : firstTextColor;}
            PropertyChanges {target: txtSecondText; textColor: focusImageVisible? secondTextFocusColor : secondTextPressColor;}
            PropertyChanges {target: txtThirdText; textColor: focusImageVisible? thirdTextFocusColor : thirdTextPressColor;}
        },
        State {
            name: 'dimmed'; when: container.dimmed
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: txtFirstText; textColor: firstDimmedTextColor;}
            PropertyChanges {target: txtSecondText; textColor: secondTextPressColor;}
            PropertyChanges {target: txtThirdText; textColor: thirdTextPressColor;}
        },
        State {
            name: 'disabled'; when: !mEnabled;//!container.enabled
//            PropertyChanges {target: txtFirstText; textColor: PR.const_AHA_COLOR_TEXT_DIMMED_GREY;}
//            PropertyChanges {target: txtSecondText; textColor: colorInfo.brightGrey;}
//            PropertyChanges {target: txtThirdText; textColor: thirdTextPressColor;}
            PropertyChanges {target: txtFirstText; textColor: colorInfo.disableGrey;}
            PropertyChanges {target: txtSecondText; textColor: colorInfo.brightGrey;}
            PropertyChanges {target: txtThirdText; textColor: thirdTextPressColor;}
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
        }
    ]
}




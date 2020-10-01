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

import QtQuick 1.1

MComponent {
    id: container

    //****************************** # For active(button select) by HYANG #
    property bool bPlayBeepFlag: true
    property alias buttonfirsttextCount : txtFirstText
    property bool active: false
    property string buttonName: ""
    property bool buttonEnabled: true  //# button enabled/disabled on/off - by HYANG (130128)
    //enabled: buttonEnabled
    mEnabled: buttonEnabled

    //Button Image // by WSH
    property int buttonWidth: 0//: parent.width - problem Kang
    property int buttonHeight: 0//: parent.height - problem Kang
    property int bgImageZ: 0
    property bool backGroundtopVisible: false
    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""
    property string bgImageFocusPress: ""

    //Image inside Button // by WSH
    property int fgImageX: 0
    property int fgImageY: 0
    property int fgImageZ: 0
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

    property int secondImageX: 0
    property int secondImageY: 0
    property int secondImageWidth: 0
    property int secondImageHeight: 0
    property bool secondImageVisible: true

    property string secondImage:""
    property string secondImagePress: secondImage
    property string secondImageActive: secondImage
    property string secondImageFocus: secondImage
    property string secondImageFocusPress: secondImage
    //first Text Info
    property string firstText: ""
    property int firstTextSize: 0
    property int firstTextX: 0
    property int firstTextY: 0
    property int firstTextZ: 0
    property int firstTextWidth: 0
    property string firstTextStyle: systemInfo.font_NewHDR
    property string firstTextAlies: "Left"
    property string firstTextVerticalAlies: "Center"
    //****************************** # For text (elide, visible) by HYANG #
    property string firstTextElide: "None"          //# Elide ("Left","Right","Center","None")  ex) "Right" >> ABCDEFG..
    property bool firstTextVisible: true            //# Visible (true, false)
    property bool firstTextScrollEnable: false      //# Scroll Enable (true, false)
    property int firstTextScrollInterval: 0         //# Scroll Move Interval (number high-slow, number low-fast)
    property bool firstTextScrollOnewayMode: true   //# Scroll OndewayModeFlag (true-one side, false-both side)
    property bool firstTextWrapMode: false
    //****************************** # End #
    property bool firstTextEnabled: true // true(enabled), false(disabled) <<-- Modified by WSH (130103)
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor : firstTextColor
    property string firstTextFocusPressColor : firstTextPressColor
    property string firstTextSelectedColor: "Black"
    property string firstTextDisableColor: colorInfo.disableGrey // <<--------- Modified by WSH (130103)
    property string firstTextFocusColor : firstTextColor  //# HYANG (121122)

    //second Text Info
    property string secondText: ""
    property int secondTextSize: 0
    property int secondTextX: 0
    property int secondTextY: 0
    property int secondTextWidth: 0
    //property int secondTextHeight: secondTextSize//+10
    property string secondTextStyle: systemInfo.font_NewHDR
    property string secondTextAlies: "Left"
    property string secondTextVerticalAlies: "Center"
    //****************************** # For text (elide, visible) by HYANG #
    property string secondTextElide: "None"         //# Elide ("Left","Right","Center","None")
    property bool secondTextVisible: true           //# Visible (true, false)
    property bool secondTextScrollEnable: false     //# Scroll Enable (true, false)
    property int secondTextScrollInterval: 0        //# Scroll Move Interval (number high-slow, number low-fast)
    property bool secondTextScrollOnewayMode: true  //# Scroll OndewayModeFlag (true-one side, false-both side)
    property bool secondTextWrapMode: false
    //****************************** # End #
    property bool secondTextEnabled: true // true(enabled), false(disabled) <<--- Wrote Comment by WSH (130103)
    property string secondTextColor: colorInfo.subTextGrey
    property string secondTextPressColor : secondTextColor
    property string secondTextFocusPressColor : secondTextPressColor
    property string secondTextSelectedColor: "Black"
    property string secondTextDisableColor: colorInfo.disableGrey // <<--------- Modified by WSH (130103)
    property string secondTextFocusColor : secondTextPressColor  //# HYANG (121122)

    property bool focusImageVisible: container.activeFocus   //# for FocusText - HYANG (121122)
    opacity: enabled ? 1.0 : 0.5

    onActiveFocusChanged: {
        if((activeFocus == false) &&(container.state=="pressed"))
        {
            container.state = "keyReless";
        }
        else if(activeFocus == true)
        {
            if ( !(idAppMain.gSXMSaveAsPreset == "TRUE" || idAppMain.gSXMEditPresetOrder == "TRUE"))
            {
                if(container.mEnabled)
                {
                    if(active==true)
                    {
                        container.state="active"
                    }
                    else
                    {
                        container.state= "keyReless";
                    }
                }
                else
                {
                    container.state = "disabled"
                }
            }
        }
    }

    function settingWidth()
    {
        if(buttonWidth != 0)
            return buttonWidth;
    }

    //Button Image // by WSH
    Image{
        id:backGround
        width: settingWidth()
        z: bgImageZ;
        source: bgImage
        visible: (backGround.source != "")
    }

    //*****# Focus Image - position move by HYANG (121029)
    Image {
        //anchors.fill: backGround
        id: idFocusImage
        source: bgImageFocus
        visible: showFocus && container.activeFocus
    }

    Image {
        id: backGroundtop
        visible: backGroundtopVisible
    }

    //Image inside Button // by WSH
    Image {
        id: imgFgImage
        x: fgImageX
        y: fgImageY
        z: fgImageZ
        width: fgImageWidth
        height: fgImageHeight
        source: fgImage
        visible: fgImageVisible
    }

    Image {
        id: imgSecondImage
        x: secondImageX
        y: secondImageY
        width: secondImageWidth
        height: secondImageHeight
        source: secondImage
        visible: secondImageVisible
    }

    //First Text
    Text {   //# change from "Text" to "MScrollText" by HYANG
        id: txtFirstText
        text: firstText
        x: firstTextX
        y: firstTextY - (firstTextSize/2) - 2
        z: firstTextZ
        width: firstTextWidth
        height: (firstTextWrapMode == true && lineCount == 2) ? (firstTextSize*2 + firstTextSize/2 + 4) : (firstTextSize + 4)
        color: (showFocus && container.activeFocus) ? colorInfo.brightGrey : firstTextColor
        font.family: firstTextStyle
        font.pixelSize: firstTextSize
        verticalAlignment: { //jyjon_2012-08-02
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
        //        scrollEnable: firstTextScrollEnable
        //        interval: firstTextScrollInterval
        //        onewayMode: firstTextScrollOnewayMode
        elide: {
            if(firstTextElide=="Right"){Text.ElideRight}
            else if(firstTextElide=="Left"){Text.ElideLeft}
            else if(firstTextElide=="Center"){Text.ElideMiddle}
            else /*if(firstTextElide=="None")*/{Text.ElideNone}
        }
        wrapMode: (firstTextWrapMode == true) ? Text.WordWrap : Text.NoWrap
        visible: firstTextVisible
        clip: true //jyjeon_20120221
        //****************************** # End #
        enabled: firstTextEnabled // <<---------- Added by WSH (Enabled)
    }

    //Second Text
    Text {   //# change from "Text" to "MScrollText" by HYANG
        id: txtSecondText
        text: secondText
        x: secondTextX
        y: secondTextY - (secondTextSize/2) - 2
        width: secondTextWidth
        height: secondTextSize + 4
        color: secondTextColor
        font.family: secondTextStyle
        font.pixelSize: secondTextSize
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
        //        scrollEnable: secondTextScrollEnable
        //        interval: secondTextScrollInterval
        //        onewayMode: secondTextScrollOnewayMode
        elide: {
            if(secondTextElide=="Right"){Text.ElideRight}
            else if(secondTextElide=="Left"){Text.ElideLeft}
            else if(secondTextElide=="Center"){Text.ElideMiddle}
            else /*if(secondTextElide=="None")*/{Text.ElideNone}
        } //jyjon_20120302
        wrapMode: (secondTextWrapMode == true) ? Text.WordWrap : Text.NoWrap
        visible: secondTextVisible
        clip: true //jyjeon_20120221
        //****************************** # End #
        enabled: secondTextEnabled // <<---------- Added by WSH (Enabled)
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
                container.state= "keyReless";
            }
        }else{
            container.state = "disabled"
        }
    }

    onClickOrKeySelected: {
        console.debug("------ [MButton] [onClickOrKeySelected] ")
        if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch" && container.state!="disabled" && bPlayBeepFlag) idAppMain.playBeep();
    }

    onCancel:{ // WSH 130806
        if(container.mEnabled == false) return;
        if( (idAppMain.presetSaveEnabled == true || idAppMain.presetEditEnabled == true) && (buttonName != "") ) return;

        if(active==true){
            container.state="active"
        }else{
            container.state="keyReless";
        }
    }

    Connections{
        target: idAppMain
        onCancelInstantBtnImag:{
            console.debug("------ [QML] [onCancelInstantBtnImag] container.state = "+ container.state + ",  container.active = "+ container.active)
            if(container.mEnabled == false) return;
            if( (idAppMain.presetSaveEnabled == true || idAppMain.presetEditEnabled == true) && (buttonName != "") ) return;

            if(container.state =="pressed")
            {
                backGround.source = bgImage;
                imgFgImage.source = fgImage;
                //                container.state="keyReless";
            }
        }
    }

    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: backGround; source: bgImagePress;z:-1}
            PropertyChanges {target: backGroundtop; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: idFocusImage; visible: false;}
            //            PropertyChanges {target: txtThirdText; color: thirdTextPressColor;}
        },
        State {
            name: 'active'; when: container.active
            PropertyChanges {target: backGround; source: bgImageActive;}
            PropertyChanges {target: imgFgImage; source: fgImageActive;}
            PropertyChanges {target: txtFirstText; color: firstTextSelectedColor;}
            PropertyChanges {target: txtSecondText; color: secondTextSelectedColor;}
            //            PropertyChanges {target: txtThirdText; color: thirdTextSelectedColor;}
        },
        State {
            name: 'keyPress'; when: container.state=="keyPress" // problem Kang
            PropertyChanges {target: backGround; source: bgImageFocusPress;}
            PropertyChanges {target: imgFgImage; source: fgImageFocusPress;}
            PropertyChanges {target: txtFirstText; color: firstTextFocusPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextFocusPressColor;}
            //            PropertyChanges {target: txtThirdText; color: thirdTextFocusPressColor;}
        },
        State {
            name: 'keyReless';
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: txtFirstText; color: focusImageVisible? firstTextFocusColor : firstTextColor;}
            PropertyChanges {target: txtSecondText; color: focusImageVisible? secondTextFocusColor : secondTextPressColor;}
            //            PropertyChanges {target: txtThirdText; color: focusImageVisible? thirdTextFocusColor : thirdTextPressColor;}
        },
        State {
            name: 'disabled'; when: !mEnabled; // Modified by WSH(130103)
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: txtFirstText; color: mEnabled? firstTextColor : firstTextDisableColor;}
            PropertyChanges {target: txtSecondText; color: mEnabled? secondTextColor : secondTextDisableColor;}
            //            PropertyChanges {target: txtThirdText; color: mEnabled? thirdTextColor : thirdTextDisableColor;}
        }
    ]
}




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
import "../../system/DH" as MSystem

MComponent {
    id: container

    //****************************** # For active(button select) by HYANG #
    property bool active: false
    property string buttonName: ""
    property bool buttonEnabled: true  //# button enabled/disabled on/off - by HYANG (130128)
    //enabled: buttonEnabled
    mEnabled: buttonEnabled

    //Button Image // by WSH
    property int buttonWidth//: parent.width - problem Kang
    property int buttonHeight//: parent.height - problem Kang
    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""
    property string bgImageFocusPress: ""
    //// 2013.10.30 qutiguy : ITS0198902
    property int bgImageFocusY: 0

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

    property bool changedTextDisabledColor: false // <<--------- Modified by dg.jin (140325 for kh)

    //first Text Info
    property string firstText: ""
    property int firstTextSize: 0
    property int firstTextX: 0
    property int firstTextY: 0
    property int firstTextWidth: 0
    property int firstTextHeight: firstTextSize//+10 // # because text position wrong by HYANG(120522)
    property string firstTextStyle: systemInfo.hdr//"HDR"
    property string firstTextAlies: "Left"
    property string firstTextVerticalAlies: "Center"
    //****************************** # For text (elide, visible) by HYANG #
    property string firstTextElide: "None"          //# Elide ("Left","Right","Center","None")  ex) "Right" >> ABCDEFG..
    property bool firstTextVisible: true            //# Visible (true, false)
    //****************************** # End #
    property bool firstTextEnabled: true // true(enabled), false(disabled) <<-- Modified by WSH (130103)
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor : firstTextColor
    property string firstTextFocusPressColor : firstTextPressColor
    property string firstTextSelectedColor: "Black"
    //property string firstTextDisabledColor: changedTextDisabledColor ? colorInfo.presetlistGrey : colorInfo.disableGrey // <<--------- Modified by dg.jin (140325 for kh)
    property string firstTextDisabledColor: colorInfo.disableGrey
    property string firstTextFocusColor : firstTextColor  //# HYANG (121122)

    //second Text Info
    property string secondText: ""
    property int secondTextSize: 0
    property int secondTextX: 0
    property int secondTextY: 0
    property int secondTextWidth: 0
    property int secondTextHeight: secondTextSize//+10
    property string secondTextStyle: systemInfo.hdr//"HDR"
    property string secondTextAlies: "Left"
    property string secondTextVerticalAlies: "Center"

    //****************************** # For text (elide, visible) by HYANG #
    property string secondTextElide: "None"         //# Elide ("Left","Right","Center","None")
    property bool secondTextVisible: true           //# Visible (true, false)
    //****************************** # End #
    property bool secondTextEnabled: true // true(enabled), false(disabled) <<--- Wrote Comment by WSH (130103)
    property string secondTextColor: colorInfo.subTextGrey
    property string secondTextPressColor : secondTextColor
    property string secondTextFocusPressColor : secondTextPressColor
    property string secondTextSelectedColor: "Black"
    //property string secondTextDisabledColor: changedTextDisabledColor ? colorInfo.presetlistGrey : colorInfo.disableGrey // <<--------- Modified by dg.jin (140325 for kh)
    property string secondTextDisabledColor: colorInfo.disableGrey
    property string secondTextFocusColor : secondTextPressColor  //# HYANG (121122)

    //third Text Info
    property string thirdText: ""
    property int thirdTextSize: 0
    property int thirdTextX: 0
    property int thirdTextY: 0
    property int thirdTextWidth: 0
    property int thirdTextHeight: thirdTextSize+10
    property string thirdTextStyle: systemInfo.hdr//"HDR"
    property string thirdTextAlies: "Left"
    property string thirdTextVerticalAlies: "Center"
    //****************************** # For text by HYANG #
    property string thirdTextElide: "None"          //# Elide ("Left","Right","Center","None")
    property bool thirdTextVisible: true            //# Visible (true, false)
    //****************************** # End #
    property bool thirdTextEnabled: true // true(enabled), false(disabled) <<--- Wrote Comment by WSH (130103)
    property string thirdTextColor: colorInfo.subTextGrey
    property string thirdTextPressColor : thirdTextColor
    property string thirdTextFocusPressColor : thirdTextPressColor
    property string thirdTextSelectedColor: "Black"
    //property string thirdTextDisabledColor: changedTextDisabledColor ? colorInfo.presetlistGrey : colorInfo.disableGrey // <<--------- Modified by dg.jin (140325 for kh)
    property string thirdTextDisabledColor: colorInfo.disableGrey
    property string thirdTextFocusColor : thirdTextPressColor  //# HYANG (121122)

    property bool focusImageVisible: idFocusImage.visible  //# for FocusText - HYANG (121122)
    property bool presetScan        : false // JSH 130122

    //dg.jin 20140822 ITS 0246233, 0246234 Scrll no stop for Touch and CCP press
    property bool focusImageVisibleOrPress: (idFocusImage.visible || isMousePressed() || (container.state == "pressed") || (container.state == "keyPress")) //dg.jin 20140813 ITS 0245258 focuss issue for KH

    opacity: enabled ? 1.0 : 0.5

    property bool firstTextScrollEnable : false;     //# Scroll Enable (true, false)
    property bool secondTextScrollEnable: false;     //# Scroll Enable (true, false)
    property bool thirdTextScrollEnable : false;     //# Scroll Enable (true, false)
    property int  scrollTextSpacing     : 120;

    //dg.jin 20140820 ITS 0243389 full focus issue for KH
    property bool isoptionmenuline : false;
    property int optionmenuLineY : 0;
    property int optionmenuLineHeight : 0;
    property string optionmenuLineImg : "";

    property bool tunePressButton: false;  //dg.jin 20141007 band tune press issue

    //property int  bgImageY              : 0          // JSH 130802 TEST

    //dg.jin 20140820 ITS 0243389 full focus issue for KH
    //--------------------- Line Image #
    Image {
        id: imgLine
        y: optionmenuLineY
        height: optionmenuLineHeight
        source: optionmenuLineImg
        visible: isoptionmenuline
    } // End Imgae 
    
    //Button Image // by WSH
    Image{
        id:backGround
        //y:bgImageY   // JSH 130802 TEST
        //dg.jin 20140929 station list press image y error
        y: bgImageFocusY
        source: bgImage
        //anchors.fill: parent // JSH 130426 Delete
    }

    //*****# Focus Image - position move by HYANG (121029)
    Image {
        //anchors.fill: backGround // JSH 130426 Delete
        id: idFocusImage
        //y:bgImageY   // JSH 130802 TEST
        //// 2013.10.30 qutiguy : ITS0198902
        y: bgImageFocusY
        source: bgImageFocus
        visible: showFocus && container.activeFocus && (!showPopup) //dg.jin 20140901 ITS 247202 focus issue
    }

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

    Image {
        id: imgSecondImage
        x: secondImageX
        y: secondImageY
        width: secondImageWidth
        height: secondImageHeight
        source: secondImage
        visible: secondImageVisible
    }

    //dg.jin 20141111 del presetscan text animation DH_PE
    //****************************** # Preset Scan Animation # JSH 130121
    //SequentialAnimation{
    //    id: aniPresetScan
    //    running:presetScan
    //    onRunningChanged: {
    //        if(!running){
    //            idTextArea.visible = true;
    //            idTextArea.opacity = 1.0;
    //        }
    //    }
    //    loops: Animation.Infinite
        //        NumberAnimation { target: idTextArea; property: "opacity"; to: 1.0; duration: 500 }
        //        NumberAnimation { target: idTextArea; property: "opacity"; to: 0.0; duration: 500 }
    //    NumberAnimation{ target: idTextArea; property: "opacity";  to: 0.0; duration: 250 }
    //    PauseAnimation { duration: 250;}
    //    NumberAnimation{ target: idTextArea; property: "opacity"; to: 1.0;  duration: 250 }
    //    PauseAnimation { duration: 250;}
    //}


    /////////////////////////////////////////////////////////////////////////////////////
    Item {
        id:idTextArea
        //****************************** # First Text
        MTickerText{
            id: idFirstTextItem
            x: firstTextX           ; y: firstTextY-(firstTextSize/2) - (firstTextSize/8)
            width: firstTextWidth   ; height: firstTextSize + (firstTextSize/4)
            tickerTextSpacing   : scrollTextSpacing
            tickerEnable        : firstTextScrollEnable && overTextPaintedWidth
            tickerText          : firstText
            tickerTextSize      : firstTextSize
            tickerTextColor     : firstTextColor
            tickerTextStyle     : firstTextStyle
            tickerTextAlies     : firstTextAlies
        }
        //****************************** # Second Text
        MTickerText{
            id: idSecondTextItem
            x: secondTextX           ; y: secondTextY-(secondTextSize/2) - (secondTextSize/8)
            width: secondTextWidth   ; height: secondTextSize + (secondTextSize/4)
            tickerTextSpacing   : scrollTextSpacing
            tickerEnable        : secondTextScrollEnable && overTextPaintedWidth
            tickerText          : secondText
            tickerTextSize      : secondTextSize
            tickerTextColor     : secondTextColor
            tickerTextStyle     : secondTextStyle
            tickerTextAlies     : secondTextAlies
        }
        //****************************** # Third Text
        MTickerText{
            id: idThirdTextItem
            x: thirdTextX           ; y: thirdTextY-(thirdTextSize/2) - (thirdTextSize/8)
            width: thirdTextWidth   ; height: thirdTextSize + (thirdTextSize/4)
            tickerTextSpacing   : scrollTextSpacing
            tickerEnable        : thirdTextScrollEnable && overTextPaintedWidth
            tickerText          : thirdText
            tickerTextSize      : thirdTextSize
            tickerTextColor     : thirdTextColor
            tickerTextStyle     : thirdTextStyle
            tickerTextAlies     : thirdTextAlies
        }
    }

    onSelectKeyPressed: {
        if(tunePressButton == true)  //dg.jin 20141007 band tune press issue
        {
            return;
        }
        if(container.mEnabled) {
            console.log("[QML] MButton onSelectKeyPressed. state:"+ container.state);
            container.state = "pressed"; //container.state="keyPress";
        } else {
            container.state = "disabled"
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

    onClickOrKeySelected: {
        console.debug("------ [MButton] [onClickOrKeySelected] ")
        if(playBeepOn && container.state!="disabled")
        {
            idAppMain.playBeep();
            //UIListener.writeToLogFile("playBeep MButtonOnlyRadio1");
        }
    }

    onActiveFocusChanged: {
        if(container.activeFocus == false && container.state == "pressed"){
            //container.state = "normal"
            if(active==true){ // JSH 130802 modify
                container.state="active"
            }else{
                container.state="keyReless";
            }
        }
    }
    onCancel:{ // JSH 130609
        if(!mEnabled)
            return;

        if(idAppMain.presetSaveEnabled || idAppMain.presetEditEnabled){ // JSH 130718
            if(buttonName != "")
                return;
        }

        if(active==true){ // JSH 130802 modify
            container.state="active";
        }else{
            container.state="keyReless";
        }
//        if(container.activeFocus)
//            container.state = "keyReless"
//        else
//            container.state = "normal"
    }

    states: [
        State {
            name: 'normal';
            PropertyChanges {target: backGround; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: idFirstTextItem ; tickerTextColor: firstTextColor;}
            PropertyChanges {target: idSecondTextItem; tickerTextColor: secondTextColor;}
            PropertyChanges {target: idThirdTextItem; tickerTextColor: thirdTextColor;}
        },
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: backGround;    source  : bgImagePress;}
            PropertyChanges {target: imgFgImage;    source  : fgImagePress;}
            PropertyChanges {target: idFirstTextItem ;tickerTextColor   : firstTextPressColor;}
            PropertyChanges {target: idSecondTextItem; tickerTextColor   : secondTextPressColor;}
            PropertyChanges {target: idThirdTextItem; tickerTextColor: thirdTextPressColor;}
            PropertyChanges { target: idFocusImage;     visible: false; }
        },
        State {
            name: 'active'; when: container.active
            PropertyChanges {target: backGround;    source  : bgImageActive;}
            PropertyChanges {target: imgFgImage;    source  : fgImageActive;}
            PropertyChanges {target: idFirstTextItem;  tickerTextColor   : firstTextSelectedColor;}
            PropertyChanges {target: idSecondTextItem; tickerTextColor   : secondTextSelectedColor;}
            PropertyChanges {target: idThirdTextItem; tickerTextColor    : thirdTextSelectedColor;}
        },
        State {
            name: 'keyPress'; when: container.state=="keyPress" // problem Kang
            PropertyChanges {target: backGround;    source  : bgImageFocusPress;}
            PropertyChanges {target: imgFgImage;    source  : fgImageFocusPress;}
            PropertyChanges {target: idFirstTextItem;  tickerTextColor   : firstTextFocusPressColor;}
            PropertyChanges {target: idSecondTextItem; tickerTextColor   : secondTextFocusPressColor;}
            PropertyChanges {target: idThirdTextItem; tickerTextColor: thirdTextFocusPressColor;}
        },
        State {
            name: 'keyReless';
            PropertyChanges {target: backGround;    source  : bgImage;}
            PropertyChanges {target: imgFgImage;    source  : fgImage;}
            PropertyChanges {target: idFirstTextItem;  tickerTextColor   : focusImageVisible? firstTextFocusColor : firstTextColor;}
            PropertyChanges {target: idSecondTextItem; tickerTextColor   : focusImageVisible? secondTextFocusColor : secondTextColor;}  //dg.jin 140603 ITS 0239204 KH Text color error
            PropertyChanges {target: idThirdTextItem; tickerTextColor: focusImageVisible? thirdTextFocusColor : thirdTextColor;} //dg.jin 140611 ITS 0239952 KH Text color error
        },
        State {
            name: 'disabled'; when: !mEnabled; // Modified by WSH(130103)
            PropertyChanges {target: backGround;    source  : bgImage;}
            PropertyChanges {target: imgFgImage;    source  : fgImage;}
            PropertyChanges {target: idFirstTextItem;  tickerTextColor   : mEnabled? firstTextColor : firstTextDisabledColor;}
            PropertyChanges {target: idSecondTextItem; tickerTextColor   : mEnabled? secondTextColor : secondTextDisabledColor;}
            PropertyChanges {target: idThirdTextItem; tickerTextColor: mEnabled? thirdTextColor : thirdTextDisabledColor;}
        }
    ]
}




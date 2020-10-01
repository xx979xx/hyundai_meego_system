/**
 * FileName: MButton.qml
 * Author: Problem Kang
 * Time: 2012-02-03 11:20
 *
 * - 2012-02-03 Initial Crated by Problem Kang
 * - 2013-05-16 Add Scroll Ticker Text
 */

import Qt 4.7
import "../../system/DH" as MSystem

MComponent {
    id: idMButton

    //****************************** # For active(button select)
    property bool active: false
    property string buttonName: ""
    property bool buttonEnabled: true  //# button enabled/disabled on/off
    mEnabled: buttonEnabled

    //****************************** # Button Image
    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""
    property string bgImageFocusPress: ""

    property string bgImageTop: ""

    //****************************** # Line Image
    property int lineImageX: 0
    property int lineImageY: 0
    property bool lineImageVisible: true
    property string lineImage:""
    property string lineImagePress: lineImage
    property string lineImageActive: lineImage
    property string lineImageFocus: lineImage
    property string lineImageFocusPress: lineImage

    //****************************** # Icon Image in Button
    property int fgImageX: 0
    property int fgImageY: 0  
    property int fgImageWidth: 0
    property int fgImageHeight: 0
    property bool fgImageVisible: true   
    property string fgImage:""
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: fgImage
    property string fgImageFocusPress: fgImage

    //****************************** # First Text Info
    property string firstText: ""
    property int firstTextSize: 0
    property int firstTextX: 0
    property int firstTextY: 0
    property int firstTextWidth: 0
    // property int firstTextHeight: firstTextSize
    property string firstTextStyle: idAppMain.fonts_HDR
    property string firstTextAlies: "Left"
    property string firstTextVerticalAlies: "Center"     
    property string firstTextElide: "None"
    property bool firstTextVisible: true
    property bool firstTextEnabled: true // true(enabled), false(disabled)
    property bool firstTextWrapMode: false;
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor : firstTextColor
    property string firstTextFocusPressColor : firstTextPressColor
    property string firstTextSelectedColor: firstTextColor
    property string firstTextDisableColor: colorInfo.disableGrey
    property string firstTextFocusColor : firstTextColor
    property int    firstTextPaintedHeight: idFirstTextItem.tickerPaintedHeight

    //****************************** # second Text Info
    property string secondText: ""
    property int secondTextSize: 0
    property int secondTextX: 0
    property int secondTextY: 0
    property int secondTextWidth: 0
    //property int secondTextHeight: secondTextSize
    property string secondTextStyle: idAppMain.fonts_HDR
    property string secondTextAlies: "Left"
    property string secondTextVerticalAlies: "Center"
    property string secondTextElide: "None"
    property bool secondTextVisible: true
    property bool secondTextEnabled: true // true(enabled), false(disabled)
    property bool secondTextWrapMode: false;
    property string secondTextColor: colorInfo.subTextGrey
    property string secondTextPressColor: secondTextColor
    property string secondTextFocusPressColor : secondTextPressColor
    property string secondTextSelectedColor: secondTextColor
    property string secondTextDisableColor: colorInfo.disableGrey
    property string secondTextFocusColor : secondTextPressColor
    property int    secondTextPaintedText: idSecondTextItem.tickerPaintedHeight

    property bool firstTextScrollEnable : false;     //# Scroll Enable (true, false)
    property bool secondTextScrollEnable: false;     //# Scroll Enable (true, false)
    property int  scrollTextSpacing     : 120;
    property bool focusImageVisible: idFocusImage.visible  //# for FocusText
    property bool anchorsFillParentFlag: false;

    opacity: enabled ? 1.0 : 0.5

    //****************************** # Button Normal / Pressed Image
    Image{
        id: idButtonImage
        source: bgImage     
        visible: (anchorsFillParentFlag==false)
    }
    Image{
        id: idButtonImageCopy
        source: bgImage
        anchors.fill: parent
        visible: (anchorsFillParentFlag==true)
    }
    //****************************** # Line Image
    Image {
        id: idLineImage
        x: lineImageX
        y: lineImageY
        source: lineImage
    }

    //****************************** # Button Focus Image
    Image {
        id: idFocusImage
        source: bgImageFocus        
        visible: showFocus && idMButton.activeFocus && (anchorsFillParentFlag==false)
    }
    Image {
        id: idFocusImageCopy
        source: bgImageFocus
        anchors.fill: parent
        visible: showFocus && idMButton.activeFocus && (anchorsFillParentFlag==true)
    }

    Image{
        id: idButtonImageTop
        source: bgImageTop
    }

    //****************************** # Icon Image in Button
    Image {
        id: imgFgImage
        x: fgImageX
        y: fgImageY
        width: fgImageWidth
        height: fgImageHeight
        source: fgImage
        visible: fgImageVisible
    }

    //****************************** # First Text
    Item {
        id:idTextArea
        //****************************** # First Text
        MTickerText{
            id: idFirstTextItem
            x: firstTextX           ; y: firstTextY-(firstTextSize/2) - (firstTextSize/8)
            width: firstTextWidth   ; height: firstTextSize + (firstTextSize/4)
            tickerTextSpacing   : scrollTextSpacing
            tickerEnable        : firstTextScrollEnable
            tickerText          : firstText
            tickerTextSize      : firstTextSize
            tickerTextColor     : firstTextColor
            tickerTextStyle     : firstTextStyle
            tickerTextAlies     : firstTextAlies
            tickerTextWrapMode  : firstTextWrapMode
        }

        //****************************** # Second Text
        MTickerText{
            id: idSecondTextItem
            x: secondTextX           ; y: secondTextY-(secondTextSize/2) - (secondTextSize/8)
            width: secondTextWidth   ; height: secondTextSize + (secondTextSize/4)
            tickerTextSpacing   : scrollTextSpacing
            tickerEnable        : secondTextScrollEnable
            tickerText          : secondText
            tickerTextSize      : secondTextSize
            tickerTextColor     : secondTextColor
            tickerTextStyle     : secondTextStyle
            tickerTextAlies     : secondTextAlies
            tickerTextWrapMode  : secondTextWrapMode
        }
    }    

    //****************************** # Key Selected
    onSelectKeyPressed: {
        if(idMButton.mEnabled){
            //console.log("[QML] MButton onSelectKeyPressed. state:"+ idMButton.state);
            idMButton.state="pressed";
        }else{
            idMButton.state="disabled"
        }
    }

    //****************************** # Key Released
    onSelectKeyReleased: {
        if(idMButton.mEnabled){
            if(active==true){
                idMButton.state="active"
            }else{
                idMButton.state="keyRelease";
            }
        }else{
            idMButton.state = "disabled"
        }
    }
    //****************************** # Key Enter / Touch Click
    onClickOrKeySelected: {
        //console.debug("------ [MButton] [onClickOrKeySelected] ")
        if(playBeepOn && idMButton.state!="disabled") idAppMain.playBeep();
    }

    onCancel: {
        if(!idMButton.mEnabled) return;
        //  idMButton.state = "keyRelease"

        if(active == true){ idMButton.state="active"; }
	else{ idMButton.state="keyRelease"; }
    }

    //****************************** # State
    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: idButtonImage; source: bgImagePress;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
            PropertyChanges {target: idFirstTextItem; tickerTextColor: firstTextPressColor;}
            PropertyChanges {target: idSecondTextItem; tickerTextColor: secondTextPressColor;}
            PropertyChanges {target: idFocusImage; visible: false;}
        },
        State {
            name: 'active'; when: idMButton.active
            PropertyChanges {target: idButtonImage; source: bgImageActive;}
            PropertyChanges {target: imgFgImage; source: fgImageActive;}
            PropertyChanges {target: idFirstTextItem; tickerTextColor: firstTextSelectedColor;}
            PropertyChanges {target: idSecondTextItem; tickerTextColor: secondTextSelectedColor;}
        },
        State {
            name: 'keyPress'
            PropertyChanges {target: idButtonImage; source: bgImageFocusPress;}
            PropertyChanges {target: imgFgImage; source: fgImageFocusPress;}
            PropertyChanges {target: idFirstTextItem; tickerTextColor: firstTextFocusPressColor;}
            PropertyChanges {target: idSecondTextItem; tickerTextColor: secondTextFocusPressColor;}
        },
        State {
            name: 'keyRelease';// when: !(idMButton.visible)
            PropertyChanges {target: idButtonImage; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: idFirstTextItem; tickerTextColor: focusImageVisible? firstTextFocusColor : firstTextColor;}
            PropertyChanges {target: idSecondTextItem; tickerTextColor: focusImageVisible? secondTextFocusColor : secondTextPressColor;}
        },
        State {
            name: 'disabled'; when: !mEnabled;
            PropertyChanges {target: idButtonImage; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: idFirstTextItem; tickerTextColor: mEnabled? firstTextColor : firstTextDisableColor;}
            PropertyChanges {target: idSecondTextItem; tickerTextColor: mEnabled? secondTextColor : secondTextDisableColor;}
        }
    ]
}


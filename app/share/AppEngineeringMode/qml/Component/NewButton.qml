/**
 * FileName: MButton.qml
 * Author: Problem Kang
 * Time: 2012-02-03 11:20
 *
 * - 2012-02-03 Initial Crated by Problem Kang
 * - 2013-06-10 Add Scroll Ticker Text
 */

import Qt 4.7
import "../System" as MSystem
import "../Operation/operation.js" as MOperation

MComponent {
    id: idMButton

    // # Delegate Info
    property bool active: false
    property string buttonName: ""
    property bool buttonEnabled: true
    mEnabled: buttonEnabled

    property bool focusImageVisible: idFocusImage.visible
    opacity: enabled ? 1.0 : 0.5

    // # Button Image
    property int buttonWidth//: parent.width
    property int buttonHeight//: parent.height
    property string defaultImage: ""
    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""

    // # Inside Image
    property int fgImageX: 0
    property int fgImageY: 0
    property int fgImageWidth: 0
    property int fgImageHeight: 0
    property bool fgImageVisible: true
    property string fgImage:""
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: fgImage

    // # First Text Info
    property string firstText: ""
    property int firstTextSize: 0
    property int firstTextX: 0
    property int firstTextY: 0
    property int firstTextWidth: 0
    property int firstTextHeight: firstTextSize//+10
    property string firstTextStyle: "NewHDR"
    property string firstTextHorizontalAlies: "Left"
    property string firstTextVerticalAlies: "Center"
    property string firstTextElide: "None"
    property bool firstTextVisible: true
    property bool firstTextEnabled: true
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor: firstTextColor
    property string firstTextSelectedColor: firstTextColor
    property string firstTextDisableColor: colorInfo.disableGrey
    property string firstTextFocusColor: firstTextColor

    // # First Text Scroll
    property bool firstTextScrollEnable: false
    property bool firstTextOverPaintedWidth: false

    // # Second Text Info
    property string secondText: ""
    property int secondTextSize: 0
    property int secondTextX: 0
    property int secondTextY: 0
    property int secondTextWidth: 0
    property int secondTextHeight: secondTextSize//+10
    property string secondTextStyle: "NewHDR"
    property string secondTextHorizontalAlies: "Left"
    property string secondTextVerticalAlies: "Center"
    property string secondTextElide: "Right"
    property bool secondTextVisible: true
    property bool secondTextEnabled: true
    property string secondTextColor: colorInfo.subTextGrey
    property string secondTextPressColor: secondTextColor
    property string secondTextSelectedColor: secondTextColor
    property string secondTextDisableColor: colorInfo.disableGrey
    property string secondTextFocusColor: secondTextPressColor

    // # Second Text Scroll
    property bool secondTextScrollEnable: false
    property bool secondTextOverPaintedWidth: false

    // # Bg Image
    Image{
        id: idBgImg
        source: bgImage
    }

    // # Button Focus Image
    Image {
        id: idFocusImage
        source: (showFocus && idMButton.activeFocus) ? bgImageFocus : ""
        visible: (showFocus && idMButton.activeFocus) ? true : false
    }

    // # Default Image
    Image{
        id: idDefaultImg
        x: idBgImg.x - 1
        source: defaultImage
    }

    // # Inside Image
    Image {
        id: imgFgImage
        x: fgImageX
        y: fgImageY
        width: fgImageWidth
        height: fgImageHeight
        source: fgImage
        visible: fgImageVisible
    }

    // # First Text
    Item {
        id: idFirstTextItem
        x: firstTextX
        y: firstTextY - (firstTextSize/2) - (firstTextSize/8)
        width: firstTextWidth
        height: firstTextSize+(firstTextSize/4)/*parent.height*/
        clip: firstTextOverPaintedWidth ? true : false;

        Text {
            id: txtFirstText
            width: (firstTextScrollEnable == false) ? firstTextWidth : txtFirstText2.paintedWidth
            height: firstTextSize+(firstTextSize/4)/*parent.height*/
            text: firstText
            color: firstTextColor
            font.family: UIListener.getFont(false)/*firstTextStyle*/
            font.pixelSize: firstTextSize
            verticalAlignment: { MOperation.getVerticalAlignment(firstTextVerticalAlies) }
            horizontalAlignment: { MOperation.getHorizontalAlignment(firstTextHorizontalAlies) }
            //            elide: {
            //                //                if(firstTextScrollEnable == true){ Text.ElideNone }
            //                //                else{ MOperation.getTextElide(firstTextElide) }
            //            }
            visible: firstTextVisible
            enabled: firstTextEnabled
        }

        Text {
            id: txtFirstText2
            text: firstText
            color: firstTextColor
            font.family: UIListener.getFont(false)/*firstTextStyle*/
            font.pixelSize: firstTextSize
            visible: firstTextOverPaintedWidth ? true : false
            enabled: firstTextEnabled
            verticalAlignment: txtFirstText.verticalAlignment
            horizontalAlignment: txtFirstText.horizontalAlignment
            anchors.left: txtFirstText.right
            anchors.leftMargin: 120
        }

    }

    // # Second Text
    Item {
        id: idSecondTextItem
        x: secondTextX
        y: secondTextY-(secondTextSize/2) - (secondTextSize/8)
        width: secondTextWidth
        height: parent.height
        clip: secondTextOverPaintedWidth ? true : false;

        Text {
            id: txtSecondText
            width: (secondTextScrollEnable == false) ? secondTextWidth : txtSecondText2.paintedWidth
            text: secondText
            color: secondTextColor
            font.family: UIListener.getFont(false)/*secondTextStyle*/
            font.pixelSize: secondTextSize
            verticalAlignment: { MOperation.getVerticalAlignment(secondTextVerticalAlies) }
            horizontalAlignment: { MOperation.getHorizontalAlignment(secondTextHorizontalAlies) }
            //            elide: {
            //                //                if(secondTextScrollEnable == true){ Text.ElideNone }
            //                //                else{ MOperation.getTextElide(secondTextElide) }
            //            }
            visible: secondTextVisible
            enabled: secondTextEnabled
        }

        Text {
            id: txtSecondText2
            text: secondText
            color: secondTextColor
            font.family: UIListener.getFont(false)/*secondTextStyle*/
            font.pixelSize: secondTextSize
            visible: secondTextOverPaintedWidth ? true : false
            enabled: secondTextEnabled
            verticalAlignment: txtSecondText.verticalAlignment
            horizontalAlignment: txtSecondText.horizontalAlignment
            anchors.left: txtSecondText.right
            anchors.leftMargin: 120
        }

    }
    // # For Scroll Text Animation
    SequentialAnimation {
        id: idTickerAnimation1
        loops: Animation.Infinite
        running: false
        PauseAnimation { duration: 1000 }
        PropertyAnimation {
            target: txtFirstText
            property: "x"
            from: 0
            to: -(txtFirstText2.paintedWidth + 120)
            duration: (txtFirstText2.paintedWidth + 120)/100 *1000
        }
        PauseAnimation { duration: 1500 }
    }

    SequentialAnimation {
        id: idTickerAnimation2
        loops: Animation.Infinite
        running: false
        PauseAnimation { duration: 1000 }
        PropertyAnimation {
            target: txtSecondText
            property: "x"
            from: 0
            to: -(txtSecondText2.paintedWidth + 120)
            duration: (txtSecondText2.paintedWidth + 120)/100 *1000
        }
        PauseAnimation { duration: 1500 }
    }
    // # For Scroll Text
    onFirstTextScrollEnableChanged:{
        if( (firstTextOverPaintedWidth == true) && (firstTextScrollEnable == true) )
        {
            idTickerAnimation1.start();
        }
        else
        {
            idTickerAnimation1.stop();
            txtFirstText.x = 0;
        }
    }

    onSecondTextScrollEnableChanged:{
        if( (secondTextOverPaintedWidth == true) && (secondTextScrollEnable == true) )
        {
            idTickerAnimation2.start();
        }
        else
        {
            idTickerAnimation2.stop();
            txtSecondText.x = 0/*secondTextX*/;
        }
    }

    function setPaintedWidth()
    {
        if(txtFirstText2.paintedWidth > firstTextWidth) firstTextOverPaintedWidth = true;
        else firstTextOverPaintedWidth = false;

        if(txtSecondText2.paintedWidth > secondTextWidth) secondTextOverPaintedWidth = true;
        else secondTextOverPaintedWidth = false;
    }


    // ### Key Selected
    onSelectKeyPressed: {
        if(idMButton.mEnabled == true){
            //console.log("[QML] MButton onSelectKeyPressed. state:"+ idMButton.state);
            idMButton.state="keyPress";
        }else{
            idMButton.state="disabled"
        }
    }

    // ### Key Released
    onSelectKeyReleased: {
        if(idMButton.mEnabled == true){
            if(idMButton.active == true){
                idMButton.state="active"
            }else{
                idMButton.state="keyRelease";
            }
        }else{
            idMButton.state = "disabled"
        }
    }

    // ### Key Enter / Touch Click
    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            //console.debug(" [QML][MButton][JOG/TOUCH] onClickOrKeySelected ")
            //if(playBeepOn && idMButton.state!="disabled") idAppMain.playBeep();
            //event.accepted = true;
        }
        setPaintedWidth()
    }

    // ### Delegate Event
    onActiveFocusChanged: {
        if(idMButton.activeFocus == true)
        {
            if(idMButton.active == true){
                idMButton.state="active"
            }else{
                idMButton.state="keyRelease";
            }
        }else{
            idMButton.state="keyRelease";
        }
        setPaintedWidth()
    }

//    onMouseExit:{
//        if(idAppMain.presetEditEnabled == true)
//        {
//            idAppMain.isSelectButton = true;
//        }
//        else
//        {
//            idAppMain.isSelectButton = false;
//        }

//        idMButton.state="keyRelease";
//    }

    Component.onCompleted:{
        setPaintedWidth()
    }

    // # State
    onStateChanged:
    {
        //console.log("========>>[MButton][onStateChanged] idMButton.state: "+idMButton.state+" idMButton.active: "+idMButton.active)
    }

    states: [
        State {
            name: 'active'; // when: (idMButton.active == true)
            PropertyChanges {target: idBgImg; source: bgImagePress;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: idFocusImage; visible: (showFocus && idMButton.activeFocus) ? true : false;}
            PropertyChanges {target: txtFirstText2; color: firstTextSelectedColor;}
            PropertyChanges {target: txtSecondText2; color: secondTextSelectedColor;}
        },
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: idBgImg; source: bgImagePress;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: txtFirstText2; color: firstTextPressColor;}
            PropertyChanges {target: txtSecondText2; color: secondTextPressColor;}
            PropertyChanges {target: idFocusImage; visible: false;}
        },
//        State {
//            name: 'hold'; when: idMButton.pressAndHoldFlag == true
//            PropertyChanges {target: idBgImg; source: bgImagePress;}
//            PropertyChanges {target: imgFgImage; source: fgImagePress;}
//            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
//            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
//            PropertyChanges {target: idFocusImage; visible: false;}
//        },
        State {
            name: 'keyPress'; /*when: idMButton.state=="keyPress"*/
            PropertyChanges {target: idBgImg; source: bgImagePress;}
            PropertyChanges {target: imgFgImage; source: fgImagePress;}
            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
            PropertyChanges {target: txtSecondText; color: secondTextPressColor;}
            PropertyChanges {target: idFocusImage; visible: false;}
            PropertyChanges {target: txtFirstText2; color: firstTextPressColor;}
            PropertyChanges {target: txtSecondText2; color: secondTextPressColor;}
        },
        State {
            name: 'keyRelease';
            PropertyChanges {target: idBgImg; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: txtFirstText; color: (focusImageVisible == true)? firstTextFocusColor : (idMButton.mEnabled == true) ? firstTextColor : firstTextDisableColor;}
            PropertyChanges {target: txtSecondText; color: (focusImageVisible == true) ? secondTextFocusColor : (idMButton.mEnabled == true)? secondTextPressColor : secondTextDisableColor;}
            PropertyChanges {target: idFocusImage; visible: (showFocus && idMButton.activeFocus) ? true : false;}
            PropertyChanges {target: txtFirstText2; color: focusImageVisible? firstTextFocusColor : firstTextColor;}
            PropertyChanges {target: txtSecondText2; color: focusImageVisible? secondTextFocusColor : secondTextPressColor;}
        },
        State {
            name: 'disabled'; when: (idMButton.mEnabled == false);
            PropertyChanges {target: idBgImg; source: bgImage;}
            PropertyChanges {target: imgFgImage; source: fgImage;}
            PropertyChanges {target: txtFirstText; color: mEnabled? firstTextColor : firstTextDisableColor;}
            PropertyChanges {target: txtSecondText; color: mEnabled? secondTextColor : secondTextDisableColor;}
            PropertyChanges {target: idFocusImage; visible: false;}
            PropertyChanges {target: txtFirstText2; color: mEnabled? firstTextColor : firstTextDisableColor;}
            PropertyChanges {target: txtSecondText2; color: mEnabled? secondTextColor : secondTextDisableColor;}
        }
    ]
}

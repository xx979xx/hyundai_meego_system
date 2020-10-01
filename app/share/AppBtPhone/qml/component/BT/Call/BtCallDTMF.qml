/**
 * BTCallDTMF.qml
 *
 */
import QtQuick 1.1
import "../../QML/DH" as MComp
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath
import "../../BT/Common/Javascript/operation.js" as MOp


MComp.MComponent
{
    x: 0
    y: 0
    width: systemInfo.lcdWidth - 386
    height: 420     //586 - 166
    focus: true


    // PROPERTIES
    property bool delayedDTMF: false


    /* INTERNAL functions */
    function dialKeyHandler(key) {
        // 현재까지의 DTMF 입력값 뒤에 계속 추가함
        //DEPRECATED callDTMFDialInput = callDTMFDialInput + key
        if(true == dtmfLock()) {
            // DTMF 연속입력 방지
            dtmfStringBuilder(key);
            BtCoreCtrl.HandleHfpTxDTMFCode(key);
        }
    }

    function dtmfStringBuilder(key) {
        callDTMFDialInput = callDTMFDialInput + key;

        /*while(text_dtmf_number.paintedWidth > 810) {
            var ellipsis = callDTMFDialInput.search("...");
            console.log("# ellipsis = " + ellipsis);

            if(-1 < ellipsis) {
                // 이미 앞에 ... 이 있는 경우
                callDTMFDialInput = "..." + callDTMFDialInput.substring(4);
            } else {
                callDTMFDialInput = "..." + callDTMFDialInput.substring(1);
            }
        }*/
        if(text_dtmf_number.text.length > 29) {
            text_dtmf_number.font.pointSize = 40
        } else if(text_dtmf_number.text.length == 29) {
            text_dtmf_number.font.pointSize = 42
        } else if(text_dtmf_number.text.length == 28) {
            text_dtmf_number.font.pointSize = 43
        } else if(text_dtmf_number.text.length == 27) {
            text_dtmf_number.font.pointSize = 45
        } else if(text_dtmf_number.text.length == 26) {
            text_dtmf_number.font.pointSize = 47
        } else if(text_dtmf_number.text.length == 25) {
            text_dtmf_number.font.pointSize = 48
        } else if(text_dtmf_number.text.length == 24) {
            text_dtmf_number.font.pointSize = 50
        } else if(text_dtmf_number.text.length == 23) {
            text_dtmf_number.font.pointSize = 52
        } else if(text_dtmf_number.text.length == 22) {
            text_dtmf_number.font.pointSize = 54
        } else {
            text_dtmf_number.font.pointSize = 54
        }
    }

    function dtmfLock() {
        if(true == delayedDTMF) {
            return false;
        } else {
            delayedDTMF = true;
            idDTMFDelayTimer.restart();
            return true;
        }
    }

    function dtmfUnlock() {
        idDTMFDelayTimer.stop();
        delayedDTMF = false;
    }


    /* EVENT handlers */
    Component.onCompleted: {
        if(true == visible) {
            callDial01.forceActiveFocus();
        }
    }

    Component.onDestruction: {
        dtmfUnlock();
    }

    onVisibleChanged: {
        if(true == visible) {
            callDial01.forceActiveFocus();
        }

        dtmfUnlock();
    }


    /* WIDGETS */
    Image {
        id: search_input
        source: ImagePath.imgFolderBt_phone + "dial_inputbox.png"
        width: 845
        height: 81

        Text {
            id: text_dtmf_number
            text: callDTMFDialInput
            x: 17
            y: 14   //41 - 27
            width: 811
            height: 54
            font.pointSize: 54
            font.family: stringInfo.fontFamilyBold    //"HDB"
            color: colorInfo.buttonGrey
            clip: false
            elide: Text.ElideLeft
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }
    }

    // 1
    MComp.MButton {
        id: callDial01
        x: 0
        y: 91
        width: 279
        height: 69
        focus: true

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage:    ImagePath.imgFolderBt_phone + "dial_num_1.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        onClickOrKeySelected: {
            callDial01.forceActiveFocus();
            dialKeyHandler("1");
        }

        KeyNavigation.down: callDial04
        KeyNavigation.right:callDial02

        onDownRightKeyPressed:  { callDial05.focus = true; }
        onWheelLeftKeyPressed:  { callDialSharp.focus = true; }
        onWheelRightKeyPressed: { callDial02.focus = true; }
    }

    // 2
    MComp.MButton {
        id: callDial02
        x: 283
        y: 91
        width: 279
        height: 69

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage: ImagePath.imgFolderBt_phone + "dial_num_2.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        firstText: "ABC"
        firstTextX: 166     //114 +  52
        firstTextY: 34      //45 - 11
        firstTextSize: 22
        firstTextWidth: 60
        firstTextElide: ""

        onClickOrKeySelected: {
            callDial02.forceActiveFocus();
            dialKeyHandler("2");
        }

        KeyNavigation.down:     callDial05
        KeyNavigation.left:     callDial01
        KeyNavigation.right:    callDial03

        onDownLeftKeyPressed:   { callDial04.focus = true; }
        onDownRightKeyPressed:  { callDial06.focus = true; }

        onWheelLeftKeyPressed:  { callDial01.focus = true; }
        onWheelRightKeyPressed: { callDial03.focus = true; }
    }

    // 3
    MComp.MButton {
        id: callDial03
        x: 566      //283 + 283
        y: 91
        width: 279
        height: 69

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage: ImagePath.imgFolderBt_phone + "dial_num_3.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        firstText: "DEF"
        firstTextX: 166     //114 +  52
        firstTextY: 34      //45 - 11
        firstTextSize: 22
        firstTextWidth: 60
        firstTextElide: ""

        onClickOrKeySelected: {
            callDial03.forceActiveFocus();
            dialKeyHandler("3");
        }

        KeyNavigation.down: callDial06
        KeyNavigation.left: callDial02

        onDownLeftKeyPressed:   { callDial05.focus = true; }

        onWheelLeftKeyPressed:  { callDial02.focus = true; }
        onWheelRightKeyPressed: { callDial04.focus = true; }
    }

    // 4
    MComp.MButton {
        id: callDial04
        x: 0
        y: 162      //91 + 71
        width: 279
        height: 69

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage: ImagePath.imgFolderBt_phone + "dial_num_4.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        firstText: "GHI"
        firstTextX: 166     //114 +  52
        firstTextY: 34      //45 - 11
        firstTextSize: 22
        firstTextWidth: 60
        firstTextElide: ""

        onClickOrKeySelected: {
            callDial04.forceActiveFocus();
            dialKeyHandler("4");
        }

        KeyNavigation.up:   callDial01
        KeyNavigation.down: callDial07
        KeyNavigation.right:callDial05

        onUpRightKeyPressed:    { callDial02.focus = true; }
        onDownRightKeyPressed:  { callDial08.focus = true; }

        onWheelLeftKeyPressed:  { callDial03.focus = true; }
        onWheelRightKeyPressed: { callDial05.focus = true; }
    }

    // 5
    MComp.MButton {
        id: callDial05
        x: 283
        y: 162      //91 + 71
        width: 279
        height: 69

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage: ImagePath.imgFolderBt_phone + "dial_num_5.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        firstText: "JKL"
        firstTextX: 166     //114 + 52
        firstTextY: 34      //45 - 11
        firstTextSize: 22
        firstTextWidth: 60
        firstTextElide: ""

        onClickOrKeySelected: {
            callDial05.forceActiveFocus();
            dialKeyHandler("5");
        }

        KeyNavigation.up:       callDial02
        KeyNavigation.down:     callDial08
        KeyNavigation.left:     callDial04
        KeyNavigation.right:    callDial06

        onUpRightKeyPressed:    { callDial03.focus = true; }
        onUpLeftKeyPressed:     { callDial01.focus = true; }
        onDownRightKeyPressed:  { callDial09.focus = true; }
        onDownLeftKeyPressed:   { callDial07.focus = true; }

        onWheelLeftKeyPressed:  { callDial04.focus = true; }
        onWheelRightKeyPressed: { callDial06.focus = true; }
    }

    // 6
    MComp.MButton {
        id: callDial06
        x: 566
        y: 162
        width: 279
        height: 69

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage: ImagePath.imgFolderBt_phone + "dial_num_6.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        firstText: "MNO"
        firstTextX: 166
        firstTextY: 34
        firstTextSize: 22
        firstTextWidth: 60
        firstTextElide: ""

        onClickOrKeySelected: {
            callDial06.forceActiveFocus();
            dialKeyHandler("6");
        }

        KeyNavigation.up:   callDial03
        KeyNavigation.down: callDial09
        KeyNavigation.left: callDial05

        onUpLeftKeyPressed:     { callDial02.focus = true; }
        onDownLeftKeyPressed:   { callDial08.focus = true; }

        onWheelLeftKeyPressed:  { callDial05.focus = true; }
        onWheelRightKeyPressed: { callDial07.focus = true; }
    }

    // 7
    MComp.MButton {
        id: callDial07
        x: 0
        y: 233
        width: 279
        height: 69

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage: ImagePath.imgFolderBt_phone + "dial_num_7.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        firstText: "PQRS"
        firstTextX: 166
        firstTextY: 34
        firstTextSize: 22
        firstTextWidth: 60
        firstTextElide: ""

        onClickOrKeySelected: {
            callDial07.forceActiveFocus();
            dialKeyHandler("7");
        }

        KeyNavigation.up:   callDial04
        KeyNavigation.down: callDialStar
        KeyNavigation.right:callDial08

        onUpRightKeyPressed:    { callDial05.focus = true; }
        onDownRightKeyPressed:  { callDial00.focus = true; }

        onWheelLeftKeyPressed:  { callDial06.focus = true; }
        onWheelRightKeyPressed: { callDial08.focus = true; }
    }

    // 8
    MComp.MButton {
        id: callDial08
        x: 283
        y: 233
        width: 279
        height: 69

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage: ImagePath.imgFolderBt_phone + "dial_num_8.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        firstText: "TUV"
        firstTextX: 166     //114 +  52
        firstTextY: 34      //45 - 11
        firstTextSize: 22
        firstTextWidth: 60
        firstTextElide: ""

        onClickOrKeySelected: {
            callDial08.forceActiveFocus();
            dialKeyHandler("8");
        }

        KeyNavigation.up:   callDial05
        KeyNavigation.down: callDial00
        KeyNavigation.left: callDial07
        KeyNavigation.right:callDial09

        onUpRightKeyPressed:    { callDial06.focus = true; }
        onUpLeftKeyPressed:     { callDial04.focus = true; }
        onDownRightKeyPressed:  { callDialSharp.focus = true; }
        onDownLeftKeyPressed:   { callDialStar.focus = true; }

        onWheelLeftKeyPressed:  { callDial07.focus = true; }
        onWheelRightKeyPressed: { callDial09.focus = true; }
    }

    // 9
    MComp.MButton {
        id: callDial09
        x: 566
        y: 233
        width: 279
        height: 69

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage: ImagePath.imgFolderBt_phone + "dial_num_9.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        firstText: "WXYZ"
        firstTextX: 166     //114 +  52
        firstTextY: 34      //45 - 11
        firstTextSize: 22
        firstTextWidth: 60
        firstTextElide: ""

        onClickOrKeySelected: {
            callDial09.forceActiveFocus();
            dialKeyHandler("9");
        }

        KeyNavigation.up:   callDial06
        KeyNavigation.down: callDialSharp
        KeyNavigation.left: callDial08

        onUpLeftKeyPressed:     { callDial05.focus = true; }
        onDownLeftKeyPressed:   { callDial00.focus = true; }

        onWheelLeftKeyPressed:  { callDial08.focus = true; }
        onWheelRightKeyPressed: { callDialStar.focus = true; }
    }

    // *
    MComp.MButton {
        id: callDialStar
        x: 0
        y: 304
        width: 279
        height: 69

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage: ImagePath.imgFolderBt_phone + "dial_num_asterisk.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        onClickOrKeySelected: {
            callDialStar.forceActiveFocus();
            dialKeyHandler("*");
        }

        KeyNavigation.up:       callDial07
        KeyNavigation.right:    callDial00

        onUpRightKeyPressed:    { callDial08.focus = true; }

        onWheelLeftKeyPressed:  { callDial09.focus = true; }
        onWheelRightKeyPressed: { callDial00.focus = true; }
    }

    // 0
    MComp.MButton {
        id: callDial00
        x: 283
        y: 304
        width: 279
        height: 69

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage: ImagePath.imgFolderBt_phone + "dial_num_0.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        firstText: "+"
        firstTextX: 166     //114 +  52
        firstTextY: 27      //45 - 18 
        firstTextSize: 36
        firstTextWidth: 60
        firstTextElide: ""

        onClickOrKeySelected: {
            callDial00.forceActiveFocus();
            dialKeyHandler("0");
        }

        KeyNavigation.up:       callDial08;
        KeyNavigation.left:     callDialStar;
        KeyNavigation.right:    callDialSharp;

        onUpRightKeyPressed:    { callDial09.focus = true; }
        onUpLeftKeyPressed:     { callDial07.focus = true; }

        onWheelLeftKeyPressed:  { callDialStar.focus = true; }
        onWheelRightKeyPressed: { callDialSharp.focus = true; }
    }

    // #
    MComp.MButton {
        id: callDialSharp
        x: 566
        y: 304
        width: 279
        height: 69

        bgImage:        ImagePath.imgFolderBt_phone + "btn_keypad_num_n.png"
        bgImagePress:   ImagePath.imgFolderBt_phone + "btn_keypad_num_p.png"
        bgImageFocus:   ImagePath.imgFolderBt_phone + "btn_keypad_num_f.png"

        fgImage: ImagePath.imgFolderBt_phone + "dial_num_sharp.png"
        fgImageX: 114
        fgImageY: 9
        fgImageWidth: 51
        fgImageHeight: 53

        onClickOrKeySelected: {
            callDialSharp.forceActiveFocus();
            dialKeyHandler("#");
        }

        KeyNavigation.up:   callDial09
        KeyNavigation.left: callDial00

        onUpLeftKeyPressed:     { callDial08.focus = true; }

        onWheelLeftKeyPressed:  { callDial00.focus = true; }
        onWheelRightKeyPressed: { callDial01.focus = true; }
    }


    /* TIMERS */
    Timer {
        id: idDTMFDelayTimer
        interval: 300
        repeat: false

        onTriggered: {
            console.log("##############################################");
            console.log("DTMF unlock!");
            console.log("##############################################");
            delayedDTMF = false;
        }
    }
}
/* EOF */

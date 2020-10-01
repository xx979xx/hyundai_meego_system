/**
 * SetttinsBTPinCodeKeypad.qml
 *
 */
import QtQuick 1.1
import "../../../../../QML/DH_arabic" as MComp
import "../../../../../BT_arabic/Common/System/DH/ImageInfo.js" as ImagePath


MComp.MComponent
{
    id : idSettingsBtPinCodeKeypad
    x: 0
    y: 0
    width: 720  //66 + 151 + 151 + 151 + 201 //systemInfo.lcdWidth
    height: systemInfo.lcdHeight - 215
    focus: true


    // PROPERTIES
    property int keypadWidth: 190
    property int keypadHeight: 84
    property int keypadImgX: 71
    property int keypadImgY: 18
    property int cellWidth: 138
    property int cellHeight: 81
    property int aniCellX: 27
    property int aniCellY: 26
    property int txtCellWidth: 98
    property int kyepadY: 110   //368-90-168
    property int numCount: 0
    property string lockNum
    property bool countInit: false


    /* EVENT handlers */
    Component.onCompleted: {
        txtCallNumber1.text = ""
        txtCallNumber2.text = ""
        txtCallNumber3.text = ""
        txtCallNumber4.text = ""
        changeLockNum = ""
        //cursor1()
        numCount = 0
        idPinBtn1.forceActiveFocus()
    }

    onVisibleChanged: {
        txtCallNumber1.text = ""
        txtCallNumber2.text = ""
        txtCallNumber3.text = ""
        txtCallNumber4.text = ""

        changeLockNum = ""
        //        cursor1()
        numCount=0
    }

    function setDeletedCode() {
        qml_debug(" # function setDeletedCode")
        
        numCount = numCount - 1
        if(txtCallNumber1.text != "") {
            txtCallNumber1.text = ""
            //cursor3()
        } else if(txtCallNumber2.text != "") {
            txtCallNumber2.text = ""
            //cursor2()
        } else if(txtCallNumber3.text != "") {
            txtCallNumber3.text = ""
            //cursor1()
        } else if(txtCallNumber4.text != "") {
            txtCallNumber4.text = ""
            numCount = numCount
        }

        if(0 == numCount) {
            /* 입력값이 0가 될 때, 버튼이 비활성화 되어 Beep음 미출력되므로, App에서 Beep 출력 필요 */
            idPinBtn1.forceActiveFocus();
        }
    }

    function setClearAll() {
        qml_debug(" # function setClearAll")
        
        txtCallNumber1.text = ""
        txtCallNumber2.text = ""
        txtCallNumber3.text = ""
        txtCallNumber4.text = ""
        
        changeLockNum = ""
        //cursor1()
        numCount = 0
        idPinBtn1.forceActiveFocus();
    }


    function setClearInput() {
        qml_debug("# function setClearAll")

        txtCallNumber2.text = ""
        txtCallNumber3.text = ""
        txtCallNumber4.text = ""

        changeLockNum = ""
        numCount = 1
    }

    function setNumber(count, number) {
        switch(count) {
            case 0: {
                if(txtCallNumber4.text == "") {
                    txtCallNumber4.text = number
                    //cursor2()
                }
                break;
            }

            case 1: {
                if(txtCallNumber3.text == "") {
                    txtCallNumber3.text = number
                    //cursor3()
                }
                break;
            }

            case 2: {
                if(txtCallNumber2.text == "") {
                    txtCallNumber2.text = number
                    //cursor4()
                }
                break;
            }

            case 3: {
                if(txtCallNumber1.text == "") {
                    txtCallNumber1.text = number
                    savePinCode()

                    //clickedBtPINcodeChanging(lockNum);
                    BtCoreCtrl.invokeSetPINCode(lockNum);
                }
                break;
            }

            // 핀코드 5회 입력 코드 삭제
            /*case 4: {
                txtCallNumber1.text = number
                setClearInput()
                countInit = true
                return;
            }*/

            default:
                qml_debug(" # Call cursor1() ")
                //cursor1()
                break;
        }

        numCount = numCount + 1;
    }

    function cursorZero() {
        setClearAll();
        numCount = 0;
    }

    function savePinCode() {
        changeLockNum = txtCallNumber4.text + txtCallNumber3.text + txtCallNumber2.text + txtCallNumber1.text
        lockNum  = changeLockNum
        popScreen(317);
        //saveTimer.start()

        qml_debug(" # function savePinCode_lockNum : ", lockNum)
        return lockNum
    }


    /* WIDGETS */
    Row {
        spacing: 7
        x: 66
        y: 37
        //width: 352-168; height: cellHeight

        Item {
            width: cellWidth
            height: cellHeight

            BorderImage {
                source: ImagePath.imgFolderSettings + "bg_auth_input_n.png"
            }

            Image {
                id: aniCallNumber4
                source: ImagePath.imgFolderSettings + "ico_auth_cursor_n.png"
                x: aniCellX
                y: aniCellY
                visible: (numCount == 0) ? true : false
                SequentialAnimation {
                    running: aniCallNumber1.visible
                    loops: Animation.Infinite;

                    NumberAnimation { target: aniCallNumber1; property: "opacity"; to: 1; duration: 100 }
                    PauseAnimation  { duration: 500 }
                    NumberAnimation { target: aniCallNumber1; property: "opacity"; to: 0; duration: 100 }
                }
            }

            Text {
                id: txtCallNumber4
                x: 17
                y: 25
                width: 98
                height: 50
                font.pointSize: 50;
                font.family: stringInfo.fontFamilyBold    //"HDB"
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Item {
            width: cellWidth
            height: cellHeight

            BorderImage {
                source: ImagePath.imgFolderSettings + "bg_auth_input_n.png"
            }

            Image {
                id: aniCallNumber3
                source: ImagePath.imgFolderSettings + "ico_auth_cursor_n.png"
                x: aniCellX
                y: aniCellY
                visible: (numCount == 1) ? true : false
                SequentialAnimation {
                    running: aniCallNumber2.visible
                    loops: Animation.Infinite;

                    NumberAnimation { target: aniCallNumber2; property: "opacity"; to: 1; duration: 100 }
                    PauseAnimation  { duration: 500 }
                    NumberAnimation { target: aniCallNumber2; property: "opacity"; to: 0; duration: 100 }
                }
            }

            Text {
                id: txtCallNumber3
                x: 17
                y: 25
                width: 98
                height: 50
                font.pointSize: 50;
                color: colorInfo.buttonGrey;
                font.family: stringInfo.fontFamilyBold    //"HDB"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Item {
            width: cellWidth
            height: cellHeight

            BorderImage {
                source: ImagePath.imgFolderSettings + "bg_auth_input_n.png"
            }

            Image {
                id: aniCallNumber2
                source: ImagePath.imgFolderSettings + "ico_auth_cursor_n.png"
                x: aniCellX
                y: aniCellY
                visible: (numCount == 2) ? true : false
                SequentialAnimation {
                    running: aniCallNumber3.visible
                    loops: Animation.Infinite;

                    NumberAnimation { target: aniCallNumber3; property: "opacity"; to: 1; duration: 100 }
                    PauseAnimation  { duration: 500 }
                    NumberAnimation { target: aniCallNumber3; property: "opacity"; to: 0; duration: 100 }
                }
            }

            Text {
                id: txtCallNumber2
                x: 17
                y: 25
                width: 98
                height: 50
                font.pointSize: 50
                color: colorInfo.buttonGrey;
                font.family: stringInfo.fontFamilyBold    //"HDB"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Item {
            width: cellWidth
            height: cellHeight

            BorderImage {
                source: ImagePath.imgFolderSettings + "bg_auth_input_n.png"
            }

            Image {
                id: aniCallNumber1
                source: ImagePath.imgFolderSettings + "ico_auth_cursor_n.png"
                x: aniCellX
                y: aniCellY
                visible: (numCount == 3) ? true : false
                SequentialAnimation {
                    running: aniCallNumber4.visible
                    loops: Animation.Infinite;

                    NumberAnimation { target: aniCallNumber4; property: "opacity"; to: 1; duration: 100 }
                    PauseAnimation  { duration: 500 }
                    NumberAnimation { target: aniCallNumber4; property: "opacity"; to: 0; duration: 100 }
                }
            }

            Text {
                id: txtCallNumber1
                x: 17
                y: 25
                width: 98
                height: 50
                font.pointSize: 50
                color: colorInfo.buttonGrey;
                font.family: stringInfo.fontFamilyBold    //"HDB"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Column {
        x: 72   //352 - 280
        y: 147  //362 - 215
        spacing: 2
        focus: true

        //--------------------- KeyPad #
        Row {
            spacing: -4
            focus: true
            //--------------------- Nember 1 ##
            MComp.MButton {
                id: idPinBtn1
                width: keypadWidth
                height: keypadHeight

                bgImage:        ImagePath.imgFolderSettings + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                fgImage:        ImagePath.imgFolderBt_phone + "dial_num_1.png"
                fgImageX: keypadImgX
                fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                focus: true

                onClickOrKeySelected: {
                    idPinBtn1.forceActiveFocus()
                    setNumber(numCount, 1)
                }

                KeyNavigation.left:     idPinBtn1
                KeyNavigation.right:    idPinBtn2
                KeyNavigation.down:     idPinBtn4

                onWheelLeftKeyPressed:  idPinBtnDel.mEnabled ? idPinBtnDel.focus = true : idPinBtn0.focus = true
                onWheelRightKeyPressed: idPinBtn2.focus = true
                onDownRightKeyPressed:  idPinBtn5.focus = true
            }

            //--------------------- Nember 2 ##
            MComp.MButton {
                id: idPinBtn2
                width: keypadWidth
                height: keypadHeight

                bgImage:        ImagePath.imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                fgImage:        ImagePath.imgFolderBt_phone + "dial_num_2.png"
                fgImageX: keypadImgX
                fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53

                onClickOrKeySelected: {
                    idPinBtn2.forceActiveFocus()
                    setNumber(numCount, 2)
                }

                KeyNavigation.left:     idPinBtn1
                KeyNavigation.right:    idPinBtn3
                KeyNavigation.down:     idPinBtn5

                onDownLeftKeyPressed:   idPinBtn4.focus = true
                onDownRightKeyPressed:  idPinBtn6.focus = true

                onWheelLeftKeyPressed:  idPinBtn1.focus = true
                onWheelRightKeyPressed: idPinBtn3.focus = true

            }

            //            //--------------------- Nember 3 ##
            MComp.MButton {
                id: idPinBtn3
                width:keypadWidth
                height:keypadHeight

                bgImage:        ImagePath.imgFolderSettings + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                fgImage:        ImagePath.imgFolderBt_phone + "dial_num_3.png"
                fgImageX: keypadImgX
                fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53

                onClickOrKeySelected: {
                    idPinBtn3.forceActiveFocus()
                    setNumber(numCount, 3)
                }

                KeyNavigation.left:     idPinBtn2
                //KeyNavigation.right:    idPinBtn4
                KeyNavigation.down:     idPinBtn6

                onDownLeftKeyPressed:   idPinBtn5.focus = true

                onWheelLeftKeyPressed:  idPinBtn2.focus = true
                onWheelRightKeyPressed: idPinBtn4.focus = true
            }
        }

        Row {
            spacing: -4
            //--------------------- Nember 4 ##
            MComp.MButton {
                id: idPinBtn4
                width: keypadWidth
                height: keypadHeight

                bgImage:        ImagePath.imgFolderSettings + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                fgImage:        ImagePath.imgFolderBt_phone + "dial_num_4.png"
                fgImageX: keypadImgX
                fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53

                onClickOrKeySelected: {
                    idPinBtn4.forceActiveFocus()
                    setNumber(numCount, 4)
                }

                //KeyNavigation.left:     idPinBtn3
                KeyNavigation.right:    idPinBtn5
                KeyNavigation.up:       idPinBtn1
                KeyNavigation.down:     idPinBtn7

                onUpRightKeyPressed:    idPinBtn2.focus = true
                onDownRightKeyPressed:  idPinBtn8.focus = true

                onWheelLeftKeyPressed:  idPinBtn3.focus = true
                onWheelRightKeyPressed: idPinBtn5.focus = true
            }

            //--------------------- Nember 5 ##
            MComp.MButton {
                id: idPinBtn5
                width:keypadWidth
                height:keypadHeight

                bgImage:        ImagePath.imgFolderSettings + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                fgImage:        ImagePath.imgFolderBt_phone + "dial_num_5.png"
                fgImageX: keypadImgX
                fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53

                onClickOrKeySelected: {
                    idPinBtn5.forceActiveFocus()
                    setNumber(numCount, 5)
                }
                
                KeyNavigation.left:     idPinBtn4
                KeyNavigation.right:    idPinBtn6
                KeyNavigation.up:       idPinBtn2
                KeyNavigation.down:     idPinBtn8

                onUpLeftKeyPressed:     idPinBtn1.focus = true
                onUpRightKeyPressed:    idPinBtn3.focus = true
                onDownLeftKeyPressed:   idPinBtn7.focus = true
                onDownRightKeyPressed:  idPinBtn9.focus = true

                onWheelLeftKeyPressed:  idPinBtn4.focus = true
                onWheelRightKeyPressed: idPinBtn6.focus = true
            }

            //--------------------- Nember 6 ##
            MComp.MButton {
                id: idPinBtn6
                width: keypadWidth
                height:keypadHeight

                bgImage:        ImagePath.imgFolderSettings + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                fgImage:        ImagePath.imgFolderBt_phone + "dial_num_6.png"
                fgImageX: keypadImgX
                fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53

                onClickOrKeySelected: {
                    idPinBtn6.forceActiveFocus()
                    setNumber(numCount, 6)
                }

                KeyNavigation.left:     idPinBtn5
                //KeyNavigation.right:    idPinBtn7
                KeyNavigation.up:       idPinBtn3
                KeyNavigation.down:     idPinBtn9

                onUpLeftKeyPressed:     idPinBtn2.focus = true
                onDownLeftKeyPressed:   idPinBtn8.focus = true

                onWheelLeftKeyPressed:  idPinBtn5.focus = true
                onWheelRightKeyPressed: idPinBtn7.focus = true
            }
        }

        Row {
            spacing: -4

            //--------------------- Nember 7 ##
            MComp.MButton {
                id: idPinBtn7
                width: keypadWidth
                height: keypadHeight

                bgImage:        ImagePath.imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                fgImage:        ImagePath.imgFolderBt_phone + "dial_num_7.png"
                fgImageX: keypadImgX
                fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                focus: true

                onClickOrKeySelected: {
                    idPinBtn7.forceActiveFocus()
                    setNumber(numCount, 7)
                }

                //KeyNavigation.left:     idPinBtn6
                KeyNavigation.right:    idPinBtn8
                KeyNavigation.up:       idPinBtn4
                KeyNavigation.down:     idPinBtnDelAll.mEnabled ? idPinBtnDelAll : idPinBtn7

                onUpRightKeyPressed:    idPinBtn5.focus = true
                onDownRightKeyPressed:  idPinBtn0.focus = true

                onWheelLeftKeyPressed:  idPinBtn6.focus = true
                onWheelRightKeyPressed: idPinBtn8.focus = true
            }

            //--------------------- Nember 8 ##
            MComp.MButton {
                id: idPinBtn8
                width: keypadWidth
                height: keypadHeight
                bgImage:        ImagePath.imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                fgImage:        ImagePath.imgFolderBt_phone + "dial_num_8.png"
                fgImageX: keypadImgX
                fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                focus: true

                onClickOrKeySelected: {
                    idPinBtn8.forceActiveFocus();
                    setNumber(numCount, 8);
                }

                KeyNavigation.left:     idPinBtn7
                KeyNavigation.right:    idPinBtn9
                KeyNavigation.up:       idPinBtn5
                KeyNavigation.down:     idPinBtn0

                onUpLeftKeyPressed:     idPinBtn4.focus = true
                onUpRightKeyPressed:    idPinBtn6.focus = true
                onDownLeftKeyPressed:   idPinBtnDelAll.mEnabled ? idPinBtnDelAll.focus = true : idPinBtn8.focus = true
                onDownRightKeyPressed:  idPinBtnDel.mEnabled ? idPinBtnDel.focus = true : idPinBtn8.focus = true

                onWheelLeftKeyPressed:  idPinBtn7.focus = true
                onWheelRightKeyPressed: idPinBtn9.focus = true
            }

            //--------------------- Nember 9 ##
            MComp.MButton {
                id: idPinBtn9
                width: keypadWidth
                height: keypadHeight

                bgImage:        ImagePath.imgFolderSettings + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                fgImage:        ImagePath.imgFolderBt_phone + "dial_num_9.png"
                fgImageX: keypadImgX
                fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                focus: true

                onClickOrKeySelected: {
                    idPinBtn9.forceActiveFocus()
                    setNumber(numCount, 9)
                }

                KeyNavigation.left:     idPinBtn8
                //KeyNavigation.right:    idPinBtnDelAll.mEnabled ? idPinBtnDelAll : idPinBtn9
                KeyNavigation.up:       idPinBtn6
                KeyNavigation.down:     idPinBtnDel.mEnabled ? idPinBtnDel : idPinBtn9

                onUpLeftKeyPressed:     idPinBtn5.focus = true
                onDownLeftKeyPressed:   idPinBtn0.focus = true

                onWheelLeftKeyPressed:  idPinBtn8.focus = true
                onWheelRightKeyPressed: idPinBtnDelAll.mEnabled ? idPinBtnDelAll.focus = true : idPinBtn0.focus = true
            }
        }

        Row {
            spacing: -4

            //--------------------- Clear All ##
            MComp.MButton2 {
                id: idPinBtnDelAll
                width: keypadWidth
                height: keypadHeight

                bgImage:        (1 == UIListener.invokeGetVehicleVariant()) ? ImagePath.imgFolderSettings  + "btn_auth_del_n.png" : ImagePath.imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                mEnabled: txtCallNumber1.text != "" || txtCallNumber2.text != "" || txtCallNumber3.text != "" || txtCallNumber4.text != ""

                firstText: stringInfo.str_Bt_Pincode_Delete_All
                firstTextX: 12
                firstTextY: 25
                firstTextWidth:170
                firstTextHeight: 32
                firstTextColor: colorInfo.brightGrey
                firstTextSize: (idPinBtnDelAll_hidenText.paintedWidth > 170)? 28 : 32
                firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
                firstTextAlies: "Center"

                /* 버튼의 범위를 넘어가는 문구의 폰트사이즈 조절하기 위한 hidden text
                  */
                Text {
                    id: idPinBtnDelAll_hidenText
                    text: stringInfo.str_Bt_Pincode_Delete_All
                    font.pointSize: 32
                    font.family: stringInfo.fontFamilyRegular
                    visible: false
                }

                onClickOrKeySelected: {
                    idPinBtnDelAll.forceActiveFocus()
                    setClearAll()
                }

                //KeyNavigation.left:     idPinBtn9
                KeyNavigation.right:    idPinBtn0
                KeyNavigation.up:       idPinBtn7
                KeyNavigation.down:     idPinBtnDelAll

                onUpRightKeyPressed:    idPinBtn8.focus = true

                onWheelLeftKeyPressed:  idPinBtn9.focus = true
                onWheelRightKeyPressed: idPinBtn0.focus = true
            }

            //--------------------- Nember 0 ##
            MComp.MButton {
                id: idPinBtn0
                width: keypadWidth
                height: keypadHeight

                bgImage:        ImagePath.imgFolderSettings + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                fgImage:        ImagePath.imgFolderBt_phone + "dial_num_0.png"
                fgImageX: keypadImgX
                fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53

                onClickOrKeySelected: {
                    idPinBtn0.forceActiveFocus()
                    setNumber(numCount, 0)
                }

                KeyNavigation.left:     idPinBtnDelAll.mEnabled ? idPinBtnDelAll : idPinBtn0
                KeyNavigation.right:    idPinBtnDel.mEnabled ? idPinBtnDel : idPinBtn0
                KeyNavigation.up:       idPinBtn8
                KeyNavigation.down:     idPinBtn0

                onUpLeftKeyPressed:     idPinBtn7.focus = true
                onUpRightKeyPressed:    idPinBtn9.focus = true

                onWheelLeftKeyPressed:  idPinBtnDelAll.mEnabled ? idPinBtnDelAll.focus = true : idPinBtn9.focus = true
                onWheelRightKeyPressed: idPinBtnDel.mEnabled ? idPinBtnDel.focus = true : idPinBtn1.focus = true
            }

            //--------------------- Delete code ##
            MComp.DDDialButton {
                id: idPinBtnDel
                width: keypadWidth
                height: keypadHeight

                /* LongPress 동작에서 Beep 두번 출력되는 문제 수정 */
                playLongPressBeep: false

                bgImage:        (1 == UIListener.invokeGetVehicleVariant()) ? ImagePath.imgFolderSettings  + "btn_auth_del_n.png" : ImagePath.imgFolderSettings + "btn_auth_num_n.png"
                bgImagePress:   ImagePath.imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus:   ImagePath.imgFolderSettings + "btn_auth_num_f.png"

                mEnabled: txtCallNumber1.text != "" || txtCallNumber2.text != "" || txtCallNumber3.text != "" || txtCallNumber4.text != ""

                onClickOrKeySelected: {
                    if(numCount > 0) {
                        idPinBtnDel.forceActiveFocus();
                        setDeletedCode();
                    }
                }

                firstText: stringInfo.str_Dial_Delete
                firstTextX: 12
                firstTextY: 25
                firstTextWidth:170
                firstTextHeight: 32
                firstTextColor: colorInfo.brightGrey
                firstTextSize: 32
                firstTextStyle: stringInfo.fontFamilyBold    //"HDB"
                firstTextAlies: "Center"

                onPressAndHold: {
                    UIListener.ManualBeep();
                    setClearAll();
                }

                KeyNavigation.left:     idPinBtn0
                KeyNavigation.right:    idPinBtnDel
                KeyNavigation.up:       idPinBtn9
                KeyNavigation.down:     idPinBtnDel

                onUpLeftKeyPressed:     idPinBtn8.focus = true

                onWheelLeftKeyPressed:  idPinBtn0.focus = true
                onWheelRightKeyPressed: idPinBtn1.focus = true
            }
        }
    }
}
/* EOF */

import Qt 4.7
import "../Component" as MComp
import "../System" as MSystem

//---------------------------------------- KeyPad
Rectangle {
    height:335
    color:colorInfo.transparent
    Column {
        spacing:5
        Row {
            spacing: 4
            PINKeyPadButton {
                imgX: 71; imgY: 15
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: imgFolderBt_phone + "dial_num_1.png"
                onClicked: {
                    //UIListener.BeepSoundOut();
                    click("1")
                } // End if
            } // End PINKeyPadButton
            PINKeyPadButton {
                imgX: 71; imgY: 15
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: imgFolderBt_phone + "dial_num_2.png"
                onClicked: {
                    //UIListener.BeepSoundOut();
                    click("2")
                }
            } // End PINKeyPadButton
            PINKeyPadButton {
                imgX: 71; imgY: 15
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: imgFolderBt_phone + "dial_num_3.png"
                onClicked: {
                   // UIListener.BeepSoundOut();
                    click("3")
                } // End PINKeyPadButton
            } // End Row
        }
        Row {
            spacing:4
            PINKeyPadButton {
                imgX: 71; imgY: 15
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: imgFolderBt_phone + "dial_num_4.png"
                onClicked: {
                    //UIListener.BeepSoundOut();
                    click("4")
                 } // End PINKeyPadButton
            }
            PINKeyPadButton {
                imgX: 71; imgY: 15
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: imgFolderBt_phone + "dial_num_5.png"
                onClicked: {
                    //UIListener.BeepSoundOut();
                    click("5")
                }
            } // End PINKeyPadButton
            PINKeyPadButton {
                imgX: 71; imgY: 15
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: imgFolderBt_phone + "dial_num_6.png"
                onClicked: {
                    //UIListener.BeepSoundOut();
                    click("6")
                }
            } // End PINKeyPadButton
        } // End Row
        Row {
            spacing:4
            PINKeyPadButton {
                imgX: 71; imgY: 15
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: imgFolderBt_phone + "dial_num_7.png"
                onClicked: {
                   // UIListener.BeepSoundOut();
                    click("7")
                } // PINKeyPadButton
            }
            PINKeyPadButton {
                imgX: 71; imgY: 15
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: imgFolderBt_phone + "dial_num_8.png"
                //subText:"TUV"
                onClicked: {
                    //UIListener.BeepSoundOut();
                    click("8")
                }
            } // End PINKeyPadButton
            PINKeyPadButton {
                imgX: 71; imgY: 15
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: imgFolderBt_phone + "dial_num_9.png"
                //subText:"WXYZ"
                onClicked: {
                   // UIListener.BeepSoundOut();
                    click("9")
                }
            } // End PINKeyPadButton
        } // End Row
        Row {
            spacing:4
            PINKeyPadButton {
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: ""

                MComp.Label{
                    text: "ConsoleOn"
                    fontName: "HDR"
                    fontSize: 36
                    txtAlign: "Center"
                    fontColor: colorInfo.brightGrey
                }

                onClicked: {
                    //UIListener.BeepSoundOut();
                    IPInfo.handleExecuteScriptOn();
                    //click(" ")
                    //numCount=0
//                    txtCallNumber1.text=""
//                    txtCallNumber2.text=""
//                    txtCallNumber3.text=""
//                    txtCallNumber4.text=""
//                    changeLockNum=""
//                    cursor1()
                }
            } // End PINKeyPadButton
            PINKeyPadButton {
                imgX: 71; imgY: 15
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: imgFolderBt_phone + "dial_num_0.png"
                onClicked: {
                   // UIListener.BeepSoundOut();
                    click("0")

                }
            } // End PINKeyPadButton
            PINKeyPadButton {
                imgX: 57; imgY: 15
                width:189; height:80
                bgImage: imgFolderGeneral  + "btn_keypad_n.png"
                bgImagePressed: imgFolderGeneral + "btn_keypad_p.png"
                dialNumImg: ""

                Image{
                    x: 57; y: 15
                    width:78; height:47
                    source: imgFolderGeneral + "keypad_del.png"
                }

                onClicked: {
                    //UIListener.BeepSoundOut();
                    click("bt")
//                    numCount=numCount-1
//                    if(txtCallNumber4.text != ""){
//                        txtCallNumber4.text=""
//                        cursor3()
//                    }else if(txtCallNumber3.text != ""){
//                        txtCallNumber3.text=""
//                        cursor2()
//                    }else if(txtCallNumber2.text != ""){
//                        txtCallNumber2.text=""
//                        cursor1()
//                    }else if(txtCallNumber1.text != ""){
//                        txtCallNumber1.text=""
//                    } // End if
                }
            } // End MComp.PINKeyPadButton
        } // End Row
    } // End Column
} // End Rectangle

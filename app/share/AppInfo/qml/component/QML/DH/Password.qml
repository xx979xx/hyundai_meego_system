import Qt 4.7
import "../DH" as MComp
import "../../system/DH" as MSystem

Rectangle {
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }

    id : pinmain
    x: 352; y: 77
    width: 573//systemInfo.lcdWidth
    height: 110+335
    color: colorInfo.transparent

    property string imgFolderBt_phone: imageInfo.imgFolderBt_phone
    property string imgFolderSettings : imageInfo.imgFolderSettings

    //signal callButtonPressed()

    function cursor1(){
        console.debug("cursor1")
        aniCallNumber1.visible=true
        aniCallNumber2.visible=false
        aniCallNumber3.visible=false
        aniCallNumber4.visible=false
        aniCallNumber5.visible=false
        aniCallNumber6.visible=false
    } // End function
    
    function cursor2(){
        console.debug("cursor2")
        aniCallNumber1.visible=false
        aniCallNumber2.visible=true
        aniCallNumber3.visible=false
        aniCallNumber4.visible=false
        aniCallNumber5.visible=false
        aniCallNumber6.visible=false
    } // End function
    
    function cursor3(){
        console.debug("cursor3")
        aniCallNumber1.visible=false
        aniCallNumber2.visible=false
        aniCallNumber3.visible=true
        aniCallNumber4.visible=false
        aniCallNumber5.visible=false
        aniCallNumber6.visible=false
    } // End function
    
    function cursor4(){
        console.debug("cursor4")
        aniCallNumber1.visible=false
        aniCallNumber2.visible=false
        aniCallNumber3.visible=false
        aniCallNumber4.visible=true
        aniCallNumber5.visible=false
        aniCallNumber6.visible=false
    } // End function
    
    function cursor5(){
        console.debug("cursor5")
        aniCallNumber1.visible=false
        aniCallNumber2.visible=false
        aniCallNumber3.visible=false
        aniCallNumber4.visible=false
        aniCallNumber5.visible=true
        aniCallNumber6.visible=false
    } // End function
    
    function cursor6(){
        console.debug("cursor6")
        aniCallNumber1.visible=false
        aniCallNumber2.visible=false
        aniCallNumber3.visible=false
        aniCallNumber4.visible=false
        aniCallNumber5.visible=false
        aniCallNumber6.visible=true
    } // End function
    
    function cursorZero(){
        console.debug("cursorZero")
        aniCallNumber1.visible=false
        aniCallNumber2.visible=false
        aniCallNumber3.visible=false
        aniCallNumber4.visible=false
        aniCallNumber5.visible=false
        aniCallNumber6.visible=false
    } // End function
    
    Row{
        spacing: 7
        x: 0; y: 0
        width: 352-168; height: 81

        Rectangle {
            width: 90; height: 81
            color: colorInfo.transparent

            BorderImage {
                source: imgFolderSettings + "bg_password_6.png"
                border.left: 25;
            }
            AnimatedImage{
                id: aniCallNumber1
                x: 13 ; y: 15
                source: imgFolderSettings + "cursor_password.png"
            }
            Text {
                id: txtCallNumber1
                x:0;width:100
                color: colorInfo.black; //selectionColor: "green"
                font.pixelSize: 50;
                font.family:"HDR"
                anchors.centerIn: parent
                horizontalAlignment:TextInput.AlignHCenter
                //cursorVisible:false
                //focus: true
                //maximumLength: 1
            }
        } // End Rectangle
        Rectangle {
            width: 90; height: 81
            color: colorInfo.transparent

            BorderImage {
                source: imgFolderSettings+"bg_password_6.png"
                border.left: 25;
            }
            AnimatedImage{
                id: aniCallNumber2
                x: 13 ; y: 15
                source: imgFolderSettings + "cursor_password.png"
                visible: false
            }

            Text {
                id: txtCallNumber2
                x:0;width:100
                color: colorInfo.black;
                font.pixelSize: 50;
                font.family:"HDR"
                anchors.centerIn: parent
                horizontalAlignment:TextInput.AlignHCenter
                //cursorVisible:false
                //focus: true
                //maximumLength: 1
            }
        } // End Rectangle
        Rectangle {
            width: 90; height: 81
            color: colorInfo.transparent

            BorderImage {
                source: imgFolderSettings+"bg_password_6.png"
                border.left: 25;
            }
            AnimatedImage{
                id: aniCallNumber3
                x: 13 ; y: 15
                source: imgFolderSettings + "cursor_password.png"
                visible: false
            }

            Text {
                id: txtCallNumber3
                x:0;width:100
                color: colorInfo.black;
                font.pixelSize: 50;
                font.family:"HDR"
                anchors.centerIn: parent
                horizontalAlignment:TextInput.AlignHCenter
                //cursorVisible:false
                //focus: true
                //maximumLength: 1
            }
        } // End Rectangle
        Rectangle {
            width: 90; height: 81
            color: colorInfo.transparent

            BorderImage {
                source: imgFolderSettings+"bg_password_6.png"
                border.left: 25;
            }
            AnimatedImage{
                id: aniCallNumber4
                x: 13 ; y: 15
                source: imgFolderSettings + "cursor_password.png"
                visible: false
            }

            Text {
                id: txtCallNumber4
                x:0;width:100
                color: colorInfo.black;
                font.pixelSize: 50;
                font.family:"HDR"
                anchors.centerIn: parent
                horizontalAlignment:TextInput.AlignHCenter
                //cursorVisible:false
                //focus: true
                //maximumLength: 1
            }
        } // End Rectangle
        Rectangle {
            width: 90; height: 81
            color: colorInfo.transparent

            BorderImage {
                source: imgFolderSettings+"bg_password_6.png"
                border.left: 25;
            }
            AnimatedImage{
                id: aniCallNumber5
                x: 13 ; y: 15
                source: imgFolderSettings + "cursor_password.png"
                visible: false
            }

            Text {
                id: txtCallNumber5
                x:0;width:100
                color: colorInfo.black;
                font.pixelSize: 50;
                font.family:"HDR"
                anchors.centerIn: parent
                horizontalAlignment:TextInput.AlignHCenter
                //cursorVisible:false
                //focus: true
                //maximumLength: 1
            }
        } // End Rectangle
        Rectangle {
            width: 90; height: 81
            color: colorInfo.transparent

            BorderImage {
                source: imgFolderSettings+"bg_password_6.png"
                border.left: 25;
            }
            AnimatedImage{
                id: aniCallNumber6
                x: 13 ; y: 15
                source: imgFolderSettings + "cursor_password.png"
                visible: false
            }

            Text {
                id: txtCallNumber6
                x:0;width:100
                color: colorInfo.black;
                font.pixelSize: 50;
                font.family:"HDR"
                anchors.centerIn: parent
                horizontalAlignment:TextInput.AlignHCenter
                //cursorVisible:false
                //focus: true
                //maximumLength: 1
            }
        } // End Rectangle
    } // End Row

    //---------------------------------------- KeyPad
    Rectangle {
        x:0; y: 368-90-168 // 110
        width:576; height:335
        color:colorInfo.transparent
        Column {
            spacing:5
            Row {
                spacing: 4
                PINKeyPadButton {
                    imgX: 71; imgY: 15
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    dialNumImg: imgFolderBt_phone + "keypad_num_1.png"
                    onClicked: {
                        if(txtCallNumber1.text == ""){
                            txtCallNumber1.text="1"
                            cursor2()
                        }
                        else if(txtCallNumber2.text == ""){
                            txtCallNumber2.text="1"
                            cursor3()
                        }
                        else if(txtCallNumber3.text == ""){
                            txtCallNumber3.text="1"
                            cursor4()
                        }
                        else if(txtCallNumber4.text == ""){
                            txtCallNumber4.text="1"
                            cursor5()
                        }
                        else if(txtCallNumber5.text == ""){
                            txtCallNumber5.text="1"
                            cursor6()
                        }
                        else if(txtCallNumber6.text == ""){
                            txtCallNumber6.text="1"
                            cursorZero()
                        } // End if
                    }
                } // End PINKeyPadButton
                PINKeyPadButton {
                    imgX: 71; imgY: 15
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    dialNumImg: imgFolderBt_phone + "keypad_num_2.png"
                    onClicked: {
                        if(txtCallNumber1.text == ""){
                            txtCallNumber1.text="2"
                            cursor2()
                        }
                        else if(txtCallNumber2.text == ""){

                            txtCallNumber2.text="2"
                            cursor3()
                        }
                        else if(txtCallNumber3.text == ""){
                            txtCallNumber3.text="2"
                            cursor4()
                        }
                        else if(txtCallNumber4.text == ""){
                            txtCallNumber4.text="2"
                            cursor5()
                        }
                        else if(txtCallNumber5.text == ""){
                            txtCallNumber5.text="2"
                            cursor6()
                        }
                        else if(txtCallNumber6.text == ""){
                            txtCallNumber6.text="2"
                            cursorZero()
                        } // End if
                    }
                } // End PINKeyPadButton
                PINKeyPadButton {
                    imgX: 71; imgY: 15
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    dialNumImg: imgFolderBt_phone + "keypad_num_3.png"
                    onClicked: {
                        if(txtCallNumber1.text == "")
                        {    txtCallNumber1.text="3"
                            cursor2()
                        }else if(txtCallNumber2.text == ""){
                            txtCallNumber2.text="3"
                            cursor3()
                        }else if(txtCallNumber3.text == ""){
                            txtCallNumber3.text="3"
                            cursor4()
                        }else if(txtCallNumber4.text == ""){
                            txtCallNumber4.text="3"
                            cursor5()
                        }else if(txtCallNumber5.text == ""){
                            txtCallNumber5.text="3"
                            cursor6()
                        }else if(txtCallNumber6.text == ""){
                            txtCallNumber6.text="3"
                            cursorZero()
                        } // End if
                    }
                } // End PINKeyPadButton
            } // End Row
            Row {
                spacing:4
                PINKeyPadButton {
                    imgX: 71; imgY: 15
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    dialNumImg: imgFolderBt_phone + "keypad_num_4.png"
                    onClicked: {
                        if(txtCallNumber1.text == ""){
                            txtCallNumber1.text="4"
                            cursor2()
                        }else if(txtCallNumber2.text == ""){
                            txtCallNumber2.text="4"
                            cursor3()
                        }else if(txtCallNumber3.text == ""){
                            txtCallNumber3.text="4"
                            cursor4()
                        }else if(txtCallNumber4.text == ""){
                            txtCallNumber4.text="4"
                            cursor5()
                        }else if(txtCallNumber5.text == ""){
                            txtCallNumber5.text="4"
                            cursor6()
                        }else if(txtCallNumber6.text == ""){
                            txtCallNumber6.text="4"
                            cursorZero()
                        } // End if
                    }
                } // End PINKeyPadButton
                PINKeyPadButton {
                    imgX: 71; imgY: 15
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    dialNumImg: imgFolderBt_phone + "keypad_num_5.png"
                    onClicked: {
                        if(txtCallNumber1.text == ""){
                            txtCallNumber1.text="5"
                            cursor2()
                        }else if(txtCallNumber2.text == ""){
                            txtCallNumber2.text="5"
                            cursor3()
                        }else if(txtCallNumber3.text == ""){
                            txtCallNumber3.text="5"
                            cursor4()
                        }else if(txtCallNumber4.text == ""){
                            txtCallNumber4.text="5"
                            cursor5()
                        }else if(txtCallNumber5.text == ""){
                            txtCallNumber5.text="5"
                            cursor6()
                        }else if(txtCallNumber6.text == ""){
                            txtCallNumber6.text="5"
                            cursorZero()
                        } // End if
                    }
                } // End PINKeyPadButton
                PINKeyPadButton {
                    imgX: 71; imgY: 15
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    dialNumImg: imgFolderBt_phone + "keypad_num_6.png"
                    onClicked: {
                        if(txtCallNumber1.text == ""){
                            txtCallNumber1.text="6"
                            cursor2()
                        }else if(txtCallNumber2.text == ""){
                            txtCallNumber2.text="6"
                            cursor3()
                        }else if(txtCallNumber3.text == ""){
                            txtCallNumber3.text="6"
                            cursor4()
                        }else if(txtCallNumber4.text == ""){
                            txtCallNumber4.text="6"
                            cursor5()
                        }else if(txtCallNumber5.text == ""){
                            txtCallNumber5.text="6"
                            cursor6()
                        }else if(txtCallNumber6.text == ""){
                            txtCallNumber6.text="6"
                            cursorZero()
                        } // End if
                    }
                } // End PINKeyPadButton
            } // End Row
            Row {
                spacing:4
                PINKeyPadButton {
                    imgX: 71; imgY: 15
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    dialNumImg: imgFolderBt_phone + "keypad_num_7.png"

                    onClicked: {
                        if(txtCallNumber1.text == ""){
                            txtCallNumber1.text="7"
                            cursor2()
                        }else if(txtCallNumber2.text == ""){
                            txtCallNumber2.text="7"
                            cursor3()
                        }else if(txtCallNumber3.text == ""){
                            txtCallNumber3.text="7"
                            cursor4()
                        }else if(txtCallNumber4.text == ""){
                            txtCallNumber4.text="7"
                            cursor5()
                        }else if(txtCallNumber5.text == ""){
                            txtCallNumber5.text="7"
                            cursor6()
                        }else if(txtCallNumber6.text == ""){
                            txtCallNumber6.text="7"
                            cursorZero()
                        } // End if
                    }
                } // PINKeyPadButton
                PINKeyPadButton {
                    imgX: 71; imgY: 15
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    dialNumImg: imgFolderBt_phone + "keypad_num_8.png"
                    //subText:"TUV"
                    onClicked: {
                        if(txtCallNumber1.text == ""){
                            txtCallNumber1.text="8"
                            cursor2()
                        }else if(txtCallNumber2.text == ""){
                            txtCallNumber2.text="8"
                            cursor3()
                        }else if(txtCallNumber3.text == ""){
                            txtCallNumber3.text="8"
                            cursor4()
                        }else if(txtCallNumber4.text == ""){
                            txtCallNumber4.text="8"
                            cursor5()
                        }else if(txtCallNumber5.text == ""){
                            txtCallNumber5.text="8"
                            cursor6()
                        }else if(txtCallNumber6.text == ""){
                            txtCallNumber6.text="8"
                            cursorZero()
                        } // End if
                    }
                } // End PINKeyPadButton
                PINKeyPadButton {
                    imgX: 71; imgY: 15
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    dialNumImg: imgFolderBt_phone + "keypad_num_9.png"
                    //subText:"WXYZ"
                    onClicked: {
                        if(txtCallNumber1.text == ""){
                            txtCallNumber1.text="9"
                            cursor2()
                        }else if(txtCallNumber2.text == ""){
                            txtCallNumber2.text="9"
                            cursor3()
                        }else if(txtCallNumber3.text == ""){
                            txtCallNumber3.text="9"
                            cursor4()
                        }else if(txtCallNumber4.text == ""){
                            txtCallNumber4.text="9"
                            cursor5()
                        }else if(txtCallNumber5.text == ""){
                            txtCallNumber5.text="9"
                            cursor6()
                        }else if(txtCallNumber6.text == ""){
                            txtCallNumber6.text="9"
                            cursorZero()
                        } // End if
                    }
                } // End PINKeyPadButton
            } // End Row
            Row {
                spacing:4
                PINKeyPadButton {
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    //dialNumImg: ""

                    MComp.Label{
                        text: "Clear All"
                        fontName: "HDR"
                        fontSize: 36
                        txtAlign: "Center"
                        fontColor: colorInfo.brightGrey
                    }

                    onClicked: {
                        txtCallNumber1.text=""
                        txtCallNumber2.text=""
                        txtCallNumber3.text=""
                        txtCallNumber4.text=""
                        txtCallNumber5.text=""
                        txtCallNumber6.text=""
                        cursor1()
                    }
                } // End PINKeyPadButton
                PINKeyPadButton {
                    imgX: 71; imgY: 15
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    dialNumImg: imgFolderBt_phone + "keypad_num_0.png"
                    onClicked: {
                        if(txtCallNumber1.text == ""){
                            txtCallNumber1.text="0"
                            cursor2()
                        }else if(txtCallNumber2.text == ""){
                            txtCallNumber2.text="0"
                            cursor3()
                        }else if(txtCallNumber3.text == ""){
                            txtCallNumber3.text="0"
                            cursor4()
                        }else if(txtCallNumber4.text == ""){
                            txtCallNumber4.text="0"
                            cursor5()
                        }else if(txtCallNumber5.text == ""){
                            txtCallNumber5.text="0"
                            cursor6()
                        }else if(txtCallNumber6.text == ""){
                            txtCallNumber6.text="0"
                            cursorZero()
                        } // End if
                    }
                } // End PINKeyPadButton
                PINKeyPadButton {
                    imgX: 57; imgY: 15
                    width:189; height:80
                    bgImage: imgFolderSettings  + "btn_keypad_n.png"
                    bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
                    //dialNumImg: imgFolderSettings + "keypad_del.png"

                    Image{
                        x: 57; y: 15
                        width:78; height:47
                        source: imgFolderSettings + "keypad_del.png"
                    }

                    onClicked: {
                        if(txtCallNumber6.text != ""){
                            txtCallNumber6.text=""
                            cursor5()
                        }else if(txtCallNumber5.text != ""){
                            txtCallNumber5.text=""
                            cursor4()
                        }else if(txtCallNumber4.text != ""){
                            txtCallNumber4.text=""
                            cursor3()
                        }else if(txtCallNumber3.text != ""){
                            txtCallNumber3.text=""
                            cursor2()
                        }else if(txtCallNumber2.text != ""){
                            txtCallNumber2.text=""
                            cursor1()
                        }else if(txtCallNumber1.text != ""){
                            txtCallNumber1.text=""
                        } // End if
                    }
                } // End MComp.PINKeyPadButton
            } // End Row
        } // End Column
    } // End Rectangle
}  // End Rectangle

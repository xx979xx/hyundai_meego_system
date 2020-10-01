import Qt 4.7
import "../DH" as MComp
import "../../system/DH" as MSystem

FocusScope {
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }

    id : idPinComp
    x: 352; y: 77
    width: 573//systemInfo.lcdWidth
    height: 110+335

    property string imgFolderSettings : imageInfo.imgFolderSettings
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderBt_phone: imageInfo.imgFolderBt_phone
    property int numCount: 0
    //signal callButtonPressed()

    function cursor1(){
        console.debug("cursor1")
        aniCallNumber1.visible=true
        aniCallNumber2.visible=false
        aniCallNumber3.visible=false
        aniCallNumber4.visible=false
    } // End function

    function cursor2(){
        console.debug("cursor2")
        aniCallNumber1.visible=false
        aniCallNumber2.visible=true
        aniCallNumber3.visible=false
        aniCallNumber4.visible=false
    } // End function

    function cursor3(){
        console.debug("cursor3")
        aniCallNumber1.visible=false
        aniCallNumber2.visible=false
        aniCallNumber3.visible=true
        aniCallNumber4.visible=false
    } // End function

    function cursor4(){
        console.debug("cursor4")
        aniCallNumber1.visible=false
        aniCallNumber2.visible=false
        aniCallNumber3.visible=false
        aniCallNumber4.visible=true

    } // End function

    function cursorZero(){
        console.debug("cursorZero")
        aniCallNumber1.visible=false
        aniCallNumber2.visible=false
        aniCallNumber3.visible=false
        aniCallNumber4.visible=false
        changeLockNum=txtCallNumber1.text+txtCallNumber2.text+txtCallNumber3.text+txtCallNumber4.text
        lockNum=changeLockNum
    } // End function

    Row{
        spacing: 7
        x: 0; y: 0
        width: 352-168; height: 81

        Item {
            width: 138; height: 81           
            BorderImage {
                id: idBorder
                source: imgFolderSettings + "bg_password_4.png"
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
            }            
        } // End Rectangle
        Item {
            width: 138; height: 81            

            BorderImage {
                source: imgFolderSettings+"bg_password_4.png"
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
        Item {
            width: 138; height: 81

            BorderImage {
                source: imgFolderSettings+"bg_password_4.png"
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
        Item {
            width: 138; height: 81

            BorderImage {
                source: imgFolderSettings+"bg_password_4.png"
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
    } // End Row

    //---------------------------------------- KeyPad

    PINKeyPadButton {
        id: idPinBtn1
        x:0; y: 368-90-168 // 110
        imgX: 71; imgY: 15
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: imgFolderBt_phone + "keypad_num_1.png"
        focus: true
        KeyNavigation.left: idPinBtn1
        KeyNavigation.right: idPinBtn2
        //KeyNavigation.up: parent.forceActiveFocus
        KeyNavigation.down: idPinBtn4
        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtn1.forceActiveFocus()}
            if(numCount<=3){
                numCount=numCount+1
                //changeLockNum=changeLockNum+"1"
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
                    cursorZero()
                }
            }
            else{
                console.log("Full Number")
            }
        } // End if
        Keys.onPressed:{
            if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if(numCount<=3){
                    numCount=numCount+1
                    //changeLockNum=changeLockNum+"1"
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
                        cursorZero()
                    }
                }
                break;
            }
        }
    } // End PINKeyPadButton
    PINKeyPadButton {
        id: idPinBtn2
        x:0 + 193; y: 368-90-168
        imgX: 71; imgY: 15
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: imgFolderBt_phone + "keypad_num_2.png"
        KeyNavigation.left: idPinBtn1
        KeyNavigation.right: idPinBtn3
        //KeyNavigation.up: parent.forceActiveFocus
        KeyNavigation.down: idPinBtn5
        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtn2.forceActiveFocus()}
            if(numCount<=3){
                numCount=numCount+1
                //changeLockNum=changeLockNum+"2"
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
                    cursorZero()
                } // End if
            }
            else{
                console.log("Full Number")
            }
        }
        Keys.onPressed:{
            if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if(numCount<=3){
                    numCount=numCount+1
                    //changeLockNum=changeLockNum+"2"
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
                        cursorZero()
                    } // End if
                }
                break;
            }
        }
    } // End PINKeyPadButton
    PINKeyPadButton {
        id: idPinBtn3
        x:0+193+193; y: 368-90-168
        imgX: 71; imgY: 15
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: imgFolderBt_phone + "keypad_num_3.png"
        KeyNavigation.left: idPinBtn2
        KeyNavigation.right: idPinBtn3
        //KeyNavigation.up: parent.forceActiveFocus
        KeyNavigation.down: idPinBtn6
        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtn3.forceActiveFocus()}
            if(numCount<=3){
                numCount=numCount+1
                //changeLockNum=changeLockNum+"3"
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
                    cursorZero()
                } // End if
            }
            else{
                console.log("Full Number")
            }
        }
        Keys.onPressed:{
            if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if(numCount<=3){
                    numCount=numCount+1
                    //changeLockNum=changeLockNum+"3"
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
                        cursorZero()
                    } // End if
                }
                break;
            }
        }
    }


    PINKeyPadButton {
        id: idPinBtn4
        x:0; y: 368-90-168+85
        imgX: 71; imgY: 15
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: imgFolderBt_phone + "keypad_num_4.png"
        KeyNavigation.left: idPinBtn4
        KeyNavigation.right: idPinBtn5
        KeyNavigation.up: idPinBtn1
        KeyNavigation.down: idPinBtn7
        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtn4.forceActiveFocus()}
            if(numCount<=3){
                numCount=numCount+1
                //changeLockNum=changeLockNum+"4"
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
                    cursorZero()
                } // End if
            }
            else{
                console.log("Full Number")
            }
        }
        Keys.onPressed:{
            if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if(numCount<=3){
                    numCount=numCount+1
                    //changeLockNum=changeLockNum+"4"
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
                        cursorZero()
                    } // End if
                }
                break;
            }
        }
    }
    PINKeyPadButton {
        id: idPinBtn5
        x:0+193; y: 368-90-168+85
        imgX: 71; imgY: 15
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: imgFolderBt_phone + "keypad_num_5.png"
        KeyNavigation.left: idPinBtn4
        KeyNavigation.right: idPinBtn6
        KeyNavigation.up: idPinBtn2
        KeyNavigation.down: idPinBtn8
        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtn5.forceActiveFocus()}
            if(numCount<=3){
                numCount=numCount+1
                //changeLockNum=changeLockNum+"5"
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
                    cursorZero()
                } // End if
            }
            else{
                console.log("Full Number")
            }
        }
        Keys.onPressed:{
            if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if(numCount<=3){
                    numCount=numCount+1
                    //changeLockNum=changeLockNum+"5"
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
                        cursorZero()
                    } // End if
                }
                break;
            }
        }
    } // End PINKeyPadButton
    PINKeyPadButton {
        id: idPinBtn6
        x:0+193+193; y: 368-90-168+85
        imgX: 71; imgY: 15
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: imgFolderBt_phone + "keypad_num_6.png"
        KeyNavigation.left: idPinBtn5
        KeyNavigation.right: idPinBtn6
        KeyNavigation.up: idPinBtn3
        KeyNavigation.down: idPinBtn9
        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtn6.forceActiveFocus()}
            if(numCount<=3){
                numCount=numCount+1
                //changeLockNum=changeLockNum+"6"
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
                    cursorZero()
                } // End if
            }
            else{
                console.log("Full Number")
            }
        }
        Keys.onPressed:{
            if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if(numCount<=3){
                    numCount=numCount+1
                    //changeLockNum=changeLockNum+"6"
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
                        cursorZero()
                    } // End if
                }
                break;
            }
        }
    } // End PINKeyPadButton

    PINKeyPadButton {
        id: idPinBtn7
        x:0; y: 368-90-168+85+85
        imgX: 71; imgY: 15
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: imgFolderBt_phone + "keypad_num_7.png"
        KeyNavigation.left: idPinBtn7
        KeyNavigation.right: idPinBtn8
        KeyNavigation.up: idPinBtn4
        KeyNavigation.down: idPinBtnDelAll
        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtn7.forceActiveFocus()}
            if(numCount<=3){
                numCount=numCount+1
                //changeLockNum=changeLockNum+"7"
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
                    cursorZero()
                } // End if
            }
            else{

            }
        }
        Keys.onPressed:{
            if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if(numCount<=3){
                    numCount=numCount+1
                    //changeLockNum=changeLockNum+"7"
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
                        cursorZero()
                    } // End if
                }
                break;
            }
        }
    }
    PINKeyPadButton {
        id: idPinBtn8
        x:0+193; y: 368-90-168+85+85
        imgX: 71; imgY: 15
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: imgFolderBt_phone + "keypad_num_8.png"
        KeyNavigation.left: idPinBtn7
        KeyNavigation.right: idPinBtn9
        KeyNavigation.up: idPinBtn5
        KeyNavigation.down: idPinBtn0
        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtn8.forceActiveFocus()}
            if(numCount<=3){
                numCount=numCount+1
                //changeLockNum=changeLockNum+"8"
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
                    cursorZero()
                } // End if
            }
            else{
            }
        }
        Keys.onPressed:{
            if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if(numCount<=3){
                    numCount=numCount+1
                    //changeLockNum=changeLockNum+"8"
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
                        cursorZero()
                    } // End if
                }
                break;
            }
        }
    } // End PINKeyPadButton
    PINKeyPadButton {
        id: idPinBtn9
        x:0+193+193; y: 368-90-168+85+85
        imgX: 71; imgY: 15
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: imgFolderBt_phone + "keypad_num_9.png"
        KeyNavigation.left: idPinBtn8
        KeyNavigation.right: idPinBtn9
        KeyNavigation.up: idPinBtn6
        KeyNavigation.down: idPinBtnDel
        //subText:"WXYZ"
        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtn9.forceActiveFocus()}
            if(numCount<=3){
                numCount=numCount+1
                //changeLockNum=changeLockNum+"9"
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
                    cursorZero()
                } // End if
            }
            else{
            }
        }
        Keys.onPressed:{
            if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if(numCount<=3){
                    numCount=numCount+1
                    //changeLockNum=changeLockNum+"9"
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
                        cursorZero()
                    } // End if
                }
                break;
            }
        }
    } // End PINKeyPadButton

    PINKeyPadButton {
        id: idPinBtnDelAll
        x:0; y: 368-90-168+85+85+85
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: ""
        KeyNavigation.left: idPinBtnDelAll
        KeyNavigation.right: idPinBtn0
        KeyNavigation.up: idPinBtn7
        KeyNavigation.down: idPinBtnDelAll
        MComp.Label{
            text: "Clear All"
            fontName: "HDR"
            fontSize: 36
            txtAlign: "Center"
            fontColor: colorInfo.brightGrey
        }

        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtnDelAll.forceActiveFocus()}
            numCount=0
            txtCallNumber1.text=""
            txtCallNumber2.text=""
            txtCallNumber3.text=""
            txtCallNumber4.text=""
            changeLockNum=""
            cursor1()
        }
        Keys.onPressed:{
            if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:{
                numCount=0
                txtCallNumber1.text=""
                txtCallNumber2.text=""
                txtCallNumber3.text=""
                txtCallNumber4.text=""
                changeLockNum=""
                cursor1()
            }
            break;
            }
        }
    } // End PINKeyPadButton
    PINKeyPadButton {
        id: idPinBtn0
        x:0+193; y: 368-90-168+85+85+85
        imgX: 71; imgY: 15
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: imgFolderBt_phone + "keypad_num_0.png"
        KeyNavigation.left: idPinBtnDelAll
        KeyNavigation.right: idPinBtnDel
        KeyNavigation.up: idPinBtn8
        KeyNavigation.down: idPinBtn0
        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtn0.forceActiveFocus()}
            if(numCount<=3){
                numCount=numCount+1
                //changeLockNum=changeLockNum+"0"
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
                    cursorZero()
                } // End if
            }
            else{
            }
        }
        Keys.onPressed:{
            if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:
                if(numCount<=3){
                    numCount=numCount+1
                    //changeLockNum=changeLockNum+"0"
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
                        cursorZero()
                    } // End if
                }
                break;
            }
        }

    } // End PINKeyPadButton
    PINKeyPadButton {
        id: idPinBtnDel
        x:0+193+193; y: 368-90-168+85+85+85
        imgX: 57; imgY: 15
        width:189; height:80
        bgImage: imgFolderSettings  + "btn_keypad_n.png"
        bgImagePressed: imgFolderSettings + "btn_keypad_p.png"
        dialNumImg: ""
        KeyNavigation.left: idPinBtn0
        KeyNavigation.right: idPinBtnDel
        KeyNavigation.up: idPinBtn9
        KeyNavigation.down: idPinBtnDel
        Image{
            x: 57; y: 15
            width:78; height:47
            source: imgFolderSettings + "keypad_del.png"
        }

        onClicked: {
            if(isFocusMode){ isFocusMode = false; idPinBtnDel.forceActiveFocus()}
            numCount=numCount-1
            if(txtCallNumber4.text != ""){
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
        Keys.onPressed:{
           if(!isFocusMode){ isFocusMode = true; event.accepted = true; return;}
            switch(event.key){
            case Qt.Key_Return:
            case Qt.Key_Enter:{
                numCount=numCount-1
                if(txtCallNumber4.text != ""){
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
            break;
            }
        }
    } // End MComp.PINKeyPadButton
}  // End Rectangle

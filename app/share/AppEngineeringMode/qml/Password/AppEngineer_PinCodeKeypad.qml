import Qt 4.7
import "../../qml/Component" as MComp
import "../../qml/System" as MSystem
import "../Operation/operation.js" as MOp
import "../../../" as MBt

MComp.MComponent {
    id : idSettingsBtPinCodeKeypad
    x: 0; y: 0
    width: 66+151+151+151+201 //systemInfo.lcdWidth
    height: systemInfo.lcdHeight-215
    focus:true

    MSystem.ColorInfo { id: colorInfo }
    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }

    property string imgFolderSettings : imageInfo.imgFolderSettings
    property string imgFolderBt_phone: imageInfo.imgFolderBt_phone
    property int keypadWidth: 190
    property int keypadHeight: 84
    property int keypadImgX: 71
    property int keypadImgY: 15
    property int cellWidth: 138
    property int cellHeight: 81
    property int aniCellX: 15
    property int aniCellY: 20
    property int txtCellWidth: 100
    property int kyepadY: 110 // 368-90-168
    property int numCount: 0
    property string txtPwdNum1 : ""
    property string txtPwdNum2 : ""
    property string txtPwdNum3 : ""
    property string txtPwdNum4 : ""
    property string txtCheck1 : ""
    property string txtCheck2 : ""
    property string txtCheck3 : ""
    property string txtCheck4 : ""
    property string popupState : ""
    //property string checkPinCode
    property string enterMenu: ""

    Component.onCompleted:{
        txtCallNumber1.text=""
        txtCallNumber2.text=""
        txtCallNumber3.text=""
        txtCallNumber4.text=""
        changeLockNum=""
        //cursor1()
        numCount=0
        idPinBtn1.forceActiveFocus()
    }

    onVisibleChanged: {
        txtCallNumber1.text=""
        txtCallNumber2.text=""
        txtCallNumber3.text=""
        txtCallNumber4.text=""
        changeLockNum=""
        //cursor1()
        numCount=0
        idPinBtn1.forceActiveFocus()
    }
    function setMenuAppScreen(screenName, save){
        MOp.setMapCareScreen(screenName,save);
    }
    //--------------------- Delete this cursor #
    function setDeletedCode(){
        console.log(" # function setDeletedCode")
        numCount=numCount-1
        if(txtCallNumber4.text != ""){
            txtCallNumber4.text=""
            //cursor3()
        }else if(txtCallNumber3.text != ""){
            txtCallNumber3.text=""
            //cursor2()
        }else if(txtCallNumber2.text != ""){
            txtCallNumber2.text=""
            //cursor1()
        }else if(txtCallNumber1.text != ""){
            txtCallNumber1.text=""
            numCount=numCount
        } // End if
    } // End function

    //--------------------- Clear all cursor #
    function setClearAll(){
        console.log(" # function setClearAll")
        txtCallNumber1.text=""
        txtCallNumber2.text=""
        txtCallNumber3.text=""
        txtCallNumber4.text=""
        changeLockNum=""
        //cursor1()
        numCount=0
    } // End function

    //--------------------- Set code #
    function setNumber(count, number){
        switch(count){
        case 0:
            if(txtCallNumber1.text == ""){
                txtCallNumber1.text= "*"
                txtCheck1=number
                //cursor2()
            } // End if
            break;
        case 1:
            if(txtCallNumber2.text == ""){
                txtCallNumber2.text="*"
                txtCheck2=number
                //cursor3()
            } // End if
            break;
        case 2:
            if(txtCallNumber3.text == ""){
                txtCallNumber3.text="*"
                txtCheck3=number
                //cursor4()
            } // End if
            break;
        case 3:
            if(txtCallNumber4.text == ""){
                txtCallNumber4.text="*"
                txtCheck4=number
                savePinCode()
                //clickedBtPINcodeChanging(lockNum);
                //popupState="DimChangeOK"
            } // End if
            break;
        default :
            console.log(" # Call cursor1() ")
            //cursor1()
            break;
        } // End switch
        numCount=numCount+1
    } // End function

    //    //--------------------- Move to cursor1 #
    //    function cursor1(){
    //        aniCallNumber1.visible=true
    //        aniCallNumber2.visible=false
    //        aniCallNumber3.visible=false
    //        aniCallNumber4.visible=false
    //    } // End function

    //    //--------------------- Move to cursor2 #
    //    function cursor2(){
    //        aniCallNumber1.visible=false
    //        aniCallNumber2.visible=true
    //        aniCallNumber3.visible=false
    //        aniCallNumber4.visible=false
    //    } // End function

    //    //--------------------- Move to cursor3 #
    //    function cursor3(){
    //        aniCallNumber1.visible=false
    //        aniCallNumber2.visible=false
    //        aniCallNumber3.visible=true
    //        aniCallNumber4.visible=false
    //    } // End function

    //    //--------------------- Move to cursor4 #
    //    function cursor4(){
    //        aniCallNumber1.visible=false
    //        aniCallNumber2.visible=false
    //        aniCallNumber3.visible=false
    //        aniCallNumber4.visible=true
    //    } // End function

    //--------------------- Clear all function #
    function cursorZero(){
        //        console.log(" # function cursorZero")
        //        aniCallNumber1.visible=false
        //        aniCallNumber2.visible=false
        //        aniCallNumber3.visible=false
        //        aniCallNumber4.visible=false
        setClearAll()
        numCount=0
        //        moveFocus()
    } // End function


    //--------------------- Save  PinCode #
    function savePinCode(){
        changeLockNum=txtCheck1+txtCheck2+txtCheck3+txtCheck4
        if(mainViewState == "Software")
        {
            if(changeLockNum == "1358") {
                if(isMapCareMain){
                    console.log("[QML] enter mapcare software menu")
                    setMapCareUIScreen("", true)
                    setMapCareUIScreen("Software", false)
                }
                else{
                    setMainAppScreen("", true)
                    setMainAppScreen("Software", false)
                }

            } else {
                popupState="DimWrongMSG"
                popupOffTimer.start()
                setClearAll()
                setDeletedCode()
                idPinBtn1.forceActiveFocus()

            }

        }
        else if(mainViewState == "Hardware")
        {
            if(changeLockNum == "4763") {
                if(isMapCareMain){
                    console.log("[QML] enter mapcare Hardware menu")
                    setMapCareUIScreen("", true)
                    setMapCareUIScreen("Hardware", false)
                }
                else{
                    setMainAppScreen("", true)
                    setMainAppScreen("Hardware", false)
                }


            } else {
                popupState="DimWrongMSG"
                popupOffTimer.start()
                setClearAll()
                setDeletedCode()
                idPinBtn1.forceActiveFocus()

            }
        }
        else if(mainViewState == "Dynamics")
        {
            if(changeLockNum == "0716") {
                if(isMapCareMain){
                    console.log("[QML] enter mapcare Dynamics menu")
                    setMapCareUIScreen("", true)
                    setMapCareUIScreen("Dynamics", false)
                }
                else{
                    setMainAppScreen("", true)
                    setMainAppScreen(variantString, false)
                }

            } else {
                popupState="DimWrongMSG"
                popupOffTimer.start()
                setClearAll()
                setDeletedCode()
                idPinBtn1.forceActiveFocus()

            }
        }
        else if(mainViewState == "Update")
        {
            if(changeLockNum == "4590") {
                setMainAppScreen("", true)
                 setMainAppScreen("Update", false)
            } else {
                popupState="DimWrongMSG"
                popupOffTimer.start()
                setClearAll()
                setDeletedCode()
                idPinBtn1.forceActiveFocus()

            }
        }
        else if(mainViewState == "LogSetting")
        {
            if(changeLockNum == "4259") {

                if(isMapCareMain){
                    console.log("[QML] enter mapcare LogSetting menu")
                    setMapCareUIScreen("", true)
                    setMapCareUIScreen("LogSetting", false)
                }
                else{
                    setMainAppScreen("", true)
                    setMainAppScreen("LogSetting", true)
                }


            } else {
                popupState="DimWrongMSG"
                popupOffTimer.start()
                setClearAll()
                setDeletedCode()
                idPinBtn1.forceActiveFocus()

            }
        }
        else if(mainViewState == "AutoTest")
        {
            if(changeLockNum == "4260") {
                SystemInfo.CompareVersion();
                setMainAppScreen("", true)
                setMainAppScreen("AutoTest", false)
            } else {
                popupState="DimWrongMSG"
                popupOffTimer.start()
                setClearAll()
                setDeletedCode()
                idPinBtn1.forceActiveFocus()

            }
        }
        else if(mainViewState == "Password")
        {
                if(changeLockNum == "0428") {

                    flagState = 9
                    setMainAppScreen("", true)
                     mainViewState = "Main"
                   // idFullMainView.visible = true

                    idFullMainView.forceActiveFocus()
                    fullSoftButton.fullsoftButton.focus = true
                    fullSoftButton.fullsoftButton.forceActiveFocus()
                }
                else {
                    popupState="DimWrongMSG"
                    popupOffTimer.start()
                    setClearAll()
                    setDeletedCode()
                    idPinBtn1.forceActiveFocus()
                }
        }
        else if(mainViewState == "Variant")
        {
            if(changeLockNum == "6172") {
                if(isMapCareMain)
                {
                    console.log("[QML] enter mapcare LogSetting menu")
                    setMapCareUIScreen("", true)
                    setMapCareUIScreen("Variant", false)
                }
                else
                {
                    setMainAppScreen("", true)
                    setMainAppScreen("Variant", false)
                }

            } else {
                popupState="DimWrongMSG"
                popupOffTimer.start()
                setClearAll()
                setDeletedCode()
                idPinBtn1.forceActiveFocus()

            }
        }

        else if(mainViewState == "Diagnosis")
        {
            if(changeLockNum == "5173") {
                if(isMapCareMain)
                {
                    console.log("[QML] enter mapcare Diagnostic menu")
                    setMapCareUIScreen("", true)
                    setMapCareUIScreen("Diagnosis", false)
                }
                else
                {
                    setMainAppScreen("", true)
                    setMainAppScreen("Diagnosis", false)
                }

            } else {
                popupState="DimWrongMSG"
                popupOffTimer.start()
                setClearAll()
                setDeletedCode()
                idPinBtn1.forceActiveFocus()

            }
        }
        else if(mainViewState == "MapCareMode")
        {
            if(changeLockNum == "3649") {
                if(isMapCareMain)
                {
                    console.log("[QML] enter NAVI mapcare  menu")
                    UIListener.Dynamic_MapCare_FG()
                }


            } else {
                popupState="DimWrongMSG"
                popupOffTimer.start()
                setClearAll()
                setDeletedCode()
                idPinBtn1.forceActiveFocus()

            }
        }

        //        if(changeLockNum == "0000") {

        //            flagState = 9
        //            setMainAppScreen("", true)
        //             mainViewState = "Main"
        //           // idFullMainView.visible = true

        //            idFullMainView.forceActiveFocus()
        //            fullSoftButton.fullsoftButton.focus = true
        //            fullSoftButton.fullsoftButton.forceActiveFocus()
        //        } else {
        //            popupState="DimWrongMSG"
        //            popupOffTimer.start()
        //            setClearAll()
        //            setDeletedCode()
        //            idPinBtn1.forceActiveFocus()
        //           }


    } // End function

    //--------------------- 4 Cell's #
    Row{
        spacing: 7
        x:66
        y:37
        //width: 352-168; height: cellHeight

        //--------------------- Cell 1 ##
        Item {
            width: cellWidth; height: cellHeight
            Image {
                id: inputBox1
                source: inputBox1.focus=true?imgFolderSettings + "bg_auth_input_n.png":imgFolderSettings + "bg_auth_input_s.png"
                width:132
                height:96
                focus:true
                KeyNavigation.right:inputBox2
            }
            AnimatedImage{
                id: aniCallNumber1
                x: aniCellX ; y: aniCellY
                source: imgFolderSettings + "cursor_password.png"
                visible: (numCount==0)?true:false
            }
            Text {
                id: txtCallNumber1
                x:17; width:98
                y:20
                color: colorInfo.buttonGrey;
                font.pixelSize: 50;
                font.family:UIListener.getFont(false)//"HDR"
                anchors.centerIn: parent
                horizontalAlignment:TextInput.AlignHCenter
            }
        } // End Item
        //--------------------- Cell 2 ##
        Item {
            width: cellWidth; height: cellHeight

            BorderImage {
                id:inputBox2
                source: imgFolderSettings + "bg_auth_input_n.png"
                border.left: 25;
            }

            AnimatedImage{
                id: aniCallNumber2
                x: aniCellX ; y: aniCellY
                source: imgFolderSettings + "cursor_password.png"
                visible: (numCount==1)?true:false
            }

            Text {
                id: txtCallNumber2
                x:17; width:98
                y:20
                color: colorInfo.buttonGrey;
                font.pixelSize: 50;
                font.family:UIListener.getFont(false)//"HDR"
                anchors.centerIn: parent
                horizontalAlignment:TextInput.AlignHCenter
                //cursorVisible:false
                //focus: true
                //maximumLength: 1
            }
        } // End Item
        //--------------------- Cell 3 ##
        Item {
            width: cellWidth; height: cellHeight

            BorderImage {
                source: imgFolderSettings + "bg_auth_input_n.png"
                width:132
                height:96
            }
            AnimatedImage{
                id: aniCallNumber3
                x: aniCellX ; y: aniCellY
                source: imgFolderSettings + "cursor_password.png"
                visible: (numCount==2)?true:false
            }

            Text {
                id: txtCallNumber3
                x:17; width:98
                y:20
                color: colorInfo.buttonGrey;
                font.pixelSize: 50;
                font.family:UIListener.getFont(false)//"HDR"
                anchors.centerIn: parent
                horizontalAlignment:TextInput.AlignHCenter
                //cursorVisible:false
                //focus: true
                //maximumLength: 1
            }
        } // End Item
        //--------------------- Cell 4 ##
        Item {
            width: cellWidth; height: cellHeight

            BorderImage {
                source: imgFolderSettings + "bg_auth_input_n.png"

            }
            AnimatedImage{
                id: aniCallNumber4
                x: aniCellX ; y: aniCellY
                source: imgFolderSettings + "cursor_password.png"
                visible: (numCount==3)?true:false
            }

            Text {
                id: txtCallNumber4
                x:17; width:98
                y:20
                color: colorInfo.buttonGrey;
                font.pixelSize: 50;
                font.family:UIListener.getFont(false)//"HDR"
                anchors.centerIn: parent
                horizontalAlignment:TextInput.AlignHCenter
            }
        } // End Item
    } // End Row

    Column{
        x:352-280; y: 362-215
        spacing: 2
        focus:true
        //--------------------- KeyPad #
        Row{
            spacing: -4
            focus:true
            //--------------------- Nember 1 ##
            MComp.MButtonTouch {
                id: idPinBtn1
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_num_fp.png"
                fgImage: imgFolderBt_phone + "dial_num_1_n.png"

                fgImageX: keypadImgX; fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                focus: true
                KeyNavigation.left: idPinBtn1
                KeyNavigation.right: idPinBtn2
                KeyNavigation.down: idPinBtn4
                //added for Password UpKeyPress Issue
                onUpKeyPressed: {
                    console.log("[QML]password Button 1 UpKeyPressed ---->")
                    bandBackKey.focus = true;
                    bandBackKey.forceActiveFocus()
                }
                onClickOrKeySelected: {
                    idPinBtn1.forceActiveFocus()
                    setNumber(numCount, 1)
                }
                onWheelLeftKeyPressed: idPinBtnDel.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtn2.forceActiveFocus()
            } // End PINKeyPadButton
            //--------------------- Nember 2 ##
            MComp.MButtonTouch {
                id: idPinBtn2
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_num_fp.png"
                fgImage: imgFolderBt_phone + "dial_num_2_n.png"

                fgImageX: keypadImgX; fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                KeyNavigation.left: idPinBtn1
                KeyNavigation.right: idPinBtn3
                //KeyNavigation.up: parent.forceActiveFocus
                //added for Password UpKeyPress Issue
                KeyNavigation.down: idPinBtn5
                onUpKeyPressed: {
                    console.log("[QML]password Button 2 UpKeyPressed ---->")
                    bandBackKey.focus = true;
                    bandBackKey.forceActiveFocus()
                }
                onClickOrKeySelected: {
                    idPinBtn2.forceActiveFocus()
                    setNumber(numCount, 2)
                }
                onWheelLeftKeyPressed: idPinBtn1.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtn3.forceActiveFocus()
            } // End PINKeyPadButton
            //            //--------------------- Nember 3 ##
            MComp.MButtonTouch {
                id: idPinBtn3
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_num_fp.png"
                fgImage: imgFolderBt_phone + "dial_num_3_n.png"

                fgImageX: keypadImgX; fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                KeyNavigation.left: idPinBtn2
                KeyNavigation.right: idPinBtn3
                //KeyNavigation.up: parent.forceActiveFocus
                //added for Password UpKeyPress Issue
                onUpKeyPressed: {
                    console.log("[QML]password Button 3 UpKeyPressed ---->")
                    bandBackKey.focus = true;
                    bandBackKey.forceActiveFocus()
                }
                KeyNavigation.down: idPinBtn6
                onClickOrKeySelected: {
                    idPinBtn3.forceActiveFocus()
                    setNumber(numCount, 3)
                }
                onWheelLeftKeyPressed: idPinBtn2.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtn4.forceActiveFocus()
            } // End PINKeyPadButton
        } // End Row
        Row{
            spacing: -4
            //--------------------- Nember 4 ##
            MComp.MButtonTouch {
                id: idPinBtn4
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_num_fp.png"
                fgImage: imgFolderBt_phone + "dial_num_4_n.png"

                fgImageX: keypadImgX; fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                KeyNavigation.left: idPinBtn4
                KeyNavigation.right: idPinBtn5
                KeyNavigation.up: idPinBtn1
                KeyNavigation.down: idPinBtn7
                onClickOrKeySelected: {
                    idPinBtn4.forceActiveFocus()
                    setNumber(numCount, 4)
                }
                onWheelLeftKeyPressed: idPinBtn3.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtn5.forceActiveFocus()
            } // End PINKeyPadButton
            //--------------------- Nember 5 ##
            MComp.MButtonTouch {
                id: idPinBtn5
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_num_fp.png"
                fgImage: imgFolderBt_phone + "dial_num_5_n.png"

                fgImageX: keypadImgX; fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                KeyNavigation.left: idPinBtn4
                KeyNavigation.right: idPinBtn6
                KeyNavigation.up: idPinBtn2
                KeyNavigation.down: idPinBtn8
                onClickOrKeySelected: {
                    idPinBtn5.forceActiveFocus()
                    setNumber(numCount, 5)
                }
                onWheelLeftKeyPressed: idPinBtn4.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtn6.forceActiveFocus()
            } // End PINKeyPadButton
            //--------------------- Nember 6 ##
            MComp.MButtonTouch {
                id: idPinBtn6
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_num_fp.png"
                fgImage: imgFolderBt_phone + "dial_num_6_n.png"

                fgImageX: keypadImgX; fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                KeyNavigation.left: idPinBtn5
                KeyNavigation.right: idPinBtn6
                KeyNavigation.up: idPinBtn3
                KeyNavigation.down: idPinBtn9
                onClickOrKeySelected: {
                    idPinBtn6.forceActiveFocus()
                    setNumber(numCount, 6)
                }
                onWheelLeftKeyPressed: idPinBtn5.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtn7.forceActiveFocus()
            } // End PINKeyPadButton
        } // End Row
        Row{
            spacing: -4
            //--------------------- Nember 7 ##
            MComp.MButtonTouch {
                id: idPinBtn7
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_num_fp.png"
                fgImage: imgFolderBt_phone + "dial_num_7_n.png"

                fgImageX: keypadImgX; fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                focus: true
                KeyNavigation.left: idPinBtn7
                KeyNavigation.right: idPinBtn8
                KeyNavigation.up: idPinBtn4
                KeyNavigation.down: idPinBtnDelAll
                onClickOrKeySelected: {
                    idPinBtn7.forceActiveFocus()
                    setNumber(numCount, 7)
                }
                onWheelLeftKeyPressed: idPinBtn6.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtn8.forceActiveFocus()
            } // End PINKeyPadButton
            //--------------------- Nember 8 ##
            MComp.MButtonTouch {
                id: idPinBtn8
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_num_fp.png"
                fgImage: imgFolderBt_phone + "dial_num_8_n.png"

                fgImageX: keypadImgX; fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                focus: true
                KeyNavigation.left: idPinBtn7
                KeyNavigation.right: idPinBtn9
                KeyNavigation.up: idPinBtn5
                KeyNavigation.down: idPinBtn0
                onClickOrKeySelected: {
                    idPinBtn8.forceActiveFocus()
                    setNumber(numCount, 8)
                }
                onWheelLeftKeyPressed: idPinBtn7.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtn9.forceActiveFocus()
            } // End PINKeyPadButton
            //--------------------- Nember 9 ##
            MComp.MButtonTouch {
                id: idPinBtn9
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_num_fp.png"
                fgImage: imgFolderBt_phone + "dial_num_9_n.png"

                fgImageX: keypadImgX; fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                focus: true
                KeyNavigation.left: idPinBtn8
                KeyNavigation.right: idPinBtn9
                KeyNavigation.up: idPinBtn6
                KeyNavigation.down: idPinBtnDel
                //subText:"WXYZ"
                onClickOrKeySelected: {
                    idPinBtn9.forceActiveFocus()
                    setNumber(numCount, 9)
                }
                onWheelLeftKeyPressed: idPinBtn8.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtnDelAll.forceActiveFocus()
            } // End PINKeyPadButton
        } // End Row
        Row{
            spacing: -4
            //--------------------- Clear All ##
            MComp.MButton {
                id: idPinBtnDelAll
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
//                bgImage: imgFolderSettings  + "btn_auth_etc_n.png"
//                bgImagePress: imgFolderSettings + "btn_auth_etc_p.png"
//                bgImageFocus: imgFolderSettings + "btn_auth_etc_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_etc_fp.png"
                KeyNavigation.left: idPinBtnDelAll
                KeyNavigation.right: idPinBtn0
                KeyNavigation.up: idPinBtn7
                KeyNavigation.down: idPinBtnDelAll

                firstText: "Delete All"
                //firstText: stringInfo.strSettingsBtBtnClearAll
                firstTextColor: colorInfo.brightGrey
                firstTextSize: 36
                firstTextStyle: "HDR"
                firstTextWidth:170
                firstTextX: 12
                firstTextY: 25//40 //modified for ITS 234815 Delete All center Align Issue
                firstTextAlies: "Center"

                onClickOrKeySelected: {
                    idPinBtnDelAll.forceActiveFocus()
                    setClearAll()
                }
                onWheelLeftKeyPressed: idPinBtn9.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtn0.forceActiveFocus()
            } // End PINKeyPadButton1
            //--------------------- Nember 0 ##
            MComp.MButtonTouch {
                id: idPinBtn0
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_num_fp.png"
                fgImage: imgFolderBt_phone + "dial_num_0_n.png"

                fgImageX: keypadImgX; fgImageY: keypadImgY
                fgImageWidth: 51
                fgImageHeight: 53
                KeyNavigation.left: idPinBtnDelAll
                KeyNavigation.right: idPinBtnDel
                KeyNavigation.up: idPinBtn8
                KeyNavigation.down: idPinBtn0
                onClickOrKeySelected: {
                    idPinBtn0.forceActiveFocus()
                    setNumber(numCount, 0)
                }
                onWheelLeftKeyPressed: idPinBtnDelAll.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtnDel.forceActiveFocus()
            } // End PINKeyPadButton
            //--------------------- Delete code ##
            MComp.MButtonTouch {
                id: idPinBtnDel
                width:keypadWidth; height:keypadHeight
                bgImage: imgFolderSettings  + "btn_auth_num_n.png"
                bgImagePress: imgFolderSettings + "btn_auth_num_p.png"
                bgImageFocus: imgFolderSettings + "btn_auth_num_f.png"
//                bgImage: imgFolderSettings  + "btn_auth_etc_n.png"
//                bgImagePress: imgFolderSettings + "btn_auth_etc_p.png"
//                bgImageFocus: imgFolderSettings + "btn_auth_etc_f.png"
                bgImageFocusPress: imgFolderSettings + "btn_auth_etc_fp.png"
                fgImage: imgFolderBt_phone + "ico_dial_del.png"
                fgImageX: 41; fgImageY: 13
                fgImageWidth: 103
                fgImageHeight: 55
                KeyNavigation.left: idPinBtn0
                KeyNavigation.right: idPinBtnDel
                KeyNavigation.up: idPinBtn9
                KeyNavigation.down: idPinBtnDel
                onClickOrKeySelected: {
                    idPinBtnDel.forceActiveFocus()
                    if(numCount>0){
                        setDeletedCode()
                    }
                }
                onWheelLeftKeyPressed: idPinBtn0.forceActiveFocus()
                onWheelRightKeyPressed: idPinBtn1.forceActiveFocus()
                onPressAndHold: {setClearAll()}
            } // End MComp.PINKeyPadButton
        } // End Row
    } // End Column
    onBackKeyPressed: {
        if(isMapCareMain)
        {
            if(isMapCareEx)
            {
                idPinBtn1.forceActiveFocus()
                mainViewState = "MapCareMainEx" //added for BGFG structure
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
            else
            {
                idPinBtn1.forceActiveFocus()
                mainViewState = "MapCareMain" //added for BGFG structure
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }

        }
        else
        {
            idPinBtn1.forceActiveFocus()
            mainViewState="Main"
            setMainAppScreen("", true)
        }
    }
    MComp.MDimPopup {
        id:dimWrongMSG
        //lineCount:1
        loadingFlag:false
        firstText: "Please enter a correct password"
        popupName: "DimWrongMSG"
        visible: popupState==popupName
        focus: popupState==popupName
        onPopupClicked: {
            popupState=""
            setClearAll()
            //setDeletedCode()
            //idPinBtn1.forceActiveFocus()
        }
        onVisibleChanged: {
            if(dimChangeFail.visible){popupOffTimer.start();console.log("Timer Start : dimChangeFail")}
        }
    }
    Timer {
        id: popupOffTimer
        interval: 2000
        repeat: false
        running: false
        onTriggered: {
            console.log("Timer End~~")
            popupState=""
            //dimWrongMSG.visible = false
            popupOffTimer.stop()
        }
    } // End Timer
}  // End MComponent


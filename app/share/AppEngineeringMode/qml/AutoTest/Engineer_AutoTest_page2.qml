import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
MComp.MComponent{
    id:idAutoTestPage2
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    //clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral

    property int keyboardState: UIListener.GetKeyboardState();


    Component.onCompleted:{

        if(keyboardState > 0){
            idKeyboardEnDisState.text = "ENABLE"
        }
        else{
            idKeyboardEnDisState.text = "DISABLE"
        }
        idKeyboardEnableButton.focus = true;
        idKeyboardEnableButton.forceActiveFocus()

        UIListener.autoTest_athenaSendObject();
    }

    onBackKeyPressed: {
        console.log("Enter AutoTest Page2 Back Key or Click==============")
        mainBg.visible = false
        setMainAppScreen("", true)
         mainViewState="Main"
        if(flagState == 0){
            console.log("Enter Simple Main Software :::")
            //idMainView.visible = true
            idMainView.forceActiveFocus()

        }
        else if(flagState == 9){
              console.log("Enter Full Main Software :::")

              //idFullMainView.visible = true
              idFullMainView.forceActiveFocus()
        }
        mainBg.visible = true
    }

    MComp.MBand{
        id:autoTestPage2Band
        titleText: qsTr("Engineering Mode > ETC ")

        KeyNavigation.down:idKeyboardEnableButton
        onWheelLeftKeyPressed:{
            if(autoTestPage2Band.backKeyButton.focus == true)
                autoTestPage2Band.bandSubButton.forceActiveFocus()
            else
                autoTestPage2Band.backKeyButton.forceActiveFocus()
        }
        onWheelRightKeyPressed: {
            if(autoTestPage2Band.backKeyButton.focus == true)
                autoTestPage2Band.bandSubButton.forceActiveFocus()
            else
                autoTestPage2Band.backKeyButton.forceActiveFocus()
        }

        onBackKeyClicked: {
            mainBg.visible = false
            setMainAppScreen("", true)
            mainViewState="Main"
            if(flagState == 0){
                console.log("Enter Simple Main Software :::")
               // idMainView.visible = true
                idMainView.forceActiveFocus()

            }
            else if(flagState == 9){
                  console.log("Enter Full Main Software :::")
                 // idFullMainView.visible = true
                  idFullMainView.forceActiveFocus()
            }
            mainBg.visible = true
        }
        subBtnFlag: true
        subKeyText: "Page1"
        onSubKeyClicked:
        {
            setMainAppScreen("AutoTest", true)
            mainViewState = "AutoTest"
        }

        //logSaveBtnFlag: true

        //logSaveKeyText: "Page 1"
        //onLogSaveKeyClicked: {
        //    setMainAppScreen("AutoTest", true)
        //    mainViewState = "AutoTest"
        //}

    }



   Rectangle{
       id:idBorderKeyboardEnDis
       x:10 ; y:80
       width:360
       height: 160
       color:colorInfo.transparent
       border.color : colorInfo.buttonGrey
       border.width : 4
        Text {
            id: idKeyboardEnDisTxt
            text: "Keyboard Enable/Disable :"
            //x: 38; y: 120;
            x:20; y:20 ;
            font.pixelSize: 20; color: "#ffffff"
        }
        Text {
            id: idKeyboardEnDisState
            text: ""
            //x: 310; y: 120;
            x:270; y: 20
            font.pixelSize: 20; color: colorInfo.dimmedGrey
        }
        MComp.MButtonTouch {
            id : idKeyboardEnableButton
            //x: 38; y: 180
            x:20; y: 60
            width:140; height:80
            focus: true
            firstText: "ENABLE"
            firstTextX: 30
            firstTextY: 30
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                autoTestPage2Band.backKeyButton.forceActiveFocus()
                autoTestPage2Band
            }

            onWheelLeftKeyPressed: idUsbEyePatternButton.forceActiveFocus()

            onWheelRightKeyPressed: idKeyboardDisableButton.forceActiveFocus()

            onClickOrKeySelected: {
                idKeyboardEnableButton.forceActiveFocus()
                UIListener.keyboardEnDisable(true);
                idKeyboardEnDisState.text = "ENABLE"
            }
        }

        MComp.MButtonTouch {
            id:idKeyboardDisableButton
            //x: 190; y: 180
            x:180 ; y: 60
            width:140; height:80
            firstText: "DISABLE"
            firstTextX: 25
            firstTextY: 30
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""

            KeyNavigation.up:{
                autoTestPage2Band.backKeyButton.forceActiveFocus()
                autoTestPage2Band
            }

            onWheelLeftKeyPressed: idKeyboardEnableButton.forceActiveFocus()
            onWheelRightKeyPressed: idRandomKeyTestButton.forceActiveFocus()

            onClickOrKeySelected: {
                idKeyboardDisableButton.forceActiveFocus()
                UIListener.keyboardEnDisable(false);
                idKeyboardEnDisState.text = "DISABLE"
            }
        }

   }

   Rectangle{
       id:idUsbEyePattern
       x:10 ; y:250
       width:180
       height: 160
       color:colorInfo.transparent
       border.color : colorInfo.buttonGrey
       border.width : 4
        Text {
            id: idUsbEyePatternTxt
            text: "USB Eye Pattern"
            x:20; y:20 ;
            font.pixelSize: 20; color: "#ffffff"
        }

        MComp.MButtonTouch {
            id : idUsbEyePatternButton

            x:20; y: 60
            width:140; height:80
            focus: true
            firstText: "ENABLE"
            firstTextX: 30
            firstTextY: 30
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                autoTestPage2Band.backKeyButton.forceActiveFocus()
                autoTestPage2Band
            }

            onWheelLeftKeyPressed: idTouchTestButton.forceActiveFocus()
            onWheelRightKeyPressed: idKeyboardEnableButton.forceActiveFocus()

            onClickOrKeySelected: {
                idUsbEyePatternButton.forceActiveFocus()
                IPInfo.setUsbEyePattern();

            }
        }

   }

   Rectangle{
       id:idBorderRandomKeyTest
       x:380 ; y:80
       width:330
       height: 100
       color:colorInfo.transparent
       border.color : colorInfo.buttonGrey
       border.width : 4
        Text {
            id: idRandomKeyTestTxt
            text: "Random Key Test"
            //x: 38; y: 120;
            x: 20 ; y: 30;
            font.pixelSize: 19; color: "#ffffff"
        }
        MComp.MButtonTouch {
            id : idRandomKeyTestButton
            //x: 38; y: 180
            x: 180; y:10
            width:140; height:80
            focus: true
            firstText: "Enter"
            firstTextX: 35
            firstTextY: 30
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                autoTestPage2Band.backKeyButton.forceActiveFocus()
                autoTestPage2Band
            }

            onWheelLeftKeyPressed: idKeyboardDisableButton.forceActiveFocus()

            onWheelRightKeyPressed: idTouchTestButton.forceActiveFocus()

            onClickOrKeySelected: {
                idRandomKeyTestButton.forceActiveFocus()
                setMainAppScreen("RandomKeyTest", true)
                mainViewState = "RandomKeyTest"
            }
        }
   }
   Rectangle{
       id:idBorderTouchTest
       x:720 ; y:80
       width:330
       height: 100
       color:colorInfo.transparent
       border.color : colorInfo.buttonGrey
       border.width : 4
        Text {
            id: idTouchTestTxt
            text: "Touch Test"
            x: 20 ; y: 30;
            font.pixelSize: 20; color: "#ffffff"
        }
        MComp.MButtonTouch {
            id : idTouchTestButton
            x: 180; y:10
            width:140; height:80
            focus: true
            firstText: "Enter"
            firstTextX: 35
            firstTextY: 30
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                autoTestPage2Band.backKeyButton.forceActiveFocus()
                autoTestPage2Band
            }

            onWheelLeftKeyPressed: idRandomKeyTestButton.forceActiveFocus()
            onWheelRightKeyPressed: idUsbEyePatternButton.forceActiveFocus()

            onClickOrKeySelected: {
              idTouchTestButton.forceActiveFocus()
              mainBg.visible = false
              stateStatusBar.visible =false
              setMainAppScreen("TouchTest", true)
              mainViewState = "TouchTest"
              mainBg.visible = true
              touchTestBg.visible = true
            }
        }
   }

        Connections{
            target:UIListener

        onShowMainGUI:{
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                //added for BGFG structure
            }
            else
            {
                console.log("Enter Software Main Back Key or Click==============")
                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){
                    console.log("Enter Simple Main Software :::")
                  //  idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main Software :::")
                      //idFullMainView.visible = true
                      idFullMainView.forceActiveFocus()
                }
            }


        }
    }
}

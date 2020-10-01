import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import com.engineer.data 1.0

MComp.MComponent{
    id:idTouchTstMain
    x:0; y:-93; z:2
    width: systemInfo.lcdWidth; height: 720/*systemInfo.lcdHeight*/
    clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral

    property alias touchTimer : idEngTouchTestTimer
    property bool touchTestResult: false;
    property alias touchTestBg: bgImgTouchMain
    property bool isTouchTestBg : true

     property bool stateTouch1: false
     property bool stateTouch2: false
     property bool stateTouch3: false
     property bool stateTouch4: false
     property bool stateTouch5: false
     property bool stateTouch6: false
     property bool stateTouch7: false
     property bool stateTouch8: false
     property bool stateTouch9: false
     property bool stateTouch10: false
     property bool stateTouch11: false
     property bool stateTouch12: false
     property bool stateTouch13: false
     property bool stateTouch14: false
     property bool stateTouch15: false
     property bool stateTouch16: false
     property bool stateTouch17: false
     property bool stateTouch18: false
     property bool stateTouch19: false
     property bool stateTouch20: false

    property int touchCount : 0

    function resetTouchTest()
    {
         stateTouch1=false
         stateTouch2=false
         stateTouch3=false
         stateTouch4=false
         stateTouch5=false
         stateTouch6=false
         stateTouch7=false
         stateTouch8=false
         stateTouch9=false
         stateTouch10=false
         stateTouch11=false
         stateTouch12=false
         stateTouch13=false
         stateTouch14=false
         stateTouch15=false
         stateTouch16=false
         stateTouch17=false
         stateTouch18=false
         stateTouch19=false
         stateTouch20=false

        touchCount = 0
        touchTestResult = false

         idTouchButton1.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton2.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton3.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton4.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton5.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton6.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton7.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton8.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton9.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton10.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton11.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton12.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton13.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton14.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton15.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton16.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton17.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton18.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton19.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
         idTouchButton20.bgImage = imgFolderModeArea + "btn_title_sub_n.png"

        idTouchButton1.firstTextColor = colorInfo.brightGrey
        idTouchButton2.firstTextColor = colorInfo.brightGrey
        idTouchButton3.firstTextColor = colorInfo.brightGrey
        idTouchButton4.firstTextColor = colorInfo.brightGrey
        idTouchButton5.firstTextColor = colorInfo.brightGrey
        idTouchButton6.firstTextColor = colorInfo.brightGrey
        idTouchButton7.firstTextColor = colorInfo.brightGrey
        idTouchButton8.firstTextColor = colorInfo.brightGrey
        idTouchButton9.firstTextColor = colorInfo.brightGrey
        idTouchButton10.firstTextColor = colorInfo.brightGrey
        idTouchButton11.firstTextColor = colorInfo.brightGrey
        idTouchButton12.firstTextColor = colorInfo.brightGrey
        idTouchButton13.firstTextColor = colorInfo.brightGrey
        idTouchButton14.firstTextColor = colorInfo.brightGrey
        idTouchButton15.firstTextColor = colorInfo.brightGrey
        idTouchButton16.firstTextColor = colorInfo.brightGrey
        idTouchButton17.firstTextColor = colorInfo.brightGrey
        idTouchButton18.firstTextColor = colorInfo.brightGrey
        idTouchButton19.firstTextColor = colorInfo.brightGrey
        idTouchButton20.firstTextColor = colorInfo.brightGrey
        SystemInfo.ResetTouch()
    }

    MComp.MMsgPopup{
        id:idENGTouchTestFinPopUp
        y:0; z:100
        visible: false
        onVisibleChanged: { if(visible)idENGTouchTestFinPopUp.focus = true;}
        popupName: "Touch Test : OK"
        msgModel: ListModel{
            ListElement{ msgName:"Touch Test : OK"; }
        }
        btnModel: ListModel{
            ListElement {   btnName: "OK";  }
            //ListElement {   btnName:    "CANCEL";   }
        }
        onBtn0Click: {
            bgImgTouchMain.visible = false
            mainBg.visible = false
            resetTouchTest()
            stateStatusBar.visible = true;
            console.log("Enter Random Key Test Main :: Back Key or Click==============")
            setMainAppScreen("AutoTestPage2", true)
            mainViewState = "AutoTestPage2"
            idENGTouchTestFinPopUp.visible =false
            mainBg.visible = true
        }

    }

    MComp.MMsgPopup{
        id:idENGTouchTestFailPopUp
        y:0; z:100
        visible: false
        onVisibleChanged: { if(visible)idENGTouchTestFailPopUp.focus = true}
        popupName: "Touch Test : Fail"

        msgModel: ListModel{
            id:idTouchTestFailModel
            ListElement{ msgName:"Touch Test : Fail"; }
        }
        btnModel: ListModel{
            ListElement {   btnName: "OK";  }

        }
        onBtn0Click: {
            bgImgTouchMain.visible = false
            mainBg.visible = false
            resetTouchTest()
            stateStatusBar.visible = true;
            console.log("Enter Random Key Test Main :: Back Key or Click==============")
            setMainAppScreen("AutoTestPage2", true)
            mainViewState = "AutoTestPage2"
            idENGTouchTestFailPopUp.visible =false
            mainBg.visible = true
        }

    }
    Timer{
        id:idEngTouchTestTimer
        interval: 20000
        repeat:false
        onTriggered:
        {
            touchTestResult = SystemInfo.CheckTouchButton()
            if(touchTestResult){
                console.debug("[QML]idEngTouchTestTimer Triggered : OK PopUp")
                idENGTouchTestFinPopUp.visible = true
            }
            else{
                console.debug("[QML]idEngTouchTestTimer Triggered : Fail PopUp")
                idENGTouchTestFailPopUp.visible = true
            }
        }
    }



    //**************************************** Background
    Image{
        id:bgImgTouchMain
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight+93
        source: imgFolderGeneral + "bg_type_b.png"
    }


    Component.onCompleted:{
        stateStatusBar.visible = false;

        UIListener.autoTest_athenaSendObject();
        //idEngTouchTestTimer.start();
    }
    onVisibleChanged: {
        if(!visible){
            idEngTouchTestTimer.stop();
        }
    }

    onBackKeyPressed: {
        bgImgTouchMain.visible = false
        mainBg.visible = false
        stateStatusBar.visible = true;
        console.log("Enter Random Key Test Main :: Back Key or Click==============")
        setMainAppScreen("AutoTestPage2", true)
        mainViewState = "AutoTestPage2"
        idAutoTestPage2Main.focus = true
        idAutoTestPage2Main.forceActiveFocus()
        mainBg.visible = true
    }


    //first Line
    MComp.MButtonTouch {
        id : idTouchButton1
        x:0; y: 0
        width:256; height:180
        //focus: true
        firstText: "Touch1"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch1 == false){
              if(touchCount == 0)
                idEngTouchTestTimer.restart()

                firstTextColor = "red"
                SystemInfo.SetTouchButton(0)
                idTouchButton1.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
                  stateTouch1  = true
                  touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }
    MComp.MButtonTouch {
        id : idTouchButton2
        x:256; y: 0
        width:256; height:180
        //focus: true
        firstText: "Touch2"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch2 == false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(1)
            idTouchButton2.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch2  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }

    MComp.MButtonTouch {
        id : idTouchButton3
        x:256 +256; y: 0
        width:256; height:180
        //focus: true
        firstText: "Touch3"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch3 == false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(2)
            idTouchButton3.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch3  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }

    MComp.MButtonTouch {
        id : idTouchButton4
        x:256 +256 +256; y: 0
        width:256; height:180
        //focus: true
        firstText: "Touch4"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch4 == false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(3)
            idTouchButton4.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch4  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }
    MComp.MButtonTouch {
        id : idTouchButton5
        x:256 + 256 + 256 +256; y: 0
        width:256; height:180
        //focus: true
        firstText: "Touch5"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch5 ==false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(4)
            idTouchButton5.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch5 = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }



    //second Line
    MComp.MButtonTouch {
        id : idTouchButton6
        x:0; y: 180
        width:256; height:180
        //focus: true
        firstText: "Touch6"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch6 ==false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(5)
            idTouchButton6.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch6 = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }
    MComp.MButtonTouch {
        id : idTouchButton7
        x:256; y: 180
        width:256; height:180
        //focus: true
        firstText: "Touch7"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch7 ==false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(6)
            idTouchButton7.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch7  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }

    MComp.MButtonTouch {
        id : idTouchButton8
        x:256 +256; y: 180
        width:256; height:180
        //focus: true
        firstText: "Touch8"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch8 ==false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(7)
            idTouchButton8.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch8  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }

    MComp.MButtonTouch {
        id : idTouchButton9
        x:256 +256 +256; y: 180
        width:256; height:180
        //focus: true
        firstText: "Touch9"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch9 ==false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(8)
            idTouchButton9.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch9  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }
    MComp.MButtonTouch {
        id : idTouchButton10
        x:256 + 256 + 256 +256; y: 180
        width:256; height:180
        //focus: true
        firstText: "Touch10"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch10 ==false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(9)
            idTouchButton10.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch10  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }

    //third Line
    MComp.MButtonTouch {
        id : idTouchButton11
        x:0; y: 180 +180
        width:256; height:180
        //focus: true
        firstText: "Touch11"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch11 == false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(10)
            idTouchButton11.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch11  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }
    MComp.MButtonTouch {
        id : idTouchButton12
        x:256; y: 180 + 180;
        width:256; height:180
        //focus: true
        firstText: "Touch12"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch12 ==false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(11)
            idTouchButton12.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch12  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }

    MComp.MButtonTouch {
        id : idTouchButton13
        x:256 +256; y: 180 + 180
        width:256; height:180
        //focus: true
        firstText: "Touch13"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch13 == false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
           SystemInfo.SetTouchButton(12)
            idTouchButton13.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch13  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }

    MComp.MButtonTouch {
        id : idTouchButton14
        x:256 +256 +256; y: 180+180;
        width:256; height:180
        //focus: true
        firstText: "Touch14"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch14 ==false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(13)
            idTouchButton14.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch14  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }
    MComp.MButtonTouch {
        id : idTouchButton15
        x:256 + 256 + 256 +256; y: 180+180
        width:256; height:180
        //focus: true
        firstText: "Touch15"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch15 == false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(14)
            idTouchButton15.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch15  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }


    //forth Line
    MComp.MButtonTouch {
        id : idTouchButton16
        x:0; y: 180 +180 +180
        width:256; height:180
        //focus: true
        firstText: "Touch16"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch16 == false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(15)
            idTouchButton16.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch16  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }
    MComp.MButtonTouch {
        id : idTouchButton17
        x:256; y: 180 + 180 +180;
        width:256; height:180
        //focus: true
        firstText: "Touch17"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch17 ==false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(16)
            idTouchButton17.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch17  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }

    MComp.MButtonTouch {
        id : idTouchButton18
        x:256 +256; y: 180 + 180 +180
        width:256; height:180
        //focus: true
        firstText: "Touch18"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch18 == false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(17)
            idTouchButton18.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch18  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }

    MComp.MButtonTouch {
        id : idTouchButton19
        x:256 +256 +256; y: 180+180 +180;
        width:256; height:180
        //focus: true
        firstText: "Touch19"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch19 == false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(18)
            idTouchButton19.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch19  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }
    MComp.MButtonTouch {
        id : idTouchButton20
        x:256 + 256 + 256 +256; y: 180+180 +180
        width:256; height:180
        //focus: true
        firstText: "Touch20"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 256
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        //bgImageFocus: imgFolderNewGeneral+"btn_title_sub_n.png"
        fgImage: ""
        fgImageActive: ""


      onClickOrKeySelected: {
          if(stateTouch20 == false){
              if(touchCount == 0)
                  idEngTouchTestTimer.restart()
            firstTextColor = "red"
            SystemInfo.SetTouchButton(19)
            idTouchButton20.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
              stateTouch20  = true
              touchCount++;
              if(touchCount >=20){
                  touchTestResult = SystemInfo.CheckTouchButton()
                  if(touchTestResult)
                      idENGTouchTestFinPopUp.visible = true
                  else
                      idENGTouchTestFailPopUp.visible = true
              }
          }
        }
    }




}

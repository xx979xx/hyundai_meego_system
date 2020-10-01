import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
MComp.MComponent{
    id:idRandomKeyTstMain
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    //clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral

    property string imgFolderModeArea: imageInfo.imgFolderModeArea
    property bool stateFront: false;
    property bool stateSWRC: false;
    property bool stateCCP: false;
    property bool stateRRC: false;
    property bool stateTouch: false;
    //    property bool state05Sec: false;
    //    property bool state1Sec: false;
    //    property bool state3Sec: false;
    //    property bool state5Sec: false;



    Component.onCompleted:{

        UIListener.autoTest_athenaSendObject();
        idKeyTypeFront.focus = true
        idKeyTypeFront.forceActiveFocus()
    }

    onBackKeyPressed: {
        console.log("Enter Random Key Test Main :: Back Key or Click==============")
        setMainAppScreen("AutoTestPage2", true)
        mainViewState = "AutoTestPage2"
    }

    MComp.MBand{
        id: idRandomKeyTestBand
        titleText: qsTr("Engineering Mode > Random Key Test ")

       KeyNavigation.down: idKeyTypeFront
        onBackKeyClicked: {
        //mainViewState="Main"
        //setMainAppScreen("", true)

            setMainAppScreen("AutoTestPage2", true)
            mainViewState = "AutoTestPage2"
        }


    }
   Rectangle{
       id:idKeyTypeBorder
       x:190 ; y:180
       width:920
       height: 120
       color:colorInfo.transparent
       border.color : colorInfo.buttonGrey
       border.width : 4
        Text {
            id: idKeyTypeTxt
            text: "TYPE"
            x:20; y:20 ;
            font.pixelSize: 20; color: "#ffffff"
        }

        MComp.MButtonTouch {
            id : idKeyTypeFront
            x:170; y: 20
            width:140; height:80
            focus: true
            firstText: "FRONT"
            firstTextX: 30
            firstTextY: 40
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

             bgImage: imgFolderModeArea + "btn_title_sub_n.png"
             bgImagePress: imgFolderModeArea + "btn_title_sub_p.png"
            //bgImageFocusPress: imgFolderModeArea+"btn_title_sub_fp.png"
            bgImageFocus: imgFolderModeArea+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                idRandomKeyTestBand.backKeyButton.forceActiveFocus()
                idRandomKeyTestBand
            }
            onWheelLeftKeyPressed: idKeyTestStartButton.forceActiveFocus()
            onWheelRightKeyPressed: idKeyTypeSWRC.forceActiveFocus()

          onClickOrKeySelected: {
                  if(stateFront == false){
                        DiagnosticReq.keyOn(0);
                        stateFront = true;
                        idKeyTypeFront.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
                  }
                  else if(stateFront == true){
                      DiagnosticReq.keyOff(0);
                      stateFront = false;
                      idKeyTypeFront.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  }
            }
        }
        MComp.MButtonTouch {
            id : idKeyTypeSWRC
            x:320; y: 20
            width:140; height:80
            focus: true
            firstText: "SWRC"
            firstTextX: 30
            firstTextY: 40
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

             bgImage: imgFolderModeArea + "btn_title_sub_n.png"
             bgImagePress: imgFolderModeArea + "btn_title_sub_p.png"
            //bgImageFocusPress: imgFolderModeArea+"btn_title_sub_fp.png"
            bgImageFocus: imgFolderModeArea+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                idRandomKeyTestBand.backKeyButton.forceActiveFocus()
                idRandomKeyTestBand
            }
            onWheelLeftKeyPressed: idKeyTypeFront.forceActiveFocus();
            onWheelRightKeyPressed: idKeyTypeCCP.forceActiveFocus()

          onClickOrKeySelected: {
                  if(stateSWRC == false){
                        DiagnosticReq.keyOn(1);
                        stateSWRC = true;
                        idKeyTypeSWRC.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
                  }
                  else if(stateSWRC == true){
                      DiagnosticReq.keyOff(1);
                      stateSWRC = false;
                      idKeyTypeSWRC.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  }
            }
        }
        MComp.MButtonTouch {
            id : idKeyTypeCCP
            x:470; y: 20
            width:140; height:80
            focus: true
            firstText: "CCP"
            firstTextX: 30
            firstTextY: 40
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

             bgImage: imgFolderModeArea + "btn_title_sub_n.png"
             bgImagePress: imgFolderModeArea + "btn_title_sub_p.png"
            //bgImageFocusPress: imgFolderModeArea+"btn_title_sub_fp.png"
            bgImageFocus: imgFolderModeArea+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                idRandomKeyTestBand.backKeyButton.forceActiveFocus()
                idRandomKeyTestBand
            }
            onWheelLeftKeyPressed: idKeyTypeSWRC.forceActiveFocus()
            onWheelRightKeyPressed: idKeyTypeRRC.forceActiveFocus()

          onClickOrKeySelected: {
                  if(stateCCP == false){
                        DiagnosticReq.keyOn(2);
                        stateCCP = true;
                        idKeyTypeCCP.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
                  }
                  else if(stateCCP == true){
                      DiagnosticReq.keyOff(2);
                      stateCCP = false;
                      idKeyTypeCCP.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  }
            }
        }
        MComp.MButtonTouch {
            id : idKeyTypeRRC
            x:620; y: 20
            width:140; height:80
            focus: true
            firstText: "RRC"
            firstTextX: 30
            firstTextY: 40
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

             bgImage: imgFolderModeArea + "btn_title_sub_n.png"
             bgImagePress: imgFolderModeArea + "btn_title_sub_p.png"
            //bgImageFocusPress: imgFolderModeArea+"btn_title_sub_fp.png"
            bgImageFocus: imgFolderModeArea+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                idRandomKeyTestBand.backKeyButton.forceActiveFocus()
                idRandomKeyTestBand
            }
            onWheelLeftKeyPressed: idKeyTypeCCP.forceActiveFocus()
            onWheelRightKeyPressed: idKeyTypeTouch.forceActiveFocus()

          onClickOrKeySelected: {
                  if(stateRRC == false){
                        DiagnosticReq.keyOn(3);
                        stateRRC = true;
                        idKeyTypeRRC.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
                  }
                  else if(stateRRC == true){
                      DiagnosticReq.keyOff(3);
                      stateRRC = false;
                      idKeyTypeRRC.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  }
            }
        }
        MComp.MButtonTouch {
            id : idKeyTypeTouch
            x:770; y: 20
            width:140; height:80
            focus: true
            firstText: "TOUCH"
            firstTextX: 30
            firstTextY: 40
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

             bgImage: imgFolderModeArea + "btn_title_sub_n.png"
             bgImagePress: imgFolderModeArea + "btn_title_sub_p.png"
            //bgImageFocusPress: imgFolderModeArea+"btn_title_sub_fp.png"
            bgImageFocus: imgFolderModeArea+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                idRandomKeyTestBand.backKeyButton.forceActiveFocus()
                idRandomKeyTestBand
            }
            onWheelLeftKeyPressed: idKeyTypeRRC.forceActiveFocus()
            onWheelRightKeyPressed: idTime05sec.forceActiveFocus()

          onClickOrKeySelected: {
                  if(stateTouch == false){
                        DiagnosticReq.keyOn(4);
                        stateTouch = true;
                        idKeyTypeTouch.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
                  }
                  else if(stateTouch == true){
                      DiagnosticReq.keyOff(4);
                      stateTouch = false;
                      idKeyTypeTouch.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  }
            }
        }

   }
   Rectangle{
       id:idTimeBoader
       x:190 ; y:320
       width:780
       height: 120
       color:colorInfo.transparent
       border.color : colorInfo.buttonGrey
       border.width : 4
        Text {
            id: idRandomKeyTestTxt
            text: "TIME"
            x: 20 ; y: 20;
            font.pixelSize: 20; color: "#ffffff"
        }
        MComp.MButtonTouch {
            id : idTime05sec
            x:170; y: 20
            width:140; height:80
            focus: true
            firstText: "0.5Sec"
            firstTextX: 30
            firstTextY: 40
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

             bgImage: imgFolderModeArea + "btn_title_sub_n.png"
             bgImagePress: imgFolderModeArea + "btn_title_sub_p.png"
            //bgImageFocusPress: imgFolderModeArea+"btn_title_sub_fp.png"
            bgImageFocus: imgFolderModeArea+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                idRandomKeyTestBand.backKeyButton.forceActiveFocus()
                idRandomKeyTestBand
            }
            onWheelLeftKeyPressed: idKeyTypeTouch.forceActiveFocus()
            onWheelRightKeyPressed: idTime1Sec.forceActiveFocus()

          onClickOrKeySelected: {
                DiagnosticReq.timeSetting(0x00);
                idTime05sec.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
                idTime1Sec.bgImage =  imgFolderModeArea + "btn_title_sub_n.png"
                idTime3Sec.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                idTime5Sec.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
            }
        }
        MComp.MButtonTouch {
            id : idTime1Sec
            x:320; y: 20
            width:140; height:80
            focus: true
            firstText: "1Sec"
            firstTextX: 30
            firstTextY: 40
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

             bgImage: imgFolderModeArea + "btn_title_sub_n.png"
             bgImagePress: imgFolderModeArea + "btn_title_sub_p.png"
            //bgImageFocusPress: imgFolderModeArea+"btn_title_sub_fp.png"
            bgImageFocus: imgFolderModeArea+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                idRandomKeyTestBand.backKeyButton.forceActiveFocus()
                idRandomKeyTestBand
            }
            onWheelLeftKeyPressed: idTime05Sec.forceActiveFocus()
            onWheelRightKeyPressed: idTime3Sec.forceActiveFocus()

          onClickOrKeySelected: {
                DiagnosticReq.timeSetting(0x01);
                  idTime05sec.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  idTime1Sec.bgImage =  imgFolderModeArea + "btn_title_sub_p.png"
                  idTime3Sec.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  idTime5Sec.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
            }
        }
        MComp.MButtonTouch {
            id : idTime3Sec
            x:470; y: 20
            width:140; height:80
            focus: true
            firstText: "3Sec"
            firstTextX: 30
            firstTextY: 40
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

             bgImage: imgFolderModeArea + "btn_title_sub_n.png"
             bgImagePress: imgFolderModeArea + "btn_title_sub_p.png"
            //bgImageFocusPress: imgFolderModeArea+"btn_title_sub_fp.png"
            bgImageFocus: imgFolderModeArea+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                idRandomKeyTestBand.backKeyButton.forceActiveFocus()
                idRandomKeyTestBand
            }
            onWheelLeftKeyPressed: idTime1Sec.forceActiveFocus()
            onWheelRightKeyPressed: idTime5Sec.forceActiveFocus()

          onClickOrKeySelected: {
                DiagnosticReq.timeSetting(0x02);
                  idTime05sec.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  idTime1Sec.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  idTime3Sec.bgImage =  imgFolderModeArea + "btn_title_sub_p.png"
                  idTime5Sec.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
            }
        }
        MComp.MButtonTouch {
            id : idTime5Sec
            x:620; y: 20
            width:140; height:80
            focus: true
            firstText: "5Sec"
            firstTextX: 30
            firstTextY: 40
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

             bgImage: imgFolderModeArea + "btn_title_sub_n.png"
             bgImagePress: imgFolderModeArea + "btn_title_sub_p.png"
            //bgImageFocusPress: imgFolderModeArea+"btn_title_sub_fp.png"
            bgImageFocus: imgFolderModeArea+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                idRandomKeyTestBand.backKeyButton.forceActiveFocus()
                idRandomKeyTestBand
            }
            onWheelLeftKeyPressed: idTime3Sec.forceActiveFocus()
            onWheelRightKeyPressed: idKeyTestStartButton.forceActiveFocus()

          onClickOrKeySelected: {
                    DiagnosticReq.timeSetting(0x03);
                  idTime05sec.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  idTime1Sec.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  idTime3Sec.bgImage = imgFolderModeArea + "btn_title_sub_n.png"
                  idTime5Sec.bgImage = imgFolderModeArea + "btn_title_sub_p.png"
            }
        }

   }

   MComp.MButtonTouch {
       id : idKeyTestStartButton
       x:990; y: 320
       width:200; height:120
       focus: true
       firstText: "Start"
       firstTextX: 50
       firstTextY: 60
       firstTextWidth: 200
       firstTextColor: colorInfo.brightGrey
       firstTextSelectedColor: colorInfo.brightGrey
       firstTextSize: 30
       firstTextStyle: "HDB"

        bgImage: imgFolderModeArea + "btn_title_sub_n.png"
        bgImagePress: imgFolderModeArea + "btn_title_sub_p.png"
       //bgImageFocusPress: imgFolderModeArea+"btn_title_sub_fp.png"
       bgImageFocus: imgFolderModeArea+"btn_title_sub_f.png"
       fgImage: ""
       fgImageActive: ""
       KeyNavigation.up:{
           idRandomKeyTestBand.backKeyButton.forceActiveFocus()
           idRandomKeyTestBand
       }
       onWheelLeftKeyPressed: idTime5Sec.forceActiveFocus()
       onWheelRightKeyPressed: idKeyTypeFront.forceActiveFocus()

     onClickOrKeySelected: {
           DiagnosticReq.startKeyRandomTest();

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

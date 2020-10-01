import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idDTCLoaderMain
    x:0
    y:0
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea

    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
    }


    //    Engineer_DeleteDTC_PopUp
    //     {
    //         id:idENGDeletePopUp
    //         y:83; z:100
    ////         parent : content
    //         onVisibleChanged: { if(visible) idENGDeletePopUp.focus =true;}
    //     }

    //    function setMainAppScreen(screenName, save){
    //        MOp.setMainScreen(screenName,save);
    //    }

    //    function    setDTCMenuScreen(index,save){
    //        MOp.setDTCMenuMain(index,save);
    //    }

    //    function setRightMenuScreen(index, save){
    //        MOp.setDiagnosisRightMain(index, save)
    //    }

    // property string system: SystemInfo.GetSoftWareVersion();
    Text{
        width: 500
        height: 60
        x:0
        y:0
        text: isMapCareMain ? "Request All Service Code" : "Request All DTCS"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }


   MComp.MButtonTouch{
       id:idActiveDTCFirstButton
       x:0
       y:60
       width:/*150*/120
       height:80
       focus: true
       firstText: isMapCareMain ? "Enter" :  "All"
       firstTextX: isMapCareMain ? 20 : 40
       firstTextY: 30/*40*/
       firstTextWidth: /*150*/120
       firstTextColor: colorInfo.brightGrey
       firstTextSelectedColor: colorInfo.brightGrey
       firstTextSize: 25
       firstTextStyle: "HDB"

       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
       fgImage: ""
       fgImageActive: ""
       onWheelLeftKeyPressed: idDeleteDTCFirstButton.forceActiveFocus()
       onWheelRightKeyPressed: idAllDTCFirstButton.forceActiveFocus()
       KeyNavigation.up:{
           backFocus.forceActiveFocus()
           diagnosisBand
       }

       //KeyNavigation.right:idActiveDTCSecondButton
       //KeyNavigation.down:idAllDTCFirstButton


       onClickOrKeySelected: {
           //DiagnosticReq.ReadActiveDTC(0);
           //mainViewState = "DTCList"
            //setMainAppScreen("DTCList", true)
           idActiveDTCFirstButton.forceActiveFocus()
            UIListener.startDTCReq()
            DiagnosticReq.setDTCInitToMicom()//added for DTC ALL Init message To Micom
       }
   }
    //   MComp.MButtonTouch{
    //       id:idActiveDTCSecondButton
    //       x:/*160*/130
    //       y:60
    //       width:/*150*/120
    //       height:80

    //       firstText: "HU"
    //       firstTextX: /*60*/40
    //       firstTextY: 40
    //       firstTextWidth: /*150*/120
    //       firstTextColor: colorInfo.brightGrey
    //       firstTextSelectedColor: colorInfo.brightGrey
    //       firstTextSize: 25
    //       firstTextStyle: "HDB"

    //       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
    //       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
    //       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
    //       fgImage: ""
    //       fgImageActive: ""

    //       visible: isMapCareMain ? false : true

    //       onWheelLeftKeyPressed: idActiveDTCFirstButton.forceActiveFocus()
    //       onWheelRightKeyPressed: idActiveDTCThirdButton.forceActiveFocus()
    //       KeyNavigation.up:{
    //           backFocus.forceActiveFocus()
    //           diagnosisBand
    //       }
    //       KeyNavigation.left:idActiveDTCFirstButton
    //       KeyNavigation.right:idActiveDTCThirdButton
    //       KeyNavigation.down:idAllDTCSecondButton

    //       onClickOrKeySelected: {
    //           //DiagnosticReq.ReadActiveDTC(1);

    //           //mainViewState = "DTCList"
    //            //setMainAppScreen("DTCList", true)
    //            UIListener.startDTCReq()
    //            DiagnosticReq.setDTCInitToMicom()//added for DTC ALL Init message To Micom

    //       }
    //   }

    //   MComp.MButtonTouch{
    //       id:idActiveDTCThirdButton
    //       x:/*320*/260
    //       y:60
    //       width:/*150*/120
    //       height:80

    //       firstText: "iBox"
    //       firstTextX: /*60*/30
    //       firstTextY: 40
    //       firstTextWidth: /*150*/120
    //       firstTextColor: colorInfo.brightGrey
    //       firstTextSelectedColor: colorInfo.brightGrey
    //       firstTextSize: 25
    //       firstTextStyle: "HDB"

    //       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
    //       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
    //       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
    //       fgImage: ""
    //       fgImageActive: ""

    //       visible: isMapCareMain ? false : true
    //       onWheelLeftKeyPressed: idActiveDTCSecondButton.forceActiveFocus()
    //       onWheelRightKeyPressed: idActiveDTCforthButton.forceActiveFocus()
    //       KeyNavigation.up:{
    //           backFocus.forceActiveFocus()
    //           diagnosisBand
    //       }
    //       KeyNavigation.left:idActiveDTCSecondButton
    //       KeyNavigation.right:idActiveDTCforthButton
    //       KeyNavigation.down:idAllDTCThirdButton

    //       onClickOrKeySelected: {
    //           DiagnosticReq.ReadActiveDTC(2);

    //           mainViewState = "DTCList"
    //            setMainAppScreen("DTCList", true)

    //       }
    //   }
    //   MComp.MButtonTouch{
    //       id:idActiveDTCforthButton
    //       x:/*320*/390
    //       y:60
    //       width:/*150*/120
    //       height:80

    //       firstText: "AMP"
    //       firstTextX: /*60*/30
    //       firstTextY: 40
    //       firstTextWidth: /*150*/120
    //       firstTextColor: colorInfo.brightGrey
    //       firstTextSelectedColor: colorInfo.brightGrey
    //       firstTextSize: 25
    //       firstTextStyle: "HDB"

    //       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
    //       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
    //       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
    //       fgImage: ""
    //       fgImageActive: ""
    //       visible: isMapCareMain ? false : true

    //       onWheelLeftKeyPressed: idActiveDTCThirdButton.forceActiveFocus()
    //       onWheelRightKeyPressed: idAllDTCFirstButton.forceActiveFocus()
    //       KeyNavigation.up:{
    //           backFocus.forceActiveFocus()
    //           diagnosisBand
    //       }
    //       KeyNavigation.left:idActiveDTCThirdButton
    //       KeyNavigation.right:idActiveDTCFirstButton
    //       KeyNavigation.down:idAllDTCforthButton

    //       onClickOrKeySelected: {
    //           DiagnosticReq.ReadActiveDTC(3);

    //           mainViewState = "DTCList"
    //           setMainAppScreen("DTCList", true)

    //       }
    //   }

   Text{
       width: 500
       height: 60
       x:0
       y:140
       text: isMapCareMain ? "Read All Service Code" :  "Read All DTCS"
       font.pixelSize: 25
       color:colorInfo.brightGrey
       //horizontalAlignment: "AlignHCenter"
       verticalAlignment: "AlignVCenter"
   }

   MComp.MButtonTouch{
       id:idAllDTCFirstButton
       x:0
       y:200
       width:/*150*/120
       height:80

       firstText:isMapCareMain ? "Enter" :  "All"
       firstTextX: isMapCareMain ? 20 : 40
       firstTextY: 30/*40*/
       firstTextWidth: /*150*/120
       firstTextColor: colorInfo.brightGrey
       firstTextSelectedColor: colorInfo.brightGrey
       firstTextSize: 25
       firstTextStyle: "HDB"

       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
       fgImage: ""
       fgImageActive: ""
       onWheelLeftKeyPressed: idActiveDTCFirstButton.forceActiveFocus()
       onWheelRightKeyPressed: idDeleteDTCFirstButton.forceActiveFocus()
       KeyNavigation.up:{
           backFocus.forceActiveFocus()
           diagnosisBand
           //idActiveDTCFirstButton
       }
        //KeyNavigation.left:idDiagnosisLeftList
       //KeyNavigation.right:idAllDTCSecondButton
       //KeyNavigation.down:idDeleteDTCFirstButton

       onClickOrKeySelected: {
            idAllDTCFirstButton.forceActiveFocus()
            if(isMapCareMain)
            {
                DiagnosticReq.ReadAllDTC(0)

                mainViewState = "DTCList"
                setMapCareUIScreen("DTCList", true)
            }
            else
            {
                DiagnosticReq.ReadAllDTC(0)

                mainViewState = "DTCList"
                setMainAppScreen("DTCList", true)
            }

       }
   }

    //   MComp.MButtonTouch{
    //       id:idAllDTCSecondButton
    //       x:/*160*/130
    //       y:200
    //       width:/*150*/120
    //       height:80

    //       firstText: "HU"
    //       firstTextX: /*60*/40
    //       firstTextY: 40
    //       firstTextWidth: /*150*/120
    //       firstTextColor: colorInfo.brightGrey
    //       firstTextSelectedColor: colorInfo.brightGrey
    //       firstTextSize: 25
    //       firstTextStyle: "HDB"

    //       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
    //       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
    //       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
    //       fgImage: ""
    //       fgImageActive: ""

    //       visible: isMapCareMain ? false : true

    //       onWheelLeftKeyPressed: idAllDTCFirstButton.forceActiveFocus()
    //       onWheelRightKeyPressed: idAllDTCThirdButton.forceActiveFocus()
    //       KeyNavigation.up:{
    //            idActiveDTCSecondButton
    //       }
    //       KeyNavigation.left:idAllDTCFirstButton
    //       KeyNavigation.right:idAllDTCThirdButton
    //       KeyNavigation.down:idDeleteDTCSecondButton

    //       onClickOrKeySelected: {

    //           if(isMapCareMain)
    //           {
    //               DiagnosticReq.ReadAllDTC(1)

    //               mainViewState = "DTCList"
    //               setMapCareUIScreen("DTCList", true)
    //           }
    //           else
    //           {
    //               DiagnosticReq.ReadAllDTC(1)

    //               mainViewState = "DTCList"
    //               setMainAppScreen("DTCList", true)
    //           }

    //       }
    //   }

    //   MComp.MButtonTouch{
    //       id:idAllDTCThirdButton
    //       x:/*320*/260
    //       y:200
    //       width:/*150*/120
    //       height:80

    //       firstText: "iBox"
    //       firstTextX: /*60*/30
    //       firstTextY: 40
    //       firstTextWidth: /*150*/120
    //       firstTextColor: colorInfo.brightGrey
    //       firstTextSelectedColor: colorInfo.brightGrey
    //       firstTextSize: 25
    //       firstTextStyle: "HDB"

    //       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
    //       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
    //       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
    //       fgImage: ""
    //       fgImageActive: ""
    //       visible: isMapCareMain ? false : true

    //       onWheelLeftKeyPressed: idAllDTCSecondButton.forceActiveFocus()
    //       onWheelRightKeyPressed: idAllDTCforthButton.forceActiveFocus()
    //       KeyNavigation.up:{
    //            idActiveDTCThirdButton
    //       }
    //       KeyNavigation.left:idAllDTCSecondButton
    //       KeyNavigation.right:idAllDTCforthButton
    //       KeyNavigation.down:idDeleteDTCThirdButton

    //       onClickOrKeySelected: {
    //           if(isMapCareMain)
    //           {
    //               DiagnosticReq.ReadAllDTC(2)

    //               mainViewState = "DTCList"
    //               setMapCareUIScreen("DTCList", true)
    //           }
    //           else
    //           {
    //               DiagnosticReq.ReadAllDTC(2)

    //               mainViewState = "DTCList"
    //               setMainAppScreen("DTCList", true)
    //           }

    //       }
    //   }
    //   MComp.MButtonTouch{
    //       id:idAllDTCforthButton
    //       x:/*320*/390
    //       y:200
    //       width:/*150*/120
    //       height:80

    //       firstText: "AMP"
    //       firstTextX: /*60*/30
    //       firstTextY: 40
    //       firstTextWidth: /*150*/120
    //       firstTextColor: colorInfo.brightGrey
    //       firstTextSelectedColor: colorInfo.brightGrey
    //       firstTextSize: 25
    //       firstTextStyle: "HDB"

    //       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
    //       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
    //       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
    //       fgImage: ""
    //       fgImageActive: ""
    //       visible: isMapCareMain ? false : true

    //       onWheelLeftKeyPressed: idAllDTCThirdButton.forceActiveFocus()
    //       onWheelRightKeyPressed: idDeleteDTCFirstButton.forceActiveFocus()
    //       KeyNavigation.up:{
    //            idActiveDTCforthButton
    //       }
    //       KeyNavigation.left:idAllDTCThirdButton
    //       KeyNavigation.right:idAllDTCFirstButton
    //       KeyNavigation.down:idDeleteDTCforthButton

    //       onClickOrKeySelected: {
    //           if(isMapCareMain)
    //           {
    //               DiagnosticReq.ReadAllDTC(3)

    //               mainViewState = "DTCList"
    //               setMapCareUIScreen("DTCList", true)
    //           }
    //           else
    //           {
    //               DiagnosticReq.ReadAllDTC(3)

    //               mainViewState = "DTCList"
    //               setMainAppScreen("DTCList", true)
    //           }

    //       }
    //   }
   Text{
       width: 500
       height: 60
       x:0
       y:280
       text: isMapCareMain ? "Delete Service Code" : "Delete DTCS"
       font.pixelSize: 25
       color:colorInfo.brightGrey
       //horizontalAlignment: "AlignHCenter"
       verticalAlignment: "AlignVCenter"
   }

   MComp.MButtonTouch{
       id:idDeleteDTCFirstButton
       x:0
       y:340
       width:/*150*/120
       height:80

       firstText: isMapCareMain ? "Enter" : "All"
       firstTextX: isMapCareMain ? 20 : 40
       firstTextY: 30/*40*/
       firstTextWidth: /*150*/120
       firstTextColor: colorInfo.brightGrey
       firstTextSelectedColor: colorInfo.brightGrey
       firstTextSize: 25
       firstTextStyle: "HDB"

       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
       fgImage: ""
       fgImageActive: ""

       onWheelLeftKeyPressed: idAllDTCFirstButton.forceActiveFocus()
       onWheelRightKeyPressed: idActiveDTCFirstButton.forceActiveFocus()

       KeyNavigation.up:{
            //idAllDTCFirstButton
           backFocus.forceActiveFocus()
           diagnosisBand
       }
        //KeyNavigation.left:idDiagnosisLeftList
       //KeyNavigation.right:idDeleteDTCSecondButton
       //KeyNavigation.down:idActiveDTCFirstButton

       onClickOrKeySelected: {
           idDeleteDTCFirstButton.forceActiveFocus()
           DiagnosticReq.Delete_DTC(0)
           idENGDeletePopUp.visible = true
           idENGDeletePopUp.popupDeleting = true
           idENGDeletePopUp.focus = true
            //idENGDeletePopUp.givePopupFocus()
       }

   }

    //   MComp.MButtonTouch{
    //       id:idDeleteDTCSecondButton
    //       x:/*160*/130
    //       y:340
    //       width:/*150*/120
    //       height:80

    //       firstText: "HU"
    //       firstTextX: /*60*/40
    //       firstTextY: 40
    //       firstTextWidth: /*150*/120
    //       firstTextColor: colorInfo.brightGrey
    //       firstTextSelectedColor: colorInfo.brightGrey
    //       firstTextSize: 25
    //       firstTextStyle: "HDB"

    //       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
    //       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
    //       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
    //       fgImage: ""
    //       fgImageActive: ""

    //       visible: isMapCareMain ? false : true

    //       onWheelLeftKeyPressed: idDeleteDTCFirstButton.forceActiveFocus()
    //       onWheelRightKeyPressed: idDeleteDTCThirdButton.forceActiveFocus()

    //       KeyNavigation.up:{
    //            idAllDTCSecondButton
    //       }
    //       KeyNavigation.left:idDeleteDTCFirstButton
    //       KeyNavigation.right:idDeleteDTCThirdButton
    //       KeyNavigation.down:idActiveDTCSecondButton
    //       onClickOrKeySelected: {
    //           DiagnosticReq.Delete_DTC(1)
    //           idENGDeletePopUp.visible = true
    //           idENGDeletePopUp.popupDeleting = true
    //           idENGDeletePopUp.focus = true
    //            //idENGDeletePopUp.givePopupFocus()
    //       }
    //   }

    //   MComp.MButtonTouch{
    //       id:idDeleteDTCThirdButton
    //       x:/*320*/260
    //       y:340
    //       width:/*150*/120
    //       height:80

    //       firstText: "iBox"
    //       firstTextX: /*60*/30
    //       firstTextY: 40
    //       firstTextWidth: /*150*/120
    //       firstTextColor: colorInfo.brightGrey
    //       firstTextSelectedColor: colorInfo.brightGrey
    //       firstTextSize: 25
    //       firstTextStyle: "HDB"

    //       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
    //       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
    //       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
    //       fgImage: ""
    //       fgImageActive: ""

    //       visible: isMapCareMain ? false : true

    //       onWheelLeftKeyPressed: idDeleteDTCSecondButton.forceActiveFocus()
    //       onWheelRightKeyPressed: idDeleteDTCforthButton.forceActiveFocus()
    //       KeyNavigation.up:{
    //            idAllDTCThirdButton
    //       }
    //       KeyNavigation.left:idDeleteDTCSecondButton
    //       KeyNavigation.right:idDeleteDTCforthButton
    //       KeyNavigation.down:idActiveDTCThirdButton
    //       onClickOrKeySelected: {
    //           DiagnosticReq.Delete_DTC(2)
    //           idENGDeletePopUp.visible = true
    //           idENGDeletePopUp.popupDeleting = true
    //           idENGDeletePopUp.focus = true
    //            //idENGDeletePopUp.givePopupFocus()
    //       }

    //   }
    //   MComp.MButtonTouch{
    //       id:idDeleteDTCforthButton
    //       x:/*320*/390
    //       y:340
    //       width:/*150*/120
    //       height:80

    //       firstText: "AMP"
    //       firstTextX: /*60*/30
    //       firstTextY: 40
    //       firstTextWidth: /*150*/120
    //       firstTextColor: colorInfo.brightGrey
    //       firstTextSelectedColor: colorInfo.brightGrey
    //       firstTextSize: 25
    //       firstTextStyle: "HDB"

    //       bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
    //       bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
    //       bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
    //       fgImage: ""
    //       fgImageActive: ""

    //       visible: isMapCareMain ? false : true

    //       onWheelLeftKeyPressed: idDeleteDTCThirdButton.forceActiveFocus()
    //       onWheelRightKeyPressed: idActiveDTCFirstButton.forceActiveFocus()
    //       KeyNavigation.up:{
    //            idAllDTCforthButton
    //       }
    //       KeyNavigation.left:idDeleteDTCThirdButton
    //       KeyNavigation.right:idDeleteDTCFirstButton
    //       KeyNavigation.down:idActiveDTCforthButton
    //       onClickOrKeySelected: {
    //           DiagnosticReq.Delete_DTC(3)
    //           idENGDeletePopUp.visible = true
    //           idENGDeletePopUp.popupDeleting = true
    //           idENGDeletePopUp.focus = true
    //            //idENGDeletePopUp.givePopupFocus()
    //       }

    //   }



}


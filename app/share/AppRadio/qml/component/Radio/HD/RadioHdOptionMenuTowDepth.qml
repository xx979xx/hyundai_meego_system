import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MOptionMenu{
//    id: idRadioHdOptionMenuTwoDepth
//    focus: true
//    //****************************** # Item Model #
//    linkedModels:  idRadioHdOptionMenuTwoDepthModel
//    //linkedDelegate:  Component{RadioHdOptionMenuDelegate{id:idRadioOptionMenuTwoDepthDelegate}}
//    menuDepth : "TwoDepth"

//    //****************************** # Item Clicked #
//    onMenu0Click: {
//        console.log(">>>>>>>>>>>>>  Preset Scan")

//        idAppMain.gotoBackScreen();
//        idAppMain.gotoBackScreen();
//        QmlController.setsearchState(0x07);
//    }
//    onMenu1Click: {
//        console.log(">>>>>>>>>>>>>  Scan")
//        idAppMain.gotoBackScreen();
//        idAppMain.gotoBackScreen();
//        QmlController.setsearchState(0x06);
//    } // End Click

//    //****************************** # Menu Close when clicked I, L, Slash key && Left Key #
//    onClickMenuKey: {
//        if(idAppMain.state == "AppRadioHdOptionMenuTwo")
//             menuAnimation = false;
//    }
//    onLeftKeyPressed:{
//        if(idAppMain.state == "AppRadioHdOptionMenuTwo")
//            menuAnimation = false;
//    }
//    //****************************** # Back Key (Clicked Comma key) #
//    onBackKeyPressed:  menuAnimation = false;

//    //****************************** # Item Model #
//    ListModel { //# FM
//        id: idRadioHdOptionMenuTwoDepthModel
//        ListElement { name: "Preset Scan";opType: ""}
//        ListElement { name: "All Channel Scan";opType: ""}
//    }
//    //****************************** # TimeOut or Dim click #
//    onOptionMenuFinished:if(idAppMain.state == "AppRadioHdOptionMenuTwo") menuAnimation = false;

//    //****************************** # Translation #
//    function setModelString(){
//        idRadioHdOptionMenuTwoDepthModel.get(0).name = stringInfo.strHDMenuPresetScan
//        idRadioHdOptionMenuTwoDepthModel.get(1).name = stringInfo.strHDMenuScan
//    }
//    Component.onCompleted: {setModelString();menuLoad = true}
//    onVisibleChanged: { if(visible) idRadioHdOptionMenuTwoDepth.linkedCurrentIndex = 0;}
//    Connections{
//        target: UIListener
//        onRetranslateUi: {
//            setModelString()
//        }
//    }
} // End MOptionMenu

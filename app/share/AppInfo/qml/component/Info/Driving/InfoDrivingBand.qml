import QtQuick 1.0

import "../../QML/DH" as MComp

MComp.MBand{
    id: idInfoDrivingBand
    x: 0; y: 0
    focus : false

    tabBtnFlag: false
    subBtnFlag: false
    titleText: stringInfo.strAutoCareDrivingMode

    onBackKeyClicked: {
        console.log(" # [InfoDrivingBand] Back")
        gotoBackScreen()
    }
} // End MBand


//import "../../Info" as MInfo

//MInfo.InfoTypeABand{
//    id: idInfoDrivingBand
//    x: 0; y:0
//    focus : true

//    titleText: stringInfo.strAutoCareDrivingMode

////    onBackKeyClicked: {
////        console.log(" # [InfoDrivingBand] Back")
////        gotoBackScreen()
////    }
//} // End InfoTypeABand

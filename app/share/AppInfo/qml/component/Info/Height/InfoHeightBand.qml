import QtQuick 1.0

import "../../QML/DH" as MComp

MComp.MBand{
    id: idInfoHeightBand
    x: 0; y: 0
    focus : false

    tabBtnFlag: false
    subBtnFlag: false
    titleText: stringInfo.strAutoCareHeightInfo

    onBackKeyClicked: {
        console.log(" # [InfoHeightBand] Back")
        gotoBackScreen()
    }
} // End MBand


//import "../../Info" as MInfo

//MInfo.InfoTypeABand{
//    id: idInfoHeightBand
//    x: 0; y:0
//    focus : true

//    titleText: stringInfo.strAutoCareHeightInfo

////    onBackKeyClicked: {
////        console.log(" # [InfoHeightBand] Back")
////        gotoBackScreen()
////    }
//} // End InfoTypeABand

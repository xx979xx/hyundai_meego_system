import QtQuick 1.0

import "component/QML/DH" as MComp

MComp.MBand{
    id: idFATCBand
    x: 0; y: 0
    focus : false

    tabBtnFlag: false
    subBtnFlag: false

    onBackKeyClicked: {
        console.log(" # [AppHvac] Back")
        gotoBackScreen()
    }
} // End MBand

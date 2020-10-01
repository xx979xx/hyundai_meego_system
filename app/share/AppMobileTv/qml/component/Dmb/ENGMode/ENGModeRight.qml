import QtQuick 1.0
import "../../QML/DH" as MComp

MComp.MEditMode{
    id:idDmbENGModeRight
    height: systemInfo.contentAreaHeight
    //opacity: 0.7
    focus: true

    buttonNumber: 4
    buttonText1: "Scan"
    buttonText2: "x2"
    buttonText3: "Full 4:3"
    buttonText4: "Full 16:9"

    onClickButton1:{ //"Channel Search"
//        console.log("==================================[idDmbENGModeRight][onClickButton1]")
        idDmbENGModeRight.focus = true;
        //CommParser.onLocationBasedScan(2)
        //setAppMainScreen("PopupSearching", true)
        //EngineListener.setPopupSearching()
        EngineListener.setPopupSearchingEngMode();
    }
    onClickButton2:{ //"x2"
//        console.log("==================================[idDmbENGModeRight][onClickButton2]")
        idDmbENGModeRight.focus = true;
        DmbPlayer.m_iScreenSizeMode = 1
        EngineListener.updateScreenSizeByOptionMenu(); // DaeHyung 2013.01.13 Fixed ISV 65801
    }
    onClickButton3:{ //"Full Screen 4:3"
//        console.log("==================================[idDmbENGModeRight][onClickButton3]")
        idDmbENGModeRight.focus = true;
        DmbPlayer.m_iScreenSizeMode = 2
        EngineListener.updateScreenSizeByOptionMenu(); // DaeHyung 2013.01.13 Fixed ISV 65801
    }
    onClickButton4:{ //"Full Screen 16:9"
//        console.log("==================================[idDmbENGModeRight][onClickButton4]")
        idDmbENGModeRight.focus = true;
        DmbPlayer.m_iScreenSizeMode = 3
        EngineListener.updateScreenSizeByOptionMenu(); // DaeHyung 2013.01.13 Fixed ISV 65801
    }
}

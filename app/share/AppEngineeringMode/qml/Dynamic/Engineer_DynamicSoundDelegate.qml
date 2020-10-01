import Qt 4.7

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MButtonSound {
    id: idDynamicSoundMenu
    //x:50; y:100
    width: 1280
    height:89
    property int bass: Connect.BassValue - 10 // added for ITS254442 Sound Value Issue
    property int mid: Connect.MidValue - 10 // added for ITS254442 Sound Value Issue
    property int treble: Connect.TrebleValue - 10 // added for ITS254442 Sound Value Issue
    property int balance: Connect.BalanceValue
    property int fader: Connect.FaderValue
    property int variableEQ: Connect.VariableEQValue
    property int avcValue: Connect.AVCValue
    property int surround: Connect.SurroundValue
    property int beep: Connect.BeepValue
    property int soundRatio: Connect.SoundRatioValue
    property int quantum: Connect.QuantumValue
    property int powerBass: Connect.PowerBassValue
    property int welcoming: Connect.WelcomingValue
    property string strFader; // added for ITS254442 Sound Value Issue
    property string strBalance;// added for ITS254442 Sound Value Issue

    Component.onCompleted:{

        // added for ITS254442 Sound Value Issue
       if(index == 0){
           idDynamicSoundMenu.secondText = treble + " / " + mid + " / " + bass
           if(balance > 10)
           {
               strBalance = "R=";
               balance = balance -10
           }
           else if(balance < 10)
           {
               strBalance = "L=";
               balance = 10 - balance
           }
           else if(balance == 10)
           {
               strBalance = "L=R"
               balance = balance -10
           }

           if(fader > 10)
           {
               strFader = "F=";
               fader = fader -10
           }
           else if(fader < 10)
           {
               strFader = "B=";
               fader = 10 - fader
           }
           else if(fader == 10)
           {
               strFader = "F=B"
               fader = fader -10
           }

           idDynamicSoundMenu.forthText = strFader + fader + " / " + strBalance + balance
       }
       else if(index == 1){
           if(variableEQ == 0x40){
                idDynamicSoundMenu.secondText = "Normal"
           }
           else if(variableEQ == 0x80){
               idDynamicSoundMenu.secondText = "Power"
           }
           else if(variableEQ == 0xC0){
               idDynamicSoundMenu.secondText = "Concert"
           }
           else{
               idDynamicSoundMenu.secondText = "Not.Received"
           }

           if(avcValue == 0x00){
               idDynamicSoundMenu.forthText = "OFF"
           }
           else if(avcValue == 0x01){
               idDynamicSoundMenu.forthText = "ON"
           }
           else{
               idDynamicSoundMenu.forthText = avcValue
           }

       }
       else if(index == 2){

           if(surround == 0x00){
               idDynamicSoundMenu.secondText = "OFF"
           }
           else if(surround == 0x01){
              idDynamicSoundMenu.secondText = "ON"
           }
           if(beep == 0x00){
               idDynamicSoundMenu.forthText = "OFF"
           }
           else if(beep == 0x01){
              idDynamicSoundMenu.forthText = "ON"
           }

       }
       else if(index == 3){
           if(soundRatio == 0x00){
                idDynamicSoundMenu.secondText = "NAVI > Audio"
           }
           else if(soundRatio == 0x01){
               idDynamicSoundMenu.secondText = "NAVI < Audio"
           }
           else if(soundRatio == 0x02){
               idDynamicSoundMenu.secondText = "NAVI = Audio"
           }

           if(quantum == 0x00){
               idDynamicSoundMenu.forthText = "OFF"
           }
           else if(quantum == 0x01){
               idDynamicSoundMenu.forthText = "Set1"
           }
           else if(quantum == 0x02){
               idDynamicSoundMenu.forthText = "Set2"
           }
       }
       else if(index == 4){
           if(powerBass == 0x00){
               idDynamicSoundMenu.secondText = "OFF"
           }
           else if(powerBass == 0x01){
               idDynamicSoundMenu.secondText = "ON"
           }

           if(welcoming == 0x00){
               idDynamicSoundMenu.forthText = "OFF"
           }
           else if(welcoming == 0x01){
               idDynamicSoundMenu.forthText = "ON"
           }
       }
        // added for ITS254442 Sound Value Issue

    }

    // added for ITS254442 Sound Value Issue
    Connections{
        target:UIListener

        onUpdateSoundInfo:
        {
            UIListener.printLogMessage("Update Sound Info.!")
            balance = Connect.BalanceValue
            fader = Connect.FaderValue

            UIListener.printLogMessage("balance: " + balance)
            UIListener.printLogMessage("fader: " + fader)
            if(index == 0){
                idDynamicSoundMenu.secondText = treble + " / " + mid + " / " + bass
                if(balance > 10)
                {
                    strBalance = "R=";
                    balance = balance -10
                }
                else if(balance < 10)
                {
                    strBalance = "L=";
                    balance = 10 - balance
                }
                else if(balance == 10)
                {
                    strBalance = "L=R"
                    balance = balance -10
                }

                if(fader > 10)
                {
                    strFader = "F=";
                    fader = fader -10
                }
                else if(fader < 10)
                {
                    strFader = "B=";
                    fader = 10 - fader
                }
                else if(fader == 10)
                {
                    strFader = "F=B"
                    fader = fader -10
                }

                idDynamicSoundMenu.forthText = strFader + fader + " / " + strBalance + balance
            }
            else if(index == 1){
                if(variableEQ == 0x40){
                     idDynamicSoundMenu.secondText = "Normal"
                }
                else if(variableEQ == 0x80){
                    idDynamicSoundMenu.secondText = "Power"
                }
                else if(variableEQ == 0xC0){
                    idDynamicSoundMenu.secondText = "Concert"
                }
                else{
                    idDynamicSoundMenu.secondText = "Not.Received"
                }

                if(avcValue == 0x00){
                    idDynamicSoundMenu.forthText = "OFF"
                }
                else if(avcValue == 0x01){
                    idDynamicSoundMenu.forthText = "ON"
                }
                else{
                    idDynamicSoundMenu.forthText = avcValue
                }

            }
            else if(index == 2){

                if(surround == 0x00){
                    idDynamicSoundMenu.secondText = "OFF"
                }
                else if(surround == 0x01){
                   idDynamicSoundMenu.secondText = "ON"
                }
                if(beep == 0x00){
                    idDynamicSoundMenu.forthText = "OFF"
                }
                else if(beep == 0x01){
                   idDynamicSoundMenu.forthText = "ON"
                }

            }
            else if(index == 3){
                if(soundRatio == 0x00){
                     idDynamicSoundMenu.secondText = "NAVI > Audio"
                }
                else if(soundRatio == 0x01){
                    idDynamicSoundMenu.secondText = "NAVI < Audio"
                }
                else if(soundRatio == 0x02){
                    idDynamicSoundMenu.secondText = "NAVI = Audio"
                }

                if(quantum == 0x00){
                    idDynamicSoundMenu.forthText = "OFF"
                }
                else if(quantum == 0x01){
                    idDynamicSoundMenu.forthText = "Set1"
                }
                else if(quantum == 0x02){
                    idDynamicSoundMenu.forthText = "Set2"
                }
            }
            else if(index == 4){
                if(powerBass == 0x00){
                    idDynamicSoundMenu.secondText = "OFF"
                }
                else if(powerBass == 0x01){
                    idDynamicSoundMenu.secondText = "ON"
                }

                if(welcoming == 0x00){
                    idDynamicSoundMenu.forthText = "OFF"
                }
                else if(welcoming == 0x01){
                    idDynamicSoundMenu.forthText = "ON"
                }
            }

        }
    }
    // added for ITS254442 Sound Value Issue

    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo   {id: colorInfo  }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    //bgImagePress: imgFolderGeneral+"bg_menu_tab_l_p.png"
    //bgImageActive: imgFolderGeneral+"bg_menu_tab_l_s.png"
    //bgImageFocusPress: imgFolderGeneral+"bg_menu_tab_l_fp.png"
    //bgImageFocus: imgFolderGeneral+"bg_menu_tab_l_f.png"

    //. active: index==selectedItem
    firstText : name
    firstTextX: 20
    firstTextY: 43
    firstTextColor: colorInfo.brightGrey
    firstTextSelectedColor: colorInfo.brightGrey
    firstTextSize: 25
    // firstTextColor: colorInfo.brightGrey
    // firstTextSize: 32
    firstTextStyle:"HDB"
    firstTextWidth: 250

    // firstTextStyle: "HDB"
    // secondText: ""
    secondTextX: 300
    secondTextY: 43
    secondTextSize:20
    secondTextColor: "#447CAD"
    //secondTextSelectedColor: colorInfo.dimmedGrey
    secondTextStyle: "HDB"
    secondTextWidth: 250

    thirdText: nextname
    thirdTextX: 570
    thirdTextY: 43
    thirdTextSize: 25
    thirdTextColor: colorInfo.brightGrey

    thirdTextStyle: "HDB"
    thirdTextWidth: 250

    forthTextX: 850
    forthTextY: 43
    forthTextSize:20
    forthTextColor: "#447CAD"
    //forthTextSelectedColor: colorInfo.dimmedGrey
    forthTextStyle: "HDB"
    forthTextWidth: 250

    //    MouseArea{
    //        anchors.fill:parent
    //    }


    Image{
        x:43-23
        y:89
        width: 1200
        source: imgFolderGeneral+"line_menu_list.png"
    }
} // End FocusScope


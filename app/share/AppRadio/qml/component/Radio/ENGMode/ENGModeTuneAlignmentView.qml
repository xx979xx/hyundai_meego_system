import Qt 4.7
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

FocusScope {
    id:idRadioENGModeAlignmentView
    width: parent.width
    height: parent.height
    property string message1 :""
    property string message2 :"Press Next Key"
    property string message3 :""
    property string nextButton : "Next"

//    Image {
//        y:-(systemInfo.statusBarHeight)
//        id: backGruond
//        source: imgFolderGeneral+"bg.png"
//    }
//    GridView{
//        clip: true
//        id: idRadioENGModeList
//        cellWidth: parent.width / 2
//        cellHeight: 72
//        anchors.fill: parent;
//        model: ENGModeModel{id:idengModel}
//        delegate: ENGModeDelegate{}
//        focus: true
//    }

    Text{
        id:idMessage1
        x: 24 ; y: 10
        text: message1
        font.family: systemInfo.hdr//"HDR"
        font.pixelSize: 35
        color: colorInfo.dimmedGrey
        //anchors.verticalCenter: parent.verticalCenter
        //anchors.left: delegate.left
        //anchors.leftMargin: 10*4

    }
    Text{
        id:idMessage3
        x:24 ; y:idMessage1.y + idMessage1.height + 10
        text: message3
        font.family: systemInfo.hdr//"HDR"
        font.pixelSize: 35
        color: colorInfo.dimmedGrey
        //anchors.verticalCenter: parent.verticalCenter
        //anchors.left: delegate.left
        //anchors.leftMargin: 10*4
    }

    Text{
        id:idMessage2
        x:24 ; y:idMessage3.y + idMessage3.height + 10
        text: message2
        font.family: systemInfo.hdr//"HDR"
        font.pixelSize: 35
        color: colorInfo.dimmedGrey
        //anchors.verticalCenter: parent.verticalCenter
        //anchors.left: delegate.left
        //anchors.leftMargin: 10*4
    }
    MComp.MButton{
        id: idNextButton
        x: (parent.width/2) - (width/2) ; y:parent.height/2 - 50

        focus: true
        width:nextButton.length*(firstTextSize/2 + 5) ;height:68 *4

        buttonName:nextButton
        firstText:nextButton
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextSize: nextButton == "Next"? 34 * 4 :34 * 2

        firstTextX: 0; firstTextY: height/2 //30
        firstTextWidth: idNextButton.width//149

        firstTextColor: colorInfo.subTextGrey
        firstTextPressColor: colorInfo.subTextGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.subTextGrey

        bgImage: imageInfo.imgFolderGeneral+"btn_title_sub_n.png"
        bgImageActive: imageInfo.imgFolderGeneral+"btn_title_sub_fp.png"
        bgImagePress: imageInfo.imgFolderGeneral+"btn_title_sub_p.png"
        bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_title_sub_fp.png"
        bgImageFocus: imageInfo.imgFolderGeneral+"btn_title_sub_f.png"

        enabled: false
        onClickOrKeySelected: {
            idNextButton.enabled = false;
            switch(idRadioENGModeMain.cmd){
            case 0x00 :{nextButton = "Next";idRadioENGModeMain.modeType = 0; break;}
            case 0x01 :{idRadioENGModeMain.cmd = 0x02;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
            case 0x02 :{idRadioENGModeMain.cmd = 0x07;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
            case 0x07 :{idRadioENGModeMain.cmd = 0x08;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
            case 0x08 :{idRadioENGModeMain.cmd = 0x0B;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
            case 0x0B :{idRadioENGModeMain.cmd = 0x0C;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
            case 0x0C :{idRadioENGModeMain.cmd = 0x0D;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
            case 0x0D :{idRadioENGModeMain.cmd = 0x0E;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
            case 0x0E :{idRadioENGModeMain.cmd = 0;message1 = "Tuner Alignment Finish";message3 = "";
                nextButton = "Go to Alignment value Screen";idNextButton.enabled = true;break;}
            }
        }

    } // End Button

//    MComp.ModeButton{
//        id: idNextButton
//        x: (parent.width/2) - (width/2) ; y:parent.height/2
//        width:nextButton.length*(fontSize/2 + 5) ; height:68
//        text:nextButton
//        fontName: systemInfo.hdr//"HDR"
//        fontSize: 34
//        bgImage:imgFolderGeneral+"btn_mode_1_n.png"
//        bgImageActive:imgFolderRadio+"btn_mode_s.png"
//        fontColor: colorInfo.brightGrey
//        fontColorShadow: colorInfo.black
//        fontColorActived: "black"
//        enabled: false

//        onClicked: {
//            idNextButton.enabled = false;
//            switch(idRadioENGModeMain.cmd){
//            case 0x00 :{nextButton = "Next";idRadioENGModeMain.modeType = 0; break;}
//            case 0x01 :{idRadioENGModeMain.cmd = 0x02;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
//            case 0x02 :{idRadioENGModeMain.cmd = 0x07;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
//            case 0x07 :{idRadioENGModeMain.cmd = 0x08;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
//            case 0x08 :{idRadioENGModeMain.cmd = 0x0B;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
//            case 0x0B :{idRadioENGModeMain.cmd = 0x0C;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
//            case 0x0C :{idRadioENGModeMain.cmd = 0x0D;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
//            case 0x0D :{idRadioENGModeMain.cmd = 0x0E;QmlController.tuneAlignmentCmd(idRadioENGModeMain.cmd);break;}
//            case 0x0E :{idRadioENGModeMain.cmd = 0;message1 = "Tuner Alignment Finish";message3 = "";
//                nextButton = "Go to Alignment value Screen";idNextButton.enabled = true;break;}
//            }
//        }
//    } // End Button

    Connections{
        target:QmlController
        onEngTuneAlignmentCmdFinish:{
            switch(idRadioENGModeMain.cmd){
            case 0x02 :{message1 = "Radio Alignment Finish(Tuner1_Sub)"; message3 = "";break;}
            case 0x07 :{message1 = "Radio Alignment Ready(Tuner2_Main)"; message3 ="SSG Tune 97.7MHz 200uV";break;}
            case 0x08 :{message1 = "Radio Alignment Finish(Tuner2_Main)"; message3 = "";break;}
            case 0x0B :{message1 = "FM CHannel Seperation Ready";message3 = "SSG Tune 97.7MHz 60dB L-ch Modulation on";break;}
            case 0x0C :{message1 = "FM CHannel Seperation Alignment Finish";message3 = "";break;}
            case 0x0D :{message1 = "AM Alignment Ready";message3 = "SSG Tune AM 1080KHz(60 dBuV)";break;}
            case 0x0E :{message1 = "AM Alignment Finish";message3 = "";break;}
            }
            idNextButton.enabled = ok ;
            if(idNextButton.enabled){
                idNextButton.focus = true;
                idNextButton.forceActiveFocus();
            }
        }
    }
}

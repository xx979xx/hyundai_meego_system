import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Label Import
import "./Common" as XMCommon

// Because Loader is a focus scope, converted from FocusScope to Item.
Item {

    Item {
        x:34; y:339
        width: 1212
        MComp.Label {
            text: idAppMain.isDRSChange ? stringInfo.sSTR_XMDATA_DRS_WARNING_EX : stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITES_STOCK
            txtAlign: "Center"
            fontName: systemInfo.font_NewHDB
            fontSize: 40
            fontColor: colorInfo.brightGrey
        }
    }

    MComp.Button {
        id: idAddButton
        x: 120+326; y: 339+185
        width: 388; height: 72
        focus: true
        text: stringInfo.sSTR_XMDATA_ADD
        fontName: systemInfo.font_NewHDR
        fontSize: 36
        txtAlign: "Center"
        fontColor: colorInfo.black
        fontColorPressed: colorInfo.black
        bgImage: imageInfo.imgFolderBt_phone + "btn_cancel_n.png"
        bgImagePressed: imageInfo.imgFolderBt_phone + "btn_cancel_p.png"
        bgImageFocused: ''

        Image {
            x:-12; y:-12
            source: imageInfo.imgFolderBt_phone + "bg_cancel_f.png"
            visible: idAddButton.activeFocus && focusOn
        }

        onClickOrKeySelected: {
            console.log("onClickOrKeySelected");
            if(playBeepOn)
            {
                UIListener.playAudioBeep();
            }
            setAppMainScreen("callForStockMyFavoritesAddStockSearch", true);
        }
        onHomeKeyPressed: {
            gotoFirstScreen();
            console.log("onHomeKeyPressed");
        }
        onBackKeyPressed: {
            console.log("onBackKeyPressed");
            gotoBackScreen(false);//CCP
        }
        onWheelRightKeyPressed: {
            console.log("onWheelRightKeyPressed");
        }
        onWheelLeftKeyPressed: {
            console.log("onWheelLeftKeyPressed");
        }
//        onClicked: {
//            UIListener.playAudioBeep();
//        }
    }
}

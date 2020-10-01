/**
 * FileName: RadioPresetList.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

FocusScope {
    id: idRadioSearchKeyPad
    x: 0; y: 0
    width: 174+174+174; height: 720-181

    property int currentPad: 0x0001
    property string value : ""

    //**************************************** 1/2/3
    MComp.MButton{
        focus: true
        id:btnKeypad1
        x:0; y:15
        width: 174; height: 130
        mEnabled: (searchFlag & 0x0002) ? true : false
        fgImageX: 65; fgImageY: 38
        fgImageWidth: 51; fgImageHeight: 53
        fgImage: (searchFlag & 0x0002) ? imageInfo.imgFolderBt_phone+"dial_num_1.png" : imageInfo.imgFolderBt_phone+"dial_num_1_d.png"
        bgImage: imageInfo.imgFolderSettings+"btn_search_num_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_num_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_num_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_num_fp.png"
        enabled: true
        onClickOrKeySelected:{
            if(value.length >= 0 && value.length < 3)
            {
                idRadioSearchDisplay.focus = true;
                btnKeypad1.focus = true;
                currentPad = 0x0001;

                value += "1"
                onChangeValue(value)
            }
        }

        //added 8-direction
        onDownRightKeyPressed: getFocusDownRightKey()
        //Wheel Left/Right
        onWheelLeftKeyPressed: getFocusWheelLeft()
        onWheelRightKeyPressed: getFocusWheelRight()
    }
    MComp.MButton{
        id:btnKeypad2
        x:0+174; y:15
        width: 174; height: 130
        mEnabled: (searchFlag & 0x0004) ? true : false
        fgImageX: 65; fgImageY: 38
        fgImageWidth: 51; fgImageHeight: 53
        fgImage: (searchFlag & 0x0004) ? imageInfo.imgFolderBt_phone+"dial_num_2.png" : imageInfo.imgFolderBt_phone+"dial_num_2_d.png"
        bgImage: imageInfo.imgFolderSettings+"btn_search_num_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_num_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_num_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_num_fp.png"
        enabled: true
        onClickOrKeySelected:{
            if(value.length >= 0 && value.length < 3)
            {
                idRadioSearchDisplay.focus = true;
                btnKeypad2.focus = true;
                currentPad = 0x0002;

                value += "2"
                onChangeValue(value)
            }
        }

        //added 8-direction
        onDownLeftKeyPressed: getFocusDownLeftKey()
        onDownRightKeyPressed: getFocusDownRightKey()
        //Wheel Left/Right
        onWheelRightKeyPressed: getFocusWheelRight()
        onWheelLeftKeyPressed: getFocusWheelLeft()
    }
    MComp.MButton{
        id:btnKeypad3
        x:0+174+174; y:15
        width: 174; height: 130
        mEnabled: (searchFlag & 0x0008) ? true : false
        fgImageX: 65; fgImageY: 38
        fgImageWidth: 51; fgImageHeight: 53
        fgImage: (searchFlag & 0x0008) ? imageInfo.imgFolderBt_phone+"dial_num_3.png" : imageInfo.imgFolderBt_phone+"dial_num_3_d.png"
        bgImage: imageInfo.imgFolderSettings+"btn_search_num_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_num_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_num_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_num_fp.png"
        enabled: true
        onClickOrKeySelected:{
            if(value.length >= 0 && value.length < 3)
            {
                idRadioSearchDisplay.focus = true;
                btnKeypad3.focus = true;
                currentPad = 0x0004;

                value += "3"
                onChangeValue(value)
            }
        }

        //added 8-direction
        onDownLeftKeyPressed: getFocusDownLeftKey()
        //Wheel Left/Right
        onWheelRightKeyPressed: getFocusWheelRight()
        onWheelLeftKeyPressed: getFocusWheelLeft()
    }

    //**************************************** 4/5/6
    MComp.MButton{
        id:btnKeypad4
        x:0; y:15+130
        width: 174; height: 130
        mEnabled: (searchFlag & 0x0010) ? true : false
        fgImageX: 65; fgImageY: 38
        fgImageWidth: 51; fgImageHeight: 53
        fgImage: (searchFlag & 0x0010) ? imageInfo.imgFolderBt_phone+"dial_num_4.png" : imageInfo.imgFolderBt_phone+"dial_num_4_d.png"
        bgImage: imageInfo.imgFolderSettings+"btn_search_num_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_num_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_num_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_num_fp.png"
        enabled: true
        onClickOrKeySelected:{
            if(value.length >= 0 && value.length < 3)
            {
                idRadioSearchDisplay.focus = true;
                btnKeypad4.focus = true;
                currentPad = 0x0008;

                value += "4"
                onChangeValue(value)
            }
        }

        //added 8-direction
        onUpRightKeyPressed: getFocusUpRightKey()
        onDownRightKeyPressed: getFocusDownRightKey()
        //Wheel Left/Right
        onWheelRightKeyPressed: getFocusWheelRight()
        onWheelLeftKeyPressed: getFocusWheelLeft()
    }
    MComp.MButton{
        id:btnKeypad5
        x:0+174; y:15+130
        width: 174; height: 130
        mEnabled: (searchFlag & 0x0020) ? true : false
        fgImageX: 65; fgImageY: 38
        fgImageWidth: 51; fgImageHeight: 53
        fgImage: (searchFlag & 0x0020) ? imageInfo.imgFolderBt_phone+"dial_num_5.png" : imageInfo.imgFolderBt_phone+"dial_num_5_d.png"
        bgImage: imageInfo.imgFolderSettings+"btn_search_num_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_num_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_num_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_num_fp.png"
        enabled: true
        onClickOrKeySelected:{
            if(value.length >= 0 && value.length < 3)
            {
                idRadioSearchDisplay.focus = true;
                btnKeypad5.focus = true;
                currentPad = 0x0010;

                value += "5"
                onChangeValue(value)
            }
        }

        //added 8-direction
        onUpLeftKeyPressed: getFocusUpLeftKey()
        onUpRightKeyPressed: getFocusUpRightKey()
        onDownLeftKeyPressed: getFocusDownLeftKey()
        onDownRightKeyPressed: getFocusDownRightKey()
        //Wheel Left/Right
        onWheelRightKeyPressed: getFocusWheelRight()
        onWheelLeftKeyPressed: getFocusWheelLeft()
    }
    MComp.MButton{
        id:btnKeypad6
        x:0+174+174; y:15+130
        width: 174; height: 130
        mEnabled: (searchFlag & 0x0040) ? true : false
        fgImageX: 65; fgImageY: 38
        fgImageWidth: 51; fgImageHeight: 53
        fgImage: (searchFlag & 0x0040) ? imageInfo.imgFolderBt_phone+"dial_num_6.png" : imageInfo.imgFolderBt_phone+"dial_num_6_d.png"
        bgImage: imageInfo.imgFolderSettings+"btn_search_num_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_num_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_num_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_num_fp.png"
        enabled: true
        onClickOrKeySelected:{
            if(value.length >= 0 && value.length < 3)
            {
                idRadioSearchDisplay.focus = true;
                btnKeypad6.focus = true;
                currentPad = 0x0020;

                value += "6"
                onChangeValue(value)
            }
        }

        //added 8-direction
        onUpLeftKeyPressed: getFocusUpLeftKey()
        onDownLeftKeyPressed: getFocusDownLeftKey()
        //Wheel Left/Right
        onWheelRightKeyPressed: getFocusWheelRight()
        onWheelLeftKeyPressed: getFocusWheelLeft()
    }

    //**************************************** 7/8/9
    MComp.MButton{
        id:btnKeypad7
        x:0; y:15+130+130
        width: 174; height: 130
        mEnabled: (searchFlag & 0x0080) ? true : false
        fgImageX: 65; fgImageY: 38
        fgImageWidth: 51; fgImageHeight: 53
        fgImage: (searchFlag & 0x0080) ? imageInfo.imgFolderBt_phone+"dial_num_7.png" : imageInfo.imgFolderBt_phone+"dial_num_7_d.png"
        bgImage: imageInfo.imgFolderSettings+"btn_search_num_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_num_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_num_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_num_fp.png"
        enabled: true
        onClickOrKeySelected:{
            if(value.length >= 0 && value.length < 3)
            {
                idRadioSearchDisplay.focus = true;
                btnKeypad7.focus = true;
                currentPad = 0x0040;

                value += "7"
                onChangeValue(value)
            }
        }

        //added 8-direction
        onUpRightKeyPressed: getFocusUpRightKey()
        onDownRightKeyPressed: getFocusDownRightKey()
        //Wheel Left/Right
        onWheelRightKeyPressed: getFocusWheelRight()
        onWheelLeftKeyPressed: getFocusWheelLeft()
    }
    MComp.MButton{
        id:btnKeypad8
        x:0+174; y:15+130+130
        width: 174; height: 130
        mEnabled: (searchFlag & 0x0100) ? true : false
        fgImageX: 65; fgImageY: 38
        fgImageWidth: 51; fgImageHeight: 53
        fgImage: (searchFlag & 0x0100) ? imageInfo.imgFolderBt_phone+"dial_num_8.png" : imageInfo.imgFolderBt_phone+"dial_num_8_d.png"
        bgImage: imageInfo.imgFolderSettings+"btn_search_num_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_num_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_num_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_num_fp.png"
        enabled: true
        onClickOrKeySelected:{
            if(value.length >= 0 && value.length < 3)
            {
                idRadioSearchDisplay.focus = true;
                btnKeypad8.focus = true;
                currentPad = 0x0080;

                value += "8"
                onChangeValue(value)
            }
        }

        //added 8-direction
        onUpLeftKeyPressed: getFocusUpLeftKey()
        onUpRightKeyPressed: getFocusUpRightKey()
        onDownLeftKeyPressed: getFocusDownLeftKey()
        onDownRightKeyPressed: getFocusDownRightKey()
        //Wheel Left/Right
        onWheelRightKeyPressed: getFocusWheelRight()
        onWheelLeftKeyPressed: getFocusWheelLeft()
    }
    MComp.MButton{
        id:btnKeypad9
        x:0+174+174; y:15+130+130
        width: 174; height: 130
        mEnabled: (searchFlag & 0x0200) ? true : false
        fgImageX: 65; fgImageY: 38
        fgImageWidth: 51; fgImageHeight: 53
        fgImage: (searchFlag & 0x0200) ? imageInfo.imgFolderBt_phone+"dial_num_9.png" : imageInfo.imgFolderBt_phone+"dial_num_9_d.png"
        bgImage: imageInfo.imgFolderSettings+"btn_search_num_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_num_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_num_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_num_fp.png"
        enabled: true
        onClickOrKeySelected:{
            if(value.length >= 0 && value.length < 3)
            {
                idRadioSearchDisplay.focus = true;
                btnKeypad9.focus = true;
                currentPad = 0x0100;

                value += "9"
                onChangeValue(value)
            }
        }

        //added 8-direction
        onUpLeftKeyPressed: getFocusUpLeftKey()
        onDownLeftKeyPressed: getFocusDownLeftKey()
        //Wheel Left/Right
        onWheelRightKeyPressed: getFocusWheelRight()
        onWheelLeftKeyPressed: getFocusWheelLeft()
    }

    //**************************************** Go/0/x
    MComp.MButton{
        id:btnKeypadStar
        x:0; y:15+130+130+130
        width: 174; height:130
        mEnabled: (xm_search_find == true) ? true : false
        bgImage: (xm_search_find == true) ? imageInfo.imgFolderSettings+"btn_search_done_n.png" : imageInfo.imgFolderSettings+"btn_search_done_d.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_done_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_done_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_done_fp.png"
        firstText: stringInfo.sSTR_XMRADIO_GO
        firstTextX: 11; firstTextY: 66
        firstTextWidth:154
        firstTextSize: 46
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: (xm_search_find == true) ? colorInfo.brightGrey : colorInfo.disableGrey
        firstTextPressColor: firstTextColor
        enabled: true
        onClickOrKeySelected:{
            if(xm_search_find == true)
            {
                idRadioSearchDisplay.focus = true;
                btnKeypadStar.focus = true;
                currentPad = 0x0200;

                resetValue();
                XMOperation.setPreviousScanStop();
                setAppMainScreen( "AppRadioMain" , false);
                UIListener.HandleFindChannelGo(false);
            }
        }

        //added 8-direction
        onUpRightKeyPressed: getFocusUpRightKey()
        //Wheel Left/Right
        onWheelRightKeyPressed: getFocusWheelRight()
        onWheelLeftKeyPressed: getFocusWheelLeft()
    }
    MComp.MButton{
        id:btnKeypad0
        x:174; y:15+130+130+130
        width: 174; height:130
        mEnabled: (searchFlag & 0x0001) ? true : false
        fgImageX: 65; fgImageY: 38
        fgImageWidth: 51; fgImageHeight: 53
        fgImage: (searchFlag & 0x0001) ? imageInfo.imgFolderBt_phone+"dial_num_0.png" : imageInfo.imgFolderBt_phone+"dial_num_0_d.png"
        bgImage: imageInfo.imgFolderSettings+"btn_search_num_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_num_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_num_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_num_fp.png"
        enabled: true
        onClickOrKeySelected:{
            if(value.length >= 0 && value.length < 3)
            {
                idRadioSearchDisplay.focus = true;
                btnKeypad0.focus = true;
                currentPad = 0x0400;

                value += "0"
                onChangeValue(value)
            }
        }

        //added 8-direction
        onUpLeftKeyPressed: getFocusUpLeftKey()
        onUpRightKeyPressed: getFocusUpRightKey()
        //Wheel Left/Right
        onWheelRightKeyPressed: getFocusWheelRight()
        onWheelLeftKeyPressed: getFocusWheelLeft()
    }
    MComp.MButton{
        id:btnKeypadSharp
        x:174+174; y:15+130+130+130
        width: 174; height:130
        mEnabled: (xm_search_number == "") ? false : true
        fgImageX: 38; fgImageY: 38
        fgImageWidth: 103; fgImageHeight: 55
        fgImage: (xm_search_number == "") ? imageInfo.imgFolderBt_phone+"ico_dial_del_d.png" : imageInfo.imgFolderBt_phone+"ico_dial_del.png"
        bgImage: imageInfo.imgFolderSettings+"btn_search_num_n.png"
        bgImagePress: imageInfo.imgFolderSettings+"btn_search_num_p.png"
        bgImageFocus:imageInfo.imgFolderSettings+"btn_search_num_f.png"
        bgImageFocusPress:imageInfo.imgFolderSettings+"btn_search_num_fp.png"
        enabled: true//(xm_search_number == "") ? false : true
        onClickOrKeySelected:{
            idRadioSearchDisplay.focus = true;
            btnKeypadSharp.focus = true;
            currentPad = 0x0800;

            value = value.toString().slice(0, -1)
            onChangeValue(value)
        }

        onPressAndHold: {
            if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch") idAppMain.playBeep();

            console.log(" All Clear Search Number");
            resetValue();
            searchFlag = UIListener.HandleSmartFindChannel(xm_search_number);
            idRadioSearchKeyPad.getFocusDirectTune();

            idAppMain.pressAndHoldResetFlag();
        }

        //added 8-direction
        onUpLeftKeyPressed: getFocusUpLeftKey()
        //Wheel Left/Right
        onWheelLeftKeyPressed: getFocusWheelLeft()
        onWheelRightKeyPressed:  getFocusWheelRight()
    }

    Keys.onPressed: {
        if(event.key == Qt.Key_Left && event.modifiers == Qt.NoModifier)
        {
            getFocusLeftKey();
        }
        else if(event.key == Qt.Key_Right && event.modifiers == Qt.NoModifier)
        {
            getFocusRightKey();
        }
        else if(event.key == Qt.Key_Up && event.modifiers == Qt.NoModifier && upKeyLongPressed == false)
        {
            if(currentPad == 0x0001 || currentPad == 0x0002 || currentPad == 0x0004)
                event.accepted = false;
            else
            {
                event.accepted = true;
                getFocusUpKey();
            }
        }
        else if(event.key == Qt.Key_Down && event.modifiers == Qt.NoModifier && downKeyLongPressed == false)
        {
            getFocusDownKey();
        }
    }

    function resetValue()
    {
        value = ""
        xm_search_number = ""
        xm_search_find = false
        currentPad = 0x0001;
    }

    function getFocusDirectTune()
    {
        console.log("%%%%%%%%%%%%%%% Direct Tune Keypad Flag %%%%%%%%%%%%%%% "+searchFlag+" / "+currentPad);

        switch(currentPad)
        {
        case 0x0001:
        {
            if(searchFlag & 0x0002)
            {
                btnKeypad1.focus = true;
                currentPad = 0x0001;
            }
            else
            {
                getRecheckFocusDirectTune();
            }
            break;
        }
        case 0x0002:
        {
            if(searchFlag & 0x0004)
            {
                btnKeypad2.focus = true;
                currentPad = 0x0002;
            }
            else
            {
                getRecheckFocusDirectTune();
            }
            break;
        }
        case 0x0004:
        {
            if(searchFlag & 0x0008)
            {
                btnKeypad3.focus = true;
                currentPad = 0x0004;
            }
            else
            {
                getRecheckFocusDirectTune();
            }
            break;
        }
        case 0x0008:
        {
            if(searchFlag & 0x0010)
            {
                btnKeypad4.focus = true;
                currentPad = 0x0008;
            }
            else
            {
                getRecheckFocusDirectTune();
            }
            break;
        }
        case 0x0010:
        {
            if(searchFlag & 0x0020)
            {
                btnKeypad5.focus = true;
                currentPad = 0x0010;
            }
            else
            {
                getRecheckFocusDirectTune();
            }
            break;
        }
        case 0x0020:
        {
            if(searchFlag & 0x0040)
            {
                btnKeypad6.focus = true;
                currentPad = 0x0020;
            }
            else
            {
                getRecheckFocusDirectTune();
            }
            break;
        }
        case 0x0040:
        {
            if(searchFlag & 0x0080)
            {
                btnKeypad7.focus = true;
                currentPad = 0x0040;
            }
            else
            {
                getRecheckFocusDirectTune();
            }
            break;
        }
        case 0x0080:
        {
            if(searchFlag & 0x0100)
            {
                btnKeypad8.focus = true;
                currentPad = 0x0080;
            }
            else
            {
                getRecheckFocusDirectTune();
            }
            break;
        }
        case 0x0100:
        {
            if(searchFlag & 0x0200)
            {
                btnKeypad9.focus = true;
                currentPad = 0x0100;
            }
            else
            {
                getRecheckFocusDirectTune();
            }
            break;
        }
        case 0x0200:
        {
            if(xm_search_find == true)
            {
                btnKeypadStar.focus = true;
                currentPad = 0x0200;
            }
            break;
        }
        case 0x0400:
        {
            if(searchFlag & 0x0001)
            {
                btnKeypad0.focus = true;
                currentPad = 0x0400;
            }
            else if(searchFlag == 0x0 && xm_search_number == "0")
            {
                btnKeypadStar.focus = true;
                currentPad = 0x0200;
            }
            else
            {
                getRecheckFocusDirectTune();
            }
            break;
        }
        case 0x0800:
        {
            if(xm_search_number != "")
            {
                btnKeypadSharp.focus = true;
                currentPad = 0x0800;
            }
            else if(xm_search_number == "" && !btnKeypadSharp.mEnabled && searchFlag & 0x0002)
            {
                console.log(" Delete Channel Number !!!!!!!!!!!!!!! Search Num: "+xm_search_number+" Enable: "+btnKeypadSharp.mEnabled+" Search Flag: "+searchFlag)
                getFocusWheelRight();
            }
            break;
        }
        default:
            setFocusBackBtn();
            break;
        }
    }

    function getRecheckFocusDirectTune()
    {
        console.log("getRecheckFocusDirectTune() -> serchFlag "+searchFlag+" "+xm_search_number+" "+xm_search_find/*+" "+currentPad*/)

        if(searchFlag & 0x0002)//1
        {
            btnKeypad1.focus = true;
            currentPad = 0x0001;
            return;
        }
        if(searchFlag & 0x0004) //2
        {
            btnKeypad2.focus = true;
            currentPad = 0x0002;
            return;
        }
        if(searchFlag & 0x0008) //3
        {
            btnKeypad3.focus = true;
            currentPad = 0x0004;
            return;
        }
        if(searchFlag & 0x0010) //4
        {
            btnKeypad4.focus = true;
            currentPad = 0x0008;
            return;
        }
        if(searchFlag & 0x0020) //5
        {
            btnKeypad5.focus = true;
            currentPad = 0x0010;
            return;
        }
        if(searchFlag & 0x0040) //6
        {
            btnKeypad6.focus = true;
            currentPad = 0x0020;
            return;
        }
        if(searchFlag & 0x0080) //7
        {
            btnKeypad7.focus = true;
            currentPad = 0x0040;
            return;
        }
        if(searchFlag & 0x0100) //8
        {
            btnKeypad8.focus = true;
            currentPad = 0x0080;
            return;
        }
        if(searchFlag & 0x0200) //9
        {
            btnKeypad9.focus = true;
            currentPad = 0x0100;
            return;
        }
        if(searchFlag & 0x0001) // 0
        {
            btnKeypad0.focus = true;
            currentPad = 0x0400;
            return;
        }
        else
        {
            //console.log("getRecheckFocusDirectTune() -> [0] No Find Search Flag "+searchFlag+" "+xm_search_number+" "+xm_search_find)

            if((searchFlag == 0x00) && (xm_search_find == true) && (xm_search_number != ""))
            {
                btnKeypadStar.focus = true;
                currentPad = 0x0200;
            }
            else
            {
                //console.log("getRecheckFocusDirectTune() -> [1] No Find Search Flag "+searchFlag+" "+xm_search_number+" "+xm_search_find)
                setFocusBackBtn();
            }
        }
    }

    function getFocusLeftKey()
    {
        if(currentPad == 0x0001 || currentPad == 0x0008 || currentPad == 0x0040 || currentPad == 0x0200)
        {
            return;
        }
        else if(currentPad == 0x0002 || currentPad == 0x0010 || currentPad == 0x0080 || currentPad == 0x0400)
        {
            switch(currentPad)
            {
            case 0x0002:
            {
                if((currentPad >> 1) && (searchFlag & 0x0002)) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
                else { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            }
            case 0x0010:
            {
                if((currentPad >> 1) && (searchFlag & 0x0010)) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
                else { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            }
            case 0x0080:
            {
                if((currentPad >> 1) && (searchFlag & 0x0080)) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
                else { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            }
            case 0x0400:
            {
                if((currentPad >> 1) && (xm_search_find == true)) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
                else { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            }
            default:
                break;
            }
        }
        else if(currentPad == 0x0004 || currentPad == 0x0020 || currentPad == 0x0100 || currentPad == 0x0800)
        {
            switch(currentPad)
            {
            case 0x0004:
            {
                if((currentPad >> 1) && (searchFlag & 0x0004)) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
                else if((currentPad >> 1) && (searchFlag & 0x0002)) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
                else { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            }
            case 0x0020:
            {
                if((currentPad >> 1) && (searchFlag & 0x0020)) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
                else if((currentPad >> 1) && (searchFlag & 0x0010)) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
                else { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            }
            case 0x0100:
            {
                if((currentPad >> 1) && (searchFlag & 0x0100)) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
                else if((currentPad >> 1) && (searchFlag & 0x0080)) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
                else { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            }
            case 0x0800:
            {
                if((currentPad >> 1) && (searchFlag & 0x0001)) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
                else if((currentPad >> 1) && (xm_search_find == true)) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
                else { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            }
            default:
                break;
            }
        }
    }

    function getFocusRightKey()
    {
        if(currentPad == 0x0004 || currentPad == 0x0020 || currentPad == 0x0100 || currentPad == 0x0800)
        {
            return;
        }
        else if(currentPad == 0x0002 || currentPad == 0x0010 || currentPad == 0x0080 || currentPad == 0x0400)
        {
            switch(currentPad)
            {
            case 0x0002:
            {
                if((currentPad << 1) && (searchFlag & 0x0008)) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
                else { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            }
            case 0x0010:
            {
                if((currentPad << 1) && (searchFlag & 0x0040)) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
                else { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            }
            case 0x0080:
            {
                if((currentPad << 1) && (searchFlag & 0x0200)) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
                else { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            }
            case 0x0400:
            {
                if((currentPad << 1) && (xm_search_number != "")) { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
                else { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            }
            default:
                break;
            }
        }
        else if(currentPad == 0x0001 || currentPad == 0x0008 || currentPad == 0x0040 || currentPad == 0x0200)
        {
            switch(currentPad)
            {
            case 0x0001:
            {
                if((currentPad << 1) && (searchFlag & 0x0004)) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
                else if((currentPad << 1) && (searchFlag & 0x0008)) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
                else { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            }
            case 0x0008:
            {
                if((currentPad << 1) && (searchFlag & 0x0020)) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
                else if((currentPad << 1) && (searchFlag & 0x0040)) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
                else { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            }
            case 0x0040:
            {
                if((currentPad << 1) && (searchFlag & 0x0100)) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
                else if((currentPad << 1) && (searchFlag & 0x0200)) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
                else { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            }
            case 0x0200:
            {
                if((currentPad << 1) && (searchFlag & 0x0001)) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
                else if((currentPad << 1) && (xm_search_number != "")) { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
                else { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            }
            default:
                break;
            }
        }
    }

    function getFocusUpKey()
    {
        if(currentPad == 0x0001 || currentPad == 0x0002 || currentPad == 0x0004)
        {
            return;
        }
        else if(currentPad == 0x0008 || currentPad == 0x0010 || currentPad == 0x0020)
        {
            switch(currentPad)
            {
            case 0x0008:
            {
                if((currentPad >> 3) && (searchFlag & 0x0002)) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
                else { btnKeypad4.focus = true; currentPad = 0x0008; setFocusBackBtn(); return; }
            }
            case 0x0010:
            {
                if((currentPad >> 3) && (searchFlag & 0x0004)) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
                else { btnKeypad5.focus = true; currentPad = 0x0010; setFocusBackBtn(); return; }
            }
            case 0x0020:
            {
                if((currentPad >> 3) && (searchFlag & 0x0008)) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
                else { btnKeypad6.focus = true; currentPad = 0x0020; setFocusBackBtn(); return; }
            }
            default:
                break;
            }
        }
        else if(currentPad == 0x0040 || currentPad == 0x0080 || currentPad == 0x0100)
        {
            switch(currentPad)
            {
            case 0x0040:
            {
                if((currentPad >> 3) && (searchFlag & 0x0010)) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
                else if((currentPad >> 3) && (searchFlag & 0x0002)) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
                else { btnKeypad7.focus = true; currentPad = 0x0040; setFocusBackBtn(); return; }
            }
            case 0x0080:
            {
                if((currentPad >> 3) && (searchFlag & 0x0020)) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
                else if((currentPad >> 3) && (searchFlag & 0x0004)) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
                else { btnKeypad8.focus = true; currentPad = 0x0080; setFocusBackBtn(); return; }
            }
            case 0x0100:
            {
                if((currentPad >> 3) && (searchFlag & 0x0040)) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
                else if((currentPad >> 3) && (searchFlag & 0x0008)) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
                else { btnKeypad9.focus = true; currentPad = 0x0100; setFocusBackBtn(); return; }
            }
            default:
                break;
            }
        }
        else if(currentPad == 0x0200 || currentPad == 0x0400 || currentPad == 0x0800)
        {
            switch(currentPad)
            {
            case 0x0200:
            {
                if((currentPad >> 3) && (searchFlag & 0x0080)) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
                else if((currentPad >> 3) && (searchFlag & 0x0010)) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
                else if((currentPad >> 3) && (searchFlag & 0x0002)) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
                else { btnKeypadStar.focus = true; currentPad = 0x0200; setFocusBackBtn(); return; }
            }
            case 0x0400:
            {
                if((currentPad >> 3) && (searchFlag & 0x0100)) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
                else if((currentPad >> 3) && (searchFlag & 0x0020)) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
                else if((currentPad >> 3) && (searchFlag & 0x0004)) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
                else { btnKeypad0.focus = true; currentPad = 0x0400; setFocusBackBtn(); return; }
            }
            case 0x0800:
            {
                if((currentPad >> 3) && (searchFlag & 0x0200)) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
                else if((currentPad >> 3) && (searchFlag & 0x0040)) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
                else if((currentPad >> 3) && (searchFlag & 0x0008)) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
                else { btnKeypadSharp.focus = true; currentPad = 0x0800; setFocusBackBtn(); return; }
            }
            default:
                break;
            }
        }
    }

    function getFocusDownKey()
    {
        if(currentPad == 0x0200 || currentPad == 0x0400 || currentPad == 0x0800)
        {
            return;
        }
        else if(currentPad == 0x0040 || currentPad == 0x0080 || currentPad == 0x0100)
        {
            switch(currentPad)
            {
            case 0x0040:
            {
                if((currentPad << 3) && (xm_search_find == true)) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
                else { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            }
            case 0x0080:
            {
                if((currentPad << 3) && (searchFlag & 0x0001)) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
                else { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            }
            case 0x0100:
            {
                if((currentPad << 3) && (xm_search_number != "")) { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
                else { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            }
            default:
                break;
            }
        }
        else if(currentPad == 0x0008 || currentPad == 0x0010 || currentPad == 0x0020)
        {
            switch(currentPad)
            {
            case 0x0008:
            {
                if((currentPad << 3) && (searchFlag & 0x0080)) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
                else if((currentPad << 3) && (xm_search_find == true)) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
                else { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            }
            case 0x0010:
            {
                if((currentPad << 3) && (searchFlag & 0x0100)) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
                else if((currentPad << 3) && (searchFlag & 0x0001)) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
                else { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            }
            case 0x0020:
            {
                if((currentPad << 3) && (searchFlag & 0x0200)) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
                else if((currentPad << 3) && (xm_search_number != "")) { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
                else { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            }
            default:
                break;
            }
        }
        else if(currentPad == 0x0001 || currentPad == 0x0002 || currentPad == 0x0004)
        {
            switch(currentPad)
            {
            case 0x0001:
            {
                if((currentPad << 3) && (searchFlag & 0x0010)) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
                else if((currentPad << 3) && (searchFlag & 0x0080)) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
                else if((currentPad << 3) && (xm_search_find == true)) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
                else { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            }
            case 0x0002:
            {
                if((currentPad << 3) && (searchFlag & 0x0020)) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
                else if((currentPad << 3) && (searchFlag & 0x0100)) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
                else if((currentPad << 3) && (searchFlag & 0x0001)) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
                else { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            }
            case 0x0004:
            {
                if((currentPad << 3) && (searchFlag & 0x0040)) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
                else if((currentPad << 3) && (searchFlag & 0x0200)) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
                else if((currentPad << 3) && (xm_search_number != "")) { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
                else { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            }
            default:
                break;
            }
        }
    }

    function getFocusWheelLeft()
    {
        switch(currentPad)
        {
        case 0x0001: //Pad 1
        {
            if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else { btnKeypad1.focus = true; currentPad = 0x0001; return; }
        }
        case 0x0002: //Pad 2
        {
            if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else { btnKeypad2.focus = true; currentPad = 0x0002; return; }
        }
        case 0x0004: //Pad 3
        {
            if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else  { btnKeypad3.focus = true; currentPad = 0x0004; return; }
        }
        case 0x0008: //Pad 4
        {
            if(searchFlag & 0x0008)  { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else { btnKeypad4.focus = true; currentPad = 0x0008; return; }
        }
        case 0x0010: //Pad 5
        {
            if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0008)  { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else { btnKeypad5.focus = true; currentPad = 0x0010; return; }
        }
        case 0x0020: //Pad 6
        {
            if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0008)  { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else { btnKeypad6.focus = true; currentPad = 0x0020; return; }
        }
        case 0x0040: //Pad 7
        {
            if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0008)  { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else { btnKeypad7.focus = true; currentPad = 0x0040; return; }
        }
        case 0x0080: //Pad 8
        {
            if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0008)  { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else { btnKeypad8.focus = true; currentPad = 0x0080; return; }
        }
        case 0x0100: //Pad 9
        {
            if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0008)  { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else { btnKeypad9.focus = true; currentPad = 0x0100; return; }
        }
        case 0x0200: //Pad Go
        {
            if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0008)  { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
        }
        case 0x0400: //Pad 0
        {
            if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0008)  { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else { btnKeypad0.focus = true; currentPad = 0x0400; return; }
        }
        case 0x0800: //Pad Del
        {
            if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0008)  { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
        }
        default:
            break;
        }
    }

    function getFocusWheelRight()
    {
        switch(currentPad)
        {
        case 0x0001: //Pad 1
        {
            if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else { btnKeypad1.focus = true; currentPad = 0x0001; return; }
        }
        case 0x0002: //Pad 2
        {
            if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else { btnKeypad2.focus = true; currentPad = 0x0002; return; }
        }
        case 0x0004: //Pad 3
        {
            if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else { btnKeypad3.focus = true; currentPad = 0x0004; return; }
        }
        case 0x0008: //Pad 4
        {
            if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else { btnKeypad4.focus = true; currentPad = 0x0008; return; }
        }
        case 0x0010: //Pad 5
        {
            if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else { btnKeypad5.focus = true; currentPad = 0x0010; return; }
        }
        case 0x0020: //Pad 6
        {
            if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else { btnKeypad6.focus = true; currentPad = 0x0020; return; }
        }
        case 0x0040: //Pad 7
        {
            if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else { btnKeypad7.focus = true; currentPad = 0x0040; return; }
        }
        case 0x0080: //Pad 8
        {
            if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else { btnKeypad8.focus = true; currentPad = 0x0080; return; }
        }
        case 0x0100: //Pad 9
        {
            if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else { btnKeypad9.focus = true; currentPad = 0x0100; return; }
        }
        case 0x0200: //Pad Go
        {
            if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
        }
        case 0x0400: //Pad 0
        {
            if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else { btnKeypad0.focus = true; currentPad = 0x0400; return; }
        }
        case 0x0800: //Pad Del
        {
            if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
        }
        default:
            break;
        }
    }

    function getFocusUpLeftKey()
    {
        switch(currentPad)
        {
        case 0x0010: //Pad 5
        {
            if(searchFlag & 0x0002) { btnKeypad1.focus = true; currentPad = 0x0001; return; }
            else { btnKeypad5.focus = true; currentPad = 0x0010; return; }
        }
        case 0x0020: //Pad 6
        {
            if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else { btnKeypad6.focus = true; currentPad = 0x0020; return; }
        }
        case 0x0080: //Pad 8
        {
            if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else { btnKeypad8.focus = true; currentPad = 0x0080; return; }
        }
        case 0x0100: //Pad 9
        {
            if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else { btnKeypad9.focus = true; currentPad = 0x0100; return; }
        }
        case 0x0400: //Pad 0
        {
            if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else { btnKeypad0.focus = true; currentPad = 0x0400; return; }
        }
        case 0x0800: //Pad Del
        {
            if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
        }
        default:
            break;
        }
    }

    function getFocusUpRightKey()
    {
        switch(currentPad)
        {
        case 0x0008: //Pad 4
        {
            if(searchFlag & 0x0004) { btnKeypad2.focus = true; currentPad = 0x0002; return; }
            else { btnKeypad4.focus = true; currentPad = 0x0008; return; }
        }
        case 0x0010: //Pad 5
        {
            if(searchFlag & 0x0008) { btnKeypad3.focus = true; currentPad = 0x0004; return; }
            else { btnKeypad5.focus = true; currentPad = 0x0010; return; }
        }
        case 0x0040: //Pad 7
        {
            if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else { btnKeypad7.focus = true; currentPad = 0x0040; return; }
        }
        case 0x0080: //Pad 8
        {
            if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else { btnKeypad8.focus = true; currentPad = 0x0080; return; }
        }
        case 0x0200: //Pad Go
        {
            if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
        }
        case 0x0400: //Pad 0
        {
            if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else { btnKeypad0.focus = true; currentPad = 0x0400; return; }
        }
        default:
            break;
        }
    }

    function getFocusDownLeftKey()
    {
        switch(currentPad)
        {
        case 0x0002: //Pad 2
        {
            if(searchFlag & 0x0010) { btnKeypad4.focus = true; currentPad = 0x0008; return; }
            else { btnKeypad2.focus = true; currentPad = 0x0002; return; }
        }
        case 0x0004: //Pad 3
        {
            if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else { btnKeypad3.focus = true; currentPad = 0x0004; return; }
        }
        case 0x0010: //Pad 5
        {
            if(searchFlag & 0x0080) { btnKeypad7.focus = true; currentPad = 0x0040; return; }
            else { btnKeypad5.focus = true; currentPad = 0x0010; return; }
        }
        case 0x0020: //Pad 6
        {
            if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else { btnKeypad6.focus = true; currentPad = 0x0020; return; }
        }
        case 0x0080: //Pad 8
        {
            if(xm_search_find == true) { btnKeypadStar.focus = true; currentPad = 0x0200; return; }
            else { btnKeypad8.focus = true; currentPad = 0x0080; return; }
        }
        case 0x0100: //Pad 9
        {
            if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else { btnKeypad9.focus = true; currentPad = 0x0100; return; }
        }
        default:
            break;
        }
    }

    function getFocusDownRightKey()
    {
        switch(currentPad)
        {
        case 0x0001: //Pad 1
        {
            if(searchFlag & 0x0020) { btnKeypad5.focus = true; currentPad = 0x0010; return; }
            else { btnKeypad1.focus = true; currentPad = 0x0001; return; }
        }
        case 0x0002: //Pad 2
        {
            if(searchFlag & 0x0040) { btnKeypad6.focus = true; currentPad = 0x0020; return; }
            else { btnKeypad2.focus = true; currentPad = 0x0002; return; }
        }
        case 0x0008: //Pad 4
        {
            if(searchFlag & 0x0100) { btnKeypad8.focus = true; currentPad = 0x0080; return; }
            else { btnKeypad4.focus = true; currentPad = 0x0008; return; }
        }
        case 0x0010: //Pad 5
        {
            if(searchFlag & 0x0200) { btnKeypad9.focus = true; currentPad = 0x0100; return; }
            else { btnKeypad5.focus = true; currentPad = 0x0010; return; }
        }
        case 0x0040: //Pad 7
        {
            if(searchFlag & 0x0001) { btnKeypad0.focus = true; currentPad = 0x0400; return; }
            else { btnKeypad7.focus = true; currentPad = 0x0040; return; }
        }
        case 0x0080: //Pad 8
        {
            if(xm_search_number != "") { btnKeypadSharp.focus = true; currentPad = 0x0800; return; }
            else { btnKeypad8.focus = true; currentPad = 0x0080; return; }
        }
        default:
            break;
        }
    }
}

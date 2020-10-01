import Qt 4.7
import "../../QML/DH" as MComp
import "../../system/DH" as MSystem
//import "../../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

//MComp.MComponent {
Item{
    id:delegate
    x:0; y:0
    width:idRadioENGModeMain.delegateCellWidth ; height: idRadioENGModeMain.delegateCellHeight

    property string imgFolderRadio : imageInfo.imgFolderRadio
    property string seletedEngButton    : ""
    property int mButtonX : 0
    property int mButtonY : 0
    property int mBtnFullNum  : 0

    property int mTextInputX : 0
    property int mTextInputY : 0
    property int mTextInputFullNum : 0

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id : colorInfo }
    MSystem.ImageInfo{ id: imageInfo }

    Row{
        Rectangle{
            id:idBorderDataName
            x:0; y:0
            width: delegateWidth != 0 ?delegateWidth : delegate.width /2
            height: delegate.height
            color:colorInfo.transparent
            border.color : colorInfo.buttonGrey
            border.width : 2
            //anchors.verticalCenter: parent.verticalCenter

            //**************************************** ENG Data Name Text
            Text{
                id:idDataName
                //x:10
                text: dataName
                font.family: systemInfo.hdr//"HDR"
                font.pixelSize: idRadioENGModeMain.delegatefontSize//30//idDataName.width < idBorderDataName.width ? 35 : 35/2
                color: colorInfo.dimmedGrey
                //anchors.verticalCenter: parent.verticalCenter
                //anchors.left: delegate.left
                //anchors.leftMargin: 10*4

                horizontalAlignment : Text.AlignHCenter; //Default Center
                verticalAlignment : Text.AlignVCenter;
                width: idBorderDataName.width ; height: idBorderDataName.height
                wrapMode:Text.Wrap
            }
        }

        Rectangle{
            id:idBorderDataValue
            x:0; y:0
            width: delegateWidth != 0 ? delegate.width - delegateWidth : delegate.width /2
            height: delegate.height
            color:colorInfo.transparent
            border.color : colorInfo.buttonGrey
            border.width : 2
            anchors.verticalCenter: parent.verticalCenter

            //**************************************** ENG Data Value Text
            Text{
                id:idDataValue
                text: dataValue
                x: 10
                font.family: systemInfo.hdr//"HDR"
                font.pixelSize: idRadioENGModeMain.delegatefontSize//30
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                visible: idDataName1.text.substring(0,6) == "button" ? false : true
                //anchors.right: delegate.right
                //anchors.rightMargin: 10*4
            }
            //**************************************** ENG Data Value 1 Text

            Text{
                id:idDataValue1
                text: dataValue1
                //x: idDataValue.width + idDataValue.x + 40
                font.family: systemInfo.hdr//"HDR"
                font.pixelSize: idRadioENGModeMain.delegatefontSize//30
                color: colorInfo.brightGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: idDataName1.width + 20//10*4
                visible: idDataName1.text.substring(0,6) == "button" ? false : true

            }
            //**************************************** ENG Data Name 1 Text
            Text{
                id:idDataName1
                //x:idDataValue1.width + idDataValue1.x + 5
                text: dataName1
                font.family: systemInfo.hdr//"HDR"
                font.pixelSize:  idRadioENGModeMain.delegatefontSize//30
                color: colorInfo.dimmedGrey
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                visible: idDataName1.text.substring(0,6) == "button" ? false : true

            }
            //*************************************
            Rectangle{
                width: parent.width
                height: parent.height
                color: "green"
                visible: idDataValue.text == "green" ? true : false
            }
            //*************************************
            Item {
                id:btn1Container
                property int btnCreatedNum : 0
                property int txtCreatedNum : 0
                Component{
                    id:btn1Component
                    MComp.MButton{
                        id: idButton                        
                        x: 5 ; y: 4
                        width:idBorderDataValue.width -10 ; height:idBorderDataValue.height - 10
                        buttonName:firstText
                        firstText:"" //idDataName.text == "Next Page" ? ">>" : idDataName.text == "Pre Page" ? "<<" : ""
                        firstTextStyle: systemInfo.hdb
                        firstTextAlies: "Center"
                        firstTextSize: idRadioENGModeMain.delegatefontSize

                        firstTextX: 0; firstTextY: idButton.y +20
                        firstTextWidth: idButton.width//149

                        firstTextColor: colorInfo.subTextGrey
                        firstTextPressColor: colorInfo.subTextGrey
                        firstTextFocusPressColor: colorInfo.brightGrey
                        firstTextSelectedColor: colorInfo.subTextGrey

                        bgImage: imageInfo.imgFolderGeneral+"btn_title_sub_n.png"
                        bgImageActive: imageInfo.imgFolderGeneral+"btn_title_sub_fp.png"
                        bgImagePress: imageInfo.imgFolderGeneral+"btn_title_sub_p.png"
                        bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_title_sub_fp.png"
                        bgImageFocus: imageInfo.imgFolderGeneral+"btn_title_sub_f.png"

                        active: seletedEngButton == buttonName
                        visible: false
                        property int num ;
                        onClickOrKeySelected: {
                            idRadioENGModeList.currentIndex = index;
                            idBorderDataValue.buttonClicked(idDataName.text , firstText);
                            forceActiveFocus();
                        }
                    } // End Button
                }

                Component{
                    id:txtBox1Component
                    Item {
                        id: name
                        property string text: idTextInput.text
                        property int num ;
                        BorderImage{
                            id:idBorder
                            //anchors.fill: parent
                            x: parent.x + 5 ; y:parent.y + 4
                            width: parent.width ; height: parent.height
                            source: imageInfo.imgFolderGeneral+"bg_ch_list_fp.png"
                        }
                        TextInput{
                            id: idTextInput
                            //anchors.fill: parent
                            x: idBorder.x + 5 ; y:idBorder.y + 10
                            width: parent.width -10 ; height: parent.height
                            font.family: systemInfo.hdb
                            font.pixelSize: idRadioENGModeMain.delegatefontSize
                            color: "white"
                        }// End TextInput
                    } //End Item
                }
            }

            function createTextInput(){
                var str = idDataName1.text.substring(15,16); //idDataName1.text == "button"
                mTextInputFullNum = parseInt(str,10);
                var sWidth = (idBorderDataValue.width  - ((idBorderDataValue.width / mTextInputFullNum)/4)) - 10

                mTextInputX = 0;
                mTextInputY = 0;

                for (var i = 0; i < mTextInputFullNum ; ++i) {
                    console.log("::::::::::::::::::createTextInput:::::::::::::::::",sWidth);
                    var txt1Com                 = txtBox1Component.createObject(btn1Container);
                    txt1Com.x                   = mTextInputX
                    txt1Com.y                   = mTextInputY
                    txt1Com.width               = sWidth
                    txt1Com.height              = idBorderDataValue.height - 10
                    txt1Com.visible             = true
                    txt1Com.num                 = btn1Container.txtCreatedNum = i + 1
                    mTextInputX                 += txt1Com.width +5;
                }
            }
            function createButton() {
                var str     = idDataName1.text.substring(6,7); //idDataName1.text == "button"
                var sWidth  = 0 ;

                mBtnFullNum = parseInt(str,10);
                mButtonY      = 5
                if(btn1Container.txtCreatedNum == 0){
                    if(mBtnFullNum > 1)
                        mButtonX      = 10
                    else
                        mButtonX      = 5

                    sWidth = idBorderDataValue.width
                }
                else{
                    sWidth      = idBorderDataValue.width / 4
                    mButtonX    = (idBorderDataValue.width  - ((idBorderDataValue.width / mTextInputFullNum)/4))
                }

                for (var i = 0; i < mBtnFullNum ; ++i) {
                    console.log("::::::::::::::::::createButton:::::::::::::::::",mBtnFullNum);
                    var btn1Com                 = btn1Component.createObject(btn1Container);
                    btn1Com.x                   = mButtonX
                    btn1Com.y                   = mButtonY
                    btn1Com.width               = sWidth / mBtnFullNum - 10 //idBorderDataValue.width / mBtnFullNum - 10
                    btn1Com.height              = idBorderDataValue.height - 10
                    btn1Com.firstTextX          = 0
                    btn1Com.firstTextY          = btn1Com.y + 20
                    btn1Com.visible             = true
                    btn1Com.num                 = btn1Container.btnCreatedNum = i + 1
                    btn1Com.firstText           = idDataName.text != "" ? returnButtonName(idDataName.text,btn1Container.btnCreatedNum) : idDataName1.text != "" ? returnButtonName(idDataName1.text,btn1Container.btnCreatedNum) : ""
                    btn1Com.firstTextSize       = mBtnFullNum > 1 ? idRadioENGModeMain.delegatefontSize - 8 : idRadioENGModeMain.delegatefontSize
                    mButtonX                    += btn1Com.width +5;
                }
            }

            function buttonClicked(str , str1){
                console.log("::::::::::::::::::function buttonClicked::::::::::::::::::::",str,str1);

                switch(str){
                case "Next Page" :{
                    if(str1 == ">>"){
                        var cnt = QmlController.getEngModePage();
                        QmlController.setEngModePage(++cnt);
                        //console.log(">>",QmlController.getEngModePage(),QmlController.engModePage)
                        //QmlController.setEngModeDisPlayOnOff(true);
                    }
                    break;
                }
                case "Pre Page" :{
                    if(str1 == "<<"){ // if(idDataValue.text == "<<"){
                        var cnt = QmlController.getEngModePage();
                        QmlController.setEngModePage(--cnt);
                        //console.log("<<",QmlController.getEngModePage(),QmlController.engModePage)
                        //QmlController.setEngModeDisPlayOnOff(true);
                    }
                    break;
                }
                case "ANT MODE" :{
                    switch(str1){
                    case "Dual" : antMode = 0 ; seletedEngButton = "Dual" ; QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    case "Main" : antMode = 1 ; seletedEngButton = "Main" ; QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    case "Sub"  : antMode = 2 ; seletedEngButton = "Sub" ; QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    }
                    break;
                }
                //KSW 140515
                case "DSP WTD" : {
                    switch(str1){
                    case "Enable" : dspWtd = 1 ; seletedEngButton = "Enable" ; QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    case "Disable" : dspWtd = 0 ; seletedEngButton = "Disable" ; QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    }
                    break;
                }
                case "AF MODE" :{ //HWS 130104
                    switch(str1){
                    case "ON"  : af = 1 ; seletedEngButton = "ON" ; QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    case "OFF" : af = 0 ; seletedEngButton = "OFF" ; QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    }
                    break;
                }

                case "ST-LIST" :{
                    switch(str1){
                    case "ON"  : st = 1 ; seletedEngButton = "ON" ;  QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    case "OFF" : st = 0 ; seletedEngButton = "OFF" ;  QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    }
                    break;
                }
                case "BG SCAN" :{
                    switch(str1){
                    case "ON"  : bg = 1 ; seletedEngButton = "ON" ;  QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    case "OFF" : bg = 0 ; seletedEngButton = "OFF" ;  QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    }
                    break;
                }
                case "TMC SCAN" :{
                    switch(str1){
                    case "ON"  : tmc = 1 ; seletedEngButton = "ON" ;  QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    case "OFF" : tmc = 0 ; seletedEngButton = "OFF" ;  QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd); break;
                    }
                    break;
                }
                case "Tune to Multicast" :{
                    switch(str1){
                    case "MPS"  : QmlController.engHDRSend(3,0); seletedEngButton="MPS"; break;
                    case "SPS1" : QmlController.engHDRSend(3,1); seletedEngButton="SPS1";break;
                    case "SPS2" : QmlController.engHDRSend(3,2); seletedEngButton="SPS2";break;
                    case "SPS3" : QmlController.engHDRSend(3,3); seletedEngButton="SPS3";break;
                    case "SPS4" : QmlController.engHDRSend(3,4); seletedEngButton="SPS4";break;
                    case "SPS5" : QmlController.engHDRSend(3,5); seletedEngButton="SPS5";break;
                    case "SPS6" : QmlController.engHDRSend(3,6); seletedEngButton="SPS6";break;
                    case "SPS7" : QmlController.engHDRSend(3,7); seletedEngButton="SPS7";break;
                    }
                    break;
                }
                case "Switch" : {
                    switch(str1){                                           //engHDRSend(qint8 mode,QByteArray data)
                    case "Force Analog" : QmlController.engHDRSend(4,0); seletedEngButton="Force Analog"; break;
                    case "Force Digital": QmlController.engHDRSend(4,1); seletedEngButton="Force Digital";break;
                    case "Automatic"    : QmlController.engHDRSend(4,2); seletedEngButton="Automatic" ;break;
                    }
                    break;
                }
                case  "Branch Vol"  : if(str1 == "Send")  QmlController.engHDRSend(0,btn1Container.children[0].text); console.log("::::::::::SEND::::::",btn1Container.children[0].text);break;
                case  "FDAC"        : if(str1 == "Send") QmlController.engHDRSend(1,btn1Container.children[0].text); console.log("::::::::::SEND::::::",btn1Container.children[0].text);break;
                case  "RDAC"        : if(str1 == "Send") QmlController.engHDRSend(2,btn1Container.children[0].text); console.log("::::::::::SEND::::::",btn1Container.children[0].text);break;
                case "PSD Info"     : if(str1 == "GET PSD") QmlController.engHDRSend(6,0); break;
                case "SIS/Cmd"      : if(str1 == "GET SIS") QmlController.engHDRSend(7,0); break;
                case "Alignment Init": if(str1 == "initialization") QmlController.tuneAlignmentCmd(0xF0);break;//QmlController.engModeANTSetting(antMode,st,bg,af,tmc,1); break;
                case "AF Clear"     : if(str1 == "clear") QmlController.engAFCounterClear(); break; //HWS
                case  "Split Mode"  : {
                    switch(str1){
                    case "ON"  : split = 1; seletedEngButton = "ON" ;  QmlController.engHDRSend(5,split);break;
                    case "OFF" : split = 0; seletedEngButton = "OFF" ; QmlController.engHDRSend(5,split);break;
                    }
                    break;
                }
                case "Status Tab" : {
                    QmlController.setEngModePage(0);
              //      QmlController.setEngModeDisPlayOnOff(true); // JSH_ENG_TEST hws
                    break;
                }
                case "SIS/Cmd Tab" :{
                    QmlController.setEngModePage(1);
        //            QmlController.setEngModeDisPlayOnOff(true); // JSH_ENG_TEST hws
                    break;
                }
                case "BER" : {
                    switch(str1){
                    case "ON"  :  seletedEngButton = "ON" ;  QmlController.engHDRSend(8,1); break;
                    case "OFF" :  seletedEngButton = "OFF" ; QmlController.engHDRSend(8,0); break;
                    case "Reset" : QmlController.engHDRSend(8,2); break; //HWS
                    }
                    break;
                }
                case "Module Update": { // HD Radio Module Update Test // 120924
                    switch(str1){
                    case "Version"  : QmlController.sendModuleUpdate(0);  break;
                    case "Ready"    : QmlController.sendModuleUpdate(1);  break;
                    case "Reset"    : QmlController.sendModuleUpdate(2);  break;
                    case "TransData": QmlController.sendModuleUpdate(3);  break;
                    case "Status"    : QmlController.sendModuleUpdate(4);  break;
                    }
                    break;
                }
                case "AE Clear":{ //HWS
                    switch(str1){
                    case "All clear" :
                        QmlController.QmlPsdImageDelete(2);
                        QmlController.QmlPsdImageDelete(3);
                        break;
                    }
                    break;
                }
                case  "AF Log"  : { // JSH 130508 added
                    switch(str1){
                    case "ON"  : aflog = 1; seletedEngButton = "ON" ;  QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd);break;
                    case "OFF" : aflog = 0; seletedEngButton = "OFF" ; QmlController.engModeANTSetting(antMode,st,bg,af,tmc,erase,aflog,dspWtd);break;
                    }
                    break;
                }
                case "Token Copy":{ // wonseok
                    switch(str1){
                    case "send USB" :
                        QmlController.copyLogFileToUSB();
                        break;
                    }
                    break;

                }
                }
            }

            function returnButtonName(firstButtonName , buttonNumber){
                var name = "";
                //if(firstButtonName == "ANT MODE"){
                if(firstButtonName.search("ANT MODE") > (-1)){
//                    if(firstButtonName.length != 8){
//                        switch(parseInt(firstButtonName.substring(8,9),10)){
//                        case 1 : name = "Dual" ; break;
//                        case 2 : name = "Main" ; break;
//                        case 3 : name = "Sub"  ; break;
//                        }
//                    }
//                    else{
                        switch(buttonNumber){
                        case 1 : name = "Dual" ; if(antMode==0) seletedEngButton=name ; break;
                        case 2 : name = "Main" ; if(antMode==1) seletedEngButton=name ; break;
                        case 3 : name = "Sub"  ; if(antMode==2) seletedEngButton=name ; break;
                        }
//                    }
//                    idDataName.text= "ANT MODE";
                }
                else if(firstButtonName == "Next Page" || firstButtonName == "Pre Page"){
                    switch(firstButtonName){
                    case "Next Page" : name = ">>" ; break;
                    case "Pre Page"  : name = "<<" ; break;
                    }
                }
                //else if(firstButtonName.search("Tune to Multicast") > (-1)){
                //    switch(parseInt(firstButtonName.substring(17,18),10)+buttonNumber){
                else if(firstButtonName == "Tune to Multicast"){
                    switch(buttonNumber){
                    case 1 : name = "MPS"   ; break;
                    case 2 : name = "SPS1"  ; break;
                    case 3 : name = "SPS2"  ; break;
                    case 4 : name = "SPS3"  ; break;
                    case 5 : name = "SPS4"  ; break;
                    case 6 : name = "SPS5"  ; break;
                    case 7 : name = "SPS6"  ; break;
                    case 8 : name = "SPS7"  ; break;
                    }
                    //idDataName.text= "Tune to Multicast";
                }
                //else if(firstButtonName.search("Switch") > (-1)){
                //    switch(parseInt(firstButtonName.substring(6,7),10)){
                else if(firstButtonName == "Switch"){
                    switch(buttonNumber){
                    case 1 : name = "Force Analog"  ; break;
                    case 2 : name = "Force Digital" ; break;
                    case 3 : name = "Automatic"     ; break;
                    }
                    //idDataName.text= "Switch";
                }
                else if(firstButtonName == "PSD Info"){
                    name = "GET PSD"
                }
                else if(firstButtonName == "SIS/Cmd"){//"SIS Info"){
                    name = "GET SIS"
                }
                else if(firstButtonName == "Branch Vol" || firstButtonName == "FDAC" || firstButtonName == "RDAC"){
                    name = "Send";
                }
                else if(firstButtonName == "Alignment Init"){
                    name = "initialization"
                }
                else if(firstButtonName == "AF Clear"){
                    name = "clear"
                }
                else if(firstButtonName.search("SIS/Cmd Tab") > (-1) || firstButtonName.search("Status Tab") > (-1)){
                    name = "GO" ;
                }
                else if(firstButtonName == "BER"){
                    switch(buttonNumber){
                    case 1 : name = "ON"  ; break;
                    case 2 : name = "OFF" ; break;
                    case 3 : name = "Reset"; break; //HWS
                    }
                }
                else if(firstButtonName == "Module Update"){ // HD Radio Module Update Test // 120924
                    switch(buttonNumber){
                    case 1 : name = "Version"   ; break;
                    case 2 : name = "Ready"     ; break;
                    case 3 : name = "Reset"     ; break;
                    case 4 : name = "TransData" ; break;
                    case 5 : name = "Status" ; break;
                    }
                }
                else if(firstButtonName == "AE Clear"){ // HWS
                    switch(buttonNumber){
                    case 1: name = "All clear" ; break;
                    }
                }
                else if(firstButtonName == "Token Copy"){
                    switch(buttonNumber){
                    case 1: name = "send USB" ; break;
                    }
                }
                //KSW 140515
                else if(firstButtonName == "DSP WTD"){
                    switch(buttonNumber){
                    case 1 : name = "Enable"; break;
                    case 2 : name = "Disable"; break;
                    }
                }
                else{
                    switch(buttonNumber){ //HWS 130104
                    case 1 :{
                        name = "ON" ;
                        if((firstButtonName == "AF MODE" &&(af == 1))||(firstButtonName=="ST-LIST"&&(st==1))||(firstButtonName=="BG SCAN"&&(bg==1))||(firstButtonName=="TMC SCAN"&&(tmc==1))||(firstButtonName=="Split Mode"&&split==1) || (firstButtonName == "AF Log" && aflog==1))
                            seletedEngButton=name
                        break;
                    }
                    case 2 :
                        name = "OFF" ;
                        if((firstButtonName == "AF MODE" &&(af == 0))||(firstButtonName=="ST-LIST"&&(st==0))||(firstButtonName=="BG SCAN"&&(bg==0))||(firstButtonName=="TMC SCAN"&&(tmc==0))||(firstButtonName=="Split Mode"&&split==0) || (firstButtonName == "AF Log" && aflog==0))
                            seletedEngButton=name
                        break;
                    }
                }
                return name;
            }

            Component.onCompleted: {
                //console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Component.onCompleted",idDataName1.text.substring(0,6) , idDataName1.text.substring(8,15));
                if(idDataName1.text.substring(8,15) == "textBox")
                    createTextInput();
                if(idDataName1.text.substring(0,6) == "button")
                    createButton()
            }
            Component.onDestruction:{
                //botton1_textBox1
                var cnt = btn1Container.txtCreatedNum + btn1Container.btnCreatedNum
                if(idDataName1.text.substring(0,6) == "button"){
                    for (var i = 0; i < cnt; ++i) {
                        console.log("::::::::::::::::::::::::::onDestruction__botton_textBox:::::::::::::::::::::::::",cnt,i);
                        btn1Container.children[i].destroy();
                    }
                }
            }
        }
    }

    Keys.onReleased:{
        if(Qt.Key_Up == event.key){
            idENGModeBand.focus = true;
            idENGModeBand.forceActiveFocus();
            event.accepted = true;
        }
    }
    Keys.onPressed:{
        if((Qt.Key_Down == event.key) || (Qt.Key_Up == event.key) || (Qt.Key_Right == event.key) || (Qt.Key_Left == event.key)){
            event.accepted  = true;
        }
        else if(idAppMain.isWheelLeft(event)){
            if(btn1Container.btnCreatedNum){
                for(var i=btn1Container.btnCreatedNum-1 ; i != 0 ; i--){
                    if(btn1Container.children[i].activeFocus){
                        if(i > 0){
                            btn1Container.children[i-1].focus = true;
                            btn1Container.children[i-1].forceActiveFocus();
                            return;
                        }
                    }
                }
            }
            if( delegate.GridView.view.currentIndex ){
                var backupIndex = delegate.GridView.view.currentIndex;
                for(var i=delegate.GridView.view.currentIndex; i != 0; i--){
                    delegate.GridView.view.moveCurrentIndexLeft();
                    if(delegate.GridView.view.currentItem.children[3].children[1].children[4].btnCreatedNum){
                        delegate.GridView.view.currentItem.children[3].children[1].children[4].children[delegate.GridView.view.currentItem.children[3].children[1].children[4].btnCreatedNum-1].focus = true;
                        delegate.GridView.view.currentItem.children[3].children[1].children[4].children[delegate.GridView.view.currentItem.children[3].children[1].children[4].btnCreatedNum-1].forceActiveFocus();
                        return;
                    }
                }
                delegate.GridView.view.currentIndex = backupIndex
                delegate.GridView.view.currentItem.children[3].children[1].children[4].children[0].focus = true;
                delegate.GridView.view.currentItem.children[3].children[1].children[4].children[0].forceActiveFocus();
            }
        }
        else if(idAppMain.isWheelRight(event)){
            if(btn1Container.btnCreatedNum){
                for(var i=0 ; btn1Container.btnCreatedNum > i ; i++){
                    if(btn1Container.children[i].activeFocus){
                        if(i+1 < btn1Container.btnCreatedNum){
                            btn1Container.children[i+1].focus = true;
                            btn1Container.children[i+1].forceActiveFocus();
                            return;
                        }else
                            break;
                    }
                }
            }
            if( delegate.GridView.view.count -1 != delegate.GridView.view.currentIndex){
                var backupIndex = delegate.GridView.view.currentIndex;
                for(var i=delegate.GridView.view.currentIndex; i < delegate.GridView.view.count; i++){
                    delegate.GridView.view.moveCurrentIndexRight();
                    if(delegate.GridView.view.currentItem.children[3].children[1].children[4].btnCreatedNum){
                        delegate.GridView.view.currentItem.children[3].children[1].children[4].children[0].focus = true;
                        delegate.GridView.view.currentItem.children[3].children[1].children[4].children[0].forceActiveFocus();
                        return;
                    }
                }
                delegate.GridView.view.currentIndex = backupIndex
                delegate.GridView.view.currentItem.children[3].children[1].children[4].children[delegate.GridView.view.currentItem.children[3].children[1].children[4].btnCreatedNum-1].focus = true;
                delegate.GridView.view.currentItem.children[3].children[1].children[4].children[delegate.GridView.view.currentItem.children[3].children[1].children[4].btnCreatedNum-1].forceActiveFocus();
            }
        } // END Wheel Right
    }
}

import Qt 4.7
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp
//import "../../../Dmb" as MDmb

//MComp.MComponent {
FocusScope {
    id:idRadioENGModeListView
    width: parent.width
    height: parent.height
    focus: true
    property string imgFolderPopup : imageInfo.imgFolderPopup
    GridView{
        id: idRadioENGModeList
        clip: visible ?true :false
        cellWidth: idRadioENGModeMain.delegateCellWidth
        cellHeight: idRadioENGModeMain.delegateCellHeight
        anchors.fill: parent;
        model: ENGModeModel{id:idengModel}
        delegate: ENGModeDelegate{}
        focus: true
    }

    /*********************Vertical scrollbar***********************/
    MComp.MScroll {
        //x: 1057-37; y: 122-120; z:1
        scrollArea: idRadioENGModeList;
        height: idRadioENGModeList.height; width: 13
        visible: false
        selectedScrollImage: imgFolderPopup+"scroll_preset_bg.png"
        anchors.right: idRadioENGModeList.right
    } // End MOptionScroll
    Connections{
        target: QmlController
        onEngData: {
            // index , msg
            // signal rev connect

                var sMsg   = msg;
                var sMsg1  = msg1;
                var sIndex = index;

                if(sMsg == 0 && sIndex == 0){                          // Radio
                    //if(engineerModeSelected == sMsg || sIndex != 0)
                    //    return;
                    if(idRadioENGModeMain.currentPage == QmlController.getEngModePage() && (engineerModeSelected == sMsg))
                        return

                    //dg.jin 140414
                    if(false == idRadioENGModeMain.engInfoRequest) {
                        return;
                    }
                    
                    if((1 == idRadioENGModeMain.modeType) && (true == dealer)) {
                        idRadioENGModeMain.tuneAlignmentViewInit();
                    }

                    idengModel.clear();
                    idRadioENGModeMain.delegateCellWidth    = idRadioENGModeListView.width/2
                    idRadioENGModeMain.delegateCellHeight   = 67//72
                    idRadioENGModeMain.delegatefontSize     = 30
                    idRadioENGModeMain.delegateWidth        = 0
                    idRadioENGModeMain.currentPage          = QmlController.getEngModePage()
                    idRadioENGModeMain.dealerMode           = dealer // JSH 131101

                    //KSW 140220
                    if(idRadioENGModeMain.currentPage == 0){ // 1 page
                        //idengModel.append({"dataName":"MODE","dataValue":0 ,"dataValue1":"","dataName1":""});
                        //idengModel.append({"dataName":"Tuner Alignment","dataValue":0 ,"dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"FM","dataValue":0,"dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AM","dataValue":0,"dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"FS","dataValue":0,"dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"USN","dataValue":0,"dataValue1":"","dataName1":""}); //KSW 140515 AC Distortion -> USN
                        idengModel.append({"dataName":"BW","dataValue":0,"dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"MP","dataValue":0,"dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"ST (%)","dataValue":0,"dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Tuner Alignment","dataValue":0,"dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"PD Mode","dataValue":0,"dataValue1":"","dataName1":""});

                        if(idRadioENGModeMain.dealerMode == false){ // JSH 131101
                            idengModel.append({"dataName":"ANT MODE","dataValue":"" , "dataValue1":"","dataName1" : "button3" });
                            idengModel.append({"dataName":"Next Page","dataValue":">>","dataValue1":"","dataName1":"button1"});
                            idengModel.append({"dataName":"DSP WTD","dataValue":"" , "dataValue1":"","dataName1" : "button2" }); //KSW 140515 add DSP WTD
//                            idengModel.append({"dataName":"Alignment Init","dataValue":"" , "dataValue1":"","dataName1" : "button1" }); //KSW 140515 move to 2page
                        }
                        engineerModeSelected = sMsg;

                        if(idRadioENGModeMain.dealerMode == false){ // JSH 131101
                            for(var i=0; i < idRadioENGModeList.count; i++){
                                idRadioENGModeList.moveCurrentIndexRight();
                                if(idRadioENGModeList.currentItem.children[3].children[1].children[4].btnCreatedNum){
                                    if(!idRadioENGModeMain.visible)
                                        return;
                                    idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].focus = true;
                                    idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].forceActiveFocus();
                                    break;
                                }
                            }
                        }
                    }
                    else{ // 2 page
                        idengModel.append({"dataName":"Tuner 2 FM Level"        ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Tuner 1 FM RBS Level"    ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"FM Offset 1"             ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"FM Offset 0"             ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AM Offset 1"             ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AM Offset 0"             ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"FM Channel Separation"   ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Tuner 2 AM Level"        ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Tuner 1 FM IF Filter"    ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Tuner 1 AM IF Filter"    ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Tuner 2 FM IF Filter"    ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Tuner 2 AM IF Filter"    ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Pre Page","dataValue":"<<","dataValue1":"","dataName1" : "button1" });
                        idengModel.append({"dataName":"Alignment Init","dataValue":"" , "dataValue1":"","dataName1" : "button1" }); //KSW 140515 move to 2page
                        //engineerModeSelected = sMsg;
                        for(var i=0; i < idRadioENGModeList.count; i++){
                            idRadioENGModeList.moveCurrentIndexRight();
                            if(idRadioENGModeList.currentItem.children[3].children[1].children[4].btnCreatedNum){
                                if(!idRadioENGModeMain.visible)
                                    return;
                                idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].focus = true;
                                idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].forceActiveFocus();
                                break;
                            }
                        }
                        return;
                    }
                    //currentPage = -1;
                }
                else if(sMsg == 1 && sIndex == 0){                     // RDS (1 == rds info page , 11 == rds Tmc page)
                    if(idRadioENGModeMain.currentPage == QmlController.getEngModePage()  && (engineerModeSelected == sMsg))
                        return

                    idengModel.clear();
                    idRadioENGModeMain.delegateCellWidth    = idRadioENGModeListView.width/4
                    idRadioENGModeMain.delegateCellHeight   = 60//67
                    idRadioENGModeMain.delegatefontSize     = 27
                    idRadioENGModeMain.currentPage          = QmlController.getEngModePage()
                    idRadioENGModeMain.delegateWidth        = 0
                    if(idRadioENGModeMain.currentPage == 0){ // 1 page
                        //console.log("==========================>1",idRadioENGModeMain.currentPage,QmlController.getEngModePage(),sMsg ,sIndex)
                        //idengModel.append({"dataName":"MODE","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"FREQ","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"PSN","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"PI Code","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TP/TA","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"PTY","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"RDS Quality","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Q","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"FS(dB)","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"MP(%)","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"USN","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"BW","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"ST Blend(%)","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"EON PI","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"EON TP/TA","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"EON PS","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AF OPT","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"REG OPT","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"NEWS OPT","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TA OPT","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AF ON","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AF1","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AF2","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AF3","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AF4","dataValue":"","dataValue1":"","dataName1":""});
                        //idengModel.append({"dataName":"AF5","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"BG-SCAN","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC-SCAN","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"P-D MODE","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AF_F","dataValue":"","dataValue1":"","dataName1":""}); //HWS 130226
                        idengModel.append({"dataName":"AF_Q","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AF_M","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AF_MS","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AF_USN","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"AF_OFF","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"AF Clear","dataValue":"","dataValue1":"","dataName1" : "button1" });
                        idengModel.append({"dataName":"Next Page","dataValue":">>","dataValue1":"","dataName1":"button1"});

                        for(var i=0; i < idRadioENGModeList.count; i++){
                            idRadioENGModeList.moveCurrentIndexRight();
                            if(idRadioENGModeList.currentItem.children[3].children[1].children[4].btnCreatedNum){
                                if(!idRadioENGModeMain.visible)
                                    return;

                                idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].focus = true;
                                idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].forceActiveFocus();
                                break;
                            }
                        }

                        engineerModeSelected = sMsg;
                    }
                    else{ // 2 page
                        //console.log("==========================>2",idRadioENGModeMain.currentPage,QmlController.getEngModePage(),sMsg ,sIndex)

                        idengModel.append({"dataName":"TMC MODE","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC FREQ","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC PI","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC PTY","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC PSN ","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC Q","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC List Cnt","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC FREQ1","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC FREQ2","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC FREQ3","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC FREQ4","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC FREQ5","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC FREQ6","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC FREQ7","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC FREQ8","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC FREQ9","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC FREQ10","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TMC M/S","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"ANT MODE","dataValue":"" , "dataValue1":"","dataName1" : "button3" });
                        idengModel.append({"dataName":"Alignment Init","dataValue":"" , "dataValue1":"","dataName1" : "button1" });
                        idengModel.append({"dataName":"AF MODE","dataValue":"" , "dataValue1":"","dataName1"  : "button2" });
                        idengModel.append({"dataName":"ST-LIST","dataValue":"" , "dataValue1":"","dataName1"  : "button2" });
                        idengModel.append({"dataName":"BG SCAN","dataValue":"" , "dataValue1":"","dataName1"  : "button2" });
                        idengModel.append({"dataName":"TMC SCAN","dataValue":"" , "dataValue1":"","dataName1" : "button2" });
                        idengModel.append({"dataName":"AF Log","dataValue":"" , "dataValue1":"","dataName1" : "button2" });
                        idengModel.append({"dataName":"Pre Page","dataValue":"<<","dataValue1":"","dataName1" : "button1" });
                        //engineerModeSelected = sMsg;
                        for(var i=0; i < idRadioENGModeList.count; i++){
                            idRadioENGModeList.moveCurrentIndexRight();
                            if(idRadioENGModeList.currentItem.children[3].children[1].children[4].btnCreatedNum){
                                if(!idRadioENGModeMain.visible)
                                    return;
                                idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].focus = true;
                                idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].forceActiveFocus();
                                break;
                            }
                        }
                        return;
                   }
                }
                else if(sMsg == 2 && sIndex == 0){                     // HD Radio

                    if(idRadioENGModeMain.currentPage == QmlController.getEngModePage() && (engineerModeSelected == sMsg))
                        return

                    idengModel.clear();
                    idRadioENGModeMain.currentPage = QmlController.getEngModePage()

                    if(idRadioENGModeMain.currentPage == 0){ // 1 page
                        idRadioENGModeMain.delegateCellWidth    = idRadioENGModeListView.width/4
                        idRadioENGModeMain.delegateCellHeight   = 60//72
                        idRadioENGModeMain.delegatefontSize     = 20//30
                        idRadioENGModeMain.delegateWidth        = 0

                        idengModel.append({"dataName":"Split Mode","dataValue":"","dataValue1":"","dataName1":"button2"}); //wonseok
                        idengModel.append({"dataName":"AE Clear","dataValue":"","dataValue1":"","dataName1":"button1"}); //HWS
                        idengModel.append({"dataName":"Switch","dataValue":"","dataValue1":"","dataName1":"button3"});
                        idengModel.append({"dataName":"Token Copy","dataValue":"","dataValue1":"","dataName1":"button1"});


                        //idengModel.append({"dataName":"MODE","dataValue":"","dataValue1":"","dataName1":""});
//                        idengModel.append({"dataName":"Status","dataValue":"","dataValue1":"","dataName1":""});
//                        idengModel.append({"dataName":"Status Tab","dataValue":"","dataValue1":"","dataName1":"button1"});  // button Name [GO]
//                        idengModel.append({"dataName":"SIS/Cmd Tab","dataValue":"","dataValue1":"","dataName1":"button1"}); // button Name [GO]
//                        idengModel.append({"dataName":"BER","dataValue":"","dataValue1":"","dataName1":"button3"});         // button Name [ON/OFF] [Reset] HWS


                        idengModel.append({"dataName":"Acquisition Status","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"SIS CRC Status","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Digital Audio Acquired","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"BER","dataValue":"","dataValue1":"","dataName1":"button3"});         // button Name [ON/OFF] [Reset] HWS

                       // idengModel.append({"dataName":"Band","dataValue":"","dataValue1":"","dataName1":""});               // [FM/AM]

                        idengModel.append({"dataName":"Service Mode","dataValue":"","dataValue1":"","dataName1":""}); // [MP1~MP6 / MP11 MA1 MA3]
                        idengModel.append({"dataName":"Codec Mode","dataValue":"","dataValue1":"","dataName1":""});   // [hex value]
                        idengModel.append({"dataName":"Blend Count","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Band","dataValue":"","dataValue1":"","dataName1":""});               // [FM/AM]

                       // idengModel.append({"dataName":"Audio Acquisition Time","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"SIS Frame Acquisition Time","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Core Frame Errors","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Frame Count","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Audio Acquisition Time","dataValue":"","dataValue1":"","dataName1":""});

                        //idengModel.append({"dataName":"","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"DAAI","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TX_Blend Enabled","dataValue":"","dataValue1":"","dataName1":""}); // [hex value]
                        idengModel.append({"dataName":"PIDS Bit Tested","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"PIDS - Blks Tested","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"QI","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TX Blend Control","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"PIDS Bit Error","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"PIDS Blks Error","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"Cd/No","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"TX Digital Gain","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"BER","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"PLER","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"P1 - Bit tested","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"P2 - Bit tested","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"P3 - Bit tested","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"P4 - Bit tested","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"P1 - Bit Errors","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"P2 - Bit Errors","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"P3 - Bit Errors","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"P4 - Bit Errors","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"P1 - BER","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"P2 - BER","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"P3 - BER","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"P4 - BER","dataValue":"","dataValue1":"","dataName1":""});

                        for(var i=0; i < idRadioENGModeList.count; i++){
                            idRadioENGModeList.moveCurrentIndexRight();
                            if(idRadioENGModeList.currentItem.children[3].children[1].children[4].btnCreatedNum){
                                if(!idRadioENGModeMain.visible)
                                    return;
                                idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].focus = true;
                                idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].forceActiveFocus();
                                break;
                            }
                        }

                        engineerModeSelected = sMsg;
                    }
                    else if(idRadioENGModeMain.currentPage == 1){ // 2 page
                        idRadioENGModeMain.delegateCellWidth    = idRadioENGModeListView.width/3
                        idRadioENGModeMain.delegateCellHeight   = 60//72
                        idRadioENGModeMain.delegatefontSize     = 19//30
                        idRadioENGModeMain.delegateWidth        = idRadioENGModeMain.delegateCellWidth /5

                        //idengModel.append({"dataName":"MODE","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"SIS/Cmd","dataValue":"","dataValue1":"","dataName1":"button1"});           // button Name [GET]
                        idengModel.append({"dataName":"Status Tab","dataValue":"","dataValue1":"","dataName1":"button1"});  // button Name [GO]
                        idengModel.append({"dataName":"SIS/Cmd Tab","dataValue":"","dataValue1":"","dataName1":"button1"}); // button Name [GO]
                        //idengModel.append({"dataName":"SIS","dataValue":"","dataValue1":"","dataName1":"button1"});         // button Name [GET]

                        idengModel.append({"dataName":"Service ID"  ,"dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Session Type","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Num of Type" ,"dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"SIS Blk Count","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"ALFN","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"ALFN Status","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"Time Lock Status","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Country Code","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"FCC facility ID","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"Call Letter","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Lattitude","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Longitude","dataValue":"","dataValue1":"","dataName1":""});

                        idengModel.append({"dataName":"Branch Vol","dataValue":"","dataValue1":"","dataName1":"button1_textBox1"}); //[Hex Value]
                        idengModel.append({"dataName":"Tune to Multicast","dataValue":"","dataValue1":"","dataName1":"button8"});
                        idengModel.append({"dataName":"Switch","dataValue":"","dataValue1":"","dataName1":"button3"});

                        idengModel.append({"dataName":"ANT MODE","dataValue":"","dataValue1":"","dataName1":"button3"});
                        idengModel.append({"dataName":"Split Mode","dataValue":"","dataValue1":"","dataName1":"button2"});

                        // HD Radio Module Update Test // 120924
                        idengModel.append({"dataName":"Module Update","dataValue":"","dataValue1":"","dataName1":"button5"});

                        idengModel.append({"dataName":"AE Clear","dataValue":"","dataValue1":"","dataName1":"button1"}); //HWS
                        idengModel.append({"dataName":"","dataValue":"","dataValue1":"","dataName1":""});
                        idengModel.append({"dataName":"Module Status","dataValue":"","dataValue1":"","dataName1":""});

                        for(var i=0; i < idRadioENGModeList.count; i++){
                            idRadioENGModeList.moveCurrentIndexRight();
                            if(idRadioENGModeList.currentItem.children[3].children[1].children[4].btnCreatedNum){
                                if(!idRadioENGModeMain.visible)
                                    return;
                                idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].focus = true;
                                idRadioENGModeList.currentItem.children[3].children[1].children[4].children[0].forceActiveFocus();
                                break;
                            }
                        }

                    }
                    return;
                }
                // sMsg == 3             // Atenna Connect
                else if(sMsg == 4 && sIndex == 0){      // Tune Alignment , JSH 120217
                    if(engineerModeSelected == sMsg || sIndex != 0)
                        return;

                    idengModel.clear();
                    idRadioENGModeMain.delegateCellWidth    = idRadioENGModeListView.width/2
                    idRadioENGModeMain.delegateCellHeight   = 72
                    idRadioENGModeMain.delegatefontSize     = 30
                    idRadioENGModeMain.delegateWidth        = 0
                    //idengModel.append({"dataName":"MODE","dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"FM Main IFCF","dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"FM Sub IFCF" ,"dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"AM Main IFCF","dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"FM Freq Offset FMIX_1","dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"FM Freq Offset FMIX_0","dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"FM Level Alignment"   ,"dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"RBS Level Alignment"  ,"dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"AM Freq Offset FMIX_1","dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"AM Freq Offset FMIX_0","dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"AM Level Alignment"   ,"dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"FM Channel Separation","dataValue":"","dataValue1":"","dataName1":""});
                    idengModel.append({"dataName":"Offset Error","dataValue":"","dataValue1":"","dataName1":""});
                    prevEngineerModeSelected = engineerModeSelected;
                    engineerModeSelected = sMsg;

                    currentPage = -1;
                }
             // RDS , HD Radio PTY Table
             if(engineerModeSelected == 1 && ( idRadioENGModeMain.currentPage == 0 && sIndex == 5)){
                     //|| engineerModeSelected == 2 &&(idRadioENGModeMain.currentPage == 1 && sIndex == 4)){
                 var cnt =0;
                 var ptyTable = new Array();
                 ptyTable[cnt++] = "None";
                 ptyTable[cnt++] = "News";
                 ptyTable[cnt++] = "Affairs";
                 ptyTable[cnt++] = "Info";
                 ptyTable[cnt++] = "Sport";
                 ptyTable[cnt++] = "Educate";
                 ptyTable[cnt++] = "Drama";
                 ptyTable[cnt++] = "Culture";
                 ptyTable[cnt++] = "Science";
                 ptyTable[cnt++] = "Varied";
                 ptyTable[cnt++] = "Pop M";
                 ptyTable[cnt++] = "Rock M";
                 ptyTable[cnt++] = "Easy M";
                 ptyTable[cnt++] = "Light M";
                 ptyTable[cnt++] = "Calssics";
                 ptyTable[cnt++] = "Other M";
                 ptyTable[cnt++] = "Weather";
                 ptyTable[cnt++] = "Finance";
                 ptyTable[cnt++] = "Children";
                 ptyTable[cnt++] = "Social";
                 ptyTable[cnt++] = "Religion";
                 ptyTable[cnt++] = "Phone In";
                 ptyTable[cnt++] = "Travel";
                 ptyTable[cnt++] = "Leisure";
                 ptyTable[cnt++] = "Jazz";
                 ptyTable[cnt++] = "Country";
                 ptyTable[cnt++] = "Nation M";
                 ptyTable[cnt++] = "Oldies";
                 ptyTable[cnt++] = "Folk M";
                 ptyTable[cnt++] = "Document";
                 ptyTable[cnt++] = "TEST";
                 ptyTable[cnt++] = "Alarm";

                  if(sIndex !=0)
                      idengModel.setProperty(sIndex-1,"dataValue",ptyTable[sMsg]);

                 delete ptyTable;
            }
            else{
                 if(index !=0){
                     idengModel.setProperty(index-1,"dataValue",sMsg);
                     idengModel.setProperty(index-1,"dataValue1",sMsg1);
                 }
            }
        }
    }
}

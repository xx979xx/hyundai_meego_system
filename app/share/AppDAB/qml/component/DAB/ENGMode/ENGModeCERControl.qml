import Qt 4.7
import "../../QML/DH" as MComp

MComp.MComponent {
    id:idENGModeCERControl

    width: 350; height: 550

    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderRadio_Dab: imageInfo.imgFolderRadio_Dab

//    Rectangle{
//        anchors.fill : parent
//        color : "red"
//        border.color : "red"
//    }


    MComp.MComponent{
        x: 0; y: 0
        width: 350; height: 550
        focus: true
        Flickable{
            contentX: 0; contentY: 0
            contentWidth: 350
            contentHeight: 1760
            flickableDirection: Flickable.VerticalFlick;
            boundsBehavior: Flickable.StopAtBounds//Flickable.DragAndOvershootBounds //Flickable.StopAtBounds  //
            anchors.fill: parent;
            clip: true
            focus: true

            Image {
                x: 0
                height: 2650
                source: imgFolderRadio_Dab+"bg_divider.png"
            }

            ///////////////////////////////////////////////////////////////////////// DAB-DAB Linking CER Value
            Item{
                x: 50; y: 0
                Text{
                    x: 0; y: 0
                    width: 315; height: 45
                    text: "# DAB-DAB Linking CER"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDB
                }
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB Worst"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mDAB_DABLinkingDABWorstCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABWorstCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABWorstCERValue += 5
                    }
                }
                MComp.MButton{
                    x: 15; y: 30
                    width: 230; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    firstText: "SET"
                    firstTextX: 0
                    firstTextY: 20
                    firstTextWidth: 230
                    firstTextAlies: "Center"
                    firstTextColor: colorInfo.brightGrey
                    firstTextSize: 20
                    firstTextStyle: idAppMain.fonts_HDB

                    onClickOrKeySelected: {
                        DABController.sendServLinkCERValue(mDAB_DABLinkingDABWorstCERValue, mDAB_DABLinkingDABBadCERValue, mDAB_DABLinkingDABNoGoodCERValue, mDAB_DABLinkingDABGoodCERValue, mDAB_DABLinkingDABPlusWorstCERValue, mDAB_DABLinkingDABPlusBadCERValue, mDAB_DABLinkingDABPlusNoGoodCERValue,mDAB_DABLinkingDABPlusGoodCERValue)
                    }
                }
            }
            Item{
                x: 50; y: 80
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB BAD"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mDAB_DABLinkingDABBadCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABBadCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABBadCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 160
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB NoGood"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mDAB_DABLinkingDABNoGoodCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABNoGoodCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABNoGoodCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 240
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB Good"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mDAB_DABLinkingDABGoodCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABGoodCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABGoodCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 320
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB+ Worst"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mDAB_DABLinkingDABPlusWorstCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABPlusWorstCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABPlusWorstCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 400
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB+ BAD"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mDAB_DABLinkingDABPlusBadCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABPlusBadCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABPlusBadCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 480
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB+ NoGood"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mDAB_DABLinkingDABPlusNoGoodCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABPlusNoGoodCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABPlusNoGoodCERValue -= 5
                    }
                }
            }
            Item{
                x: 50; y: 560
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB+ Good"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mDAB_DABLinkingDABPlusGoodCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABPlusGoodCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mDAB_DABLinkingDABPlusGoodCERValue += 5
                    }
                }
            }

            ///////////////////////////////////////////////////////////////////////// Pink noise CER Value
            Item{
                x: 50; y: 720
                Text{
                    x: 0; y: 0
                    width: 315; height: 45
                    text: "# Pink noise CER Value"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDB
                }
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - PINK unMute Status count"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mPinkNoiseUnMuteStatusCount
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseUnMuteStatusCount -= 1
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseUnMuteStatusCount += 1
                    }
                }
                MComp.MButton{
                    x: 15; y: 30
                    width: 230; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    firstText: "SET"
                    firstTextX: 0
                    firstTextY: 20
                    firstTextWidth: 230
                    firstTextAlies: "Center"
                    firstTextColor: colorInfo.brightGrey
                    firstTextSize: 20
                    firstTextStyle: idAppMain.fonts_HDB

                    onClickOrKeySelected: {
//                     DABController.sendPinknoiseCERValue(mPinkNoiseStatusCount, mPinkNoiseDABBadCERValue, mPinkNoiseDABGoodCERValue, mPinkNoiseDABPlusBadCERValue, mPinkNoiseDABPlusGoodCERValue)
                        DABController.sendPinknoiseCERValue(mPinkNoiseUnMuteStatusCount, mPinkNoiseMuteStatusCount, mPinkNoiseDABBadCERValue, mPinkNoiseDABGoodCERValue, mPinkNoiseDABPlusBadCERValue, mPinkNoiseDABPlusGoodCERValue)
                    }
                }
            }

            Item{
                x: 50; y: 800
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - PINK Mute Status count"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mPinkNoiseMuteStatusCount
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseMuteStatusCount -= 1
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseMuteStatusCount += 1
                    }
                }
            }
            Item{
                x: 50; y: 880
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB BAD"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mPinkNoiseDABBadCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseDABBadCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseDABBadCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 960
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB Good"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mPinkNoiseDABGoodCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseDABGoodCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseDABGoodCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 1040
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB+ BAD"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mPinkNoiseDABPlusBadCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseDABPlusBadCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseDABPlusBadCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 1120
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB+ Good"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mPinkNoiseDABPlusGoodCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseDABPlusGoodCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mPinkNoiseDABPlusGoodCERValue += 5
                    }
                }
            }

            ///////////////////////////////////////////////////////////////////////// Signal Status CER Value
            Item{
                x: 50; y: 1280
                Text{
                    x: 0; y: 0
                    width: 315; height: 45
                    text: "# Signal Status CER Value"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDB
                }
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - Signal Status count"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mSignalStatusCount
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mSignalStatusCount -= 1
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mSignalStatusCount += 1
                    }
                }
                MComp.MButton{
                    x: 15; y: 30
                    width: 230; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    firstText: "SET"
                    firstTextX: 0
                    firstTextY: 20
                    firstTextWidth: 230
                    firstTextAlies: "Center"
                    firstTextColor: colorInfo.brightGrey
                    firstTextSize: 20
                    firstTextStyle: idAppMain.fonts_HDB

                    onClickOrKeySelected: {
                        DABController.sendtSigStatusCERValue(mSignalStatusCount, mSignalDABBadCERValue, mSignalDABNoGoodCERValue, mSignalDABGoodCERValue, mSignalDABPlusBadCERValue, mSignalDABPlusNoGoodCERValue, mSignalDABPlusGoodCERValue)
                    }
                }
            }
            Item{
                x: 50; y: 1360
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB BAD"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mSignalDABBadCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mSignalDABBadCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mSignalDABBadCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 1440
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB NoGood"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mSignalDABNoGoodCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mSignalDABNoGoodCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mSignalDABNoGoodCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 1520
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB Good"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mSignalDABGoodCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mSignalDABGoodCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mSignalDABGoodCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 1600
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB+ BAD"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mSignalDABPlusBadCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mSignalDABPlusBadCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mSignalDABPlusBadCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 1680
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB+ NoGood"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mSignalDABPlusNoGoodCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mSignalDABPlusNoGoodCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mSignalDABPlusNoGoodCERValue += 5
                    }
                }
            }
            Item{
                x: 50; y: 1760
                Text{
                    x: 0; y: 75
                    width: 315; height: 45
                    text: "   - DAB+ Good"
                    color: colorInfo.bandBlue
                    font.pixelSize: 20
                    font.family: idAppMain.fonts_HDR
                }
                Text{
                    x: 42; y: 105
                    width: 178; height: 45
                    text: mSignalDABPlusGoodCERValue
                    color: colorInfo.white
                    font.pixelSize: 25
                    font.family: idAppMain.fonts_HDB
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MComp.MButton{
                    x: 0; y: 105
                    width: 42; height: 44
                    focus: true
                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 0
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_l_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_l_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_l_s.png"

                    onClickOrKeySelected: {
                        mSignalDABPlusGoodCERValue -= 5
                    }
                }
                MComp.MButton{
                    x: 220; y: 105
                    width: 42; height: 44

                    bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                    bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                    bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                    anchorsFillParentFlag: true;

                    fgImageX: 3
                    fgImageY: 0
                    fgImageWidth: 39
                    fgImageHeight: 42
                    fgImage: imgFolderGeneral+"ch_visual_cue_r_n.png"
                    fgImagePress:  imgFolderGeneral+"ch_visual_cue_r_s.png"
                    fgImageFocus:  imgFolderGeneral+"ch_visual_cue_r_s.png"

                    onClickOrKeySelected: {
                        mSignalDABPlusGoodCERValue += 5
                    }
                }
            }
        }
    }
}

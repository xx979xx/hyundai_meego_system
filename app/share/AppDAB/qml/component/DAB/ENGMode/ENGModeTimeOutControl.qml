/**
 * FileName: ENGModeTimeOutControl.qml
 * Author: HYANG
 * Time: 2013-06-01
 *
 * - 2013-06-01 Initial Created by HYANG
 */
 
import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation


FocusScope {
    id:idDabENGModeListView
    //focus: true

    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderRadio_Dab: imageInfo.imgFolderRadio_Dab    

    MComp.MComponent{
        id: idText
        x: 0; y: 0
        width: 315; height: 550
        focus: true
        Flickable{
            id: idFlickable
            contentX: 0; contentY: 0
            contentWidth: 315
            contentHeight: 960
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
            Text{
                x: 50; y: 5
                width: 315; height: 45
                text: "[ Timeout control ]"
                color: colorInfo.white
                font.pixelSize: 28
                font.family: idAppMain.fonts_HDB
            }

            Column {
                id:idTimeoutControl
                spacing: 2
                x: 50; y: 50
                //****************************** (1)
                Item{
                    focus: true
                    width : 315
                    height : 90
                    Text{
                        x:0; y:0
                        width: 315; height: 45
                        text: "# Ann.End"
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDR
                    }
                    Text{
                        x: 42; y: 30
                        width: 108; height: 45
                        text: mAnnounceTimeout
                        color: colorInfo.white
                        font.pixelSize: 25
                        font.family: idAppMain.fonts_HDB
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MComp.MButton{
                        x: 0; y: 30
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
                            mAnnounceTimeout -= 1
                        }
                    }
                    MComp.MButton{
                        x: 150; y: 30
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
                            mAnnounceTimeout += 1
                        }
                    }
                    MComp.MButton{
                        x: 205; y: 30
                        width: 60; height: 44
                        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                        anchorsFillParentFlag: true;
                        firstText: "SET"
                        firstTextX: 0
                        firstTextY: 20
                        firstTextWidth: 60
                        firstTextAlies: "Center"
                        firstTextColor: colorInfo.brightGrey
                        firstTextSize: 20
                        firstTextStyle: idAppMain.fonts_HDB
                        onClickOrKeySelected: {
                            DABListener.debugSetAnnounceTimeout(mAnnounceTimeout)
                        }
                    }
                }

                //****************************** (2)
                Item{
                    width : 315
                    height : 90
                    Text{
                        x:0; y:0
                        width: 315; height: 45
                        text: "# Ann.End Delay"
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDR
                    }
                    Text{
                        x: 42; y: 30
                        width: 108; height: 45
                        text: mAnnounceDelayTimeout
                        color: colorInfo.white
                        font.pixelSize: 25
                        font.family: idAppMain.fonts_HDB
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MComp.MButton{
                        x: 0; y: 30
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
                            mAnnounceDelayTimeout -= 1
                        }
                    }
                    MComp.MButton{
                        x: 150; y: 30
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
                            mAnnounceDelayTimeout += 1
                        }
                    }
                    MComp.MButton{
                        x: 205; y: 30
                        width: 60; height: 44
                        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                        anchorsFillParentFlag: true;
                        firstText: "SET"
                        firstTextX: 0
                        firstTextY: 20
                        firstTextWidth: 60
                        firstTextAlies: "Center"
                        firstTextColor: colorInfo.brightGrey
                        firstTextSize: 20
                        firstTextStyle: idAppMain.fonts_HDB
                        onClickOrKeySelected: {
                            DABListener.debugSetAnnounceDelayTime(mAnnounceDelayTimeout)
                        }
                    }
                }

                //****************************** (3)
                Item{
                    width : 315
                    height : 90
                    Text{
                        x: 0; y: 0
                        width: 315; height: 45
                        text: "# Ann.Weak"
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDR
                    }
                    Text{
                        x: 42; y: 30
                        width: 108; height: 45
                        text: mAnnounceWeakTimeout
                        color: colorInfo.white
                        font.pixelSize: 25
                        font.family: idAppMain.fonts_HDB
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    MComp.MButton{
                        x: 0; y: 30
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
                            mAnnounceWeakTimeout -= 1
                        }
                    }
                    MComp.MButton{
                        x: 150; y: 30
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
                            mAnnounceWeakTimeout += 1
                        }
                    }
                    MComp.MButton{
                        x: 205; y: 30
                        width: 60; height: 44
                        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                        anchorsFillParentFlag: true;
                        firstText: "SET"
                        firstTextX: 0
                        firstTextY: 20
                        firstTextWidth: 60
                        firstTextAlies: "Center"
                        firstTextColor: colorInfo.brightGrey
                        firstTextSize: 20
                        firstTextStyle: idAppMain.fonts_HDB
                        onClickOrKeySelected: {
                            DABListener.debugSetAnnounceWeakTimeout(mAnnounceWeakTimeout)
                        }
                    }
                }

                //****************************** (4)
                Item{
                    width : 315
                    height : 90
                    Text{
                        x: 0; y: 0
                        width: 315; height: 45
                        text: "# Seek timeout"
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDR
                    }
                    Text{
                        x: 42; y: 30
                        width: 108; height: 45
                        text: mSeekTimeout
                        color: colorInfo.white
                        font.pixelSize: 25
                        font.family: idAppMain.fonts_HDB
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MComp.MButton{
                        x: 0; y: 30
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
                            mSeekTimeout -= 1
                        }
                    }
                    MComp.MButton{
                        x: 150; y: 30
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
                            mSeekTimeout += 1
                        }
                    }
                    MComp.MButton{
                        x: 205; y: 30
                        width: 60; height: 44

                        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                        anchorsFillParentFlag: true;

                        firstText: "SET"
                        firstTextX: 0
                        firstTextY: 20
                        firstTextWidth: 60
                        firstTextAlies: "Center"
                        firstTextColor: colorInfo.brightGrey
                        firstTextSize: 20
                        firstTextStyle: idAppMain.fonts_HDB

                        onClickOrKeySelected: {
                            DABListener.debugSetSeekTimeout(mSeekTimeout)
                        }
                    }

                }

                //****************************** (5)
                Item{
                    width : 315
                    height : 90
                    Text{
                        x: 0; y: 0
                        width: 315; height: 45
                        text: "# SLS timeout"
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDR
                    }
                    Text{
                        x: 42; y: 30
                        width: 108; height: 45
                        text: mSLSTimeout
                        color: colorInfo.white
                        font.pixelSize: 25
                        font.family: idAppMain.fonts_HDB
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MComp.MButton{
                        x: 0; y: 30
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
                            mSLSTimeout -= 1
                        }
                    }
                    MComp.MButton{
                        x: 150; y: 30
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
                            mSLSTimeout += 1
                        }
                    }
                    MComp.MButton{
                        x: 205; y: 30
                        width: 60; height: 44
                        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                        anchorsFillParentFlag: true;
                        firstText: "SET"
                        firstTextX: 0
                        firstTextY: 20
                        firstTextWidth: 60
                        firstTextAlies: "Center"
                        firstTextColor: colorInfo.brightGrey
                        firstTextSize: 20
                        firstTextStyle: idAppMain.fonts_HDB
                        onClickOrKeySelected: {
                            DABController.debugSetSLSTimeout(mSLSTimeout)
                        }
                    }
                }

                //****************************** (6)
                Item{
                    width : 315
                    height : 90
                    Text{
                        x: 0; y: 0
                        width: 315; height: 45
                        text: "# DL+ timeout"
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDR
                    }
                    Text{
                        x: 42; y: 30
                        width: 108; height: 45
                        text: mDLPlusTimeout
                        color: colorInfo.white
                        font.pixelSize: 25
                        font.family: idAppMain.fonts_HDB
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MComp.MButton{
                        x: 0; y: 30
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
                            mDLPlusTimeout -= 1
                        }
                    }
                    MComp.MButton{
                        x: 150; y: 30
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
                            mDLPlusTimeout += 1
                        }
                    }
                    MComp.MButton{
                        x: 205; y: 30
                        width: 60; height: 44

                        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                        anchorsFillParentFlag: true;

                        firstText: "SET"
                        firstTextX: 0
                        firstTextY: 20
                        firstTextWidth: 60
                        firstTextAlies: "Center"
                        firstTextColor: colorInfo.brightGrey
                        firstTextSize: 20
                        firstTextStyle: idAppMain.fonts_HDB

                        onClickOrKeySelected: {
                            DABController.debugSetDLSTimeout(mDLPlusTimeout)
                        }
                    }
                }

                //****************************** (7)
                Item{
                    width : 315
                    height : 90
                    Text{
                        x: 0; y: 0
                        width: 315; height: 45
                        text: "# DLS timeout"
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDR
                    }
                    Text{
                        x: 42; y: 30
                        width: 108; height: 45
                        text: mDLSTimeout
                        color: colorInfo.white
                        font.pixelSize: 25
                        font.family: idAppMain.fonts_HDB
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MComp.MButton{
                        x: 0; y: 30
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
                            mDLSTimeout -= 1
                        }
                    }
                    MComp.MButton{
                        x: 150; y: 30
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
                            mDLSTimeout += 1
                        }
                    }
                    MComp.MButton{
                        x: 205; y: 30
                        width: 60; height: 44

                        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                        anchorsFillParentFlag: true;

                        firstText: "SET"
                        firstTextX: 0
                        firstTextY: 20
                        firstTextWidth: 60
                        firstTextAlies: "Center"
                        firstTextColor: colorInfo.brightGrey
                        firstTextSize: 20
                        firstTextStyle: idAppMain.fonts_HDB

                        onClickOrKeySelected: {
                            DABController.debugSetDLSTimeout(mDLSTimeout)
                        }
                    }
                }

                //****************************** (8)
                Item{
                    width : 315
                    height : 90
                    Text{
                        x: 0; y: 0
                        width: 315; height: 45
                        text: "# Mute time(in DAB-DAB SF)"
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDR
                    }
                    Text{
                        x: 42; y: 30
                        width: 108; height: 45
                        text: mDAB_DABLinkingMuteTimeout
                        color: colorInfo.white
                        font.pixelSize: 25
                        font.family: idAppMain.fonts_HDB
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MComp.MButton{
                        x: 0; y: 30
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
                            mDAB_DABLinkingMuteTimeout -= 1
                        }
                    }
                    MComp.MButton{
                        x: 150; y: 30
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
                            mDAB_DABLinkingMuteTimeout += 1
                        }
                    }
                    MComp.MButton{
                        x: 205; y: 30
                        width: 60; height: 44
                        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                        anchorsFillParentFlag: true;
                        firstText: "SET"
                        firstTextX: 0
                        firstTextY: 20
                        firstTextWidth: 60
                        firstTextAlies: "Center"
                        firstTextColor: colorInfo.brightGrey
                        firstTextSize: 20
                        firstTextStyle: idAppMain.fonts_HDB
                        onClickOrKeySelected: {
                            DABListener.debugSetServiceLinkMuteTimeout(mDAB_DABLinkingMuteTimeout)
                        }
                    }
                }

                //****************************** (9)
                Item{
                    width : 315
                    height : 90
                    Text{
                        x: 0; y: 0
                        width: 315; height: 45
                        text: "# DAB-FM SF"
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDR
                    }
                    Text{
                        x: 42; y: 30
                        width: 108; height: 45
                        text: MDabOperation.checkIntervalCount(mDAB_FMlinking)
                        color: colorInfo.white
                        font.pixelSize: 25
                        font.family: idAppMain.fonts_HDB
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MComp.MButton{
                        x: 0; y: 30
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
                            mDAB_FMlinking -= 2
                        }
                    }
                    MComp.MButton{
                        x: 150; y: 30
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
                            mDAB_FMlinking += 2
                        }
                    }
                    MComp.MButton{
                        x: 205; y: 30
                        width: 60; height: 44

                        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                        anchorsFillParentFlag: true;

                        firstText: "SET"
                        firstTextX: 0
                        firstTextY: 20
                        firstTextWidth: 60
                        firstTextAlies: "Center"
                        firstTextColor: colorInfo.brightGrey
                        firstTextSize: 20
                        firstTextStyle: idAppMain.fonts_HDB

                        onClickOrKeySelected: {
                            DABListener.setFMtoDABIntervalCount(mDAB_FMlinking)
                        }
                    }
                }

                //****************************** (10)
                Item{
                    width : 315
                    height : 90
                    Text{
                        x: 0; y: 0
                        width: 315; height: 45
                        text: "# DAB-DAB On/Off"
                        color: colorInfo.bandBlue
                        font.pixelSize: 20
                        font.family: idAppMain.fonts_HDR
                    }
                    Text{
                        x: 42; y: 30
                        width: 108; height: 45
                        text: mDABtoDABOnOff
                        color: colorInfo.white
                        font.pixelSize: 25
                        font.family: idAppMain.fonts_HDB
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MComp.MButton{
                        x: 0; y: 30
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
                            if(mDABtoDABOnOff == "on")
                                mDABtoDABOnOff = "off"
                            else
                                mDABtoDABOnOff = "on"
                        }
                    }
                    MComp.MButton{
                        x: 150; y: 30
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
                            if(mDABtoDABOnOff == "on")
                                mDABtoDABOnOff = "off"
                            else
                                mDABtoDABOnOff = "on"
                        }
                    }
                    MComp.MButton{
                        x: 205; y: 30
                        width: 60; height: 44
                        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
                        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
                        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
                        anchorsFillParentFlag: true;
                        firstText: "SET"
                        firstTextX: 0
                        firstTextY: 20
                        firstTextWidth: 60
                        firstTextAlies: "Center"
                        firstTextColor: colorInfo.brightGrey
                        firstTextSize: 20
                        firstTextStyle: idAppMain.fonts_HDB
                        onClickOrKeySelected: {
                            DABController.debugRequestDABtoDAB(mDABtoDABOnOff);
                        }
                    }
                }
            }
        }
    }
}

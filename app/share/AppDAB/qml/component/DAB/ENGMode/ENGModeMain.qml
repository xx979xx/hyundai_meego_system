/**
 * FileName: ENGModeMain.qml
 * Author: HYANG
 * Time: 2013-02-15
 *
 * - 2013-02-15 Initial Created by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../DAB/Common" as MDabCommon
import "../JavaScript/DabOperation.js" as MDabOperation

// DAB EngineerMode
MComp.MComponent {
    id : idDabENGModeMain
    x:0; y:0
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    MDabCommon.ImageInfo { id : imageInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral

    property int mAnnounceTimeout: DABListener.m_iAnnounceTimeout               //5m
    property int mAnnounceDelayTimeout: DABListener.m_iAnnounceDeleayTime;      //2s
    property int mAnnounceWeakTimeout: 30                                       //30s
    property int mSeekTimeout: DABListener.getSeekTimeout();                    //5s
    property int mSLSTimeout: DABController.getSLSTimeout();                    //5m
    property int mDLPlusTimeout: DABController.getDLPlusTimeout();              //5m
    property int mDLSTimeout: DABController.getDLSTimeout();                    //5m
    property int mDAB_DABLinkingMuteTimeout: DABListener.m_iServLinkMuteTimeout //5s
    property int mDAB_FMlinking: DABListener.m_iFMtoDABInterval                 //10s  (SF)

    property int mDAB_DABLinkingDABWorstCERValue: 650       //900
    property int mDAB_DABLinkingDABBadCERValue: 500         //650
    property int mDAB_DABLinkingDABNoGoodCERValue: 400      //500
    property int mDAB_DABLinkingDABGoodCERValue: 300        //450
    property int mDAB_DABLinkingDABPlusWorstCERValue: 830   //900
    property int mDAB_DABLinkingDABPlusBadCERValue: 680     //750
    property int mDAB_DABLinkingDABPlusNoGoodCERValue:480   //550
    property int mDAB_DABLinkingDABPlusGoodCERValue: 380    //450

    property int mPinkNoiseUnMuteStatusCount: 20
    property int mPinkNoiseMuteStatusCount: 5
    property int mPinkNoiseDABBadCERValue: 500
    property int mPinkNoiseDABGoodCERValue: 350
    property int mPinkNoiseDABPlusBadCERValue: 600
    property int mPinkNoiseDABPlusGoodCERValue: 550

    property int mSignalStatusCount: 15
    property int mSignalDABBadCERValue: 650
    property int mSignalDABNoGoodCERValue: 400
    property int mSignalDABGoodCERValue: 350
    property int mSignalDABPlusBadCERValue: 750
    property int mSignalDABPlusNoGoodCERValue: 500
    property int mSignalDABPlusGoodCERValue: 450

    property string mDABtoDABOnOff : "on"

    property int mProtectType   : 0
    property int mProtectLevel  : 0
    property int mProtectOption : 0

    //**************************************** Ch Mgt background
    Image {
        y : 0//-systemInfo.statusBarHeight
        source : imageInfo.imgBg_Main
    }

    MComp.MBand{
        id: idENGModeBand
        x: 0; y: 0
        focus: true
        // KeyNavigation.down: idENGModeTimeOutControlidENGModeTimeOutControl;
        //****************************** # Tab button OFF #
        tabBtnFlag: false               //bandTab button On/Off
        reserveBtnFlag: true
        reserveBtnText: "CER"
        menuBtnFlag: true                //subKey button On/Off
        menuBtnText: "CLEAR"
        titleText: "Engineering Mode" //title Label Text input

        subBtnText : "delete List"
        subBtnFlag : true
        subBtnWidth: 273
        subBtnBgImage: imageInfo.imgTitleDate_N
        subBtnBgImageFocus: imageInfo.imgTitleDate_F
        subBtnBgImagePress: imageInfo.imgTitleDate_P
        onMenuBtnClicked: {
            mAnnounceTimeout = DABListener.m_iAnnounceTimeout
            mAnnounceDelayTimeout = DABListener.m_iAnnounceDeleayTime;
            mAnnounceWeakTimeout = 30
            mSeekTimeout = DABListener.getSeekTimeout();
            mSLSTimeout = DABController.getSLSTimeout();
            mDLPlusTimeout = DABController.getDLPlusTimeout();
            mDLSTimeout = DABController.getDLSTimeout();
            mDAB_DABLinkingMuteTimeout = DABListener.m_iServLinkMuteTimeout
            mDAB_FMlinking = DABListener.m_iFMtoDABInterval

            mDAB_DABLinkingDABWorstCERValue = 650
            mDAB_DABLinkingDABBadCERValue = 500
            mDAB_DABLinkingDABNoGoodCERValue = 400
            mDAB_DABLinkingDABGoodCERValue = 300
            mDAB_DABLinkingDABPlusWorstCERValue = 830
            mDAB_DABLinkingDABPlusBadCERValue = 680
            mDAB_DABLinkingDABPlusNoGoodCERValue = 480
            mDAB_DABLinkingDABPlusGoodCERValue = 380

            mPinkNoiseUnMuteStatusCount = 20
            mPinkNoiseMuteStatusCount = 5
            mPinkNoiseDABBadCERValue = 500
            mPinkNoiseDABGoodCERValue = 350
            mPinkNoiseDABPlusBadCERValue = 600
            mPinkNoiseDABPlusGoodCERValue = 550

            mSignalStatusCount = 15
            mSignalDABBadCERValue = 650
            mSignalDABNoGoodCERValue = 400
            mSignalDABGoodCERValue = 350
            mSignalDABPlusBadCERValue = 750
            mSignalDABPlusNoGoodCERValue = 500
            mSignalDABPlusGoodCERValue = 450
        }

        onSubBtnClicked: {
            console.log("[QML] ENGModeMain.qml : onSubBtnClicked")
            DABChannelManager.deleteChannelList();
        }

        onReserveBtnClicked: {
            console.log("[QML] ENGModeMain.qml : onReserveBtnClicked")
            idENGModeContents.visible= false;
            idENGModeTimeOutControl.visible = false;
            idENGModeCERContents.visible = true;
        }

        //****************************** # button clicked or key selected #
        onBackBtnClicked:{
            console.log("[QML] ENGModeMain.qml - onBackBtnClicked :: idAppMain.inputMode = " + idAppMain.inputMode)
            if(idENGModeCERContents.visible)
            {
                idENGModeCERContents.visible = false;
                idENGModeContents.visible= true;
                idENGModeTimeOutControl.visible = true;
            }
            else
            {
                UIListener.HandleBackKey(idAppMain.inputMode);
            }
        }
    }

    //**************************************** Data Contents  (2)
    ENGModeContents{
        id: idENGModeContents
        x: 5; y: systemInfo.titleAreaHeight + 10;
    }

    ENGModeTimeOutControl{
        id: idENGModeTimeOutControl
        x: 950; y: systemInfo.titleAreaHeight;
        KeyNavigation.up: idENGModeBand
    }

    ENGModeCERContents{
        id: idENGModeCERContents
        x: 5; y: systemInfo.titleAreaHeight + 10;
        KeyNavigation.up: idENGModeBand
        visible: false;
    }

    onBackKeyPressed: {
        idDabENGModeMain.focus = true
        console.log("[QML] ENGModeMain.qml - onBackKeyPressed :: idAppMain.inputMode = " + idAppMain.inputMode)
        UIListener.HandleBackKey(idAppMain.inputMode);
    }

    onHomeKeyPressed:{     
        UIListener.HandleHomeKey();
    }

    Component.onCompleted : {
        console.log("[QML] ENGModeMain.qml : onCompleted...");
    }

    Connections {
        target : DABController
        onSendAudioInfo : {
            console.log("[QML] ==> Connections : ENGModeMain.qml : onSendAudioInfo :  = protectType = " + protectType + " protectLevel = " + protectLevel + " protectOption = " + protectOption);
            mProtectType   = protectType
            mProtectLevel  = protectLevel
            mProtectOption = protectOption
        }
    }
}

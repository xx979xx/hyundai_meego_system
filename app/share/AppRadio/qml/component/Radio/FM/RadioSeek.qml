/**
 * FileName: RadioSeek.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */

import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp



MComp.MComponent {
    id: idRadioSeek
    x: 0; y: 0
    width: systemInfo.lcdWidth-1178; height:  systemInfo.subMainHeight - systemInfo.titleAreaHeight

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioStringInfo{ id: stringInfo }

    property string imgFolderRadio : imageInfo.imgFolderRadio

    //****************************** # Seek Cue Image #
    MComp.MButton{
        id: btnSeekCue
        x: seekCueFlag? 1243-1178 : 1243-1178+1000; y: 0
        width: 37; height: 247
        bgImage: imgFolderRadio+"btn_cue_seek_n.png"
        bgImagePress: imgFolderRadio+"btn_cue_seek_p.png"
        visible: seekCueFlag
        onClickOrKeySelected: {
            console.log("##cue###")
            //////////////////////////////////
            // JSH 120404
            //seekCueFlag = !seekCueFlag
            //idRadioSeek.forceActiveFocus()
            //////////////////////////////////
            seekCueFlag = false
            timerSeek.restart()
        }
    }

    //****************************** # Seek Up/Down Image #
    MComp.MButton{
        id: btnSeekUp
        x: !seekCueFlag ? 0 : 1000; y: 0
        width: 89; height: 108
        focus: true
        bgImage: imgFolderRadio+"btn_seek_u_n.png"
        bgImagePress: imgFolderRadio+"btn_seek_u_p.png"
        bgImageFocusPress: imgFolderRadio+"btn_seek_u_fp.png"
        bgImageFocus: imgFolderRadio+"btn_seek_u_f.png"
        ////////////////////////////////////////////////////////
        // JSH 120404
        property bool requestStopSearch: false
        property bool requestReAction: false
        property bool requestStopSearchFast: false
        property bool requestReActionFast: false

        onClickOrKeySelected: { // onReleased ??
            console.log("### Seek Up ###")
            if( btnSeekUp.requestStopSearch == true )
            {
                btnSeekUp.requestReAction = btnSeekUp.requestReAction ? false:true;
                return;
            }
            if(QmlController.searchState == 0x02){
                QmlController.seekstop();
                btnSeekUp.requestStopSearch = true;
                btnSeekUp.requestReAction = true;
                return;
            }else if (QmlController.searchState != 0x00 && QmlController.searchState != 0x08 ){
                QmlController.seekstop();
                btnSeekUp.requestStopSearch = true;
                btnSeekUp.requestReAction = false;
                return;
            }
            QmlController.seekup();
            timerSeek.restart()
        }
        onPressAndHold: {
            if( btnSeekUp.requestStopSearchFast == true )
            {
                btnSeekUp.requestReActionFast = btnSeekUp.requestReActionFast ? false:true;
                return;
            }
            if(QmlController.searchState == 0x08){
                QmlController.seekstop();
                btnSeekUp.requestStopSearchFast = true;
                btnSeekUp.requestReActionFast = true;
                return;
            }else if (QmlController.searchState != 0x00){
                QmlController.seekstop();
                btnSeekUp.requestStopSearchFast = true;
                btnSeekUp.requestReActionFast = false;
                return;
            }
            QmlController.seekupFast();
            timerSeek.restart()
        }
        ////////////////////////////////////////////////////////

        KeyNavigation.down: btnSeekDown

        ////////////////////////////////////////////////////////
        // JSH 120404
        Connections {
            target: QmlController
            onChangeSearchState: {
                console.log(" HJIGKS: [btnSeekUp] onChangeSearchState value: " + value + " requestStopSearch: " + btnSeekUp.requestStopSearch + " requestReAction: " + btnSeekUp.requestReAction);
                if( value == 0 && btnSeekUp.requestStopSearch == true )
                {
                    btnSeekUp.requestStopSearch = false;
                    if( !btnSeekUp.requestReAction )
                        QmlController.seekup();
                }
                console.log(" HJIGKS: [btnSeekUp] onChangeSearchState value: " + value + " requestStopSearchFast: " + btnSeekUp.requestStopSearchFast + " requestReActionFast: " + btnSeekUp.requestReActionFast);
                if( value == 0 && btnSeekUp.requestStopSearchFast == true )
                {
                    btnSeekUp.requestStopSearchFast = false;
                    if( !btnSeekUp.requestReActionFast )
                        QmlController.seekupFast();
                }
            }
        }
        ////////////////////////////////////////////////////////
    }
    Text{
        text: stringInfo.strRadioLabelSeek
        x: !seekCueFlag ? 0 : 1000; y: 125-24/2
        width: 89; height: 24
        font.pixelSize: 24
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    }
    MComp.MButton{
        id: btnSeekDown
        x: !seekCueFlag ? 0 : 100; y: 125+17
        width: 89; height: 108
        bgImage: imgFolderRadio+"btn_seek_d_n.png"
        bgImagePress: imgFolderRadio+"btn_seek_d_p.png"
        bgImageFocusPress: imgFolderRadio+"btn_seek_d_fp.png"
        bgImageFocus: imgFolderRadio+"btn_seek_d_f.png"
        ////////////////////////////////////////////////////////
        // JSH 120404
        property bool requestStopSearch: false
        property bool requestReAction: false
        property bool requestStopSearchFast: false
        property bool requestReActionFast: false

        onClickOrKeySelected: { // onReleased ??
            console.log("### Seek Down ###")
            if( btnSeekDown.requestStopSearch == true )
            {
                btnSeekDown.requestReAction = btnSeekDown.requestReAction ? false:true;
                return;
            }
            if(QmlController.searchState == 0x01){
                QmlController.seekstop();
                btnSeekDown.requestStopSearch = true;
                btnSeekDown.requestReAction = true;
                return;
            }else if (QmlController.searchState != 0x00 && QmlController.searchState != 0x09){
                QmlController.seekstop();
                btnSeekDown.requestStopSearch = true;
                btnSeekDown.requestReAction = false;
                return;
            }
            QmlController.seekdown();
            timerSeek.restart()
        }
        onPressAndHold:{
            console.log("-----------------------onPressAndHold previous")
            if( btnSeekDown.requestStopSearchFast == true )
            {
                btnSeekDown.requestReActionFast = btnSeekDown.requestReActionFast ? false:true;
                return;
            }
            if(QmlController.searchState == 0x09){
                QmlController.seekstop();
                btnSeekDown.requestStopSearchFast = true;
                btnSeekDown.requestReActionFast = true;
                return;
            }else if (QmlController.searchState != 0x00){
                QmlController.seekstop();
                btnSeekDown.requestStopSearchFast = true;
                btnSeekDown.requestReActionFast = false;
                return;
            }
            QmlController.seekdownFast();
        }
        ////////////////////////////////////////////////////////

        KeyNavigation.up: btnSeekUp

        ////////////////////////////////////////////////////////
        // JSH 120404
        Connections {
            target: QmlController
            onChangeSearchState: {
                console.log(" HJIGKS: [btnSeekDown] onChangeSearchState value: " + value + " requestStopSearch: " + btnSeekDown.requestStopSearch + " requestReAction: " + btnSeekDown.requestReAction);
                if( value == 0 && btnSeekDown.requestStopSearch == true )
                {
                    btnSeekDown.requestStopSearch = false;
                    if( !btnSeekDown.requestReAction )
                        QmlController.seekdown();
                }
                console.log(" HJIGKS: [btnSeekDown] onChangeSearchState value: " + value + " requestStopSearchFast: " + btnSeekDown.requestStopSearchFast + " requestReActionFast: " + btnSeekDown.requestReActionFast);
                if( value == 0 && btnSeekDown.requestStopSearchFast == true )
                {
                    btnSeekDown.requestStopSearchFast = false;
                    if( !btnSeekDown.requestReActionFast )
                        QmlController.seekdownFast();
                }
            }
        }
        ////////////////////////////////////////////////////////
    }

    //****************************** # Timer #
    Timer{
        id: timerSeek
        interval: 5000; running: false; repeat: false
        onTriggered: seekCueFlag = true
    }
}

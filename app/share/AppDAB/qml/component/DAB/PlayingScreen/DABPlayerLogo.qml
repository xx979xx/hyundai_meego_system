/**
 * FileName: DABPlayerLogo.qml
 * Author: DaeHyungE
 * Time: 2013-01-22

 * * - 2013-01-22 Initial Crated by HyungE
 *   - 2013-02-21 logo fillMode add
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

FocusScope {
    id : idDABPlayerLogo
    property string fadeColor : "#000011"

    function checkSlideShow()
    {
        console.log("[QML] DABPlayerLogo.qml : checkSlideShow : m_bSLSOn = " + m_bSLSOn);
        if(idAppMain.m_bSLSOn)
        {
            return (idAppMain.m_sSLS != "")? idAppMain.m_sSLS : MDabOperation.getLogoImage(m_sPtyName)
        }
        else
        {
            return MDabOperation.getLogoImage(m_sPtyName)
        }
    }

    function getSLSImage()
    {
        console.log("[QML] DABPlayerLogo.qml : getSLSImage : m_bSLSOn = " + m_bSLSOn);
        return (idAppMain.m_sSLS != "")? idAppMain.m_sSLS : MDabOperation.getLogoImage(m_sPtyName)
    }

    function checkPtyFrame()
    {
        if(idAppMain.m_bSLSOn)
        {
            if((idAppMain.m_sSLS == "") && (m_sChannelLogo == ""))
                return true;
        }
        else
        {
            if(m_sChannelLogo == "")
                return true;
            else
                return false;
        }
    }

    Image {
        id : idImgLogoPty
        x:  (idAppMain.m_bSLSOn && (idAppMain.m_sSLS != "")) ? -60 : 0
        y:  (idAppMain.m_bSLSOn && (idAppMain.m_sSLS != "")) ? 10 : 0
        width :  (idAppMain.m_bSLSOn && (idAppMain.m_sSLS != "")) ? 332 : 262;
        height :  (idAppMain.m_bSLSOn && (idAppMain.m_sSLS != "")) ? 252 : 262
        source : imageInfo.imgBgPty
        visible: true/*checkPtyFrame()*/
    }

    Rectangle{
        x: idImgIcoDab.x-1
        y: idImgIcoDab.y-1
        width: idImgIcoDab.paintedWidth+2   //idImgIcoDab.paintedWidth+1
        height: idImgIcoDab.paintedHeight+2 //idImgIcoDab.paintedWidth+1
        // border.color: Qt.rgba(100/255, 100/255, 100/255, 1)
        // border.width: 1
        color: Qt.rgba(100/255, 100/255, 100/255, 1) // "transparent"
        visible: (idAppMain.m_bSLSOn && (idAppMain.m_sSLS != ""))
        anchors.horizontalCenter: idImgLogoPty.horizontalCenter
        anchors.verticalCenter: idImgLogoPty.verticalCenter
    }

    Image {
        id : idImgIcoDab
        x: (idAppMain.m_bSLSOn && (idAppMain.m_sSLS != "")) ? 1 : 3
        y: (idAppMain.m_bSLSOn && (idAppMain.m_sSLS != "")) ? 10+1 : 3
        width:  (idAppMain.m_bSLSOn && (idAppMain.m_sSLS != "")) ? 320 : 256
        height:  (idAppMain.m_bSLSOn && (idAppMain.m_sSLS != "")) ? 240 : 256
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: idImgLogoPty.horizontalCenter
        anchors.verticalCenter: idImgLogoPty.verticalCenter
        source : (idAppMain.m_bSLSOn == true)? getSLSImage() : MDabOperation.getLogoImage(m_sPtyName)
//        source : checkSlideShow()/*(idAppMain.m_sSLS != "")? idAppMain.m_sSLS : MDabOperation.getLogoImage(m_sPtyName)*/

    }  

    MComp.MButton {
        id: idSLSFocusArea
        x: idImgIcoDab.x-1
        y: idImgIcoDab.y-1
        width: idImgIcoDab.paintedWidth+2
        height: idImgIcoDab.paintedHeight+2
        anchors.horizontalCenter: idImgLogoPty.horizontalCenter
        anchors.verticalCenter: idImgLogoPty.verticalCenter
        focus: true
        enabled: (idAppMain.m_sSLS != "" && idAppMain.m_bSLSOn);
        BorderImage {
            source: imageInfo.imgSLS_Rectangle_F
            anchors.fill: parent;
            border {left: 10; right: 10; top: 10; bottom: 10}
            visible: idSLSFocusArea.activeFocus
        } // End BorderImage
        onClickOrKeySelected: {
            if(idAppMain.m_sSLS != "" && idAppMain.m_bSLSOn)
                setAppMainScreen("DabInfoSLSMain", true);
        }
    }
    onActiveFocusChanged: {
        if(idAppMain.state == "DABPlayerMain"){
            idDABPlayerBand.focus = true;
        }
    }
    Connections {
        target: DABListener
        onChannelLogoChanged:{
            console.log("[QML] ==> Connections : DABPlayerLogo.qml : SLS Img  = " + idAppMain.m_sSLS)
            if(idAppMain.m_bSLSOn)
            {
                if(idAppMain.m_sSLS != "")
                {
                    idImgIcoDab.source = idAppMain.m_sSLS;
                    idImgLogoPty.visible = false;
                }
                else if(m_sChannelLogo != "")
                {
                    idDABPlayerBand.focus = true;
                    idImgIcoDab.source  = m_sChannelLogo
                    idImgLogoPty.visible = false;
                }
                else
                {
                    idDABPlayerBand.focus = true;
                    idImgIcoDab.source  = MDabOperation.getLogoImage(m_sPtyName)
                    idImgLogoPty.visible = true;
                }
            }
            else
            {
                idDABPlayerBand.focus = true;
                if(m_sChannelLogo != "")
                {
                    idImgIcoDab.source  = m_sChannelLogo
                    idImgLogoPty.visible = false;
                }
                else
                {
                    idImgIcoDab.source  = MDabOperation.getLogoImage(m_sPtyName)
                    idImgLogoPty.visible = true;
                }
            }
        }

        onSlsChanged:{
            console.log("[QML] ==> Connections : DABPlayerLogo.qml : onSlsChanged : m_sSLS = " + idAppMain.m_sSLS + " m_bSLSOn = "  + idAppMain.m_bSLSOn)
            if(idAppMain.m_bSLSOn)
            {
                if(idAppMain.m_sSLS != "")
                {
                    idImgIcoDab.source = idAppMain.m_sSLS;
                    idImgLogoPty.visible = false;
                }
                else if(m_sChannelLogo != "")
                {
                    idDABPlayerBand.focus = true;
                    idImgIcoDab.source  = m_sChannelLogo
                    idImgLogoPty.visible = false;
                }
                else
                {
                    idDABPlayerBand.focus = true;
                    idImgIcoDab.source  = MDabOperation.getLogoImage(m_sPtyName)
                    idImgLogoPty.visible = true;
                }
            }
            else
            {
                idDABPlayerBand.focus = true;
                if(m_sChannelLogo != "")
                {
                    idImgIcoDab.source  = m_sChannelLogo
                    idImgLogoPty.visible = false;
                }
                else
                {
                    idImgIcoDab.source  = MDabOperation.getLogoImage(m_sPtyName)
                    idImgLogoPty.visible = true;
                }
            }
        }

        onSlideShowChanged: {
            console.log("[QML] ==> Connections : DABPlayerLogo.qml : onSlsChanged : isOn = " + isOn)
            if(isOn)
            {
                if(idAppMain.m_sSLS != "")
                {
                    idImgIcoDab.source = idAppMain.m_sSLS;
                    idImgLogoPty.visible = false;
                }
                else if(m_sChannelLogo != "")
                {
                    idImgIcoDab.source  = m_sChannelLogo
                    idImgLogoPty.visible = false;
                }
                else
                {
                    idImgIcoDab.source  = MDabOperation.getLogoImage(m_sPtyName)
                    idImgLogoPty.visible = true;
                }
            }
            else
            {
                idDABPlayerBand.focus = true;
                if(m_sChannelLogo != "")
                {
                    idImgIcoDab.source  = m_sChannelLogo
                    idImgLogoPty.visible = false;
                }
                else
                {
                    idImgIcoDab.source  = MDabOperation.getLogoImage(m_sPtyName)
                    idImgLogoPty.visible = true;
                }
            }
        }
    }
}

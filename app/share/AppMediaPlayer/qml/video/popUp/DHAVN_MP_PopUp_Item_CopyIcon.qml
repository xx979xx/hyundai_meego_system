import Qt 4.7
import QtQuick 1.1

import "DHAVN_MP_PopUp_Constants.js" as CONST
import "DHAVN_MP_PopUp_Resources.js" as RES
//[KOR][ITS][170734][comment] (aettie.ji)
/** Icon image */
Item
{
    id: icons

    /** --- Input parameters --- */

    property string icon_usb_a: RES.const_POPUP_COPY_ICON_USB_AUDIO
    property string icon_usb_v: RES.const_POPUP_COPY_ICON_USB_VIDEO
    property string icon_usb_p: RES.const_POPUP_COPY_ICON_USB_IMAGE
    property string icon_juke_a: RES.const_POPUP_COPY_ICON_JUKEBOX_AUDIO
    property string icon_juke_v: RES.const_POPUP_COPY_ICON_JUKEBOX_VIDEO
    property string icon_juke_p: RES.const_POPUP_COPY_ICON_JUKEBOX_IMAGE
    property string icon_juke_a_n: RES.const_POPUP_COPY_ICON_JUKEBOX_AUDIO_N
    property string icon_juke_v_n: RES.const_POPUP_COPY_ICON_JUKEBOX_VIDEO_N
    property string icon_juke_p_n: RES.const_POPUP_COPY_ICON_JUKEBOX_IMAGE_N

    property string icon_arrow_n: RES.const_POPUP_COPY_GAUGE_ARROW_N
    property string icon_arrow_s: RES.const_POPUP_COPY_GAUGE_ARROW_S
    property string icon_dot_n: RES.const_POPUP_COPY_GAUGE_DOT_N
    property string icon_dot_s: RES.const_POPUP_COPY_GAUGE_DOT_S
    property int dot_idx:0;
    //property variant iconEnum: {'audio':0,'video':1,'photo:'2}
    property int iconType

    width :636
    height: 100
    
    /** --- Child object --- */
    Image
    {
        id: usb_icon

        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: false
        source: (iconType==0) ? icon_usb_a :( (iconType==1)? icon_usb_v : icon_usb_p )
        width: 100
        anchors{ top: parent.top; bottom: parent.bottom; left: parent.left }
        fillMode: Image.PreserveAspectCrop
        visible: true
    }

    Item
    {
        id: gauge_transfer
        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: false
        visible:  true
        width :536
        height: 100
        property int dot_idx:parent.dot_idx;
        anchors{top: parent.top; left: usb_icon.right}

        Timer
        {
            id: image_timer
            interval: 200; running:true ; repeat: true 
            onTriggered: 
            {
                if(parent.dot_idx > 15)
                	   parent.dot_idx = 0;
                else
                    parent.dot_idx++;
            }
        }
        Image
        {
            id: dot_0
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==0)? icon_dot_s:icon_dot_n
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_1
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==1)? icon_dot_s:icon_dot_n
            anchors.left: dot_0.left
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_2
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==2)? icon_dot_s:icon_dot_n
            anchors.left: dot_1.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_3
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==3)? icon_dot_s:icon_dot_n
            anchors.left: dot_2.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_4
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==4)? icon_dot_s:icon_dot_n // modified by ravikanth 02-07-13 for ITS 0177763
            anchors.left: dot_3.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_5
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==5)? icon_dot_s:icon_dot_n
            anchors.left: dot_4.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_6
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==6)? icon_dot_s:icon_dot_n
            anchors.left: dot_5.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_7
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==7)? icon_dot_s:icon_dot_n
            anchors.left: dot_6.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_8
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==8)? icon_dot_s:icon_dot_n
            anchors.left: dot_7.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_9
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==9)? icon_dot_s:icon_dot_n
            anchors.left: dot_8.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_10
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==10)? icon_dot_s:icon_dot_n
            anchors.left: dot_9.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_11
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==11)? icon_dot_s:icon_dot_n
            anchors.left: dot_10.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_12
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==12)? icon_dot_s:icon_dot_n
            anchors.left: dot_11.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_13
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 28; height: 36
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==13)? icon_dot_s:icon_dot_n
            anchors.left: dot_12.right
            anchors.top: parent.top
            anchors.topMargin: 32
        }
        Image
        {
            id: dot_14
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 44; height: 56
            fillMode: Image.PreserveAspectCrop
            source:(parent.dot_idx==14)? icon_arrow_s:icon_arrow_n
            anchors.left: dot_13.right
            anchors.top: parent.top
            anchors.topMargin: 22
        }
        Image
        {
            id: dot_15
            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: false
            width: 100
            fillMode: Image.PreserveAspectCrop
            anchors.left: dot_14.right
            anchors.top: parent.top
            visible:true
            source:
            {
                //(iconType==0) ? icon_juke_a : ((iconType==1)? icon_juke_v : icon_juke_p)
                if (iconType==0)
                {
                    if (parent.dot_idx==15) return icon_juke_a
                    else return icon_juke_a_n
                }
                else if (iconType==1)
                {
                    if (parent.dot_idx==15) return icon_juke_v
                    else return icon_juke_v_n
                }
                else 
                {
                    if (parent.dot_idx==15) return icon_juke_p
                    else return icon_juke_p_n
                }
            }
        }
    }
}


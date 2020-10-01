/**
 * FileName: RadioMain.qml
 * Author: HYANG
 * Time: 2012-02
 *
 * - 2012-02 Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idRadioEPGQml
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    property string sxm_epg_curlist: "left" //"right"
    property string sxm_epg_curcat : PLAYInfo.ChnCategory
    property string sxm_epg_curchn : ""
    property int    sxm_epg_chnindex : 0
    property int    sxm_epg_proindex : -1
    property string sxm_epg_curdate : UIListener.HandleGetCurrentDate()
    property Item topBand: idRadioEPGBand
    property bool    epglistMovingState : false

    //****************************** # SXM Radio - Title area #
    MComp.MBand {
        id: idRadioEPGBand
        x: 0; y: 0

        //****************************** # EPG Title #
        titleText: (gSXMEPGMode == "CATEGORY") ? stringInfo.sSTR_XMRADIO_CATEGORY : stringInfo.sSTR_XMRADIO_PROGRAM_GUIDE
        subTitleText: (gSXMEPGMode == "CATEGORY") ? "" : sxm_epg_curcat
        subTitleTextColor: Qt.rgba(155/255, 164/255, 176/255, 1)
        subtitleEPGFlag: (gSXMEPGMode == "CATEGORY") ? false : true
        signalTextFlag: (gSXMEPGMode == "CATEGORY") ? false : true
        signalText: sxm_epg_curdate
        signalTextX: 644
        signalTextY: 19
        signalTextWidth: 149
        signalTextSize: 28
        signalTextAlies: "Right"
        signalTextColor: Qt.rgba(180/255, 191/255, 205/255, 1)

        //****************************** # Tab button OFF #
        tabBtnFlag: false
        reserveBtnFlag: false
        subBtnFlag: (gSXMEPGMode == "CATEGORY") ? false : true
        subBtnText: stringInfo.sSTR_XMRADIO_CATEGORY
        subBtnWidth: 190
        subBtnBgImage: imageInfo.imgFolderXMData+"btn_title_week_n.png"
        subBtnBgImageFocus: imageInfo.imgFolderXMData+"btn_title_week_f.png"
        subBtnBgImagePress: imageInfo.imgFolderXMData+"btn_title_week_p.png"
        menuBtnFlag: (gSXMEPGMode == "CATEGORY") ? false : true
        menuBtnText: stringInfo.sSTR_XMRADIO_MENU

        onSubBtnClicked: {
            if(gSXMEPGMode == "PROGRAM")
            {
                selectEPGCategory();
            }
        }

        onMenuBtnClicked: {
            if(gSXMEPGMode == "PROGRAM")
            {
                if((UIListener.epgChannelListCount() == 0) && (EPGInfo.handelEpgProgramListCount() == 0))
                    idRadioEPGBand.focus = true
                else
                    idEPGMainList.item.setForceFocusToProgram();

                setAppMainScreen( "AppRadioEPGMenu" , true);
            }
        }

        //****************************** # button clicked or key selected #
        onBackBtnClicked: {
            if(gSXMEPGMode == "CATEGORY")
                selectEPGMain();
            else
            {
                setEPGClose();
                setAppMainScreen( "AppRadioMain" , false);
            }
        }

        Keys.onPressed: {
            if(event.key == Qt.Key_Down)
            {
                if(gSXMEPGMode == "PROGRAM")
                {
                    if((UIListener.epgChannelListCount() == 0) && (EPGInfo.handelEpgProgramListCount() == 0))
                        idRadioEPGBand.focus = true
                    else
                        idEPGMainList.item.setForceFocusToProgram();
                }
                else //"CATEGORY"
                {
                    if(UIListener.epgCategoryListCount() == 0)
                        idRadioEPGBand.focus = true
                    else
                        idEPGMainFocusScope.focus = true
                }
            }
        }
    }

    FocusScope{
        id:idEPGMainFocusScope
        x:0; y:0;
        focus:true;

        Loader{
            id: idEPGMainList;
            focus: true;
            anchors.fill: parent;

            function hide()
            {
                idEPGMainList.visible = false;
            }
            function show()
            {
                idEPGMainList.source = "XMAudioEPGMainList.qml";
                idEPGMainList.visible = true;
                idEPGMainFocusScope.focus = true;
                idEPGMainList.focus = true;
                idEPGMainList.item.focus = true;
                initCheckEPGMainFocus(true);
                idEPGCategoryList.hide();
            }
        }

        Loader{
            id: idEPGCategoryList;
            anchors.fill: parent

            function hide()
            {
                idEPGCategoryList.visible = false;
            }
            function show()
            {
                idEPGCategoryList.source = "XMAudioEPGCategoryList.qml";
                idEPGCategoryList.visible = true;
                idEPGMainFocusScope.focus = true;
                idEPGCategoryList.focus = true;
                idEPGCategoryList.item.focus = true;
                idEPGMainList.hide();
            }
        }
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        console.log("XMAudioEPG - BackKey Clicked")
        if(gSXMEPGMode == "CATEGORY")
            selectEPGMain();
        else
        {
            setEPGClose();
            setAppMainScreen( "AppRadioMain" , false);
        }
    }
    /* CCP Home Key */
    onHomeKeyPressed: {
        console.log("XMAudioEPG - HomeKey Clicked");
        setEPGClose();
        UIListener.HandleHomeKey();
    }
    /* CCP Menu Key */
    onClickMenuKey: {
        console.log("XMAudioEPG - MenuKey Clicked");
        if(gSXMEPGMode == "PROGRAM")
        {
            idAppMain.releaseTouchPressed();
            if((UIListener.epgChannelListCount() == 0) && (EPGInfo.handelEpgProgramListCount() == 0))
                idRadioEPGBand.focus = true
            else
                idEPGMainList.item.setForceFocusToProgram();

            setAppMainScreen( "AppRadioEPGMenu" , true);
        }
    }

    //****************************** # Function #
    function setEPGClose()
    {
        idEPGMainList.hide();
        idEPGCategoryList.hide();
        UIListener.HandleSetTuneKnobKeyOperation(0);
        UIListener.HandleSetSeekTrackKeyOperation(0);
    }

    function setEPGCategory(category)
    {
        sxm_epg_curcat = category;
    }

    function setEPGChannel(channel)
    {
        sxm_epg_curchn = channel;
    }

    function setEPGCurrentDate()
    {
        sxm_epg_curdate = UIListener.HandleGetCurrentDate();
    }

    function selectEPGMain()
    {
        gSXMEPGMode = "PROGRAM";
        UIListener.HandleSetTuneKnobKeyOperation(2);
        UIListener.HandleSetSeekTrackKeyOperation(2);
        idEPGMainList.show();
    }

    function selectEPGCategory()
    {
        gSXMEPGMode = "CATEGORY";
        UIListener.HandleSetTuneKnobKeyOperation(9);
        UIListener.HandleSetSeekTrackKeyOperation(9);
        idEPGCategoryList.show();
    }

    function initCheckEPGMainFocus(selected)
    {
        if(UIListener.epgChannelListCount() == 0 && EPGInfo.handelEpgProgramListCount() == 0)
        {
            idRadioEPGBand.focus =true;
            idRadioEPGBand.forceActiveFocus();
            return true;
        }
        idEPGMainList.item.initEPGMainFocusPosition(selected);
    }
}

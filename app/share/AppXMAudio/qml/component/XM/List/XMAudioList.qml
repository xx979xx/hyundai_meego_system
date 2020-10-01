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
    id: idRadioListQml
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    //************************************************************************* # Property, State #
    state: (gSXMListMode == "LIST") ? "LIST" : "SKIP"

    property string sxm_list_curlist: "left" //"right"
    property string sxm_list_currchn : ""
    property int    sxm_list_catindex : 0
    property int    sxm_list_chnindex : 0
    property int    sxm_list_currcatindex  : 0
    property Item topBand: idRadioListBand
    property bool changeCategoryInChannelListByTimer: false

    property string bandSubSkipTitleTextColor: colorInfo.blue
    
    //************************************************************************* # Title area #
    MComp.MBand {
        id: idRadioListBand
        x: 0; y: 0

        titleText: (gSXMListMode == "SKIP") ? (stringInfo.sSTR_XMRADIO_SKIP_CHANNEL) : stringInfo.sSTR_XMRADIO_CHANNEL_LIST
        tabBtnFlag: false
        reserveBtnFlag: false
        subBtnFlag: false
        menuBtnFlag: (gSXMListMode == "SKIP") ? false : true
        menuBtnText: stringInfo.sSTR_XMRADIO_MENU

        subSkipTitleText: (gSXMListMode == "SKIP") ? "("+idAppMain.sxm_list_skipcount+")" : ""
        subSkipTitleTextColor: bandSubSkipTitleTextColor
        subSkipTitleTextSize: 30

        onMenuBtnClicked: {
            stopCategoryListTimerOnly();
            if(gSXMListMode == "LIST")
            {
                if(idRadioSkipList.listSkipListCount == 0)
                {
                    idAppMain.isSkipChannelListEmpty = false
                }
                else
                {
                    idAppMain.isSkipChannelListEmpty = true
                }

                setListForceFocusChannelListPosition();
                setAppMainScreen( "AppRadioListMenu" , true);
            }
        }
        onBackBtnClicked: {
            if(gSXMListMode == "SKIP")
                setListList();
            else
            {
                setListClose();
                setAppMainScreen( "AppRadioMain" , false);
            }
        }

        Keys.onPressed: {
            if(event.key == Qt.Key_Down)
            {
                if(gSXMListMode == "SKIP")
                    idRadioListSkipDisplay.focus = true;
                else
                {
                    if((idRadioCategoryList.listCategoryListCount == 0) && (idRadioChannelList.listChannelListCount == 0))
                        idRadioListBand.focus = true;
                    else
                        setListForceFocusChannelListPosition();
                }
            }
        }

        onTuneLeftKeyPressed: {
            if(idRadioListBand.activeFocus && gSXMListMode == "LIST")
            {
                if(!(UIListener.HandleGetShowPopupFlag() == true) && !(idAppMain.state == "PopupRadioWarning1Line"))
                {
                    setListForceFocusChannelListOrBand();
                }
            }
        }
        onTuneRightKeyPressed: {
            if(idRadioListBand.activeFocus && gSXMListMode == "LIST")
            {
                if(!(UIListener.HandleGetShowPopupFlag() == true) && !(idAppMain.state == "PopupRadioWarning1Line"))
                {
                    setListForceFocusChannelListOrBand();
                }
            }
        }
    }

    //************************************************************************* # List(Channel List) #
    MComp.MComponent{
        id:idRadioListMainDisplay

        //************************************************************************* # Background Image #
        Image{
            x: 0; y: systemInfo.titleAreaHeight; z: 0
            visible: (gSXMListMode == "LIST") ? true : false
            Image{
                x: 0; y: 0
                source: imageInfo.imgFolderGeneral+"bg_menu_l.png"
                visible: (sxm_list_curlist ==  "left") ? true : false
            }
            Image {
                x:0; y:0
                source: imageInfo.imgFolderGeneral+"bg_menu_r.png"
                visible: (sxm_list_curlist ==  "left") ? false : true
            }
        }
        Image{
            x: 0; y: systemInfo.titleAreaHeight; z: 0
            visible: (gSXMListMode == "LIST") ? true : false
            Image{
                x: 0; y: 0; z:3
                source: imageInfo.imgFolderGeneral+"bg_menu_l_s.png"
                visible: (sxm_list_curlist == "left") ? true : false
            }
            Image {
                x:585; y:0; z:3
                source: imageInfo.imgFolderGeneral+"bg_menu_r_s.png"
                visible: (sxm_list_curlist == "left") ? false : true
            }
        }

        // Category List
        XMAudioCategoryList{
            id: idRadioCategoryList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+9
            width: 585; height: systemInfo.contentAreaHeight-20

            Keys.onPressed: {
                if(event.key == Qt.Key_Right)
                {
                    if(idRadioChannelList.listChannelListCount > 0)
                    {
                        if(idRadioCategoryList.movementStartedListCategoryFlag == true)
                            idRadioCategoryList.movementStartedListCategoryFlag = false;

                        stopCategoryListTimer();
                    }
                    else
                    {
                        idRadioListMainDisplay.focus = true;
                        idRadioChannelList.focus = false;
                        idRadioCategoryList.focus = true;
                    }
                }
            }
            onActiveFocusChanged: { if(idRadioCategoryList.activeFocus) sxm_list_curlist = "left"; }
        }

        // Channel List
        XMAudioChannelList {
            id: idRadioChannelList
            x: 698; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+9
            width: systemInfo.lcdWidth-698; height: systemInfo.contentAreaHeight-20
            focus: true

            KeyNavigation.left: idRadioCategoryList
            onActiveFocusChanged: { if(idRadioChannelList.activeFocus) sxm_list_curlist = "right"; }
        }

        //************************************************************************* # Visual Cue#
        MComp.MVisualCue{
            id: idMVisualCue
            x: 560; y: 357-systemInfo.statusBarHeight; z: 10
            arrowUpFlag: (idAppMain.state == "AppRadioListMenu") ? false : idRadioCategoryList.activeFocus || idRadioChannelList.activeFocus ? true:false
            arrowDownFlag: (idAppMain.state == "AppRadioListMenu") ? false : idRadioListBand.activeFocus ? (idRadioCategoryList.listCategoryListCount == 0) ? false : true : false
            arrowRightFlag: (idAppMain.state == "AppRadioListMenu") ? false : idRadioCategoryList.activeFocus ? (idRadioChannelList.listChannelListCount == 0) ? false : true : false
            arrowLeftFlag: (idAppMain.state == "AppRadioListMenu") ? false : idRadioChannelList.activeFocus ? true:false
            visible: (gSXMListMode != "SKIP")
        }
    }

    //************************************************************************* # Skip List #
    MComp.MComponent{
        id:idRadioListSkipDisplay

        //Skip List
        XMAudioSkipList {
            id: idRadioSkipList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
            focus: true
        }
    }

    onVisibleChanged: {
        if (visible == true)
        {
            if((idRadioChannelList.listChannelListCount == 0) && (idRadioCategoryList.listCategoryListCount == 1))
            {
                idRadioCategoryList.forceActiveFocus();
            }
            else
            {
                idRadioChannelList.forceActiveFocus();
            }
        }
    }

    onBackKeyPressed: {
        if(gSXMListMode == "SKIP")
            setListList();
        else
        {
            setListClose();
            setAppMainScreen( "AppRadioMain" , false);
        }
    }
    onHomeKeyPressed: {
        setListClose();
        UIListener.HandleHomeKey();
    }
    onClickMenuKey: {
        if(gSXMListMode == "LIST")
        {
            if(idRadioSkipList.listSkipListCount == 0)
            {
                idAppMain.isSkipChannelListEmpty = false
            }
            else
            {
                idAppMain.isSkipChannelListEmpty = true
            }

            idAppMain.releaseTouchPressed();
            setListForceFocusChannelListPosition();
            setAppMainScreen( "AppRadioListMenu" , true);
        }
    }
    onStateChanged: {
        if(gSXMListMode != "SKIP") //Category, Channel List
        {
            if((idRadioChannelList.listChannelListCount == 0) && (idRadioCategoryList.listCategoryListCount == 0))
            {
                idRadioListBand.focus = true;
            }
            else
            {
                setListForceFocusChannelList();
            }
        }
        else //Skip List
        {
            if(idRadioSkipList.listSkipListCount > 0)
            {
                idRadioListSkipDisplay.focus = true;
                idRadioSkipList.aLISTSkipListModel.currentIndex = 0;
                idRadioSkipList.aLISTSkipListModel.positionViewAtIndex(0, ListView.Beginning);
                idRadioSkipList.focus = true;
            }
            else
            {
                idRadioListBand.focus = true;
            }
        }
    }

    //************************************************************************* # Function #
    function setListClose()
    {
        idRadioList.visible = false;
        idRadioCategoryList.stopListCategoryTimer();
        UIListener.HandleSetTuneKnobKeyOperation(0);
        UIListener.HandleSetSeekTrackKeyOperation(0);
    }

    function stopCategoryListTimer()
    {
        idRadioCategoryList.stopListCategoryTimer();
        if(idRadioCategoryList.aLISTCategoryModel.currentIndex != sxm_list_catindex)
        {
            sxm_list_catindex = idRadioCategoryList.aLISTCategoryModel.currentIndex;
            idRadioCategoryList.changeChannelListCategory(sxm_list_catindex);
            setListForceFocusChannelList();
        }
        else
        {
            if(changeCategoryInChannelListByTimer == true)
            {
                changeCategoryInChannelListByTimer = false;
                setListForceFocusChannelList();
            }
            else
            {
                setListForceFocusChannelListPosition();
            }
        }
    }

    function stopCategoryListTimerOnly()
    {
        idRadioCategoryList.stopListCategoryTimer();
    }

    function setChannelListReset()
    {
        idRadioChannelList.onListInitPos(true);
    }

    function setListCategory(category)
    {
        idAppMain.sxm_list_currcat = category;
    }

    function setListChannel(channel)
    {
        sxm_list_currchn = channel;
    }

    function setListList()
    {
        gSXMListMode = "LIST";
        UIListener.HandleSetTuneKnobKeyOperation(1);
        UIListener.HandleSetSeekTrackKeyOperation(1);
        UIListener.HandleSetListMode(gSXMListMode);
    }

    function setListSkip()
    {
        gSXMListMode = "SKIP";
        UIListener.HandleSetTuneKnobKeyOperation(8);
        UIListener.HandleSetSeekTrackKeyOperation(8);
        UIListener.HandleSetListMode(gSXMListMode);
    }

    function setListForceFocusCategoryList()
    {
        if((idRadioChannelList.listChannelListCount == 0) && (idRadioCategoryList.listCategoryListCount == 0))
        {
            idRadioListBand.focus = true;
        }
        else
        {
            if(idRadioCategoryList.listCategoryListCount > 0)
            {
                idRadioListMainDisplay.focus = true;
                idRadioChannelList.focus = false;
                idRadioCategoryList.focus = true;
            }
            else
            {
                setListForceFocusChannelList();
            }
        }
    }

    function setListForceFocusChannelList()
    {
        if((idRadioChannelList.listChannelListCount == 0) && (idRadioCategoryList.listCategoryListCount == 0))
        {
            idRadioListBand.focus = true;
        }
        else
        {
            if(idRadioChannelList.listChannelListCount > 0)
            {
                idRadioChannelList.onListInitPos(false);

                idRadioListMainDisplay.focus = true;
                idRadioCategoryList.focus = false;
                idRadioChannelList.forceActiveFocus();
            }
            else
            {
                idRadioListMainDisplay.focus = true;
                idRadioCategoryList.forceActiveFocus();
            }
        }
    }

    function setListForceFocusChannelListPosition()
    {
        if((idRadioChannelList.listChannelListCount == 0) && (idRadioCategoryList.listCategoryListCount == 0))
        {
            idRadioListBand.focus = true;
        }
        else
        {
            if(idRadioChannelList.listChannelListCount > 0)
            {
                idRadioChannelList.onListPosUpdate();

                idRadioListMainDisplay.focus = true;
                idRadioCategoryList.focus = false;
                idRadioChannelList.forceActiveFocus();
            }
            else
            {
                idRadioListMainDisplay.focus = true;
                idRadioCategoryList.forceActiveFocus();
            }
        }
    }

    function setListForceFocusChannelListOrBand()
    {
        if(idRadioChannelList.listChannelListCount > 0)
        {
            idRadioChannelList.onListPosUpdate();

            idRadioListMainDisplay.focus = true;
            idRadioCategoryList.focus = false;
            idRadioChannelList.forceActiveFocus();
        }
        else
        {
            idRadioListBand.focus = true;
        }
    }

    function setListTuneEnter()
    {
        if(idRadioChannelList.listChannelListCount > 0)
            idRadioChannelList.setChannelListTuneEnter();
    }

    function setListTuneLeft()
    {
        if(idRadioChannelList.listChannelListCount > 0)
            idRadioChannelList.setChannelListTuneLeft();
    }
    function setListTuneRight()
    {
        if(idRadioChannelList.listChannelListCount > 0)
            idRadioChannelList.setChannelListTuneRight();
    }

    //************************************************************************* # Timer #
    Timer {
        id: changeListCategoryTimer
        interval: 250
        running: false
        repeat: false
        onTriggered: idRadioCategoryList.changeListCategoryList();
    }

    //************************************************************************* # States #
    states: [
        State{
            name: "LIST"
            PropertyChanges{target: idRadioListSkipDisplay; opacity: 0; focus: false}
            PropertyChanges{target: idRadioListMainDisplay; opacity: 1; focus: true}
        },
        State{
            name: "SKIP"
            PropertyChanges{target: idRadioListMainDisplay; opacity: 0; focus: false}
            PropertyChanges{target: idRadioListSkipDisplay; opacity: 1; focus: true}
        }
    ]

    transitions: [
        Transition{
            ParallelAnimation{ PropertyAnimation{properties: "opacity"; duration: 0; easing.type: "InCubic"} }
        }
    ]
}

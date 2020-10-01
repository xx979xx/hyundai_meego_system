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
    id: idRadioFeaturedFavoritesQml
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    property string sxm_ffavorites_curlist: "left" //"right"
    property string sxm_ffavorites_curband : stringInfo.sSTR_XMRADIO_All_CHANNELS
    property string sxm_ffavorites_bandcont : ""
    property int    sxm_ffavorites_bandindex : 0
    property int    sxm_ffavorites_bandcontindex : 0
    property Item topBand: idRadioFeaturedFavoritesBand
    property bool changeBandInFFByTimer: false

    //****************************** # SXM Radio - Title area #
    MComp.MBand {
        id: idRadioFeaturedFavoritesBand
        x: 0; y: 0

        //****************************** # XM List Title #
        titleText: stringInfo.sSTR_XMRADIO_FEATURED_FAVORITE

        //****************************** # Tab button OFF #
        tabBtnFlag: false
        reserveBtnFlag: false
        subBtnFlag: false
        menuBtnFlag: false

        //****************************** # button clicked or key selected #
        onBackBtnClicked: {
            setFeaturedFavoritesClose();

            if(idAppMain.prevScreeID == "AppRadioList")
                setAppMainScreen( "AppRadioList" , false);
            else
                setAppMainScreen( "AppRadioMain" , false);
        }

        Keys.onPressed: {
            if(event.key == Qt.Key_Down)
            {
                if((idRadioBandList.featuredFavoritesBandListCount == 0) && (idRadioBandContList.featuredFavoritesBandContListCount == 0))
                    idRadioFeaturedFavoritesBand.focus = true;
                else
                    changeFocusToContListPosition();
            }
        }

        onTuneLeftKeyPressed: {
            if(idRadioFeaturedFavoritesBand.activeFocus)
            {
                if(idAppMain.state == "AppRadioFeaturedFavorites" && !(UIListener.HandleGetShowPopupFlag() == true))
                {
                    changeFocusToContListOrBand();
                }
            }
        }
        onTuneRightKeyPressed: {
            if(idRadioFeaturedFavoritesBand.activeFocus)
            {
                if(idAppMain.state == "AppRadioFeaturedFavorites" && !(UIListener.HandleGetShowPopupFlag() == true))
                {
                    changeFocusToContListOrBand();
                }
            }
        }
    }

    //****************************** # SXM Radio - Display Area #
    MComp.MComponent{
        id:idRadioFeaturedFavoritesDisplay
        focus: true;

        //****************************** # Background Image #
        Image{
            x: 0; y: systemInfo.titleAreaHeight; z: 0
            visible: true
            Image{
                source: imageInfo.imgFolderGeneral+"bg_menu_l.png"
                visible: (sxm_ffavorites_curlist == "left") ? true : false
            }
            Image {
                source: imageInfo.imgFolderGeneral+"bg_menu_r.png"
                visible: (sxm_ffavorites_curlist == "left") ? false : true
            }
        }
        Image{
            x: 0; y: systemInfo.titleAreaHeight; z: 0
            visible: true
            Image{
                x: 0; y: 0; z:1
                source: imageInfo.imgFolderGeneral+"bg_menu_l_s.png"
                visible: (sxm_ffavorites_curlist == "left") ? true : false
            }
            Image {
                x:585; y:0; z:5
                source: imageInfo.imgFolderGeneral+"bg_menu_r_s.png"
                visible: (sxm_ffavorites_curlist == "left") ? false : true
            }
        }

        //****************************** # Band List #
        XMAudioBandList{
            id: idRadioBandList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+9
            width: 585; height: systemInfo.contentAreaHeight-20

            Keys.onPressed: {
                if(event.key == Qt.Key_Right)
                {
                    if(idRadioBandContList.featuredFavoritesBandContListCount > 0)
                    {
                        if(idRadioBandList.movementStartedFFBandFlag == true)
                            idRadioBandList.movementStartedFFBandFlag = false;

                        stopFeaturedFavoritesCategoryListTimer();
                    }
                    else
                    {
                        idRadioFeaturedFavoritesDisplay.focus = true;
                        idRadioBandList.focus = true;
                    }
                }
            }
            onActiveFocusChanged: { if(idRadioBandList.activeFocus) sxm_ffavorites_curlist = "left"; }
        }

        //****************************** # Band Contents List #
        XMAudioBandContList {
            id: idRadioBandContList
            x: 698; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+9
            width: systemInfo.lcdWidth-698; height: systemInfo.contentAreaHeight-20
            focus: true

            KeyNavigation.left: idRadioBandList
            onActiveFocusChanged: { if(idRadioBandContList.activeFocus) sxm_ffavorites_curlist = "right"; }
        }

        //****************************** # Visual Cue - list #
        MComp.MVisualCue{
            id: idMVisualCue
            x: 560; y: 357-systemInfo.statusBarHeight; z: 10
            arrowUpFlag: idRadioBandList.activeFocus || idRadioBandContList.activeFocus ? true:false
            arrowDownFlag: idRadioFeaturedFavoritesBand.activeFocus ? (idRadioBandList.featuredFavoritesBandListCount == 0) ? false : true : false
            arrowRightFlag: idRadioBandList.activeFocus ? (idRadioBandContList.featuredFavoritesBandContListCount == 0) ? false : true : false
            arrowLeftFlag: idRadioBandContList.activeFocus ? true:false
        }
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        setFeaturedFavoritesClose();
        if(idAppMain.prevScreeID == "AppRadioList")
            setAppMainScreen( "AppRadioList" , false);
        else
            setAppMainScreen( "AppRadioMain" , false);
    }
    /* CCP Home Key */
    onHomeKeyPressed: {
        setFeaturedFavoritesClose();
        UIListener.HandleHomeKey();
    }

    onVisibleChanged: {
        if(visible)
        {
            idRadioFeaturedFavoritesBand.giveForceFocus("backBtn");
            changeFFBandList(gFFavoritesBandIndex, false);

            if( (idRadioBandList.featuredFavoritesBandListCount == 0) && (idRadioBandContList.featuredFavoritesBandContListCount == 0))
            {
                idRadioFeaturedFavoritesBand.focus = true;
            }
            else
            {
                changeFocusToContList();
            }
        }
        else
        {
            sxm_ffavorites_bandindex =-1;
            gFFavoritesBandIndex = 0;
        }
    }

    //****************************** # Function #
    function setFeaturedFavoritesClose()
    {
        idRadioFeaturedFavorites.visible = false;
        idRadioBandList.stopFeaturedFavoritesTimer();
        FFManager.ffBandUpdateRebuildLater();
        UIListener.HandleSetTuneKnobKeyOperation(0);
        UIListener.HandleSetSeekTrackKeyOperation(0);
    }

    function stopFeaturedFavoritesCategoryListTimer()
    {
        idRadioBandList.stopFeaturedFavoritesTimer();
        if(idRadioBandList.aFFBandListModel.currentIndex != sxm_ffavorites_bandindex)
        {
            sxm_ffavorites_bandindex = idRadioBandList.aFFBandListModel.currentIndex
            changeFFBandList(sxm_ffavorites_bandindex, true);
            changeFocusToContList();
        }
        else
        {
            if(changeBandInFFByTimer == true)
            {
                changeBandInFFByTimer = false;
                changeFocusToContList();
            }
            else
            {
                changeFocusToContListPosition();
            }
        }
    }

    function setFeaturedFavoritesBand(band)
    {
        sxm_ffavorites_curband = band;
    }

    function setFeaturedFavoritesBandCont(bandcont)
    {
        sxm_ffavorites_bandcont = bandcont;
    }

    function changeFFBandList(currentIdx, selectband)
    {
        gFFavoritesBandIndex =  currentIdx;
        sxm_ffavorites_bandcontindex = 0;
        sxm_ffavorites_bandindex = currentIdx;
        if(selectband)
            idRadioBandContList.changeFFBandListIdx(currentIdx);
        changeFocusToContListReset();
    }

    function changeFocusToContListReset()
    {
        idRadioBandContList.onFFBandContInitPos(true);
    }

    function changeFocusToContList()
    {
        if((idRadioBandList.featuredFavoritesBandListCount == 0) && (idRadioBandContList.featuredFavoritesBandContListCount == 0))
        {
            idRadioFeaturedFavoritesBand.focus = true;
        }
        else
        {
            if(idRadioBandContList.featuredFavoritesBandContListCount > 0)
            {
                idRadioBandContList.onFFBandContInitPos(false);

                idRadioFeaturedFavoritesDisplay.focus = true;
                idRadioBandContList.forceActiveFocus();
            }
            else
            {
                idRadioFeaturedFavoritesDisplay.focus = true;
                idRadioBandList.forceActiveFocus();
            }
        }
    }

    function changeFocusToContListPosition()
    {
        if((idRadioBandList.featuredFavoritesBandListCount == 0) && (idRadioBandContList.featuredFavoritesBandContListCount == 0))
        {
            idRadioFeaturedFavoritesBand.focus = true;
        }
        else
        {
            if(idRadioBandContList.featuredFavoritesBandContListCount > 0)
            {
                idRadioBandContList.onFFBandContPosUpdate();

                idRadioFeaturedFavoritesDisplay.focus = true;
                idRadioBandContList.forceActiveFocus();
            }
            else
            {
                idRadioFeaturedFavoritesDisplay.focus = true;
                idRadioBandList.forceActiveFocus();
            }
        }
    }

    function changeFocusToContListOrBand()
    {
        if(idRadioBandContList.featuredFavoritesBandContListCount > 0)
        {
            idRadioBandContList.onFFBandContPosUpdate();

            idRadioFeaturedFavoritesDisplay.focus = true;
            idRadioBandContList.forceActiveFocus();
        }
        else
        {
            idRadioFeaturedFavoritesBand.focus = true;
        }
    }

    function setFFTuneEnter()
    {
        if(idRadioBandContList.featuredFavoritesBandContListCount > 0)
            idRadioBandContList.setFFContListTuneEnter();
    }
    function setFFTuneLeft()
    {
        if(idRadioBandContList.featuredFavoritesBandContListCount > 0)
            idRadioBandContList.setFFContListTuneLeft();
    }
    function setFFTuneRight()
    {
        if(idRadioBandContList.featuredFavoritesBandContListCount > 0)
            idRadioBandContList.setFFContListTuneRight();
    }

    //************************************************************************* # Timer #
    Timer {
        id: changeFeaturedFavoritesBandTimer
        interval: 250
        running: false
        repeat: false
        onTriggered: idRadioBandList.changeFeaturedFavoritesBandList();
    }
}

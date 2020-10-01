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
    id: idRadioSearchQml
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    property int searchFlag : 0
    property string xm_search_number : ""
    property bool   xm_search_find : false

    //****************************** # Background Image #
    Image{
        x: 0; y: systemInfo.titleAreaHeight;
        Image {
            source: imageInfo.imgFolderGeneral+"bg_menu_r.png"
        }
        Image {
            x:585
            source: imageInfo.imgFolderGeneral+"bg_menu_r_s.png"
        }
    }

    //****************************** # SXM Radio - Title area #
    MComp.MBand {
        id: idRadioSearchBand
        x: 0; y: 0

        //****************************** # XM List Title #
        titleText: stringInfo.sSTR_XMRADIO_DIRECT_TUNE

        //****************************** # Tab button OFF #
        tabBtnFlag: false
        reserveBtnFlag: false
        subBtnFlag: false
        menuBtnFlag: false

        //****************************** # button clicked or key selected #
        onBackBtnClicked: {
            console.log("### Direct Tune - BackKey Clicked ###")
            setAppMainScreen( "AppRadioMain" , false);
        }

        KeyNavigation.down: ((searchFlag & 0x03ff) || (xm_search_find == true) || (xm_search_number != "")) ? idRadioSearchDisplay : null
    }

    //****************************** # SXM Radio - Display Area #
    MComp.MComponent{
        id:idRadioSearchDisplay
        focus: true;

        //****************************** # Display Mode #
        XMAudioSearchText {
            id: idRadioSearchText
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
        }

        //****************************** # Preset ChannelList #
        XMAudioSearchKeyPad{
            id: idRadioSearchKeyPad
            x: 717; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
            focus: true

            KeyNavigation.up: idRadioSearchBand
        }
    }

    onVisibleChanged: {
        if(visible)
        {
            idRadioSearchBand.giveForceFocus("backBtn");
            idRadioSearchDisplay.focus = true;
            searchFlag = UIListener.HandleSmartFindChannel(xm_search_number);
            idRadioSearchKeyPad.getFocusDirectTune();
        }
        else
        {
            setSearchClose();
            idRadioSearchKeyPad.resetValue();
        }
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        console.log("Direct Tune - BackKey Clicked")
        setAppMainScreen( "AppRadioMain" , false);
    }

    //****************************** # Function #
    function setSearchClose()
    {
        idRadioSearch.visible = false;
        UIListener.HandleSetTuneKnobKeyOperation(0);
        UIListener.HandleSetSeekTrackKeyOperation(0);
    }

    function setFocusBackBtn()
    {
        idRadioSearchBand.giveForceFocus("backBtn");
        idRadioSearchBand.focus = true;
    }

    function onChangeValue(value) {
        xm_search_number = value;
        if( UIListener.HandleFindChannel(value) == true)
            xm_search_find = true
        else
            xm_search_find = false

        searchFlag = UIListener.HandleSmartFindChannel(xm_search_number);
        idRadioSearchKeyPad.getFocusDirectTune();
    }
}

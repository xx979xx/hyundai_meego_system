/**
 * FileName: DHAVN_AhaStationLeftMenuGroup.qml
 * Author: David.Bae
 * Time: 2012-04-26 21:00
 *
 * - 2012-04-26 Initial Created by David
 */
import Qt 4.7
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES

FocusScope{
    id: idLeftMenuFocusScope
    width: PR.const_AHA_PRESET_LEFT_MENU_BG_WIDTH
    height: PR.const_AHA_PRESET_LEFT_MENU_BG_HEIGHT

    property int countOfButton: 4

    property alias button1Text: idButton1.firstText
    property alias button2Text: idButton2.firstText

    property alias button1Active: idButton1.active;
    property alias button2Active: idButton2.active;
    //hsryu added
    property alias button1FocusVisible : idButton1.focusImageVisible
    property alias button2FocusVisible : idButton2.focusImageVisible
//wsuk.kim 130816 ITS_0182685 depress when pressed with CCP/Tune Knob
    property alias button1Press : idButton1.pressImageVisible
    property alias button2Press : idButton2.pressImageVisible
//wsuk.kim 130816 ITS_0182685 depress when pressed with CCP/Tune Knob
    signal button1Clicked();
    signal button2Clicked();

    //Menu bg image
    Image{
        id:idLeftMenuBgImage
        source: PR_RES.const_APP_AHA_STATION_LIST_LEFT_TAB_BG;
    }

    function getBgImageName(buttonNumber, type)
    {
        if(countOfButton == 2)
        {
            if(buttonNumber==4 || buttonNumber==3)
                return "";
            return PR_RES.const_APP_AHA_IMGFOLDER + "station_tab_0"+buttonNumber+"_"+type+".png"
        }

        return "";
    }

    function getMenuHeight()
    {
        if(countOfButton == 4){
            return 138
        }else if(countOfButton == 3){
            return 185
        }else if(countOfButton == 2) {
            return 277
        }else if(countOfButton == 1) {
            return parent.height;
        }
        return parent.height;
    }
    function getFontX()
    {
        switch(countOfButton)
        {
        case 1: return 5;
        case 2: return 5;
        }
        return 47
    }
    function getFontY()
    {
        switch(countOfButton)
        {
        case 1: return 160;
        case 2: return 158;
        }
        return 69;
    }

    Connections
    {
        target: ahaController

        onBackground:
        {
            leftMenuButton1Press = false;
            leftMenuButton2Press = false;
        }
    }

    // Button 1
    DHAVN_AhaStationButton{
        id: idButton1
        y:0
        width: PR.const_AHA_STATION_LEFT_MENU_BUTTON_WIDTH;
        height: getMenuHeight()

        fgImageX: PR.const_AHA_STATION_LEFT_MENU_BUTTON_FG_IMAGE_X
        fgImageY: PR.const_AHA_STATION_LEFT_MENU_BUTTON_FG_IMAGE_Y
        fgImageWidth: PR.const_AHA_STATION_LEFT_MENU_BUTTON_FG_IMAGE_WIDTH
        fgImageHeight: PR.const_AHA_STATION_LEFT_MENU_BUTTON_FG_IMAGE_HEIGHT

        fgImage: PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_PRESET_ICON_P    //wsuk.kim 131010 leftmenu text color change from grey to white.    const_APP_AHA_STATION_LIST_LEFT_BUTTON_PRESET_ICON_N
        fgImagePress: PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_PRESET_ICON_P
        fgImageFocus: PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_PRESET_ICON_F
        fgImageFocusPress: PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_PRESET_ICON_P
        fgImageActive: button1FocusVisible? PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_PRESET_ICON_F : PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_PRESET_ICON_S   //wsuk.kim 131203 ITS_212562 selected-focus color change bright grey.

        bgImage:            ""
        bgImagePress:       getBgImageName("1", "p");
        bgImageFocus:       getBgImageName("1", "f");
        bgImageFocusPress:  getBgImageName("1", "fp");
//        bgImageActive:      getBgImageName("1", "s");

        firstText: "Button1"
        firstTextX: getFontX()  //wsuk.kim 130827 station list leftmenu text position
        firstTextY: getFontY()
        firstTextWidth: PR.const_AHA_STATION_LEFT_MENU_BUTTON_TEXT_WIDTH
        firstTextSize: PR.const_AHA_STATION_LEFT_MENU_BUTTON_TEXT_SIZE
        firstTextColor: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY //wsuk.kim 131010 leftmenu text color change from grey to white.    const_AHA_COLOR_TEXT_DIMMED_GREY//colorInfo.dimmedGrey
        firstTextPressColor : PR.const_AHA_COLOR_TEXT_BRIGHT_GREY//colorInfo.brightGrey
        firstTextFocusPressColor : colorInfo.brightGrey
        firstTextSelectedColor: button1FocusVisible? PR.const_AHA_COLOR_TEXT_BRIGHT_GREY : PR.const_AHA_COLOR_TEXT_CURR_STATION    //wsuk.kim 131203 ITS_212562 selected-focus color change bright grey.
        firstDimmedTextColor: PR.const_AHA_COLOR_TEXT_DIMMED_GREY//"red"
        firstTextStyle: button1Active? PR.const_AHA_FONT_FAMILY_HDB: PR.const_AHA_FONT_FAMILY_HDR   //wsuk.kim 130930 selected item, change from HDR to HDB.
        firstTextAlies: "Center"    //wsuk.kim 130827 station list leftmenu text position

        visible:(countOfButton==1) || (countOfButton==2) || (countOfButton == 3) || (countOfButton == 4)
        onClickOrKeySelected:{
            button1Clicked();
        }
        focus:true;
    }

    Image {
        y: idButton1.height
        source: PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_SEPARATE
    }

    // Button 2
    DHAVN_AhaStationButton{
        id: idButton2
        y:idButton1.y + idButton1.height
        width: PR.const_AHA_STATION_LEFT_MENU_BUTTON_WIDTH;
        height: getMenuHeight()

        fgImageX: PR.const_AHA_STATION_LEFT_MENU_BUTTON_FG_IMAGE_X
        fgImageY: PR.const_AHA_STATION_LEFT_MENU_BUTTON_FG_IMAGE_Y
        fgImageWidth: PR.const_AHA_STATION_LEFT_MENU_BUTTON_FG_IMAGE_WIDTH
        fgImageHeight: PR.const_AHA_STATION_LEFT_MENU_BUTTON_FG_IMAGE_HEIGHT

        fgImage: PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_LBS_ICON_P   //wsuk.kim 131010 leftmenu text color change from grey to white.   const_APP_AHA_STATION_LIST_LEFT_BUTTON_LBS_ICON_N
        fgImagePress: PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_LBS_ICON_P
        fgImageFocus: PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_LBS_ICON_F
        fgImageFocusPress: PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_LBS_ICON_P
        fgImageActive: button2FocusVisible? PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_LBS_ICON_F : PR_RES.const_APP_AHA_STATION_LIST_LEFT_BUTTON_LBS_ICON_S //wsuk.kim 131203 ITS_212562 selected-focus color change bright grey.

        bgImage:            ""
        bgImagePress:       getBgImageName("2", "p");
        bgImageFocus:       getBgImageName("2", "f");
        bgImageFocusPress:  getBgImageName("2", "fp");
//        bgImageActive:      getBgImageName("2", "s");

        firstText: "Button2"
        firstTextX: getFontX()  //wsuk.kim 130827 station list leftmenu text position
        firstTextY: getFontY()
        firstTextWidth: PR.const_AHA_STATION_LEFT_MENU_BUTTON_TEXT_WIDTH
        firstTextSize: PR.const_AHA_STATION_LEFT_MENU_BUTTON_TEXT_SIZE
        firstTextColor: PR.const_AHA_COLOR_TEXT_BRIGHT_GREY //wsuk.kim 131010 leftmenu text color change from grey to white.    const_AHA_COLOR_TEXT_DIMMED_GREY//colorInfo.dimmedGrey
        firstTextPressColor : PR.const_AHA_COLOR_TEXT_BRIGHT_GREY//colorInfo.brightGrey
        firstTextFocusPressColor : colorInfo.brightGrey
        firstTextSelectedColor: button2FocusVisible? PR.const_AHA_COLOR_TEXT_BRIGHT_GREY : PR.const_AHA_COLOR_TEXT_CURR_STATION //wsuk.kim 131203 ITS_212562 selected-focus color change bright grey.
        firstDimmedTextColor: PR.const_AHA_COLOR_TEXT_DIMMED_GREY//"red"
        firstTextStyle: button2Active? PR.const_AHA_FONT_FAMILY_HDB: PR.const_AHA_FONT_FAMILY_HDR   //wsuk.kim 130930 selected item, change from HDR to HDB.
        firstTextAlies: "Center"    //wsuk.kim 130827 station list leftmenu text position

        visible:(countOfButton==2) || (countOfButton == 3) || (countOfButton == 4)
        onClickOrKeySelected:{
            button2Clicked();
        }
    }
}

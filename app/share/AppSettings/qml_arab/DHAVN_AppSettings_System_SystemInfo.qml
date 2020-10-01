import QtQuick 1.1
import "DHAVN_AppSettings_General.js" as APP
import "DHAVN_AppSettings_Resources.js" as RES
import "./SimpleItems"
import "Components/ScrollingTicker"

DHAVN_AppSettings_FocusedItem{
    id: systemInfoMain
    anchors.top: parent.top
    anchors.topMargin: 78
    anchors.left: parent.left
    width: 570
    height: 535

    default_x: 0
    default_y: 0
    focus_x: 0
    focus_y: 0

    is_focusMovable: false

    function getIsLastIndex(itemNum)
    {
        var nItemIndex = getItemIndex(itemNum)
        if( nItemIndex == (list_model.count - 1) )
            return true
        else
            return false
    }

    function getItemIndex(itemNumber)
    {
        var retVal = -1;
        for(var index=0; index < list_model.count; index++)
        {
            if(list_model.get(index).itemNum == itemNumber)
            {
                retVal = index
                return retVal;
            }
        }

        return retVal
    }

    ListModel{
        id: list_model

        Component.onCompleted:
        {
            list_model.append({"itemNum":APP.const_SETTINGS_GENERAL_MODEL, "isVisible": true,
                                  verName: QT_TR_NOOP("STR_SETTING_SYSTEM_MODEL"),
                                  verInfo: qsTr(SystemInfo.Model)})
            list_model.append({"itemNum":APP.const_SETTINGS_GENERAL_SW_VERSION, "isVisible": true,
                                  verName: QT_TR_NOOP("STR_SETTING_SYSTEM_SW_VER"),
                                  verInfo: qsTr(SystemInfo.SWVersion)})
            if(SettingsStorage.isIBoxVariant)
            {
                list_model.append({"itemNum":APP.const_SETTINGS_GENERAL_IBOX_VERSION, "isVisible": SettingsStorage.isIBoxVariant,
                                      verName: QT_TR_NOOP("STR_SETTING_SYSTEM_IBOX_VER"),
                                      verInfo: qsTr(SystemInfo.IBoxVersion)})
            }

            if(SettingsStorage.isNaviVariant)
            {
                list_model.append({"itemNum":APP.const_SETTINGS_GENERAL_MAP_VERSION, "isVisible": SettingsStorage.isNaviVariant,
                                      verName: QT_TR_NOOP("STR_SETTING_SYSTEM_MAP_VER"),
                                      verInfo: qsTr(SystemInfo.MapVersion)})
                list_model.append({"itemNum":APP.const_SETTINGS_GENERAL_NAVI_APPLICATION,"isVisible": SettingsStorage.isNaviVariant,
                                      verName: QT_TR_NOOP("STR_SETTING_SYSTEM_NAVI_APPLICATION"),
                                      verInfo: qsTr(SystemInfo.AppVersion)})
            }

            list_model.append({"itemNum":APP.const_SETTINGS_GENERAL_GRACENOTE_SDK_VERSION, "isVisible": true,
                                  verName: QT_TR_NOOP("STR_SETTING_SYSTEM_GRACENOTE_SDK_VER"),
                                  verInfo: qsTr(SystemInfo.GraceNoteSDKVersion)})

            list_model.append({"itemNum":APP.const_SETTINGS_GENERAL_GRACENOTE_DB_VERSION, "isVisible": true,
                                  verName: QT_TR_NOOP("STR_SETTING_SYSTEM_GRACENOTE_DB_VER"),
                                  verInfo: qsTr(SystemInfo.GraceNoteDBVersion)})

            if(SettingsStorage.currentRegion != 0)
            {
                list_model.append({"itemNum":APP.const_SETTINGS_GENERAL_BT_MAC_ADDRESS, "isVisible": true,
                                      verName: QT_TR_NOOP("STR_SETTING_SYSTEM_BT_MAC_ADDRESS"),
                                      verInfo: qsTr(SystemInfo.BTMacAddress)})
            }
        }
    }

    DHAVN_AppSettings_FocusedItem{
        id: contentItem
        anchors.fill: parent

        default_x: 0
        default_y: 0
        focus_x: 0
        focus_y: 0
        clip: true

        Component{
            id: item_delegate
            DHAVN_AppSettings_FocusedItem{
                width: 544
                height: (list_model.count > 5) ? 107 : 104

                Image{
                    id: horizontal_line
                    visible: isVisible && !(getIsLastIndex(itemNum))
                    anchors.top:parent.top
                    anchors.topMargin: parent.height
                    anchors.left:parent.left
                    anchors.leftMargin: 79
                    source: RES.const_URL_IMG_SETTINGS_B_MENU_LINE
                }

                Text{
                    id: titleText
                    anchors.verticalCenter: parent.bottom
                    anchors.verticalCenterOffset: -72
                    anchors.left:horizontal_line.left
                    anchors.leftMargin: 24
                    width: 445
                    font.pointSize: 40
                    horizontalAlignment: Text.AlignRight
                    color: APP.const_COLOR_TEXT_BRIGHT_GREY
                    font.family: EngineListener.getFont(false)
                    text: qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, verName) + LocTrigger.empty
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                Text{
                    id: infoText
                    anchors.verticalCenter: parent.bottom
                    anchors.verticalCenterOffset: -23
                    anchors.left:horizontal_line.left
                    anchors.leftMargin: 24
                    width: /*445*/ (itemNum != APP.const_SETTINGS_GENERAL_IBOX_VERSION) ? 445 : 450 //modify for ITS 220511 ibox version size error
                    font.pointSize: 26
                    horizontalAlignment: Text.AlignRight
                    color: APP.const_APP_SETTINGS_MENU_ITEM_SELECTED_TEXT_COLOR
                    font.family: EngineListener.getFont(false)
                    text: verInfo
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    visible: !naviAppVerInfoText.bUsed
                }

                ScrollingTicker {
                    id: naviAppVerInfoText
                    height:parent.height
                    width: (itemNum != APP.const_SETTINGS_GENERAL_IBOX_VERSION) ? 445 : 450 //modify for ITS 220511 ibox version size error
                    scrollingTextMargin: 120
                    anchors.left:horizontal_line.left
                    anchors.leftMargin: 24
                    y: 32//63
                    isScrolling: ( isParkingMode && listOfSettings.focus_visible/*list_view.focus_visible && index == list_view.__current_index  */)
                    fontPointSize: 26
                    fontStyle: (isVideoMode) && (!isBrightEffectShow) ? Text.Outline : Text.Normal
                    clip: true
                    fontFamily: EngineListener.getFont(false)
                    text:(bUsed)? verInfo : ""
                    fontColor: APP.const_APP_SETTINGS_MENU_ITEM_SELECTED_TEXT_COLOR
                    property bool bUsed:(qsTranslate(APP.const_APP_SETTINGS_LANGCONTEXT, QT_TR_NOOP("STR_SETTING_SYSTEM_NAVI_APPLICATION")) + LocTrigger.empty == titleText.text)
                }
            }
        }

        DHAVN_AppSettings_System_SystemInfo_ListView{
            id: listOfSettings
            width: parent.width
            focus_x: 0
            focus_y: 0
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            anchors.left:parent.left
            snapMode: ListView.SnapToItem
            cacheBuffer: 10000
            clip: true
            model: list_model
            delegate:  item_delegate
            orientation: ListView.Vertical

            onFocus_visibleChanged:
            {
                if(focus_visible)
                    setVisualCue(true, false, false, true);
            }

            onMovementEnded:
            {
                if(!focus_visible)
                {
                    systemInfoMain.hideFocus()
                    systemInfoMain.setFocusHandle(0,0)
                    if(isShowSystemPopup == false)
                    {
                        systemInfoMain.showFocus()
                    }
                }
            }
        }

        DHAVN_AppSettings_SI_VerticalScrollBar{
            id: scrollbar
            anchors.top: parent.top
            anchors.topMargin: 33
            anchors.left: parent.left
            anchors.leftMargin: 15
            clip: true
            position: listOfSettings.visibleArea.yPosition
            pageSize: listOfSettings.visibleArea.heightRatio
            visible: ( pageSize < 1 )

            onPageSizeChanged:
            {
                if( pageSize < 1 )
                {
                    systemInfoMain.is_focusMovable = true
                }
                else
                {
                    systemInfoMain.is_focusMovable = false
                }
            }
        }
    }

    Connections {
        target: EngineListener

        onSigNaviSdcardRemoved: {
            SystemInfo.MapVersion = " "
            SystemInfo.AppVersion = " "
            SystemInfo.Association = " "

            var index = -1

            // Map
            index = getItemIndex(APP.const_SETTINGS_GENERAL_MAP_VERSION)
            if(index != -1)
                list_model.setProperty(index, "verInfo", " ");

            // Navi App
            index = getItemIndex(APP.const_SETTINGS_GENERAL_NAVI_APPLICATION)
            if(index != -1)
                list_model.setProperty(index, "verInfo", " ");

            // Association
            index = getItemIndex(APP.const_SETTINGS_GENERAL_ASSOCIATION)
            if(index != -1)
                list_model.setProperty(index,  "verInfo", " ");
        }
    }
}

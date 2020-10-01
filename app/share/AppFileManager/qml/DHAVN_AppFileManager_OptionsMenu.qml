import QtQuick 1.0
import com.filemanager.uicontrol 1.0
import QmlOptionMenu 1.0

DHAVN_AppFileManager_FocusedItemNew
{
    id: root

    name: "OptionsMenu"
    visible: false

    function show()
    {
        EngineListener.sendTouchCleanUpForApps();
       root.visible = true
       menu.visible = true
       menu.show() // added by Sergey 02.08.2103 for ITS#181512
       menu.showFocus() // added by Dmitry 03.05.13
    }

    function hide()
    {
       menu.hide()
    }

    function quickHide()
    {
        menu.quickHide() // added by Sergey 02.08.2103 for ITS#181512
    } 

    onVisibleChanged:
    {
        if (visible)
            mainScreen.focus_default = 5 // focus is taken by menu
        // {added by Michael.Kim 2014.01.25 for ITS 221044
        else if (mainScreen.currentLoaderCount == 0)
            mainScreen.focus_default = 4
        // }added by Michael.Kim 2014.01.25 for ITS 221044
        else
            mainScreen.focus_default = 2 // return focus to content
    }

    OptionMenu
    {
        id :menu

        menumodel: FmMenu.optionMenuModel
        middleEast: EngineListener.middleEast // modified by Dmitry 03.05.13
        scrollingTicker: EngineListener.scrollingTicker  // [KOR][ISV][64532][C] by aettie 20130628

        property int focus_x: 0
        property int focus_y: 0
        property string name: "OptionMenu"
        visible: false
        focus_visible: true //added by aettie.ji 2013.05.02 for option menu default focus

        autoHiding: true   // added by lyg 2012.08.28 for CR 12846
        autoHideInterval: 10000   // modified by Sergey 01.08.2013


        onBeep: UIListener.ManualBeep(); // added by Sergey 02.11.2013 for ITS#205776

        onTextItemSelect:
        {
// added by Dmitry 17.07.13 for ITS0177790
            if (itemId != 0) // 0 is now playing item ID
            {
               menu.quickHide(); // modified by Sergey 06.08.2013
            }
            FmMenu.HandleOptionMenu(itemId, 0)
// added by Dmitry 17.07.13 for ITS0177790
        }

        onIsHidden:
        {
           menu.visible = false
           root.visible = false
        }
 // [KOR][ISV][64532][C] by aettie 20130628
    Connections
    {
        target:EngineListener
        onTickerChanged:
        {
            EngineListener.qmlLog("onTickerChanged ticker(fileManager option) : " + ticker);
            menu.scrollingTicker = ticker;
        }
    }

    }
}
// modified by Dmitry 26.04.13

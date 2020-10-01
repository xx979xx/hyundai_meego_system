import QtQuick 1.1
import "DHAVN_AppSettings_General.js" as APP

Item{
    id: pageStack

    function push(rootState, nestedState)
    {
        //console.log("pageStackModel : push("+rootState+", "+nestedState+")")
        pageStackModel.append({"rootState": rootState,  "nestedState": nestedState})

        /*
        for(var i=0; i<pageStackModel.count; i++)
        {
            console.log("pageStackModel.get("+i+").rootState:"+pageStackModel.get(i).rootState)
            console.log("pageStackModel.get("+i+").nestedState:"+pageStackModel.get(i).nestedState)
        }
        */
    }

    function pop()
    {
        if( pageStackModel.count > 0)
        {
            pageStackModel.remove(pageStackModel.count-1)
        }
        /*
        else
        {
            console.log("Error!! pop() is unable")
        }
        */
    }

    function getLastItemIndex()
    {
        //console.log("getLastItemIndex() : "+(pageStackModel.count-1))
        if( pageStackModel.count > 0)
        {
            return pageStackModel.count-1
        }
    }

    // Update property-value
    function setPageStackProperty(pageIndex, propertyName, value)
    {
        //console.log("pageStackModel : setPageStackProperty()")
        if(pageStackModel.count > 0)
        {
            pageStackModel.setProperty(pageIndex, propertyName, value)

            /*
            for(var i=0; i<pageStackModel.count; i++)
            {
                console.log("pageStackModel.get("+i+").rootState:"+pageStackModel.get(i).rootState)
                console.log("pageStackModel.get("+i+").nestedState:"+pageStackModel.get(i).nestedState)
            }
            */
        }
        /*
        else
            console.log("pageStackModel.count is 0")
        */
    }

    // Get List Item
    function getRootState(index)
    {
        //console.log("pageStackModel : getRootState("+index+"):"+pageStackModel.get(index).rootState)
        return pageStackModel.get(index).rootState
    }

    function getNestedState(index)
    {
        //console.log("pageStackModel : getNestedState("+index+"):"+pageStackModel.get(index).nestedState)
        return pageStackModel.get(index).nestedState
    }

    // Get Loader By State
    function getLoaderByStateName(stateName)
    {
        //console.log("pageStackModel : getLoaderByStateName("+stateName+")")
        switch(stateName)
        {
        case APP.const_APP_SETTINGS_MAIN_STATE_SOUND:
            return audio_loader;
        case APP.const_APP_SETTINGS_MAIN_STATE_SCREEN:
            return screen_loader;
        //added for DHPE DRS
        case APP.const_APP_SETTINGS_MAIN_STATE_SCREEN_DRS:
            return screenDRS_loader;
        case APP.const_APP_SETTINGS_MAIN_STATE_VOICE:
            return voice_loader;
        case APP.const_APP_SETTINGS_MAIN_STATE_SYSTEM:
            return system_loader;
        case APP.const_APP_SETTINGS_MAIN_STATE_CLOCK:
            return clock_loader;
        case APP.const_APP_SETTINGS_MAIN_STATE_GENERAL:
            return general_loader;
        case APP.const_APP_SETTINGS_MAIN_STATE_KEYPAD:
            return keypad_loader;
        }
    }

    function count()
    {
        //console.log("PageStack : size() : pageStackCount :"+pageStackModel.count)
        return pageStackModel.count;
    }

    function clearAll()
    {
        pageStackModel.clear()
        //console.log("PageStack : clearAll() : pageStackCount :"+pageStackModel.count)
    }

    ListModel
    {
        id: pageStackModel
    }

}

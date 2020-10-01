// { modified by Sergey 25.04.2013
import Qt 4.7
import "DHAVN_AppFileManager_General.js" as FM

Item
{
    width: FM.const_APP_FILE_MANAGER_SCREEN_WIDTH
    height: FM.const_APP_FILE_MANAGER_SCREEN_HEIGHT

    Loader { id: mainQml }

    Connections
    {
        target: EngineListener

        onLoadMainQml:
        {
            if(UIListener.getCurrentScreen() == screen)
                mainQml.source = "DHAVN_AppFileManager_main.qml"
        }
    }
}
// } modified by Sergey 25.04.2013

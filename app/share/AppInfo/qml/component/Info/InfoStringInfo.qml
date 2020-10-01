import QtQuick 1.0

Item {
    id:stringInfo

    // # Reference : DH VIT AVN UI Scenario_19_Info_Ver2.04_120302.pdf

    // GUIGL : 15.2.1 Autocare_Incon_menu
    property string strAutoCare                      :qsTr("Auto Care")        //Script 2012-03-23
    property string strAutoCareHeightInfo            :qsTr("Height Info")      //Script 2012-03-23
    property string strAutoCareDrivingMode           :qsTr("STR_Info_DrivingMode")
    property string strAutoCareCarSetting            :qsTr("Car Setting")      //Script 2012-03-23

    // # GUI   :  5.1.2 Vehicle Height
    // # GUIGL : 19.2.1 Car Height
    property string strAutoCareHeightNormal          :qsTr("Normal")           //Script 2012-03-23
    property string strAutoCareHeightLow             :qsTr("Low")              //Script 2012-03-23
    property string strAutoCareHeightHigh            :qsTr("High")             //Script 2012-03-23

    // # GUI   :  5.1.3.1 Driving Mode
    // # GUIGL : 19.2.2 Driving Mode
    property string strAutoCareDrivingSports         :qsTr("STR_NONAV_DRIVING_SPORTS")           //Script 2012-03-23
    property string strAutoCareDrivingNormal         :qsTr("STR_NONAV_DRIVING_NORMAL")           //Script 2012-03-23
    property string strAutoCareDrivingECO            :qsTr("STR_NONAV_DRIVING_ECO")              //Script 2012-03-23
    property string strAutoCareDrivingSnow           :qsTr("STR_NONAV_DRIVINGSNOW")             //Script 2012-03-23
    property string strAutoCareDrivingSportsMsg      :qsTr("STR_Info_strDrivingSportsMsg")       //Script 2012-04-02
    property string strAutoCareDrivingNormalMsg      :qsTr("STR_NONAV_DRIVING_NORMALMsg") //Script 2012-04-02
    property string strAutoCareDrivingECOMsg         :qsTr("STR_Info_strDrivingEcoMsg")           //Script 2012-04-02
    property string strAutoCareDrivingSnowMsg        :qsTr("STR_Info_strDrivingSNOWMsg")           //Script 2012-04-02

    function retranslateUi(languageId)
    {
        console.log("InfoStringInfo: retranslateUi");

        // GUIGL : 15.2.1 Autocare_Incon_menu
        strAutoCare                      =qsTr("Auto Care")                    //Script 2012-03-23
        strAutoCareHeightInfo            =qsTr("Height Info")                  //Script 2012-03-23
        strAutoCareDrivingMode           =qsTr("STR_Info_DrivingMode")                 //Script 2012-03-23
        strAutoCareCarSetting            =qsTr("Car Setting")                  //Script 2012-03-23

        // # GUI   :  5.1.2 Vehicle Height
        // # GUIGL : 19.2.1 Car Height
        strAutoCareHeightNormal          =qsTr("Normal")                       //Script 2012-03-23
        strAutoCareHeightLow             =qsTr("Low")                          //Script 2012-03-23
        strAutoCareHeightHigh            =qsTr("High")                         //Script 2012-03-23
    
        // # GUI   :  5.1.3.1 Driving Mode
        // # GUIGL : 19.2.2 Driving Mode
        strAutoCareDrivingSports         =qsTr("STR_NONAV_DRIVING_SPORTS")                       //Script 2012-03-23
        strAutoCareDrivingNormal         =qsTr("STR_NONAV_DRIVING_NORMAL")                       //Script 2012-03-23
        strAutoCareDrivingECO            =qsTr("STR_NONAV_DRIVING_ECO")                          //Script 2012-03-23
        strAutoCareDrivingSnow           =qsTr("STR_NONAV_DRIVINGSNOW")                         //Script 2012-03-23
        strAutoCareDrivingSportsMsg      =qsTr("STR_Info_strDrivingSportsMsg")       //Script 2012-04-02
        strAutoCareDrivingNormalMsg      =qsTr("STR_Info_strDrivingNormalMsg") //Script 2012-04-02
        strAutoCareDrivingECOMsg         =qsTr("STR_Info_strDrivingEcoMsg")           //Script 2012-04-02
        strAutoCareDrivingSnowMsg        =qsTr("STR_Info_strDrivingSNOWMsg")           //Script 2012-04-02
    } // End fuction

    Connections{
        target: uiListener
        onRetranslateUi:{
            LocTrigger.retrigger();
            stringInfo.retranslateUi(languageId);
        }
    } // End Connections
} // End Item

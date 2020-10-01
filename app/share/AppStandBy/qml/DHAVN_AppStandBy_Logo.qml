import Qt 4.7
import "DHAVN_AppStandBy_Images.js" as Images

Item
{
    id: standbyLogo
    anchors.fill: parent
    property int cv: UIListener.GetCountryVariantFromQML()
    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI

    Image
    {
       id: idGenesisLogo
       width: parent.width
       height: parent.height
       source: vehicleVariant == 1 ? (
                                         cv == 0 ? "/app/share/images/AppStandBy/KH_emblem_K9_UVO_8bit.png"      // Korea
                                                 : cv == 2 ?  "/app/share/images/AppStandBy/KH_emblem_KIA_UVO_8bit.png" // China
                                                           : "/app/share/images/AppStandBy/KH_emblem_KIA_8bit.png"                                            )
                                   : evv == 2 ? ( cv < 3 ?  "/app/share/images/AppStandBy/DH_PE_GENESIS_1280x720_bluelink.png"   : "/app/share/images/AppStandBy/DH_PE_GENESIS_1280x720.png"  )
                                                        : ( cv < 3 ?  "/app/share/images/AppStandBy/Logo_bluelink_On.png"   : "/app/share/images/AppStandBy/Logo_bluelink_Off.png" )
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        visible: cppToqml.IsBlackMode
    }
}

import Qt 4.7
import "DHAVN_AppStandBy_General.js" as General

Item
{
   id: mainScreen;
   width: 1280
   height: 720
   focus: true
   property int currentScreen: 1
   property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
   property int evv: EngineListener.getEvv()           //   HWTYPE_DH:  0, HWTYPE_15MY : 1, HWTYPE_DHPE: 2

   Connections {
       target:EngineListener
       onSetRearLogo: //( bool setRear , int screenId )
       {
           if ( screenId != UIListener.getCurrentScreen() )
               return;
           if ( setRear ) {
               standbyLogo.visible = true;
               idMain.visible = false
           }
           else {
               standbyLogo.visible = false
               idMain.visible = true
           }
       }
   }

   Item {
       id: standbyLogo
       anchors.fill: parent

       Image {
          width: parent.width
          height: parent.height
          property int cv: UIListener.GetCountryVariantFromQML()
          source: vehicleVariant == 1 ? (
                                            cv == 0 ? "/app/share/images/AppStandBy/KH_emblem_K9_UVO_8bit.png"      // Korea
                                            : cv == 2 ?  "/app/share/images/AppStandBy/KH_emblem_KIA_UVO_8bit.png" // China
                                            : "/app/share/images/AppStandBy/KH_emblem_KIA_8bit.png"                                            )
                                      : evv == 2 ? ( cv < 3 ?  "/app/share/images/AppStandBy/DH_PE_GENESIS_1280x720_bluelink.png"   : "/app/share/images/AppStandBy/DH_PE_GENESIS_1280x720.png"  )
                                                 : ( cv < 3 ?  "/app/share/images/AppStandBy/Logo_bluelink_On.png"   : "/app/share/images/AppStandBy/Logo_bluelink_Off.png" )

          Rectangle {
              anchors.fill: parent
              color: "black"
              visible: cppToqml.IsBlackMode
          }
       }
   }

   DHAVN_AppStandBy_Main {
       id: idMain; y: 0; visible: false
   }
   
}

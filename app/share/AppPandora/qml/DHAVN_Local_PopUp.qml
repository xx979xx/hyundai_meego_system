import Qt 4.7
import "DHAVN_AppPandoraConst.js" as PR
import CQMLLogUtil 1.0

Image
{
    id: popup

    visible:false
    //property int offset_y: -93

    property int offset_y: 0


    /** --- Input parameters --- */
    property ListModel message: ListModel {}
    property int typePopup: 0
    property int icon: 0
    property int max_text_width: 0
    property string logString :""

    function __LOG( textLog , level)
    {
       logString = "Local_PopUp.qml::" + textLog ;
       logUtil.log(logString , level);
    }

    function retranslateUI( context )
    {
       if (context) { __lang_context = context }
       __emptyString = " "
       __emptyString = ""
    }

    property string __lang_context: "main"
    property string __emptyString: ""

    /** --- Object property --- */
    /** Popup type */
    source: "/app/share/images/popup/bg_type_c.png";

    Component.onCompleted:
    {
        __LOG( " popup.width: " +  popup.width , LogSysID.LOW_LOG);
        if ( max_text_width > (popup.width - 50) ) { max_text_width = (popup.width - 50) }
//        if ( icon == EPopUp.LOADING_ICON )
//        {
//            if ( max_text_width > ( popup.width - 50  - animation.width - row1.spacing ) )
//                max_text_width -= animation.width + row1.spacing
//        }
        __LOG( " .max_text_width: " +  popup.max_text_width , LogSysID.LOW_LOG);
    }

    //anchors.centerIn: parent
    x: 259   // x cordinate as per spec
    y: 463 + offset_y  //y cordinate as per spec : 463 from start of screen ,
    //so deduct status bar height.
    z:1000

    /** --- Child object --- */

    Row
    {
        id: row1
        spacing: 35
        anchors.centerIn: parent
        height: col.height

        /** Loading icon */
        AnimatedImage
        {
            id: animation
//            source: RES.const_LOADING_IMG
//            anchors.verticalCenter: col.verticalCenter
//            visible: icon == EPopUp.LOADING_ICON ? true : false
        }

        /** Text message */
        Column
        {
            id: col
            spacing: 26
            width: max_text_width

            Repeater
            {
                model: message

                Loader
                {
                    sourceComponent: Text
                    {
                        id: dimmed_text
                        property bool painted: false
                        text: ( msg.substring(0, 4) == "STR_" ) ? qsTranslate( __lang_context, msg) + LocTrigger.empty : msg // modified by lssanh 2013.02.07 ISV72140
                        color: "#FAFAFA";
                        font.pixelSize: 36
                        font.family: PR.const_PANDORA_FONT_FAMILY_HDR
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        width:712
                        horizontalAlignment: Text.AlignHCenter
                        style : Text.Sunken
                        Binding
                        {
                            target: dimmed_text
                            property: "width"
                            value: max_text_width
                            when: painted
                        }
                    }
                    onLoaded:
                    {
                       if ( item.width > max_text_width ) { max_text_width = item.width }
                       item.painted = true
                    }
                 }
              }
    }
    }


}

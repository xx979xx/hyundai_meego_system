import Qt 4.7
import "DHAVN_MP_PopUp_Constants.js" as CONST
import "DHAVN_MP_PopUp_Resources.js" as RES

/** Text message */

Column
{
    id: super_text
    /** --- Input parameters --- */
    property ListModel txtModel: ListModel {}
    property bool txtOnly: false
    property bool use_icon: false
    property int alignment

    function retranslateUI( context )
    {
       if (context) { __lang_context = context }
       __emptyString = " "
       __emptyString = ""
    }

    property string __lang_context: CONST.const_LANGCONTEXT
    property string __emptyString: ""

    /** --- Child object --- */
    anchors.left: parent.left
    //anchors.top: parent.top
    anchors.verticalCenter: parent.verticalCenter
//    anchors.topMargin:{
//            if(use_icon == false ){
//                if(txtModel.count == 1) 152 - 28
//                else if( txtModel.count == 2) 130 -28
//                else if(txtModel.count == 3) 108 - 28
//                else if(txtModel.count == 4) 86 - 28
//            }else{
//                if(txtModel.count == 1) 50 + 170 - 28
//                else if( txtModel.count == 2) 50 + 148  - 28
//            }
//    }
    Repeater
    {
        model: txtModel

        delegate: Component
        {

        Text
            {
                id: id_text
                text: argstext(index)
                height: 44
                width:710
                anchors.left:parent.left
                anchors.leftMargin: 0 //57 //modified by lssanh 2013.02.05 ISV72350
                horizontalAlignment: alignment//use_icon == false ? Text.AlignLeft : Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color:  CONST.const_TEXT_COLOR_SUB_GREY
                font.pointSize:   CONST.const_TEXT_PT
                //font.family: CONST.const_TEXT_FONT_FAMILY
                font.family: CONST.const_TEXT_FONT_FAMILY_HDR_NEW//{ modified by yongkyun.lee 2013-11-08 for :ITS 207804
                wrapMode: Text.WordWrap
                style : Text.Sunken
//                states: [
//                    State
//                    {
//                        name: "Button"; when: ( txtOnly ==false )
//                        PropertyChanges { target: id_text; width: use_icon == false ? CONST.const_TEXT_AREA_WIDTH_LEFT_ALIGN: CONST.const_TEXT_AREA_WIDTH_CENTER_ALIGN }
//                        PropertyChanges { target: id_text; anchors.leftMargin:use_icon == false ? CONST.const_TEXT_LEFTALIGN_LEFT_MARGIN : CONST.const_TEXT_CENTERALIGN_LEFT_MARGIN}
//                    },
//                   State
//                    {
//                        name: "noButton"; when: ( txtOnly==true)
//                        PropertyChanges { target: id_text; width: use_icon == false ? CONST.const_TEXT_AREA_WIDTH_LEFT_ALIGN: parent.width }
//                        PropertyChanges { target: id_text; anchors.leftMargin:0}
//                    }
//                ]
            }//text

        }//delegate
    }//repeater


    function argstext(index)
    {
	//modified by aettie.ji 2013.02.06 for language setting
    	if (txtModel.get(index).msg.substring(0, 4) != "STR_" )
	{
            return txtModel.get(index).msg
	}
    	if(txtModel.get(index).arguments != undefined)
    	{
    		var translation = qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, txtModel.get(index).msg )
		for (var i = 0; i < txtModel.get(index).arguments.count; i++)
		{
                        translation = translation.arg(txtModel.get(index).arguments.get(i).arg1) // modified by ravikanth 14-05-13
           	}
           	return translation
    	}

     	return (txtModel.get(index).arg1 == undefined) ? qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, txtModel.get(index).msg ):
     		(qsTranslate(LocTrigger.empty + CONST.const_LANGCONTEXT, txtModel.get(index).msg)).arg(txtModel.get(index).arg1)

    /*if ( txtModel.get(index).msg.indexOf("STR_") !== 0 )
           {
               return txtModel.get(index).msg
           }

           if(txtModel.get(index).arguments != undefined) {
               var translation = (qsTranslate( __lang_context, txtModel.get(index).msg) + __emptyString);
               for (var i = 0; i < txtModel.get(index).arguments.count; i++)
               {
                   translation = translation.arg(txtModel.get(index).arguments.get(i).arg1);
               }
               return translation;
           }

           return (txtModel.get(index).arg1 == undefined) ?
                       qsTranslate(__lang_context, txtModel.get(index).msg) + __emptyString :
                       (qsTranslate( __lang_context, txtModel.get(index).msg) + __emptyString).arg(txtModel.get(index).arg1)
    */
    	//modified by aettie.ji 2013.02.06 for language setting
    }
}


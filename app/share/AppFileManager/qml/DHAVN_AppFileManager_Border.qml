import Qt 4.7

Item
{
   id: root

   property int size: 5

   //{ modified by aettie.ji 2012.12.03 for New UX
   //anchors.fill: parent

   Rectangle
   {
      id: top_line

      //anchors.top: parent.top

      //width: parent.width
      //height: parent.size

      //color: "blue"

      x: -39
      y: -39

      width: 1271
      height: parent.size

      color: "#0080FF"
   }

   Rectangle
   {
      id: right_line

      //anchors.right: parent.right

      //width: parent.size
      //height: parent.height

      //color: "blue"

      x: 1227
      y: -39

      width: parent.size
      height: 141

      color:"#0080FF"

   }

   Rectangle
   {
      id: bottom_line

      //anchors.bottom: parent.bottom

      //width: parent.width
      //height: parent.size

      //color: "blue"

      x: -39
      y: 97

      width: 1271
      height: parent.size

      color:"#0080FF"
   }

   Rectangle
   {
      id: left_line

      //anchors.left: parent.left

      //width: parent.size
      //height: parent.height

      //color: "blue"

      x: -39
      y: -39
      width: parent.size
      height: 141

      color:"#0080FF"

   }

}

//} modified by aettie.ji 2012.12.03 for New UX

import Qt 4.7

Item
{
   id: root

   property int size: 4

   anchors.fill: parent

   Rectangle
   {
      id: top_line

      anchors.top: parent.top

      width: parent.width
      height: parent.size

      color: "steelblue"
   }

   Rectangle
   {
      id: right_line

      anchors.right: parent.right

      width: parent.size
      height: parent.height

      color: "steelblue"
   }

   Rectangle
   {
      id: bottom_line

      anchors.bottom: parent.bottom

      width: parent.width
      height: parent.size

      color: "steelblue"
   }

   Rectangle
   {
      id: left_line

      anchors.left: parent.left

      width: parent.size
      height: parent.height

      color: "steelblue"
   }
}


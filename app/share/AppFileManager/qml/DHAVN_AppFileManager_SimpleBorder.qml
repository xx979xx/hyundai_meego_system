import Qt 4.7

Item
{
   id: root

   property int border_width: 5

   width: 0
   height: 0


   Rectangle
   {
      id: top_side

      anchors.left: parent.left
      anchors.top: parent.top

      width: parent.width
      height: root.border_width

      color: "blue"
      opacity: 0.8
   }

   Rectangle
   {
      id: right_side

      anchors.right: parent.right
      anchors.top: parent.top

      width: root.border_width
      height: parent.height

      color: "blue"
      opacity: 0.8
   }

   Rectangle
   {
      id: bottom_side

      anchors.bottom: parent.bottom
      anchors.left: parent.left

      width: parent.width
      height: root.border_width

      color: "blue"
      opacity: 0.8
   }

   Rectangle
   {
      id: left_side

      anchors.left: parent.left
      anchors.top: parent.top

      width: root.border_width
      height: parent.height

      color: "blue"
      opacity: 0.8
   }
}

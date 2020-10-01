var list = [];

// adds object to list
function add(layer, model)
{
   var obj = {"layer": layer, "model": model}
   list.push(obj)
}

// removes top object from list
function remove()
{
    list.pop()
}

// returns top object
function top()
{
   if (list.length >= 1)
      return list[list.length - 1]
}

function previous()
{
   if (list.length >= 2)
      return list[list.length - 2]
}

// returns object at index
function at(index)
{
    return list[index]
}

// returns list count
function count()
{
    return list.length
}

// purges list
function clear()
{
    list.splice(0, list.length)
}

List<dynamic> addStringToList(List<dynamic> list, String itemToAdd) {
  if (!list.contains(itemToAdd)) {
    if (list.length == 0)
      list = [itemToAdd];
    else
      list.insert(0, itemToAdd);
    return list;
  } else
    return list;
}

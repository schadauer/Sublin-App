List<String> addStringToList(List<String> list, String itemToAdd) {
  if (!list.contains(itemToAdd)) {
    if (list.length == 0)
      list = [itemToAdd];
    else
      list.add(itemToAdd);
    return list;
  } else
    return null;
}

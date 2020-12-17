import 'dart:math';

class NumberUtil {
  static List<int> randomizeArray(List<int> array) {
    var rgen = Random(); // Random number generator

    for (var i = 0; i < array.length; i++) {
      var randomPosition = rgen.nextInt(array.length);
      var temp = array[i];
      array[i] = array[randomPosition];
      array[randomPosition] = temp;
    }

    return array;
  }

  static List<int> getListNumberSortRandom() {
    var listNumber = <int>[];
    listNumber.add(3);
    listNumber.add(5);
    listNumber.add(7);
    listNumber.add(2);
    listNumber.add(4);
    listNumber.add(1);
    listNumber.add(9);
    listNumber.add(6);
    listNumber.add(8);
    listNumber.add(0);

    var listaNumberSortRandom = NumberUtil.randomizeArray(listNumber);

    return listaNumberSortRandom;
  }
}

typedef Range = (int, int);

extension RangeExtension on Range {
  int get lower => $1;
  int get upper => $2;

  bool isInRange(int number) {
    return lower <= number && number <= upper;
  }
}

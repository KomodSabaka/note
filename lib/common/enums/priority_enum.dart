enum PriorityEnum {
  high('high'),
  medium('medium'),
  low('low');

  final String type;

  const PriorityEnum(this.type);
}

extension ConvertPriority on String {
  PriorityEnum toPriorityEnum() {
    switch (this) {
      case ('high'):
        return PriorityEnum.high;
      case ('medium'):
        return PriorityEnum.medium;
      case ('low'):
        return PriorityEnum.low;
      default:
        return PriorityEnum.low;
    }
  }
}

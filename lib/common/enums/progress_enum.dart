enum ProgressEnum {
  notStarted('notStarted'),
  inProgress('inProgress'),
  done('done');

  final String progress;

  const ProgressEnum(this.progress);
}

extension ConvertProgress on String {
  ProgressEnum toProgressEnum() {
    switch (this) {
      case ('notStarted'):
        return ProgressEnum.notStarted;
      case ('inProgress'):
        return ProgressEnum.inProgress;
      case ('done'):
        return ProgressEnum.done;
      default:
        return ProgressEnum.notStarted;
    }
  }
}

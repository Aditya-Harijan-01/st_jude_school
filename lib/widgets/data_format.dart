String formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int unit = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && unit < units.length - 1) {
      size /= 1024;
      unit++;
    }
    final decimals = unit == 0 ? 0 : 1;
    return '${size.toStringAsFixed(decimals)} ${units[unit]}';
  }
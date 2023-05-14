import 'dart:math';

class ComputeCorrelation {
  static double computeCorrelation2Values(List<double> x, List<double> y) {
    var xMean = x.reduce((a, b) => a + b) / x.length;
    var yMean = y.reduce((a, b) => a + b) / y.length;
    var xStd = sqrt(
        x.map((e) => pow(e - xMean, 2)).reduce((a, b) => a + b) / x.length);
    var yStd = sqrt(
        y.map((e) => pow(e - yMean, 2)).reduce((a, b) => a + b) / y.length);
    var xyCov = 0.0;
    for (var i = 0; i < x.length; i++) {
      xyCov += (x[i] - xMean) * (y[i] - yMean);
    }
    xyCov /= x.length;
    return xyCov / (xStd * yStd);
  }
}

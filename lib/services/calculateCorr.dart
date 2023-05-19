import 'dart:math';
import 'package:scidart/numdart.dart';

class ComputeCorrelation {
  static double getSD(Array a) {
    var meanA = mean(a);
    var temp = 0.0;
    for (var el in a) {
      temp += (el - meanA) * (el - meanA);
    }
    return sqrt(temp / (a.length));
  }

  static double computeCorrelation2Values() {
    var a = Array2d([
      Array([1.0, 2.0, 342.0]),
      Array([2.0, 1.0, 62.0]),
      Array([3.0, 81.0, 39.0]),
      Array([4.0, 18.0, 29.0]),
    ]);

    var colSumMat = matrixSumColumns(a);

    var meanMat1D = arrayDivisionToScalar(colSumMat, a.length);
    var fullMeanMat = Array2d.empty();

    for (int i = 0; i < a.length; i++) {
      fullMeanMat.add(meanMat1D);
    }

    var matMinusMean = a - fullMeanMat;
    var matMinusMeanTranspose = matrixTranspose(matMinusMean);

    var dotMat = matrixDot(matMinusMeanTranspose, matMinusMean);
    var covMat = Array2d.empty();

    for (int i = 0; i < a[0].length; i++) {
      covMat.add(arrayDivisionToScalar(dotMat[i], a.length.toDouble()));
    }

    var sdMat = Array.empty();

    for (int i = 0; i < a[0].length; i++) {
      sdMat.add(getSD(matrixColumnToArray(a, i)));
    }

    var corrMat = covMat;

    for (int i = 0; i < a[0].length; i++) {
      corrMat[i] = arrayDivisionToScalar(covMat[i], sdMat[i]);
    }

    corrMat = matrixTranspose(covMat);

    for (int i = 0; i < a[0].length; i++) {
      covMat[i] = arrayDivisionToScalar(covMat[i], sdMat[i]);
    }

    print("a: $a");
    print("a len: ${a.length}");
    print("dot: $dotMat");
    print("corrMat: $corrMat");
    print("covMat: ${covMat.toList()}");
    print("SD matrix: $sdMat");
    return 0.0;
  }
}

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
      Array([81, 23, 64, 16, 97]),
      Array([3, 7, 45, 88, 11]),
      Array([92, 56, 31, 79, 51]),
      Array([42, 78, 33, 72, 1]),
      Array([68, 32, 89, 63, 94])
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

    var corrMat = Array2d.fixed(
      a[0].length,
      a.length,
    );

    for (int i = 0; i < a[0].length; i++) {
      corrMat[i] = arrayDivisionToScalar(covMat[i], sdMat[i]);
    }
    corrMat = matrixTranspose(corrMat);
    for (int i = 0; i < a[0].length; i++) {
      corrMat[i] = arrayDivisionToScalar(corrMat[i], sdMat[i]);
    }

    List<double> indices = [];

    for (int i = 0; i < a[0].length; i++) {
      indices.addAll(corrMat[i].toList());
      print(corrMat[i].toList());
    }

    print(indices);
    // print("a: $a");
    // print("a len: ${a.length}");
    // print("dot: $dotMat");
    // print("corr: $corrMat");
    // print("covMat: $covMat");
    // print("SD matrix: $sdMat");
    return 0.0;
  }
}

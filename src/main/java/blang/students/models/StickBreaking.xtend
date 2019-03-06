package blang.students.models

import blang.core.RealVar
import java.util.List
import java.util.ArrayList
import blang.types.DenseSimplex
import blang.types.StaticUtils
import xlinear.MatrixOperations

class StickBreaking {

    /** creates a simplex using the stick-breaking method.*/
    def static DenseSimplex Gem(List<RealVar> b){

      val k = b.size;
      
      // Cases for out-of-support betas : return uniformSimplex
      if ((b.get(0).doubleValue == 0.0 && b.get(1).doubleValue == 0.0) 
        || b.get(0).doubleValue > 1.0 || b.get(0).doubleValue < 0.0 ) {
        val uniformSimplex = StaticUtils.fixedSimplex(MatrixOperations.ones(k)/k)
        return uniformSimplex
      }

      // log b and b's complement and
      var logb = new ArrayList
      var logbc = new ArrayList
      for (int i : 0 ..< k) { 
        logb.add(i, Math.log(b.get(i).doubleValue))
        logbc.add(i, Math.log(1.0 - b.get(i).doubleValue))
      }

      // Compute logPi
      var logPi = new ArrayList
      logPi.add(logb.get(0))
      var simplexSum = b.get(0).doubleValue
      for (int i : 1 ..< k){
        val logp = logPi.get(i-1) - logb.get(i-1) + logb.get(i) + logbc.get(i-1) 
        // nasty edge cases
        switch logp {
          case logp.isNaN : {logPi.add(Math.log(1.0 - simplexSum)); simplexSum = 1.0}
          case simplexSum + Math.exp(logp) >= 1.0 : logPi.add(Double.NEGATIVE_INFINITY)
          default: {logPi.add(logp); simplexSum += Math.exp(logp)}
        }
      }
      
      // Exponentiating to get pi simplex
      var pi = new ArrayList
      for (int i : 0 ..< k) { pi.add(i, Math.exp(logPi.get(i))) }

      if (simplexSum <= 0.999999) {
        val diff = 1.0 - simplexSum
        pi.set(k-1, pi.get(k-1)+diff)
      }
      return StaticUtils.fixedSimplex(pi)
    }
    
    
}
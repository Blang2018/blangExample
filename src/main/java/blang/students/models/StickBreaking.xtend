package blang.students.models

import blang.core.RealVar
import java.util.List
import java.util.ArrayList
import blang.types.DenseSimplex
import blang.types.StaticUtils

class StickBreaking {


    /** creates a simplex using the stick-breaking method.*/
     
    def static DenseSimplex BreakStick(List<RealVar> b){
      val k = b.size;
//      // For some reason(s), there are Beta RVs outside of [0,1]
//      if (b.get(0).doubleValue > 1.0 || b.get(0).doubleValue < 0.0) {
//        println(b); 
//        println("WHY IS THIS BETA REALIZATION NOT IN [0,1]?!?!?");
//      }

      // Dummy 0.0 case for pre-processing stage
      // #TODO Investigate why some Beta RVs outside of [0,1]
      if ((b.get(0).doubleValue == 0.0 && b.get(1).doubleValue == 0.0)
        || (b.get(0).doubleValue > 1.0 || b.get(0).doubleValue < 0.0)
      ){
        var pi = new ArrayList => [
         for (int i : 0 ..< k) { add(1.0/k) } 
        ]
        return StaticUtils.fixedSimplex(pi)
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
        val p = logPi.get(i-1) - logb.get(i-1) + logb.get(i) + logbc.get(i-1) 
        // nasty edge cases
        switch p {
          case p.isNaN : {logPi.add(Math.log(1.0 - simplexSum)); simplexSum = 1.0}
          case simplexSum + Math.exp(p) >= 1.0 : logPi.add(Double.NEGATIVE_INFINITY)
          default: {logPi.add(p); simplexSum += Math.exp(p)}
        }
      }
      
      // Exponentiating to get actual pi simplex
      var pi = new ArrayList
      for (int i : 0 ..< k) { pi.add(i, Math.exp(logPi.get(i))) }

      return StaticUtils.fixedSimplex(pi)
    }
    
    
}
package blang.students.models

import blang.core.RealVar
import java.util.List
import java.util.ArrayList

class StickBreaking {


    /* Generates pi (a simplex) from a list of IID Beta R.V.s
     * returns ArrayList<Double>
     */
    def static BreakStick(List<RealVar> b){
      val k = b.size
      // Dummy 0.0 case for pre-processing stage
      if (b.get(0).doubleValue == 0.0 && b.get(1).doubleValue == 0.0 ){
        var pi = new ArrayList
        for (int i : 0 ..< k) { pi.add(1.0/k) }
        return pi
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
      for (int i : 1 ..< k){
        logPi.add(
          logPi.get(i-1) - logb.get(i-1) + logb.get(i) + logbc.get(i-1) 
        )
      }
      var pi = new ArrayList
      for (int i : 0 ..< k) { pi.add(i, Math.exp(logPi.get(i))) }
      // deal with NaN
      var simplexSum = 0.0
      for (int i : 0 ..< k) {
        if (!pi.get(i).isNaN){
          simplexSum += pi.get(i)
        } else { pi.set(i, 0.0) }
      }
      if (1.0 - simplexSum > 1E-6) {
        pi.set(pi.indexOf(0.0), 1.0-simplexSum)
      }
      if (simplexSum > 1.0+1e-6) {
        val idxOfLastNoneZero = pi.indexOf(0.0) - 1
        val excess = simplexSum - 1.0
        pi.set(idxOfLastNoneZero, pi.get(idxOfLastNoneZero) - excess)
      }
      return pi
    }
    
    
}
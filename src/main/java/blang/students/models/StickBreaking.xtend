package blang.students.models

import blang.core.RealVar
import java.util.List
import java.util.ArrayList

class StickBreaking {


    /* Generates pi (a simplex) from a list of IID Beta R.V.s
     * returns ArrayList<Double>
     */
    def static BreakStick(List<RealVar> b){
      System.out.print(b)
      val k = b.size
      val pi = new ArrayList
      pi.add(0, b.get(0).doubleValue)
      // b's complement
      val bc = new ArrayList
      for (int i : 0 ..< k) { bc.add(i, 1.0 - b.get(i).doubleValue) }
      for (int i : 1 ..< k) {
        pi.add(i,
          // More efficient way to compute:
          // pi_k = b_k * PRODUCT{bc_l} (for l = 1, ..., k-1)
          Math.exp(
            Math.log(pi.get(i-1))
          - Math.log(b.get(i-1).doubleValue)
          + Math.log(b.get(i).doubleValue)
          + Math.log(bc.get(i-1).doubleValue)
          )
        )
      }
      return pi;
    }
    
    
}
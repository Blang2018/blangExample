package blang.students.models.partitions

import org.eclipse.xtend.lib.annotations.Data
import blang.mcmc.Samplers
import java.util.List
import java.util.Random
import blang.inits.experiments.tabwriters.TidilySerializable
import blang.inits.experiments.tabwriters.TidySerializer.Context
import blang.distributions.Generators
import java.util.Collections
import java.util.ArrayList
import blang.inits.DesignatedConstructor
import blang.inits.ConstructorArg
import briefj.BriefIO
import java.util.Map

@Data
@Samplers(PartitionSampler)
class Partition implements TidilySerializable{
  
  /*
   * Assignment of partition for each element
   * eg. A partition p of 8 points uniformly across 4 subsets
   * p = {0,0,1,1,2,2,3,3} or p = {0,1,0,1,2,3,3,2}
   */
  val List<Integer> assignments
  
  /**
   * Initialize to the trivial partition.
   */
  @DesignatedConstructor
  new (@ConstructorArg("nElements") int nElements){
    assignments = new ArrayList<Integer>(Collections.nCopies(nElements, 0))
  }
  
  def int nElements() {
    return assignments.size()
  }
  
  /**
   * Can optimize to be a field, but must be careful keeping track of
   * accept/reject +/- 1 of partitionSize
   * defined as max(assignments)+1
   */
  def int nSubsets() {
    return Collections.max(assignments) + 1
  }
  
  /**
   * Sample a neighbour assignment
   */
  def void sampleNeighbour(Random random){
    // Select an element to switch assignment
    var eleToMove = Generators.discreteUniform(random, 0, nElements)
    var currentSubset = assignments.get(eleToMove)
    
    // TODO Track counts instead of Collections.freq each time.
    //      WARNING: Be extra careful when rejecting a proposal,
    //      must update count.
    // If removing the element creates gaps in tables, redraw.
    // This forbids moves that break symmetry
    while ((currentSubset < (nSubsets - 1)) && Collections.frequency(assignments, currentSubset) == 1) {
      // redraw
      eleToMove = Generators.discreteUniform(random, 0, nElements)
      currentSubset = assignments.get(eleToMove)
    } 
    // Move to a different subset
    // if current configuration is: 0, 1, 2, 3, 4, 2, then nSubsets = 5
    // draw from 0, 1, 2, 3, 4, 5
    // Hence Uniform(0, 6)
    var targetSubset = Generators.discreteUniform(random, 0, nSubsets + 1)
    while (targetSubset == currentSubset || targetSubset >= nElements) {
      // redraw target
      targetSubset = Generators.discreteUniform(random, 0, nSubsets + 1)
    }
    // Case if currentSubset == nSubsets - 1 && counts == 1, then sample from 0, nSubsets -1
    // 0 1 2 3 [4] 2
    // 0 1 2 3  *  2, draw * from 0 1 2 3
    if (currentSubset == nSubsets -1 && Collections.frequency(assignments, currentSubset) == 1){
      targetSubset = Generators.discreteUniform(random, 0, nSubsets - 1)
    }

    assignments.set(eleToMove, targetSubset)
  }
  
  
  override String toString(){
    return assignments.toString()
  }
  
  def void setAssignment(List<Integer> newAssignment){
    Collections.copy(assignments, newAssignment)
  }
  
  /**
   * For outputting samples in a tidy format.
   */
  override void serialize(Context context){
    for (int i : 0 ..< nElements()) {
      context.recurse(assignments.get(i), "element", i)
    }
  }
  
  
}
package blang.students.models.partitions;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

import blang.distributions.Generators;

public class CRPForwardSimulation {
  /** */
  public static Partition crp(Random rand, double alpha, int nElements)
  {
	List<Integer> assignments = new ArrayList<Integer>(Collections.nCopies(nElements, 0));
	List<Integer> counts = new ArrayList<Integer>(Collections.nCopies(nElements, 0));
	double[] probs = new double[nElements];
	double denom;
	assignments.set(0, 0);
	counts.set(0, 1);
	int numTables = 1;
	for (int i = 1; i < assignments.size(); i++){
		denom = alpha + i;
		double logDenom = Math.log(denom);
	    for (int j = 0 ; j < numTables; j++) {
		  probs[j] = Math.exp(Math.log(counts.get(j)) - logDenom);
		}
		probs[numTables] = Math.exp(Math.log(alpha) - logDenom);
		int assignedTo = Generators.categorical(rand, probs);
		assignments.set(i, assignedTo);
		counts.set(assignedTo, counts.get(assignedTo) + 1);
		if (assignedTo == numTables) {
			numTables += 1;
		}
	}
	
	Partition crpPartition = new Partition(nElements);
//	Collections.shuffle(assignments);
	crpPartition.setAssignment(assignments);
	return crpPartition;
  }
	
}

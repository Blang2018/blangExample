package blang.students.models.partitions;

import java.util.ArrayList;
import java.util.List;

import bayonet.distributions.Random;
import blang.core.LogScaleFactor;
import blang.distributions.Generators;
import blang.mcmc.ConnectedFactor;
import blang.mcmc.SampledVariable;
import blang.mcmc.Sampler;

public class PartitionSampler implements Sampler{

	/**
	 * Metropolis-Hastings Algorithm for sampling Partitions.
	 */
	
	@SampledVariable
	Partition partition;
	
	@ConnectedFactor
	List<LogScaleFactor> numericFactors;
	
	
	@Override
	public void execute(Random rand) {
		
		// Store the previous configuration in case we reject our proposed sample
		List<Integer> currentConfig = new ArrayList<Integer>(partition.getAssignments());
		
		
		// Compute log density of current configuration
		double currentDensity = logDensity();
		
		// Propose a new configuration
		partition.sampleNeighbour(rand);

		// Compute log density of proposed configuration
		double proposedDensity = logDensity();
		
		// Compute acceptance probability
		double alpha = Math.min(1, Math.exp(proposedDensity - currentDensity));

		// Decide to accept for not
		boolean decision = Generators.bernoulli(rand, alpha);
		
		// If rejected, set the configuration back to previous configuration (currentConfig),
		// Since we sampled it in place with partition.sampleNeighbour(rand);
		if (!decision) {
			partition.setAssignment(currentConfig);
		}
		// TODO if tracking counts, be sure to undo counts when rejecting a proposal

		
	}
	
	private double logDensity() {
		double sum = 0.0;
		for (LogScaleFactor f : numericFactors) {
			sum += f.logDensity();
		}
		return sum;
	}
	
}
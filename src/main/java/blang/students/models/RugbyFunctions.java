package blang.students.models;

import java.util.List;
import blang.core.RealVar;
import blang.distributions.Generators;

public class RugbyFunctions {
	
	private static double Mean(List<RealVar> listOfVars){
		return listOfVars.stream().mapToDouble(x->x.doubleValue()).average().getAsDouble();
	}
	
	public static double computeTheta(List<RealVar> atks_star, List<RealVar> defs_star, 
			                          int indexAtk, int indexDef, RealVar intercept, RealVar home)
	{
		double result;
		double atksMean = Mean(atks_star);
		double defsMean = Mean(defs_star);
		result = Math.exp(
				atks_star.get(indexAtk).doubleValue() +
				defs_star.get(indexDef).doubleValue() -
				atksMean - defsMean +
				intercept.doubleValue() +
				home.doubleValue());
		return edgeCases(result);
	}
	
	private static double edgeCases(double result) {
		if (result == 0) {
			return Generators.ZERO_PLUS_EPS;
		} else if (result == Double.POSITIVE_INFINITY) {
			return Double.MAX_VALUE;
		} else {
			return result;
		}
	}

}

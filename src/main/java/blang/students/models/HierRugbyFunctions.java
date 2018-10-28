package blang.students.models;

import java.util.List;

import org.apache.commons.math3.stat.descriptive.SummaryStatistics;

import blang.core.RealVar;

public class HierRugbyFunctions {
	
	public static double Mean(List<RealVar> listOfVars){
		return listOfVars.stream().mapToDouble(x->x.doubleValue()).average().getAsDouble();
	}

}

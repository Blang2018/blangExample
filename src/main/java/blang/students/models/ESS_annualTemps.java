package blang.students.models;
import bayonet.math.EffectiveSampleSize;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import au.com.bytecode.opencsv.CSVWriter;



public class ESS_annualTemps {

	public static void main(String[] args) throws IOException {
		List<Double> samples = getSamples("/Users/sahand/Desktop/blang/blangWork/wip/HMM/data/annualtemps-out/samples/ess_states_data", 1);

		
		@SuppressWarnings("resource")
		CSVWriter writer = new CSVWriter(new FileWriter("/Users/sahand/Desktop/blang/blangWork/wip/HMM/data/annualtemps-out/ess_annualTemps.txt"), ',');

		Double ess = EffectiveSampleSize.ess(samples);
		System.out.println(ess);
		String[] line = {"states", String.valueOf(ess)};
		writer.writeNext(line);
		System.out.println(line);
		writer.close();
	}

	private static List<Double> getSamples(String csvName, int index) throws IOException{
		
		@SuppressWarnings("resource")
		CSVParser samplesParser = new CSVParser(new FileReader(csvName + ".csv"), CSVFormat.DEFAULT.withHeader());
		List<CSVRecord> records = samplesParser.getRecords();
		List<Double> samples = new ArrayList<Double>();
		for (CSVRecord record : records) {
			samples.add(Double.parseDouble(record.get(index)));
		}
		return samples;
	}


}

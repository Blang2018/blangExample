package blang.students.models;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import au.com.bytecode.opencsv.CSVWriter;
import bayonet.math.EffectiveSampleSize;



public class ESSHierarchicalRugby {

	public static void main(String[] args) throws IOException {

		String ROOT = args[0] + "/";
		String[] namesSingleVal = {"home", "intercept", "sd_atk", "sd_def"};
		String[] namesIndexedVal = {"atks_star", "defs_star"};

		@SuppressWarnings("resource")
		CSVWriter writer = new CSVWriter(new FileWriter("ess.txt"), ',');

		for (String name : namesSingleVal) {
			Double ess = EffectiveSampleSize.ess(getSamples(ROOT + name, 1));
			String[] line = {name, String.valueOf(ess)};
			writer.writeNext(line);
		}
		
		int nTeams = 6;
		for (String name : namesIndexedVal) {
			List<Double> samples = getSamples(ROOT + name, 2);
			List<List<Double>> partitions = new ArrayList<List<Double>>(nTeams);
			int partSize = samples.size() / nTeams;
			// initialize
			for (int i = 0; i < nTeams; i++) {
				partitions.add(new ArrayList<Double>(partSize));
			}
			// TODO: Fix implementation, avoid doubling in space complexity :(
			for (int i = 0; i < samples.size(); i++) {
				partitions.get(i % nTeams).add(samples.get(i));
			}

			for (int i = 0; i < nTeams; i++) {
				Double ess = EffectiveSampleSize.ess(partitions.get(i));
				String[] line = {name + i, String.valueOf(ess)};
				writer.writeNext(line);
			}
			
		}
		writer.flush();
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

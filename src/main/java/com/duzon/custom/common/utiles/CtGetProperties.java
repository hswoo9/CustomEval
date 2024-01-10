package com.duzon.custom.common.utiles;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;

public class CtGetProperties {
	
	public static String getKey(String key) {
		
		try {
			Configuration config = new PropertiesConfiguration("config/properties/bizboxa.properties");
			return config.getString(key);
		} catch (ConfigurationException e) {
			e.printStackTrace();
		}
		
		return null;
		
	}
}

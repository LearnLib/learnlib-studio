package de.learnlib.studio.symbol.utils

import de.learnlib.studio.symbol.symbol.DataType


class DataTypeConverter {
	
	static def convertDataType(de.learnlib.studio.siblibrary.siblibrary.DataType sibLibraryType) {
    	switch (sibLibraryType) {
			case BOOLEAN: DataType.BOOLEAN
			case INTEGER: DataType.INTEGER
			case OBJECT:  DataType.OBJECT
			case REAL:    DataType.REAL
			case TEXT:    DataType.TEXT
    	}
    }
	
}

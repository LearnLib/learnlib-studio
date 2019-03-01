package de.learnlib.studio.siblibrary.utils

import org.eclipse.xtext.xbase.lib.Procedures.Procedure0


class UpdateStatus {
	
	public static val INSTANCE = new UpdateStatus()
	
	var int inProgress
	
	private new() {
		inProgress = 0
	}
	
	def start() {
		inProgress++
	}
	
	def stop() {
		inProgress--
	}
	
	def isInProgress() {
		return inProgress > 0
	}
	
	def ifNotAlreadyUpdating(Procedure0 procedure) {
	    if (!isInProgress) {
	        start()
	        
	        procedure.apply()
	        
	        stop()
	    }
	}
	
}

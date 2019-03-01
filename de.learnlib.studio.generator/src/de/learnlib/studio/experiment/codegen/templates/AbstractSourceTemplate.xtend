package de.learnlib.studio.experiment.codegen.templates;

import de.learnlib.studio.experiment.codegen.GeneratorContext


abstract class AbstractSourceTemplate extends AbstractTemplateImpl {
	
	val String name
	val String className
	val String package_
	
	new(GeneratorContext context, String name) {
		super(context, "/src/main/java/" + context.modelPackageAsPath, name.toFirstUpper + ".java")
		
		this.package_  = context.modelPackage
		this.name      = name.toFirstLower
		this.className = name.toFirstUpper
		
        context.addSourceTemplate(this)
	}
	
	new(GeneratorContext context, String subPackage, String name) {
		super(context, "/src/main/java/" + context.modelPackageAsPath + '/' + subPackage.replace('.', '/'), name.toFirstUpper + ".java")
		
		this.package_  = context.modelPackage + '.' + subPackage
		this.name      = name.toFirstLower
		this.className = name.toFirstUpper
		
		context.addSourceTemplate(this)
	}
	
	def getPackage() {
		package_
	}
	
	def getName() {
		name
	}
	
	def getClassName() {
		className
	}
	
	def getFullName() {
		package_ + '.' + className
	}
	
	def final reference(Class<? extends Template> clazz) {
        val template = context.sourceTemplates.findFirst[t | clazz.isAssignableFrom(t.class)]
        return template.fullName
    }

}

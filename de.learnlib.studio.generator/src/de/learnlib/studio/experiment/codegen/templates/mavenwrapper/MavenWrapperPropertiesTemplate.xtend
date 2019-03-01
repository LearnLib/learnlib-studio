package de.learnlib.studio.experiment.codegen.templates.mavenwrapper

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.AbstractTemplateImpl


class MavenWrapperPropertiesTemplate extends AbstractTemplateImpl {
	
	new(GeneratorContext context) {
        super(context, ".mvn/wrapper/", "maven-wrapper.properties")
    }
	
	override template() '''
		distributionUrl=https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.6.0/apache-maven-3.6.0-bin.zip
		wrapperUrl=https://repo.maven.apache.org/maven2/io/takari/maven-wrapper/0.4.2/maven-wrapper-0.4.2.jar
	'''

}

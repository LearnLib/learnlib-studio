package de.learnlib.studio.experiment.codegen.templates

import java.util.stream.Collectors

import java.util.List
import de.learnlib.studio.siblibrary.siblibrary.MavenArtifact

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.providers.MavenArtifactProvider

class MavenTemplate extends AbstractTemplateImpl {
    
    new(GeneratorContext context) {
        super(context, "/", "pom.xml")
    }
    
    private def getOtherArtifacts() {
        val artifactComparator = [MavenArtifact a1, MavenArtifact a2 |
            val groupCompare = a1.groupId.compareTo(a2.groupId)
            if (groupCompare != 0) {
                return groupCompare;
            } else {
                return a2.artifactId.compareTo(a2.artifactId)
            }
        ]
        
        val providers = context.getProviders(MavenArtifactProvider)
        
        if (providers.nullOrEmpty) {
            return newLinkedList()
        } else {
            val artifacts = providers.map[p | p.artifacts as List<MavenArtifact>].flatten
            return artifacts.sortWith(artifactComparator).stream.distinct.collect(Collectors.toList)
        }
    }
    
    override template() '''
        <?xml version="1.0"?>
        <project xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xmlns="http://maven.apache.org/POM/4.0.0"
                 xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        
            <modelVersion>4.0.0</modelVersion>
        
            <groupId>« context.modelPackage »</groupId>
            <artifactId>« context.modelName »</artifactId>
            <version>1.0.0-SNAPSHOT</version>
            
            <name>« context.modelName »</name>
        
            <properties>
                <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
                <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
                
                <maven.compiler.source>1.8</maven.compiler.source>
                <maven.compiler.target>1.8</maven.compiler.target>
                
                <learnlib.version>0.15.0</learnlib.version>
                <automatalib.version>0.9.0</automatalib.version>
                
                <slf4j.version>1.7.25</slf4j.version>
            </properties>
        
            <dependencies>
                <!-- LearnLib dependencies -->
                <dependency>
                	<groupId>de.learnlib.distribution</groupId>
                    <artifactId>learnlib-distribution</artifactId>
                    <version>${learnlib.version}</version>
                    <type>pom</type>
              	</dependency>
        
                <!-- AutomataLib dependencies -->
                <dependency>
                    <groupId>net.automatalib.distribution</groupId>
                    <artifactId>automata-distribution</artifactId>
                    <version>${automatalib.version}</version>
                    <type>pom</type>
          		</dependency>
                  
                <!-- other dependencies -->
                <dependency>
                    <groupId>org.slf4j</groupId>
                    <artifactId>slf4j-api</artifactId>
                    <version>${slf4j.version}</version>
                </dependency>
                <dependency>
                    <groupId>org.slf4j</groupId>
                    <artifactId>slf4j-jdk14</artifactId>
                    <version>${slf4j.version}</version>
                </dependency>
                <dependency>
                    <groupId>commons-cli</groupId>
                    <artifactId>commons-cli</artifactId>
                    <version>1.4</version>
                </dependency>
                
                « FOR a : otherArtifacts »
                    <dependency>
                        <groupId>« a.groupId »</groupId>
                        <artifactId>« a.artifactId »</artifactId>
                        <version>« a.version »</version>
                    </dependency>
                « ENDFOR »
            </dependencies>
            
            <build>
                   <plugins>
                       <plugin>
                        <artifactId>maven-assembly-plugin</artifactId>
                           <configuration>
                               <archive>
                                   <manifest>
                                       <mainClass>« context.modelPackage ».Main</mainClass>
                                   </manifest>
                               </archive>
                               <descriptorRefs>
                                   <descriptorRef>jar-with-dependencies</descriptorRef>
                               </descriptorRefs>
                           </configuration>
                           <executions>
                               <execution>
                                   <id>make-assembly</id>
                                   <phase>package</phase>
                                   <goals>
                                       <goal>single</goal>
                                   </goals>
                               </execution>
                           </executions>
                       </plugin>
                   </plugins>
               </build>
        </project>
    '''
    
}

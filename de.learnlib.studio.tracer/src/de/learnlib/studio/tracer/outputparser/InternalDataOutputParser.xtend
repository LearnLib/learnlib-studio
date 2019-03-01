package de.learnlib.studio.tracer.outputparser

import java.nio.file.Files
import java.nio.file.Paths
import java.nio.charset.Charset

import org.eclipse.core.resources.IProject

import de.learnlib.studio.discriminationtree.factory.DiscriminationTreeFactory
import de.learnlib.studio.discriminationtree.discriminationtree.InnerNode
import de.learnlib.studio.utils.GraphLayouter


class InternalDataOutputParser extends OutputParser {
    
    val IProject  project
    
    new (IProject project) {
        this.project = project
    }
    
    override parse() {
        val lines = buffer.toString().split("\n")
        
        switch (lines.head) {
            case "LStar": parseLSTar(lines.tail)
            case "TTT":   parseTTTDT(lines.tail)
        }
    }
    
    private def parseLSTar(String[] lines) {
        val file = Paths.get(project.location.toString()).resolve("results").resolve("LStar.txt")
        
        System.out.println("Writting to " + file)
        Files.write(file, lines, Charset.forName("UTF-8"));
    }
    
    private def parseTTTDT(String[] lines) {
        val dtFactory = DiscriminationTreeFactory.eINSTANCE;
        val newDisciminationTree = dtFactory.createDiscriminationTree("/" + project.name + "/results", "TTT");
        
        val levels  = lines.map[l | l.length - l.trim.length]
        val InnerNode[] nodeMap = newArrayOfSize(lines.size)
        val InnerNode[] parents = newArrayOfSize(levels.max)
        
        for (var i = 0; i < lines.length; i++) {
            val current = lines.get(i)
            val level   = levels.get(i)
            
            if (i + 1 < levels.size && level < levels.get(i + 1)) {
                val newInnerNode = newDisciminationTree.newInnerNode(0, 0)
                newInnerNode.setLabel(current.trim())
                
                if (i > 0) {
                    val parentNode = parents.get(level - 2)
                    parentNode.newConnection(newInnerNode)
                }
                
                nodeMap.set(i, newInnerNode)
                parents.set(levels.get(i), newInnerNode)
            } else {
                val newLeafNode = newDisciminationTree.newLeafNode(0, 0)
                newLeafNode.setLabel(current.trim())
                
                val parentNode = parents.get(level - 2)
                parentNode.newConnection(newLeafNode)
            }
        }
        
        new GraphLayouter().layout(newDisciminationTree.allNodes)
        newDisciminationTree.save()
    }
}

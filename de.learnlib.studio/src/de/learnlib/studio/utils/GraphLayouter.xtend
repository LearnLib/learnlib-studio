package de.learnlib.studio.utils

import java.util.List
import java.util.Set

import graphmodel.Node
import graphmodel.Edge


class GraphLayouter {
    
    static val DEFAULT_DISTANCE_BETWEEN_NODES  = 100
    static val DEFAULT_DISTANCE_BETWEEN_LAYERS = 100
    
    static val DEFAULT_START_OFFSET_X = 50
    static val DEFAULT_START_OFFSET_Y = 50
    
    val int distanceBetweenNodes
    val int distanceBetweenLayers
    
    val int startOffsetX
    val int startOffsetY
    
    new() {
        this(
            DEFAULT_DISTANCE_BETWEEN_NODES,
            DEFAULT_DISTANCE_BETWEEN_LAYERS,
            DEFAULT_START_OFFSET_X,
            DEFAULT_START_OFFSET_Y
        )
    }
    
    new(int distanceBetweenNodes, int distanceBetweenLayers, int startOffsetX, int startOffsetY) {
        this.distanceBetweenNodes  = distanceBetweenNodes
        this.distanceBetweenLayers = distanceBetweenLayers
        
        this.startOffsetX = startOffsetX
        this.startOffsetY = startOffsetY
    }
    
    def layout(List<Node> nodes) {
        val orderedNodes = sortNodes(nodes)
        
        val edgresToIgnore = findEdgesToIgnore(orderedNodes)
        
        val layers = assignLayers(orderedNodes, edgresToIgnore)
        
        positionNodes(layers)
    }

    private def List<Node> sortNodes(List<Node> nodes) {
        val untreatedNodes = <Node> newLinkedList(nodes)

        val left  = <Node> newLinkedList()
        val right = <Node> newLinkedList()
        
        while (!untreatedNodes.isEmpty) {
            val sink = findASink(untreatedNodes)
            if (sink !== null) {
                right.addFirst(sink)
                untreatedNodes -= sink
            } else {
                var source = findASource(untreatedNodes)
                if (source === null) {
                    source = findASemiSource(untreatedNodes)
                }
                left.addLast(source)
                untreatedNodes -= source
            }
        }
        
        left += right
        return left
    }
    
    private def findASink(List<Node> nodes) {
        return nodes.findFirst[n | countOutgoing(n, nodes) == 0]
    }
    
    private def findASource(List<Node> nodes) {
        return nodes.findFirst[n | countIncomming(n, nodes) == 0]
    }
    
    private def findASemiSource(List<Node> nodes) {
        return nodes.maxBy(n | countOutgoing(n, nodes) - countIncomming(n, nodes))
    }
    
    private def countIncomming(Node node, List<Node> list) {
        return node.incoming.filter[e | e.sourceElement != node && list.contains(e.sourceElement)].size
    }
    
    private def countOutgoing(Node node, List<Node> list) {
        return node.outgoing.filter[e | e.targetElement != node && list.contains(e.targetElement)].size
    }
    
    private def Set<Edge> findEdgesToIgnore(List<Node> nodes) {
        val edges     = <Edge> newHashSet()
        val seenNodes = <Node> newHashSet()
        
        nodes.forEach[node |
            val reverseEdges = node.outgoing.filter[e | e.targetElement != node && seenNodes.contains(e.targetElement)]
            edges += reverseEdges
            seenNodes += node
        ]
                
        return edges
    }
    
    private def List<List<Node>> assignLayers(List<Node> orderedNodes, Set<Edge> edgesToIgnore) {
        val layers = <List<Node>> newLinkedList()
        var currentLayer = <Node> newLinkedList()
        layers.add(currentLayer)
        
        while (!orderedNodes.isEmpty) {
            val node = orderedNodes.last
            
            val nodeIsSink = node.outgoing.filter[e | e.targetElement != node && !edgesToIgnore.contains(e)].size == 0
            
            if (!nodeIsSink) {
                currentLayer.forEach[n | edgesToIgnore += n.incoming]
                currentLayer = <Node> newLinkedList()
                layers += currentLayer
            }
            
            currentLayer += node
            orderedNodes -= node
        }
        
        layers.reverse
        return layers
    }
    
    private def positionNodes(List<List<Node>> layers) {
        val maxLayerSize = layers.maxBy[size].size
        layers.forEach[layer, i |
            val offset = (maxLayerSize - layer.size) / 2.0f
            layer.forEach[node, j |
                val x = Math.round((j + offset) * distanceBetweenNodes  + startOffsetX)
                val y = Math.round( i           * distanceBetweenLayers + startOffsetY)
                
                node.move(x, y)
            ]
        ]
    }
    
}

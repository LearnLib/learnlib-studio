package de.learnlib.studio.utils

import graphmodel.Container
import graphmodel.Node


class VerticalStackContainerLayouter {
    
    val int defaultHeight

    val int marginHorizontal
    val int marginVertical
    
    new(int defaultHeight, int marginHorizontal, int marginVertical) {
        this.defaultHeight = defaultHeight
        this.marginHorizontal = marginHorizontal
        this.marginVertical = marginVertical
    }
    
    def layoutAll(Container container) {
        val children = container.nodes
        
        container.height = defaultHeight + marginVertical
        
        children.forEach[child | layoutNew(container, child)]
    }
    
    def layoutNew(Container container, Node newNode) {
        newNode.x = marginHorizontal
        newNode.width = container.width - (marginHorizontal * 2)

        if (container.nodes.size == 1) {
            container.height = defaultHeight + marginVertical
        }
        
        newNode.y = container.height
        container.height = newNode.y + newNode.height + marginVertical
    }
    
    def resizeChildren(Container container) {
        val newWidth = container.width - (marginHorizontal * 2)
        container.nodes.forEach[resize(newWidth, height)]
    }
    
}

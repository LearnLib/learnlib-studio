package de.learnlib.studio.experiment.codegen.templates.blocks

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.LStarAlgorithm
import de.learnlib.studio.experiment.experiment.ShowInternalData
import de.learnlib.studio.experiment.experiment.TTTAlgorithm


class ShowInternalDataBlockTemplate
		extends AbstractBlockTemplate<ShowInternalData> {

    new(GeneratorContext context) {
        super(context, "blocks", "ShowInternalData")
    }

    new(GeneratorContext context, ShowInternalData node, int i) {
        super(context, node, i, "blocks", "ShowInternalData")
    }

    override template() '''
        package «package»;
        
        import java.io.IOException;
        «IF context.isNodeTypeUsed(LStarAlgorithm) »
            
            import de.learnlib.algorithms.lstar.mealy.ExtensibleLStarMealy;
            import de.learnlib.datastructure.observationtable.writer.ObservationTableASCIIWriter;
            import net.automatalib.words.Word;
        «ENDIF»
        «IF context.isNodeTypeUsed(TTTAlgorithm) »
            import java.util.Deque;
            import java.util.LinkedList;
            
            import de.learnlib.datastructure.discriminationtree.model.AbstractDTNode;
            import de.learnlib.algorithms.ttt.base.AbstractBaseDTNode;
            import de.learnlib.algorithms.ttt.base.BaseTTTDiscriminationTree;
            import de.learnlib.algorithms.ttt.base.TTTState;
            import de.learnlib.algorithms.ttt.mealy.TTTLearnerMealy;
            import net.automatalib.words.Word;
         «ENDIF»
        
        import «context.modelPackage».ExperimentData;
        «IF context.isNodeTypeUsed(LStarAlgorithm) »
            import «context.modelPackage».blocks.learner.AbstractLStarBlock;
        «ENDIF»
        «IF context.isNodeTypeUsed(TTTAlgorithm) »
            import «context.modelPackage».blocks.learner.AbstractTTTBlock;
        «ENDIF»
        
        
        public class ShowInternalDataBlock extends AbstractBlock {
        	
        	public ShowInternalDataBlock(String blockId) {
        	    super(blockId);
            }
        	
        	@Override
        	public String startMessage() {
        		return "Exporting internal data";
        	}
        	
        	@Override
        	public Block execute(ExperimentData data) {
        		Block lastLearnerBlock = data.getLastLearnerBlock();
        		
        		«IF context.isNodeTypeUsed(LStarAlgorithm) »
        		    if (lastLearnerBlock instanceof AbstractLStarBlock) {
        		        System.out.println("LStar");
        		        ExtensibleLStarMealy<String, String> lStar = ((AbstractLStarBlock) lastLearnerBlock).getLearner();
        		                
        		        StringBuilder buffer = new StringBuilder();
        		        ObservationTableASCIIWriter<String, Word<String>> otWriter = new ObservationTableASCIIWriter<>();
        		        otWriter.write(lStar.getObservationTable(), buffer);
        		        System.out.println(buffer.toString());
        		        System.out.println();
        		    }
        		«ENDIF»
                
                «IF context.isNodeTypeUsed(TTTAlgorithm) »
                    if (lastLearnerBlock instanceof AbstractTTTBlock) {
                        System.out.println("TTT");
                        TTTLearnerMealy<String, String> ttt = ((AbstractTTTBlock) lastLearnerBlock).getLearner();
                        BaseTTTDiscriminationTree<String, Word<String>> discriminationTree = ttt.getDiscriminationTree();
                        AbstractBaseDTNode<String,Word<String>> root = discriminationTree.getRoot();
                        
                        Deque<AbstractBaseDTNode<String,Word<String>>> dtNodeQueue  = new LinkedList<>();
                        Deque<Integer>                                 levelsQueue = new LinkedList<>();
                        dtNodeQueue.add(root);
                        levelsQueue.add(0);
                        
                        while (!dtNodeQueue.isEmpty()) {
                            AbstractBaseDTNode<String,Word<String>> current = dtNodeQueue.poll();
                            Integer                                 level   = levelsQueue.poll();
                            
                            if (current.isInner()) {
                                AbstractBaseDTNode[] children = current.getChildren().toArray(new AbstractBaseDTNode[current.getChildren().size()]);
                                Integer childrenLevel = level + 1;
                                for (int i = children.length - 1; i >= 0; i--) {
                                    dtNodeQueue.addFirst(children[i]);
                                    levelsQueue.addFirst(childrenLevel);
                                }
                                
                                for (int i = 0; i < level; i++) {
                                    System.out.print("  ");
                                }
                                System.out.println(current.getDiscriminator().toString());
                            } else if (current.isLeaf()) {
                                for (int i = 0; i < level; i++) {
                                    System.out.print("  ");
                                }
                                System.out.println(current.getData().toString());
                            }
                        }
                        System.out.println();
                    }
        	«ENDIF»
            
        	   return successor;
        	}
        	
        }
    '''

}

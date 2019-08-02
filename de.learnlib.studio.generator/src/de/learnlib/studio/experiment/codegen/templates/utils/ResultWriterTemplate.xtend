package de.learnlib.studio.experiment.codegen.templates.utils

import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.config.CommandLineOptionsTemplate

class ResultWriterTemplate extends AbstractSourceTemplate {
    
    new(GeneratorContext context) {
        super(context, "util", "ResultWriter")
    }
    
    override template() '''
        package « package »;
        
        import java.io.IOException;
        import java.nio.file.FileSystems;
        import java.nio.file.Files;
        import java.nio.file.Path;
        import java.nio.file.StandardOpenOption;
        
        import « reference(CommandLineOptionsTemplate) »;
        
        
        public class « className » {
            
            private « className»() {}
            
            public static void writeData(String dataId, String value) {
                writeData(dataId, "", value);
            }
            
            public static void writeData(String dataId, int step, String value) {
                writeData(dataId, Integer.toString(step), value);
            }
            
            public static void writeData(String dataId, String step, String value) {
                try {
                    // Get the file
                    String resultDir = System.getProperty(CommandLineOptions.SELECT_OUPUT_DIR.getSystemProperty());
                    Path resultDirPath = FileSystems.getDefault().getPath(resultDir);
                    
                    if (!Files.exists(resultDirPath)) {
                        Files.createDirectories(resultDirPath);
                    }
                    
                    final String fileBaseName = "« context.modelName »";
                    System.out.println("File Base Name: " + fileBaseName);
                    final String experimentStartTime = System.getProperty("EXPERIMENT_START_TIME");
                    String newFileName = fileBaseName + "-" + experimentStartTime + ".csv";
                    
                    Path targetFile = resultDirPath.resolve(newFileName);
                    
                    
                    // Print the information
                    if (!Files.exists(targetFile)) {
                        writeData(targetFile, "Configuration, DataID, Step, Value");
                    }
                    
                    String currentConfiguration = System.getProperty("« context.modelName ».currentConfiguration");
                    if (currentConfiguration == null) {
                        currentConfiguration = "0";
                    }
                    
                    StringBuffer outputLine = new StringBuffer();
                    outputLine.append(currentConfiguration);
                    outputLine.append(", ");
                    outputLine.append(dataId);
                    outputLine.append(", ");
                    outputLine.append(step);
                    outputLine.append(", ");
                    outputLine.append(value);
                    
                    writeData(targetFile, outputLine.toString());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            
            public static void writeData(Path file, String data) {
                String content = data + "\n";
                
                try {
                    if (Files.notExists(file)) {
                        Files.createFile(file);
                    }
                    Files.write(file, content.getBytes(), StandardOpenOption.APPEND);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            
            /*
            public static void writeData(String dataId, String fileExt, String data) {
                try {
                    Path file = getFile(dataId, fileExt);
                    
                    writeData(file, data);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            */
            
            public static Path getFile(String dataId, String fileExt) throws IOException {
                String resultDir = System.getProperty(CommandLineOptions.SELECT_OUPUT_DIR.getSystemProperty());
                Path resultDirPath = FileSystems.getDefault().getPath(resultDir);
                
                String currentConfiguration = System.getProperty("« context.modelName ».currentConfiguration");
                if (currentConfiguration != null) {
                    resultDirPath = resultDirPath.resolve(currentConfiguration);
                }
                
                final String fileBaseName = "« context.modelName »_" + dataId;
                System.out.println("File Base Name: " + fileBaseName);
                
                long fileNo = 1l;
                if (Files.exists(resultDirPath)) {
                    fileNo = Files.find(resultDirPath, 1, (p, a) -> {
                                            String fileName = p.toFile().getName();
                                            return a.isRegularFile() && fileName.startsWith(fileBaseName) && fileName.endsWith(fileExt);
                                        })
                                    .count() + 1l;
                } else {
                    Files.createDirectories(resultDirPath);
                }
                
                String newFileName = fileBaseName + "_" + Long.toString(fileNo) + "." + fileExt;
                
                Path targetFile = resultDirPath.resolve(newFileName);
                return targetFile;
            }
            
        }
    '''
    
}
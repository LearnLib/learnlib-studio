# The Next Generation LearnLib Studio


## Development Set-Up

- Clone this project.
- `./mvnw clean package -f de.learnlib.studio.libraries`. This downloads all needed
- Start a recent Cinco version and select the cloned folder as workspace.
- Right click on the *Project Explorer* -> *Import* -> *General* -> *Existing Projects into Workspace* -> Choose the cloned
  folder as root directory, *Select all* and *Finish*
- Right click on*de.learnlib.studio/model/LearnLibStudio.cpd* and click *Generate Cinco Product*
- Run as Eclipse application


## Examples

Some examples can be found in the *examples* folder.
In a running LearnLib Studio right click on the *Project Explorer* -> *Import* -> *Existing Projects into Workspace* ->
Choose the *example* folder as root directory, *Select all*, Check *Copy projects into workspace* and *Finish*.

The 3rd example is designed for a [ToDoMVC](http://todomvc.com/) running on port 8000 and Chrome and Chromedriver executable on the system.

## Build a Standalone

- Have a working Development Set-Up
- Run `./build.sh` (only tested on Linux). You can select the desired platforms by adding *linux64*, *win64*, or *macosx*.
  Defaults to all platforms.
- Enjoy the standalone versions in *de.learnlib.studio.product/target/products*.


## Used Technologies / Frameworks / Libraries / ...

- [LearnLib / AutomataLib](https://learnlib.de/)
- [Cinco](https://cinco.scce.info/)
- [Eclipse IDE & Xtend](https://www.eclipse.org/)
- [Maven Wrapper](https://github.com/takari/maven-wrapper)
- and a bunch more...


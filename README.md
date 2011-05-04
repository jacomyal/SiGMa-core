####SiGMa-core
The core repository of SiGMa, the *Simple Graph Mapper*

- - -

Here is a simple example of how to use **SiGMa-core** in an *ActionScript 3* project:
<pre>
// SiGMa-core use example:
// Initialize the CoreControler, by giving it a DisplayObjectContainer 
// the DisplayObjectContainer where to you want to draw your graph
CoreControler.init(stage,stage.stageWidth,stage.stageHeight);

// Create some nodes and edges...
var n1:Node = new Node("n1","Hello");
n1.x = 0; n1.y = 0; n1.size = 30;

var n2:Node = new Node("n2","world!");
n2.x = 0; n2.y = 5; n2.size = 30;

var e1:Edge = new Edge("e1","n1","n2");

// ... and push them into the graph
Graph.pushNode(n1);
Graph.pushNode(n2);
Graph.pushEdge(e1);
</pre>


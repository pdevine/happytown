package
{
    import flash.utils.Dictionary;

    public class TraversalGraph
    {
        private var graph:Dictionary;

        public function TraversalGraph()
        {
            graph = new Dictionary();

            //trace(graph);
            //var p:Array = findPath(graph, 'n1', 'n7', []);
            //trace("shortest path:", p);
        }

        public function addVertex(v:Object):void
        {
            trace("added", v, " to graph");
            graph[v] = [];
        }

        public function addEdge(v1:Object, v2:Object):void
        {
            trace("connected", v1, "to", v2);
            graph[v1].push(v2);
        }

        public function findShortestPath(start:Object,
                                         end:Object,
                                         path:Array):Array
        {
            var newPath:Array;
            var existingPath:Array;

            // make a copy of the current path and add the starting location
            existingPath = path.slice(0)
            existingPath.push(start);
            trace("findShortest:", start, end, path);
            trace(graph);

            if(start == end) {
                trace("found!", start);
                path.push(end);
                return path;
            }

            if(! start in graph) {
                trace(start, "not in graph");
                return null; 
            }

            var shortest:Array = [];

            for(var i:int = 0; i < graph[start].length; i++)
            {
                var nextNode:String = graph[start][i];

                trace("nextNode:", nextNode);
                trace("existing path:", existingPath);

                var found:Boolean = false;
                for(var j:int = 0; j < existingPath.length; j++)
                {
                    if(nextNode == existingPath[j])
                    {
                        found = true;
                        break;
                    }
                }
                if(! found)
                {
	                trace("searching for: ", nextNode);
	                newPath = findShortestPath(
                        nextNode,
                        end,
                        existingPath);
	                if(newPath.length > 0) {
	                    trace("new path: ", newPath);
                        if(shortest.length == 0 ||
                           newPath.length < shortest.length)
                            shortest = newPath;
	                }
                }
            }
            return shortest;
        }

    }
}

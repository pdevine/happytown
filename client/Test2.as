package
{
    import flash.display.Sprite;
    import flash.utils.Dictionary;

    public class Test2 extends Sprite
    {
        private var graph:Dictionary;
        public function Test2()
        {
            graph = new Dictionary();

            graph['n1'] = ['n2', 'n4'];
            graph['n2'] = ['n1', 'n3'];
            graph['n3'] = ['n2', 'n6'];
            graph['n4'] = ['n1'];
            graph['n5'] = ['n6', 'n8'];
            graph['n6'] = ['n3', 'n5', 'n9'];
            graph['n7'] = ['n8'];
            graph['n8'] = ['n7', 'n5', 'n9'];
            graph['n9'] = ['n6', 'n8'];

            trace(graph);
            var p:Array = findPath(graph, 'n1', 'n7', []);
            trace("shortest path:", p);
        }

        public function findPath(graph:Dictionary,
                                 start:String,
                                 end:String,
                                 path:Array):Array
        {
            var newPath:Array;
            var existingPath:Array;

            // make a copy of the current path and add the starting location
            existingPath = path.slice(0)
            existingPath.push(start);

            if(start == end) {
                trace("found!", start);
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
	                newPath = findPath(graph, nextNode, end, existingPath);
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

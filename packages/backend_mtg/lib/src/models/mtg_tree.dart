import './mtg_node.dart' ;
import './mtg_scale.dart' ;
import './mtg_description.dart' ;

class MTGTree {
    List<MTGScale>? scales;
    MTGNode? root;
    Map<String, MTGNode>? nodes;
    List<MTGDescription>? descriptions;
}

/**
 * User: booster
 * Date: 02/02/14
 * Time: 10:25
 */
package demo.model {
import stork.core.Node;

public class GameModelNode extends Node {
    public static const X:int       = 1;
    public static const O:int       = -1;
    public static const EMPTY:int   = 0;

    private var board:Vector.<Vector.<int>> = new <Vector.<int>>[
        new <int>[0, 0, 0],
        new <int>[0, 0, 0],
        new <int>[0, 0, 0]
    ];

    private var _currentSymbol:int  = EMPTY;
    private var _victorSymbol:int   = EMPTY;

    public function GameModelNode() {
        super("GameModel");
    }

    public function get currentSymbol():int { return _currentSymbol; }
    public function set currentSymbol(value:int):void { _currentSymbol = value; }
    public function get victorSymbol():int { return _victorSymbol; }
    public function set victorSymbol(value:int):void { _victorSymbol = value; }
    public function nextSymbol():int { return currentSymbol == O ? X : O; }

    public function putSymbol(symbol:int, x:int, y:int):void { board[y][x] = symbol; }
    public function getSymbol(x:int, y:int):int { return board[y][x]; }

    public function get boardFull():Boolean {
        var colSize:int = board.length;
        for(var y:int = 0; y < colSize; y++) {
            var row:Vector.<int> = board[y];

            var rowSize:int = row.length;
            for(var x:int = 0; x < rowSize; x++) {
                var field:int = row[x];

                if(field == EMPTY)
                    return false;
            }
        }

        return true;
    }
}
}

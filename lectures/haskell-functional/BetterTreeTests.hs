-- $Id$
module BetterTreeTests where
import BetterTree
import Testing

main :: IO ()
main = dotests "$Revision$" (treeMap_tests ++ deleteNode_tests)
-- test cases
l3 = Leaf 3
n3710 = Node {left = Leaf 3, value = 7, right = Leaf 10}
rt = Node {left = Leaf 11, value = 9
          ,right = (Node {left = Leaf 2, value = 5
                         ,right = Leaf 4})}
-- tests for treeMap functions, tm is the treeMap function tested
test_treeMap = dotests "Testing treeMap $Revision" treeMap_tests
treeMap_tests = (tm_tests treeMap ++ tm_tests treeMap')
tm_tests tm = 
    [eqTest (tm id l3) "==" l3
    ,eqTest (tm (+1) l3) "==" (Leaf 4)
    ,eqTest (tm (+1) n3710)
     "==" (Node {left = Leaf 4, value = 8, right = Leaf 11})
    ,eqTest (tm (\n -> 10*n) rt)
     "==" Node {left = Leaf 110, value = 90
               ,right = Node {left = Leaf 20, value = 50, right = Leaf 40}}
    ]
-- tests for deleteNode functions, dn is the deleteNode function tested
test_deleteNode = dotests "Testing deleteNode $Revision" deleteNode_tests
deleteNode_tests = (dn_tests deleteNode ++ dn_tests deleteNode')
dn_tests dn = 
    [eqTest (dn 3 l3) "==" Empty
    ,eqTest (dn 7 l3) "==" l3
    ,eqTest (dn 7 n3710) "==" Empty
    ,eqTest (dn 5 n3710) "==" n3710
    ,eqTest (dn 10 n3710) "==" (Node {left = Leaf 3, value = 7, right = Empty})
    ,eqTest (dn 9 rt) "==" Empty
    ,eqTest (dn 11 rt)
     "==" Node {left = Empty, value = 9
               ,right = Node {left = Leaf 2, value = 5, right = Leaf 4}}
    ,eqTest (dn 5 rt)
     "==" Node {left = Leaf 11, value = 9, right = Empty}
    ,eqTest (dn 2 rt)
     "==" Node {left = Leaf 11, value = 9
               ,right = Node {left = Empty, value = 5, right = Leaf 4}}
    ,eqTest (dn 4 rt)
     "==" Node {left = Leaf 11, value = 9
               ,right = Node {left = Leaf 2, value = 5, right = Empty}}
    ]

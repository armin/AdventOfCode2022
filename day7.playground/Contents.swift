import UIKit

var greeting = "Hello, playground"


print("\(input)")

public class TreeNode<T> {
    
    public var value: T
    public var children: [TreeNode] = []
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func add(_ child: TreeNode) {
        children.append(child)
    }
}

extension TreeNode {
    public func depthFirstTraversal(visit: (TreeNode) -> Void) {
        visit(self)
        children.forEach {
            $0.depthFirstTraversal(visit: visit)
        }
    }
}
extension TreeNode {
    public func levelOrderTraversal(visit: (TreeNode) -> Void) {
        visit(self)
        var queue = [TreeNode]()
        children.forEach { queue.append($0) }
        
        while !queue.isEmpty {
            let node = queue.removeFirst()
            visit(node)
            node.children.forEach { queue.append($0) }
        }
    }
}

extension TreeNode where T: Equatable {
    public func search(_ value: T) -> TreeNode? {
        var result: TreeNode?
        depthFirstTraversal { node in
            if node.value == value {
                result = node
            }
        }
        return result
    }
}

protocol Nodeable {
    var type: NodeType { get set }
    var size: Int { get set }
    var name: String  { get set }
}

enum NodeType {
    case dir, file
}

class Node: Nodeable {
    var type: NodeType = .dir
    var size: Int = 0
    var name: String = ""
    init(
        type: NodeType = .dir,
        size: Int = 0,
        name: String = ""
    ) {
        self.type = type
        self.size = size
        self.name = name
    }
}

func parse(input: String) {
    var root = TreeNode<Node>(Node(type: .dir, size: 0, name: "/"))
    var currentNode = root
    
    let lines: [String] = input.components(separatedBy: "\n")
    
    for line in lines {
        // if $. execute, pop
        //   $ if cd .., up one level
        //     if cd x, pop
        if line.hasPrefix("$ cd") {
            let index = line.index(line.startIndex, offsetBy: 5)
            let cmdCd = String(line.suffix(from: index))
            if cmdCd == ".." {
                print("cd up")
            }
            else { // cd abc
                print("ignore cd")
            }
            continue
        }
        // if ls, pop
        if line.hasPrefix("$ ls") {
            print("ignore ls")
            continue
        }

        // if dir, add dir node, pop
        if line.hasPrefix("dir ") {
            let index = line.index(line.startIndex, offsetBy: 4)
            let dir = String(line.suffix(from: index))

            print("add node \(dir)")
            var node = Node(
                type: .dir,
                size: 0,
                name: dir
            )
            let treeNode = TreeNode(node)
            currentNode.add(treeNode)
            currentNode = treeNode
            continue
        }

        // if number, add file node
        let comps = line.components(separatedBy: " ")
        if comps.count == 2 {
            let size = Int(comps[0])!
            let file = comps[1]
            print("add file node \(size) \(file)")
            var node = Node(
                type: .file,
                size: size,
                name: file
            )
            let treeNode = TreeNode(node)
            currentNode.add(treeNode)
            continue
        }
        
    }
//    print("finished with current node \(tree.name)")
//    let root = findRoot(node: tree)
//    print(calcSize(value: 0, node: root))
    
    // populate dirs with sizes of children
    
}

//func findRoot(node: Nodeable) -> Nodeable {
//    guard let parent = node.parent else { return node }
//    return findRoot(node: parent)
//}
//
//func printTree(node: Nodeable) {
//    for child in node.children {
//        print("child: \(child.name)")
//        if child.type == .file {
//            print("size: \(child.size)")
//        }
//        printTree(node: child)
//    }
//}

//func calcSize(value: Int, node: inout Nodeable) -> Int {
//    var size = value
//    for child in node.children {
//        if child.type == .file {
//            size += calcSize(value: child.size ,node: child)
//        }
//        if child.type == .dir {
//            node.size = calcSize(value: child.size ,node: child)
//        }
//
//    }
//    return size
//}



let input = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""

parse(input: input)

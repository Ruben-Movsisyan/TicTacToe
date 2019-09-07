import Foundation

public enum BoardSize: String{
    case small = "1"
    case medium = "2"
    case large = "3"
}

enum Turn: Character {
    case tic = "X"
    case tac = "O"
    
    var next: Turn {
        switch self {
        case .tic: return .tac
        case .tac: return .tic
        }
    }
}

var size = BoardSize.small
var boardInit: [[String]]!
var playerIndex = 1
var player = Turn.tic
var moveCount = 0

print("""
Please enter the board size you want to play:
1. Small: (3x3)
2. Medium: (5x5)
3. Large: (7x7)
Otherwise classic board will be initialized (3x3)
""")

func declaringBoard(rows: Int, columns: Int) -> [[String]]{
    boardInit = Array(repeating: Array(repeating: "_", count: rows), count: columns)
    for i in 0..<boardInit.count{
    print(boardInit[i])
    }
    return boardInit
}

if let checker = BoardSize(rawValue: readLine()!){
     size = checker
}

switch size {
case .small:
    boardInit = declaringBoard(rows: 3, columns: 3)
case .medium:
    boardInit = declaringBoard(rows: 5, columns: 5)
case .large:
    boardInit = declaringBoard(rows: 7, columns: 7)
}

func printWinningPlayer(){
    playerIndex += 1
    if playerIndex == 3 {playerIndex = 1}
    print("\nPlayer\(playerIndex) wins!!")
}

public func inputCoordinates(){
    print("\nPlayer\(playerIndex) input desired point coordinates (row, column): ", terminator: "")
    if let input = readLine(strippingNewline: true){
        let coordinates = input.filter { !$0.isWhitespace }.split(separator: ",")
        if coordinates.count >= 2, let first = Int(coordinates[0]), let second = Int(coordinates[1]) {
            let normalizedFirst = first - 1
            let normalizedSecond = second - 1
            if normalizedFirst >= 0 && normalizedSecond >= 0 && normalizedFirst < boardInit.count && normalizedSecond < boardInit.count{
                if boardInit[normalizedFirst][normalizedSecond] == "_"{
                    boardInit[normalizedFirst][normalizedSecond] = String(player.rawValue)
                    player = player.next
                    playerIndex += 1
                    moveCount += 1
                    if playerIndex == 3 {playerIndex = 1}
                }else{
                    print("\nThis space is used!\n")
                }
            }else {
                print("\nWrong input!\n")
            }
        }else {
            print("\nWrong input!\n")
        }
    }
}

func haveWinner() -> Bool {
    for i in 0..<boardInit.endIndex{
        for j in 0..<boardInit.endIndex{
            if boardInit[i][j] != String(player.next.rawValue){
                break
            }
            if j == boardInit.endIndex - 1{
                printWinningPlayer()
                return true
            }
        }
    }
    for i in 0..<boardInit.endIndex{
        for j in 0..<boardInit.endIndex{
            if boardInit[j][i] != String(player.next.rawValue){
                break
            }
            if j == boardInit.endIndex - 1 {
                printWinningPlayer()
                return true
            }
        }
    }
    for i in 0..<boardInit.endIndex{
        if boardInit[i][i] != String(player.next.rawValue){
            break
        }
        if i == boardInit.endIndex - 1{
           printWinningPlayer()
            return true
        }
    }
    for i in 0..<boardInit.endIndex{
        if boardInit[i][boardInit.endIndex-i-1] != String(player.next.rawValue){
            break
        }
        if i == boardInit.endIndex - 1{
            printWinningPlayer()
            return true
        }
    }
    if moveCount == boardInit.count * boardInit.count{
        print("\nNo winner this time!!")
        return true
    }
    return false
}

while !haveWinner(){
    inputCoordinates()
    for i in 0..<boardInit.count{
        print(boardInit[i])
    }
    
}

print("\nGame over!!")

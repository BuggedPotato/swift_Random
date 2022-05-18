import Foundation

enum cardSymbol : String
{
    case pik = "♤"
    case czerwo = "♡"
    case trefl = "♧"
    case karo = "♢" 
}

struct Card : Hashable, Comparable
{
    let name: String;
    let value: Int;

    func hash( into hasher: inout Hasher )
    {
        name.hash( into: &hasher );
        value.hash( into: &hasher );
    }

    static func == (a: Card, b: Card) -> Bool 
    {
        return a.name == b.name && a.value == b.value
    }
    static func < (a: Card, b: Card) -> Bool 
    {
        if a.name == b.name
        {
            return a.value < b.value;
        }
        else
        {
            return a.name < b.name;
        }
    }
}

func getPackOfSymbol( _ symbol: cardSymbol ) -> Set<Card>
{
    let names: [String] = [ "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K" ];
    let values: [Int] = [ 11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 2, 3, 4 ];
    var set: Set<Card> = Set<Card>();

    for i in 0..<names.count
    {
        let card : Card = Card( name: symbol.rawValue + names[i], value: values[i] );
        set.insert( card );
    }
    return set;
}

func getAllCards() -> Set<Card>
{
    var a = getPackOfSymbol( cardSymbol.pik );
    a = a.union( getPackOfSymbol( cardSymbol.czerwo ) );
    a = a.union( getPackOfSymbol( cardSymbol.trefl ) );
    a = a.union( getPackOfSymbol( cardSymbol.karo ) );

    return a;
}

func getPackValue( _ pack : Set<Card> ) -> Int
{
    var sum: Int = 0;
    pack.map{ sum += $0.value };
    return sum;
}

// true -> in game, false -> lost / persian eye
func printPackValueAndCheckScore( _ pack: Set<Card> ) -> Bool?
{
    let sum : Int = getPackValue( pack );
    pack.map{ print( "\($0.name) (\($0.value))", terminator: ", " ) };
    print( "Σ=\(sum)" );

    if checkForPersianEye( pack )
    {
        // print( "[[ Perskie Oko! ]]" );
        return nil;
    }
    else if sum > 21
    {
        // print( ">> Przegrana!" );
        return false;
    }
    return true;
}
func checkForPersianEye( _ pack: Set<Card> ) -> Bool
{
    var aces: Set<Card> = Set<Card>();
    aces.insert( Card( name: cardSymbol.pik.rawValue+"A", value: 11 ) );
    aces.insert( Card( name: cardSymbol.czerwo.rawValue+"A", value: 11 ) );
    aces.insert( Card( name: cardSymbol.trefl.rawValue+"A", value: 11 ) );
    aces.insert( Card( name: cardSymbol.karo.rawValue+"A", value: 11 ) );

    return pack.intersection( aces ).count == 2;
}



func botDecision( _ computerPack: Set<Card> ) -> String
{
    let packValue: Int = getPackValue( computerPack );
    return packValue < 17 ? "d" : "p";
}



func decideWinner( playerPack: Set<Card>, computerPack: Set<Card> ) -> String
{
    let playerScore: Int = getPackValue( playerPack );
    let computerScore: Int = getPackValue( computerPack );

    var str : String = "";
    if playerScore > computerScore
    {
        str = "[[ WYGRANA GRACZA (\(playerScore)>\(computerScore)) ]]";
    }
    else if playerScore == computerScore
    {
        str = "[[ REMIS ]]";
    }
    else 
    {
        str = "[[ WYGRANA KOMPUTERA (\(computerScore)>\(playerScore)) ]]";
    }
    return str;
}



// zmienne do gry
var freeCards: Set<Card> = getAllCards();
var playerPack: Set<Card> = Set<Card>();
var computerPack: Set<Card> = Set<Card>();

print( "Początek gry:" );
var input: String = "";

print( "Gracz:" );
// pierwsze dobranie
playerPack.insert( freeCards.removeFirst() );
printPackValueAndCheckScore( playerPack );
// kolejka gracza
while true
{
    input = readLine()!.lowercased();
    if input == "dobieram" || input == "d"
    {
        playerPack.insert( freeCards.removeFirst() );
        let res: Bool? = printPackValueAndCheckScore( playerPack );
        if res == nil
        {
            print( "[[ WYGRYWASZ ZDOBYWAJĄC PERSKIE OKO! ]]" ); 
            exit(0);
        }
        else if !res!
        {
            print( "[[ WYGRANA KOMPUTERA ]]" ); 
            exit(0);
        }
    }
    else if input == "pass" || input == "p"
    {
        break;
    }
    else
    {
        print( ">> Nieprawidłowe polecenie." );
    }
}

// kolejka komputera
print( "Komputer:" );
computerPack.insert( freeCards.removeFirst() );
printPackValueAndCheckScore( computerPack );
while true
{
    input = botDecision( computerPack );
    if input == "dobieram" || input == "d"
    {
        computerPack.insert( freeCards.removeFirst() );
        let res: Bool? = printPackValueAndCheckScore( computerPack );
        if res == nil
        {
            print( "[[ KOMPUTER WYGRYWA ZDOBYWAJĄC PERSKIE OKO! ]]" ); 
            exit(0);
        }
        else if !res!
        {
            print( "[[ WYGRANA GRACZA ]]" ); 
            exit(0);
        }
    }
    else if input == "pass" || input == "p"
    {
        break;
    }
}

print( decideWinner( playerPack: playerPack, computerPack: computerPack ) );
/*
2. Napisz program umożliwiający rotowanie tablicy w prawo i lewo.
	- wejściową tablicę podaje użytkownik
	- użytkownik decyduje o rotacji wpsując kierunek R/L i ilość iteracji
	- w wyniku kod wypisuje każdą z iteracji
	- pętla kontynuowana do zakończenia np. klawisz "k"
	
	przykładowo:
		wprowadzona tablica wejściowa [1,2,3,4,5]
		
		R3
		[1,2,3,4,5] // iteracja 0
		[5,1,2,3,4] // iteracja 1
		[4,5,1,2,3] // iteracja 2
		[3,4,5,1,2] // iteracja 3
	
		L2
		[3,4,5,1,2] // iteracja 0
		[4,5,1,2,3] // iteracja 1
		[5,1,2,3,4] // iteracja 2
		
		k // koniec
*/

func youSpinMeRightRoundLikeAnArrayBaby( inputArray : [Any], spinString : String ) -> Void
{
    let distance : Int;
    var array : [Any] = inputArray;
    if let a = parseSpinString( string: spinString )
    {
        distance = a;
    }
    else
    {
        print( "\n[ERROR] Invalid string argument!\n" );
        return;
    }

    print( array );
    for _ in 0..<abs( distance )
    {
        if distance > 0
        {
            let element : Any = array.removeLast();
            array.insert( element, at: 0 );
        }
        else
        {
            let element : Any = array.removeFirst();
            array.append( element );
        }
        print( array );
    }
}

func parseSpinString( string : String ) -> Int?
{
    var direction : Int = 1;
    var distance : UInt;

    var input : String = string;
    input = input.lowercased();
    switch( input.first )
    {
        case "l":
            direction = -1;
        case "r":
            direction = 1;
        default: 
            return nil;
    }

    input = String( input.dropFirst() );
    if let a = UInt( input )
    {
        distance = a;
    }
    else
    {
        return nil;
    }

    return direction * Int( distance );
}


var input : String = "";
while true
{
    print( "Input array:\n" );
    input = readLine()!;
    
    if !(input.first == "[" && input.last == "]")
    {
        print( "\n[ERROR] Invalid array input.\n" );
        continue;
    }
    // removes '[' thingies
    input.removeFirst();
    input.removeLast();
    break;
}

let array : [Any] = input.split( separator: "," ).map{ let tmp = Int( $0 ); return tmp ?? $0 };

while true
{
    print( "Original array:\n\(array)" );
    print( " >" );
    input = readLine()!;
    if input.lowercased() == "k"
    {
        break;
    }
    
    youSpinMeRightRoundLikeAnArrayBaby( inputArray: array, spinString: input );
}



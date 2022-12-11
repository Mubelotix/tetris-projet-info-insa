unit menu;

interface

uses crt, grids, blocks, scores;

// Affiche l'écran de defaite
procedure CheckDefeatScreen(score, p: Integer);

// Renvoie p. Si p=1 c'est Oui sinon c'est non
function selectYorN(Key:Char ; Score, p: Integer): Integer;

// Renvoie g. Si g=1 c'est Jouer sinon c'est Classement
function selectYorN2(Key:Char ; g: Integer): Integer;

// Affiche l'écran d'accueil
procedure MainScreen(g:Integer);

// Demande le pseudo
function askName(): string;




implementation

// Affiche l'écran de defaite
procedure CheckDefeatScreen(score, p: Integer);
var i, j: Integer;
begin
    writeln();
    writeln();
    writeln();
    
    // plafond
    write('┌');
    for i:=0 to 23 do write('─');
    write('┐');
    
    // contenu
    for j:=1 to 10 do begin   
        //Grille en elle-meme
        writeln();
        write('│');
        if  j = 3 then begin
            write('      Score:  ', Score);
            if Score = 0 then
                write ('         ')
            else
                for i:=1 to 9 - Round(ln(Score)/ln(10)) do
                    write(' '); ///Ajuster le | selon la taille du score
            write('│');
        end else if j = 5 then
            write('Voulez-Vous recommencer?│')
        else if j = 7 then begin
            if p=1 then
                write('    > Oui        Non    │');
            if p=-1 then
                write('      Oui      > Non    │');
        end else begin
            for i:=0 to 11 do
                write('  ');
            write('│');
        end;
    end;

    //sol
    writeln();
    write('└');
    for i:=0 to 23 do
        write('─');
    write('┘');
end;

// Renvoie p. Si p=1 c'est Oui sinon c'est non
function selectYorN(Key:Char ; Score, p:integer): integer;
begin
    if KeyPressed then begin
        Key := ReadKey;  //Touche Droite et Gauche
        Case Key Of
            #0: Begin
                if KeyPressed = True then Key:= ReadKey;
                Case Key Of
                    #75: p:= p*(-1);
                    #77: p:= p*(-1);
                end;
            End;
            ' ': p:= p*3;
        end;
    End;    
    selectYorN := p;
    clrscr;
    CheckDefeatScreen(Score,p);
    Delay(50);
end;

////PARTIE DE Julien

// Affiche l'écran d'accueil
procedure MainScreen(g:Integer);
var j: integer;
begin
    writeln();
    writeln();
    writeln();

    for j:=1 to 10 do begin
        writeln();
        case j of
            1: write('  _______   _        _     ');
            2: write(' |__   __| | |      (_)    ');
            3: write('    | | ___| |_ _ __ _ ___ ');
            4: write('    | |/ _ \ __|  __| / __|');
            5: write('    | |  __/ |_| |  | \__ \');
            6: write('    |_|\___|\__|_|  |_|___/'); 

            8: if (g = 1) then write (' 	> Jouer		') else  write (' 	  Jouer'    );
            10: if (g = -1) then write ('	> Classement	') else  write ('	  Classement	');
        end;
    end;

    Delay(10);
end;

// Renvoie g. Si g=1 c'est Jouer sinon c'est Classement
function selectYorN2(Key: Char; g: Integer): Integer;
begin
    if KeyPressed then begin
        Key := ReadKey;  //Touche haut 72 et Bas 80 
        Case Key Of
            #0: Begin
                if KeyPressed then Key:= ReadKey;
                Case Key Of
                    #80: g:= g*(-1);
                    #72: g:= g*(-1);
                End;
            End;
            ' ': g:= g*(3)
        end;
    End;
    selectYorN2 := g;
    clrscr;
    MainScreen(g);
    Delay(150);
    //write(g);
end;

// Demande le pseudo
function askName(): string;
begin
    clrscr();
    writeln('Inserez votre pseudo');
    Readln(askname);
end;

end.

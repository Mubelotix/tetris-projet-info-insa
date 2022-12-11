unit menu;

interface

uses crt, grids, blocks, scores;

procedure CheckDefeatScreen(score, p:Integer); // Ecran de defaite
function selectYorN(Key:Char ; Score, p:integer): integer;   ///Renvoie p. Si p=1 c'est Oui sinon c'est non
function selectYorN2(Key:Char ; g:integer): integer;   ///Renvoie g. Si g=1 c'est Jouer sinon c'est Classement
procedure MainScreen(g:Integer);
function askName(): string;

implementation
	
procedure CheckDefeatScreen(score, p:Integer); // Ecran de defaite
var i,j: integer;

begin
writeln();
writeln();
writeln();
                                        //plafond
  write('┌');
  for i:=0 to 23 do write('─');
  write('┐');
  
                                        //contenu
 for j:=1 to 10 do
 begin   
                                        //Grille en elle-meme
 writeln();
 write('│');
   if  j = 3 then begin
   write('      Score:  ', Score);
   if Score = 0 then write ('         ') else for i:=1 to 9 - Round(ln(Score)/ln(10)) do write(' '); ///Ajuster le | selon la taille du score
   write('│');
   end
    
   else if j = 5  then write('Voulez-Vous recommencer?│')
   else if j = 7  then 
        begin
         if p=1 then write('    > Oui        Non    │');
        if p=-1 then write('      Oui      > Non    │');
        end
   else 
   begin
    for i:=0 to 11 do
     begin
     write('  ')
     end;
     write('│');
     end;
    
end;

         
                                        //sol
writeln();
write('└');
for i:=0 to 23 do write('─');
write('┘');

end;


function selectYorN(Key:Char ; Score, p:integer): integer;   ///Renvoie p. Si p=1 c'est Oui sinon c'est non
begin
if KeyPressed = True then 
  begin
  Key := ReadKey;  //Touche Droite et Gauche

   Case Key
      Of
       #0    : Begin
                if KeyPressed = True then Key:= ReadKey;
                Case Key
                Of
                 #75 : 
                  begin
                   p:= p*(-1)
                  end;
                 #77 : 
                  begin
                  p:= p*(-1)
                  end;

                 End;
                End;
        ' '  : 
                begin
                p:= p*3
               
                end;       

  End;     
     
  End;    
  selectYorN := p;
  clrscr;
  CheckDefeatScreen(Score,p);
  Delay(50);
end;




////PARTIE DE Julien

procedure MainScreen(g:Integer); // Ecran d'accueil
var j: integer;

begin

writeln();
writeln();
writeln();

for j:=1 to 10 do
	begin
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

function selectYorN2(Key:Char ; g:integer): integer;   ///Renvoie g. Si g=1 c'est Jouer sinon c'est Classement
begin
if KeyPressed = True then 
  begin
  Key := ReadKey;  //Touche haut 72 et Bas 80 

   Case Key
      Of
       #0    : Begin
                if KeyPressed = True then Key:= ReadKey;
                Case Key
                Of
                 #80 : 
                  begin
                   g:= g*(-1)
                  end;
                 #72 : 
                  begin
                  g:= g*(-1)
                  end;

                 End;
                End;
         ' ' :
                begin
                 g:= g*(3)
				end;       

  End;        
  End;    
  selectYorN2 := g;
  clrscr;
  MainScreen(g);
  Delay(150);
  //write(g);
end;



function askName(): string;
begin
clrscr();
writeln('Inserez votre pseudo');
Readln(askname);
end;




END.


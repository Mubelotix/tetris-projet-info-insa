unit menu;

interface

uses crt, grids, blocks;

procedure defeatScreen(score, p:Integer); // Ecran de defaite
function selectYorN(Key:Char ; Score, p:integer): integer;   ///Renvoie p. Si p=1 c'est Oui sinon c'est non

implementation
	
procedure defeatScreen(score, p:Integer); // Ecran de defaite
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
   if  j = 3 then write('      Score:  ', Score, '         │')
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
                 #72 : 
                  begin
                  p:= p*3
               
                  end;
                 End;
                End;
              

  End;        
  End;    
  selectYorN := p;
  clrscr;
  defeatScreen(Score,p);
  Delay(150);
  write(p);
end;


END.


program menu_tetris;

procedure Jouer;
begin 
writeln('Le jeu va commencer');
end;

procedure Classement;
begin
writeln('Voici le classement des scores');
end;



procedure Menu;
var b:byte; boucle:boolean;
begin
writeln('');
writeln(' TETRIS ');
writeln('');
writeln;
writeln('1. Commencer une partie');
writeln('2. classement');

writeln;
boucle:=true;
while boucle do
      begin
      boucle:=false;
      write('Choix : ');
      readln(b);
      writeln;
      case b of
           1:jouer;
        
           2:classement;
          
           else boucle:=true;
           end;
      end;
end;

begin
Menu;
readln;
end.


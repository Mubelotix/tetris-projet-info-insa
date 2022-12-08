
unit grids;
{$MODE OBJFPC}

interface
uses blocks, sysutils, crt;

type Grid = record
    tiles: Array [0..9, 0..23] of Byte;
end;

// Retourne une grille vide
function empty_grid(): Grid;

// Retourne True si cette position du bloc qui tombe est valide.
function test_collision(
    g: Grid;
    falling_block: Block;   // Structure of the falling block
    x, y: Integer           // Position of the falling block
): Boolean;
procedure test_test_collision();

procedure display(grid:Grid; following_blocks:BlockList; Score, BestScore:integer);


function Clone(grid:Grid; block:Block): Grid; //Fais un clone de la grille + le bloc tombant

function FullLineVerification(i:integer; grid:Grid): Boolean; //Verifie UNE ligne. Renvoie FALSE si la ligne n'est pas complete
function EraseLine(n:integer; grid:Grid):Grid;  //Suprimme la ligne n
function Defeat(grid:Grid):Boolean;  //Verifie si la premiere ligne  contient un bloc, si oui = TRUE et signifie la defaite

implementation

function empty_grid(): Grid;
var i, j: Integer;
begin
    for i := 0 to 9 do
        for j := 0 to 23 do
            empty_grid.tiles[i][j] := 0;
end;

function test_collision(
    g: Grid;
    falling_block: Block;   // Structure of the falling block
    x, y: Integer           // Position of the falling block
): Boolean;
var tx, ty: Integer;
begin
    test_collision := True;
    for tx := 0 to 3 do
        for ty := 0 to 3 do
            if falling_block.tiles[tx][ty] <> 0 then
                if (x + tx < 0) or (x + tx > 9) or (y + ty < 0) or (y + ty > 23) then
                    test_collision := False
                else if g.tiles[x + tx][y + ty] <> 0 then
                    test_collision := False;
end;

procedure test_test_collision();
var line: Block;
    g: Grid;
begin
    line.tiles := load_blocks()[0].tiles;
    g := empty_grid();

    // Test a trivially valid position
    if not(test_collision(g, line, 2, 2)) then
        raise Exception.Create('Single line at center of grid should be valid');

    // Test trivially invalid positions
    if test_collision(g, line, -2, 2) then
        raise Exception.Create('Single line overflowing left should be invalid');
    if test_collision(g, line, 10, 2) then
        raise Exception.Create('Single line overflowing right should be invalid');
    if test_collision(g, line, 2, -1) then
        raise Exception.Create('Single line overflowing top should be invalid');
    if test_collision(g, line, 2, 21) then
        raise Exception.Create('Single line overflowing bottom should be invalid');

    // Test a position overlapping a tile on the grid
    g.tiles[2][2] := 1;
    if test_collision(g, line, 1, 2) then
        raise Exception.Create('Single line overlapping a tile should be invalid');

    // Test a non overlapping position
    if not(test_collision(g, line, 2, 2)) then
        raise Exception.Create('Single line not overlapping a tile should be valid');
end;

procedure display(grid:Grid; following_blocks:BlockList; Score, BestScore:integer);
var i,j: integer;

 begin
 //plafond
 writeln();
  write('┌');
  for i:=0 to 19 do write('─');
  write('┐');
  
 //contenu
 for j:=3 to 23 do
 begin
                                       //Grille en elle-meme
  writeln();
  write('│');
   for i:=0 to 9 do
   
    begin

    if grid.tiles[i][j] = 0 then write('  ')
    else 
     begin
      case grid.tiles[i][j] of
       1 : TextColor(Blue);
       2 : TextColor(Brown);
       3 : TextColor(Cyan);
       4 : TextColor(Green);
       5 : TextColor(Magenta);
       6 : TextColor(Red);
       7 : TextColor(White);
       end;
       write('██');
       TextColor(White);
     end;
     
    end;
    write('│');

                                          //Grille en elle-meme
                                          
                         
 //Blocs suivants
 
   if j=3 then write ('      Score:', Score);
   if j=4 then write (' Best Score:', BestScore);
 
   if (j>5)and(j<9) then
 begin
    write(' ');
    if following_blocks[0].tiles[j-5][0] <> 0 then write('██') else write('  ');
    if following_blocks[0].tiles[j-5][1] <> 0 then write('██') else write('  ');
    if following_blocks[0].tiles[j-5][2] <> 0 then write('██') else write('  ');
    if following_blocks[0].tiles[j-5][3] <> 0 then write('██') else write('  ');
  end; 
   if (j>8)and(j<13) then
 begin
    write(' ');
    if following_blocks[1].tiles[j-9][0] <> 0 then write('██') else write('  ');
    if following_blocks[1].tiles[j-9][1] <> 0 then write('██') else write('  ');
    if following_blocks[1].tiles[j-9][2] <> 0 then write('██') else write('  ');
    if following_blocks[1].tiles[j-9][3] <> 0 then write('██') else write('  ');
  end; 
   if (j>12)and(j<17) then
 begin
    write(' ');
    if following_blocks[2].tiles[j-13][0] <> 0 then write('██') else write('  ');
    if following_blocks[2].tiles[j-13][1] <> 0 then write('██') else write('  ');
    if following_blocks[2].tiles[j-13][2] <> 0 then write('██') else write('  ');
    if following_blocks[2].tiles[j-13][3] <> 0 then write('██') else write('  ');
  end; 


 
 
                                      
  end;
  
  // sol
  
 writeln();
 write('└');
 for i:=0 to 19 do write('─');
 write('┘');
  

 end;
 

function Clone(grid:Grid; block:Block): Grid; //Fais un clone de la grille + le bloc tombant
var i, j: integer;
begin
Clone.tiles := grid.tiles;
for j:=0 to 3 do
 for i:=0 to 3 do
 if block.tiles[i][j] <> 0 then
  Clone.tiles[block.x+i][j+block.y]:= block.tiles[i][j];
end;

function FullLineVerification(i:integer; grid:Grid): Boolean; //Verifie UNE ligne. Renvoie FALSE si la ligne n'est pas complete
var j:integer;
begin
FullLineVerification := True;
for j:=0 to 9 do 
  begin
  if grid.tiles[j][i] = 0 then FullLineVerification := False;
  end;
end;

function EraseLine(n:integer; grid:Grid):Grid;  //Suprimme la ligne n
var i,k:integer;
begin
for i:=3 to n-1  do
for k:=0 to 9  do 
EraseLine.tiles[k][n+3-i] := grid.tiles[k][n+2-i];
end;

function Defeat(grid:Grid):Boolean;  //Verifie si la premiere ligne  contient un bloc, si oui = TRUE et signifie la defaite
var k:integer;
begin
Defeat := False;
for k:=0 to 9 do
  begin
    if grid.tiles[k][3] <> 0 then Defeat := True;
  end;
end;

end.

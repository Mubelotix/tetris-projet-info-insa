
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
    falling_block: FallingBlock;   // Structure of the falling block
    x, y: Integer           // Position of the falling block
): Boolean;
procedure test_test_collision();

procedure display(grid:Grid); //Affiche une grille de type Grid


function Clone(grid:Grid; block:FallingBlock): Grid; //Fais un clone de la grille + le bloc tombant


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
    falling_block: FallingBlock;   // Structure of the falling block
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
var line: FallingBlock;
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

procedure display(grid:Grid);
var i,j: integer;

 begin
 //plafond
 writeln();
  write('┌');
  for i:=0 to 21 do write('─');
  write('┐');
  
 //contenu
 for j:=3 to 23 do
 begin
  
  writeln();
  write('│');
   for i:=0 to 9 do
    begin
    //write('  ');
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
    write('  │')
  end;
  
  // sol
  
 writeln();
 write('└');
 for i:=0 to 21 do write('─');
 write('┘');
  

 end;
 

function Clone(grid:Grid; block:FallingBlock): Grid; //Fais un clone de la grille + le bloc tombant
var i, j: integer;
begin
Clone.tiles := grid.tiles;
for j:=0 to 3 do
 for i:=0 to 3 do
 if block.tiles[i][j] <> 0 then
  Clone.tiles[block.x+i][j+block.y]:= block.tiles[i][j];
end;



end.

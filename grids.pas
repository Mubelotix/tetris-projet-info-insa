
unit grids;
{$MODE OBJFPC}

interface
uses blocks, sysutils;

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
    line := load_blocks()[0];
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

end.

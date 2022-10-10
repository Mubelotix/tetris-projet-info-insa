
unit grids;
{$MODE OBJFPC}

interface
uses blocks, sysutils;

type Grid = record
    tiles: Array [0..9, 0..23] of Byte;
end;

// Retourne True si cette position du bloc qui tombe est valide.
function test_collision(
    g: Grid;
    falling_block: Block;   // Structure of the falling block
    x, y: Integer           // Position of the falling block
): Boolean;

procedure test_collision_test();

implementation

function test_collision(
    g: Grid;
    falling_block: Block;   // Structure of the falling block
    x, y: Integer           // Position of the falling block
): Boolean;
begin end;

procedure test_collision_test();
begin
raise Exception.Create('Helpful description of what went wrong');
end;

end.

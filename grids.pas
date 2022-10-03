
unit grids;

interface
uses blocks;

type Grid = record
    tiles: Array [0..9, 0..23] of Byte;
end;

// Retourne True si cette position du bloc qui tombe est valide.
function test_collision(
    g: Grid;
    falling_block: Block;   // Structure of the falling block
    x, y: Integer           // Position of the falling block
): Boolean;

implementation

function test_collision(
    g: Grid;
    falling_block: Block;   // Structure of the falling block
    x, y: Integer           // Position of the falling block
): Boolean;
begin end;

end.

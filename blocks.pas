unit blocks;
{$MODE OBJFPC}

interface
uses sysutils;

type Block = record
    tiles: Array [0..3, 0..3] of Integer;
    x: integer;
    y:integer;
    
end;

type BlockList = Array [0..6] of Block;

// Charge tous les blocs à partir du fichier blocks.txt
function load_blocks(): BlockList;
procedure test_load_blocks();

// Fait tourner le bloc.
function rotate_block(b: Block; direction: Boolean { True si sens horaire, False si trigonométrique }): Block; 
procedure test_rotate_block();

// Retourne un bloc random
function NewFallingBlock(): Block;

// Renouvelle le bloc qui tombe à partir du premier dans la liste des prochains et complète cette liste
procedure UpdateNextBlocks(var falling_block: Block; var next_blocks: BlockList);

implementation


function load_blocks(): BlockList;
var f: Text;
    i, x, y: Integer;
    lines: Array [0..3] of String;
begin
    // Open file
    Assign(f, 'blocks.txt');
    Reset(f);

    // Read lines
    for y := 0 to 3 do begin
        readln(f, lines[y]);
    end;
    close(f);

    // Parse lines
    for i := 0 to 6 do begin
        for x := 0 to 3 do begin
            for y := 0 to 3 do begin
                load_blocks[i].tiles[x][y] := Ord(lines[y][1 + i*5 + x]) - Ord('0');
                
            end;
        end;
    end;
end;

procedure test_load_blocks();
var blocks: BlockList;
begin
    // Load blocks and compare the sixth block with some known tile values
    blocks := load_blocks();
    if (blocks[5].tiles[1][0] <> 6) OR (blocks[5].tiles[1][1] <> 6) OR (blocks[5].tiles[1][2] <> 6) OR (blocks[5].tiles[2][1] <> 6) OR (blocks[5].tiles[0][0] <> 0) then begin
        raise Exception.Create('Loaded blocks didn''t match expected values.');
    end;
end;

function rotate_block(b: Block; direction: Boolean { True si sens horaire, False si trigonométrique }): Block;
var new_b: Block;
var x, y: Integer;
begin
    if direction then begin
        for y := 0 to 3 do
            for x := 0 to 3 do
                new_b.tiles[x][y] := b.tiles[y][3-x];
                
    end else begin
        for y := 0 to 3 do
            for x := 0 to 3 do
                new_b.tiles[x][y] := b.tiles[3-y][x];
    end;
    rotate_block.x := b.x;
    rotate_block.y := b.y;
    rotate_block.tiles := new_b.tiles;
end;

// Renouvelle le bloc qui tombe à partir du premier dans la liste des prochains et complète cette liste
procedure UpdateNextBlocks(var falling_block: Block; var next_blocks: BlockList);
var i: integer;
begin
    falling_block := next_blocks[0];  // Le prochain bloc qui spawn est le premier sur la liste
    for i:=0 to 5 do   
        next_blocks[i]:= next_blocks[i+1]; // Translation a droite de tous les blocs
    next_blocks[6] := NewFallingBlock();
end;

// ------------------ TESTS ------------------
// 
// Tous le code qui suit est utilisé dans les tests unitaires.
// Il n'est pas exécuté dans le jeu.
//
// -------------------------------------------

procedure test_rotate_block();
var b: Block;
var i: Integer;
begin
    // Simple rotation:
    // 
    // 0123      c840
    // 4567      d951 
    // 89ab  --> ea62
    // cdef      fb73

    b.tiles[0][0] := 0; b.tiles[1][0] := 1; b.tiles[2][0] := 2; b.tiles[3][0] := 3;
    b.tiles[0][1] := 4; b.tiles[1][1] := 5; b.tiles[2][1] := 6; b.tiles[3][1] := 7;
    b.tiles[0][2] := 8; b.tiles[1][2] := 9; b.tiles[2][2] := 10; b.tiles[3][2] := 11;
    b.tiles[0][3] := 12; b.tiles[1][3] := 13; b.tiles[2][3] := 14; b.tiles[3][3] := 15;

    rotate_block(b, True);

    if  (b.tiles[0][0] <> 12) OR (b.tiles[1][0] <> 8) OR (b.tiles[2][0] <> 4) OR (b.tiles[3][0] <> 0) OR
        (b.tiles[0][1] <> 13) OR (b.tiles[1][1] <> 9) OR (b.tiles[2][1] <> 5) OR (b.tiles[3][1] <> 1) OR
        (b.tiles[0][2] <> 14) OR (b.tiles[1][2] <> 10) OR (b.tiles[2][2] <> 6) OR (b.tiles[3][2] <> 2) OR
        (b.tiles[0][3] <> 15) OR (b.tiles[1][3] <> 11) OR (b.tiles[2][3] <> 7) OR (b.tiles[3][3] <> 3) then
            raise Exception.Create('Rotated block doesn''t match the expected values.');

    // Rotate back to original

    rotate_block(b, False);

    if  (b.tiles[0][0] <> 0) OR (b.tiles[1][0] <> 1) OR (b.tiles[2][0] <> 2) OR (b.tiles[3][0] <> 3) OR
        (b.tiles[0][1] <> 4) OR (b.tiles[1][1] <> 5) OR (b.tiles[2][1] <> 6) OR (b.tiles[3][1] <> 7) OR
        (b.tiles[0][2] <> 8) OR (b.tiles[1][2] <> 9) OR (b.tiles[2][2] <> 10) OR (b.tiles[3][2] <> 11) OR
        (b.tiles[0][3] <> 12) OR (b.tiles[1][3] <> 13) OR (b.tiles[2][3] <> 14) OR (b.tiles[3][3] <> 15) then
            raise Exception.Create('Rotating back should restore the original');

    // Rotate 4 times

    for i := 1 to 4 do
        rotate_block(b, True);
    
    if  (b.tiles[0][0] <> 0) OR (b.tiles[1][0] <> 1) OR (b.tiles[2][0] <> 2) OR (b.tiles[3][0] <> 3) OR
        (b.tiles[0][1] <> 4) OR (b.tiles[1][1] <> 5) OR (b.tiles[2][1] <> 6) OR (b.tiles[3][1] <> 7) OR
        (b.tiles[0][2] <> 8) OR (b.tiles[1][2] <> 9) OR (b.tiles[2][2] <> 10) OR (b.tiles[3][2] <> 11) OR
        (b.tiles[0][3] <> 12) OR (b.tiles[1][3] <> 13) OR (b.tiles[2][3] <> 14) OR (b.tiles[3][3] <> 15) then
            raise Exception.Create('Rotating 4 times shouldn''t change the block');

    // The other way around

    for i := 1 to 4 do
        rotate_block(b, False);

    if  (b.tiles[0][0] <> 0) OR (b.tiles[1][0] <> 1) OR (b.tiles[2][0] <> 2) OR (b.tiles[3][0] <> 3) OR
        (b.tiles[0][1] <> 4) OR (b.tiles[1][1] <> 5) OR (b.tiles[2][1] <> 6) OR (b.tiles[3][1] <> 7) OR
        (b.tiles[0][2] <> 8) OR (b.tiles[1][2] <> 9) OR (b.tiles[2][2] <> 10) OR (b.tiles[3][2] <> 11) OR
        (b.tiles[0][3] <> 12) OR (b.tiles[1][3] <> 13) OR (b.tiles[2][3] <> 14) OR (b.tiles[3][3] <> 15) then
            raise Exception.Create('Rotating 4 times shouldn''t change the block');
end;
 
function NewFallingBlock(): Block;
var x: integer;
begin
    x := Random(7);
    NewFallingBlock.tiles := load_blocks[x].tiles;
    NewFallingBlock.x := 3;
    NewFallingBlock.y := 0;
end;


end.

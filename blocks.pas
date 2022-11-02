unit blocks;
{$MODE OBJFPC}

interface
uses sysutils;

type Block = record
    tiles: Array [0..3, 0..3] of Byte;
end;

type BlockList = Array [0..6] of Block;

// Charge tous les blocs à partir du fichier blocks.txt
function load_blocks(): BlockList;
procedure test_load_blocks();

// Fait tourner le bloc.
procedure rotate_block(var Block; direction: Boolean { True si sens horaire, False si trigonométrique });

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

procedure rotate_block(var Block; direction: Boolean { True si sens horaire, False si trigonométrique });
begin end;

end.

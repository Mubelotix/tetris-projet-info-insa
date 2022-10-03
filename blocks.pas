unit blocks;

interface

type Block = record
    tiles: Array [0..3, 0..3] of Byte;
end;

type BlockList = Array [0..6] of Block;

// Charge tous les blocs à partir du fichier blocks.txt
function load_blocks(): BlockList;

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
                load_blocks[i].tiles[x][y] := Ord(lines[y][1 + i*8 + x*2]) - Ord('0');
            end;
        end;
    end;
end;

procedure rotate_block(var Block; direction: Boolean { True si sens horaire, False si trigonométrique });
begin end;

end.

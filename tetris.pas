program tetris;
uses blocks;

var block_list: BlockList;
var i, x, y: Integer;

begin
    block_list := load_blocks();
    for i := 0 to 6 do begin
        for y := 0 to 3 do begin
            for x := 0 to 3 do
                write(block_list[i].tiles[x][y]);
            writeln();
        end;
        writeln();
        writeln();
    end;
end.

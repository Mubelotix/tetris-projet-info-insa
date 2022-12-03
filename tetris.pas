program tetris;
uses blocks, grids, crt;

var block_list: BlockList;
var i, x, y: Integer;
var MainGrid: Grid;
var falling_block: FallingBlock;


procedure mainGame();
begin

writeln(falling_block.y);
display(Clone(MainGrid, falling_block));

if test_collision(MainGrid, falling_block, falling_block.x, falling_block.y+1) = True then
  begin
  falling_block.y := falling_block.y + 1;
  end
else 
  begin
  MainGrid := (Clone(MainGrid, falling_block));
  falling_block := NewFallingBlock();

  end;


Delay(150);
clrscr;
end;

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
    
MainGrid := empty_grid();
display(MainGrid);
falling_block := NewFallingBlock();

while 2>1 do mainGame();


end.


unit grids;
{$MODE OBJFPC}

interface
uses blocks, sysutils, crt, scores, graphics, sdl, sdl_image, SDL_MIXER, SDL_TTF;

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

procedure display(grid:Grid; falling_blocks:BlockList; Score, BestScore:integer);
procedure displaySDL(g: Grid; scr: PSDL_Surface; textures: PTexturesRecord; falling_blocks: BlockList; Lines, Score, BestScore: Integer);


function merge(grid:Grid; block:Block): Grid; //Fais un clone de la grille + le bloc tombant

function FullLineVerification(i:integer; grid:Grid): Boolean; //Verifie UNE ligne. Renvoie FALSE si la ligne n'est pas complete
function EraseLine(n:integer; grid:Grid):Grid;  //Suprimme la ligne n
function Defeat(grid:Grid):Boolean;  //Verifie si la premiere ligne  contient un bloc, si oui = TRUE et signifie la defaite
procedure Clignotement(n, BestScore :integer; MainGrid: Grid; falling_block:Block; falling_blocks: BlockList; ActualScore: Score );
procedure ClignotementSDL(g: Grid; line: Integer; scr: PSDL_Surface; textures: PTexturesRecord; falling_blocks: BlockList; lines, score, BestScore: Integer; falling_block:block);

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

procedure displaySDL(g: Grid; scr: PSDL_Surface; textures: PTexturesRecord; falling_blocks: BlockList; Lines, Score, BestScore: Integer);
var rect: TSDL_Rect;
    x, y: Integer;
    texture: ^PSDL_Surface;
    text: String;
begin
    SDL_BlitSurface(textures^.background, nil, scr, nil);

    // Affiche le nombre de lignes
    rect.w := 500;
    rect.h := 500;
    rect.x := 380+110;
    rect.y := 350-1;
    text := IntToStr(Lines) +#0;
    textures^.fontface := TTF_RenderText_Blended(textures^.arial, @text[1], textures^.font_color^);
    SDL_BlitSurface(textures^.fontface, nil, scr, @rect);

    // Affiche le score
    rect.y := 400-1;
    text := IntToStr(score) +#0;
    textures^.fontface := TTF_RenderText_Blended(textures^.arial, @text[1], textures^.font_color^);
    SDL_BlitSurface(textures^.fontface, nil, scr, @rect);

    rect.w := 32;
    rect.h := 32;
    for x := 0 to 9 do
        for y := 4 to 23 do begin
            rect.x := (x+1) * 32;
            rect.y := (y-3) * 32;

            case g.tiles[x][y] of
                1 : texture := @textures^.blue_square;
                2 : texture := @textures^.cyan_square;
                3 : texture := @textures^.green_square;
                4 : texture := @textures^.orange_square;
                5 : texture := @textures^.purple_square;
                6 : texture := @textures^.red_square;
                7 : texture := @textures^.yellow_square;
                8 : texture := @textures^.rainbow_square;
                else continue;
            end;

            SDL_BlitSurface(texture^, nil, scr, @rect);
        end;
    
end;

procedure display(grid:Grid; falling_blocks:BlockList; Score, BestScore:integer);
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

    if grid.tiles[i][j] = 0 then write(' 0')
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
    if falling_blocks[0].tiles[j-5][0] <> 0 then write('██') else write('  ');
    if falling_blocks[0].tiles[j-5][1] <> 0 then write('██') else write('  ');
    if falling_blocks[0].tiles[j-5][2] <> 0 then write('██') else write('  ');
    if falling_blocks[0].tiles[j-5][3] <> 0 then write('██') else write('  ');
  end; 
   if (j>8)and(j<13) then
 begin
    write(' ');
    if falling_blocks[1].tiles[j-9][0] <> 0 then write('██') else write('  ');
    if falling_blocks[1].tiles[j-9][1] <> 0 then write('██') else write('  ');
    if falling_blocks[1].tiles[j-9][2] <> 0 then write('██') else write('  ');
    if falling_blocks[1].tiles[j-9][3] <> 0 then write('██') else write('  ');
  end; 
   if (j>12)and(j<17) then
 begin
    write(' ');
    if falling_blocks[2].tiles[j-13][0] <> 0 then write('██') else write('  ');
    if falling_blocks[2].tiles[j-13][1] <> 0 then write('██') else write('  ');
    if falling_blocks[2].tiles[j-13][2] <> 0 then write('██') else write('  ');
    if falling_blocks[2].tiles[j-13][3] <> 0 then write('██') else write('  ');
  end; 


 
 
                                      
  end;
  
  // sol
  
 writeln();
 write('└');
 for i:=0 to 19 do write('─');
 write('┘');
  

 end;
 

function merge(grid: Grid; block: Block): Grid; // Fusionne un bloc dans la grille
var x, y: integer;
begin
    merge.tiles := grid.tiles;
    for x:=0 to 3 do
        for y:=0 to 3 do
            if block.tiles[x][y] <> 0 then
                merge.tiles[block.x+x][block.y+y]:= block.tiles[x][y];
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

function EraseLine(n: Integer; grid: Grid): Grid;  //Suprimme la ligne n
var y, x: Integer;
begin
    for y := n downto 1 do
        for x := 0 to 9 do
            EraseLine.tiles[x][y] := grid.tiles[x][y-1];
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

procedure Clignotement(n, BestScore :integer; MainGrid: Grid; falling_block:Block; falling_blocks: BlockList; ActualScore: Score );
var i,j: integer;
var cligno: grid;
begin
cligno := MainGrid;
for i:=0 to 9 do
  begin
  cligno.tiles[i][n]:=0;
  end;
  for j:=1 to 3 do
  begin
     clrscr;
     display(merge(MainGrid, falling_block), falling_blocks, ActualScore.value, BestScore);
     delay(150);
     clrscr;
     display(merge(cligno, falling_block), falling_blocks, ActualScore.value, BestScore);
     delay(150);
     clrscr;
  end;
 
end;

procedure ClignotementSDL(g: Grid; line: Integer; scr: PSDL_Surface; textures: PTexturesRecord; falling_blocks: BlockList; lines, score, BestScore: Integer; falling_block:block);
var x: Integer;
begin
    for x := 0 to 9 do begin
        g.tiles[x][line] := 8;
        SDL_FillRect(scr, nil, 0);
        displaySDL(merge(g, falling_block), scr, textures, falling_blocks, lines, score, BestScore);
        SDL_Flip(scr);
        Delay(16);
    end;
    for x := 0 to 9 do begin
        g.tiles[x][line] := 0;
        SDL_FillRect(scr, nil, 0);
        displaySDL(merge(g, falling_block), scr, textures, falling_blocks, lines, score, BestScore);
        SDL_Flip(scr);
        Delay(16);
    end;
end;

end.

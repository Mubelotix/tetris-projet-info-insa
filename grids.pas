
unit grids;
{$MODE OBJFPC}

interface
uses blocks, sysutils, crt, scores, graphics, sdl, sdl_image, SDL_MIXER, SDL_TTF;

type Grid = record
    tiles: Array [0..9, 0..23] of Byte;
end;

// Retourne une grille vide
function EmptyGrid(): Grid;

// Retourne True si cette position du bloc qui tombe est valide.
function CheckCollision(
    grid: Grid;
    falling_block: Block;   // Structure of the falling block
    x, y: Integer           // Position of the falling block
): Boolean;
procedure test_CheckCollision();

// Affiche une grille sur une surface, ainsi que les éléments d'interface sur la droite
procedure Display(grid: Grid; scr: PSDL_Surface; textures: PTexturesRecord; next_blocks: BlockList; deleted_lines: Integer; current_score: Score; scores: ScoreList);

// Fusionne un bloc dans une grille
function Merge(grid: Grid; block: Block): Grid;

// Vérifie UNE ligne. Renvoie FALSE si la ligne n'est pas complète
function CheckFullLine(grid: Grid; i: Integer): Boolean;

// Vérifie si des blocs ont atteint le plafond
function CheckDefeat(grid: Grid): Boolean;

// Fais clignoter une ligne (prévu pour précéder EraseLine)
procedure BlinkLine(grid: Grid; line: Integer; scr: PSDL_Surface; textures: PTexturesRecord; next_blocks: BlockList; falling_block: Block; deleted_lines: Integer; current_score: Score; scores: ScoreList);

// Suprimme la ligne n de la grille
procedure EraseLine(var grid: Grid; n: Integer);

implementation

// Retourne une grille vide
function EmptyGrid(): Grid;
var i, j: Integer;
begin
    for i := 0 to 9 do
        for j := 0 to 23 do
            EmptyGrid.tiles[i][j] := 0;
end;

// Retourne True si cette position du bloc qui tombe est valide.
function CheckCollision(
    grid: Grid;
    falling_block: Block;   // Structure of the falling block
    x, y: Integer           // Position of the falling block
): Boolean;
var tx, ty: Integer;
begin
    CheckCollision := True;
    for tx := 0 to 3 do
        for ty := 0 to 3 do
            if falling_block.tiles[tx][ty] <> 0 then
                if (x + tx < 0) or (x + tx > 9) or (y + ty < 0) or (y + ty > 23) then
                    CheckCollision := False
                else if grid.tiles[x + tx][y + ty] <> 0 then
                    CheckCollision := False;
end;

// Affiche une grille sur une surface, ainsi que les éléments d'interface sur la droite
procedure Display(grid: Grid; scr: PSDL_Surface; textures: PTexturesRecord; next_blocks: BlockList; deleted_lines: Integer; current_score: Score; scores: ScoreList);
var rect: TSDL_Rect;
    x, y, i: Integer;
    texture: ^PSDL_Surface;
    text: String;
begin
    SDL_BlitSurface(textures^.background, nil, scr, nil);

    // Affiche le nombre de lignes
    rect.w := 500;
    rect.h := 500;
    rect.x := 380+110;
    rect.y := 350+4;
    text := IntToStr(deleted_lines) +#0;
    textures^.fontface := TTF_RenderText_Blended(textures^.arial, @text[1], textures^.font_color^);
    SDL_BlitSurface(textures^.fontface, nil, scr, @rect);

    // Affiche le score
    rect.y := 400+4;
    text := IntToStr(current_score.value) +#0;
    textures^.fontface := TTF_RenderText_Blended(textures^.arial, @text[1], textures^.font_color^);
    SDL_BlitSurface(textures^.fontface, nil, scr, @rect);

    rect.w := 32;
    rect.h := 32;
    for x := 0 to 9 do
        for y := 4 to 23 do begin
            if grid.tiles[x][y] = 0 then continue;
            rect.x := (x+1) * 32;
            rect.y := (y-3) * 32;
            SDL_BlitSurface(get_block(textures, grid.tiles[x][y]), nil, scr, @rect);
        end;

    // Affiche les prochains blocs
    for i := 0 to 1 do
        for x := 0 to 3 do
            for y := 0 to 3 do begin
                if next_blocks[i].tiles[x][y] = 0 then continue;
                rect.x := 380 + x * 32;
                rect.y := 64 + (y+5*i) * 32;
                SDL_BlitSurface(get_block(textures, next_blocks[i].tiles[x][y]), nil, scr, @rect);
            end;
end;

// Fusionne un bloc dans une grille
function Merge(grid: Grid; block: Block): Grid;
var x, y: integer;
begin
    Merge.tiles := grid.tiles;
    for x:=0 to 3 do
        for y:=0 to 3 do
            if block.tiles[x][y] <> 0 then
                Merge.tiles[block.x+x][block.y+y]:= block.tiles[x][y];
end;

// Vérifie UNE ligne. Renvoie FALSE si la ligne n'est pas complète
function CheckFullLine(grid: Grid; i: Integer): Boolean;
var j:integer;
begin
    CheckFullLine := True;
    for j:=0 to 9 do
        if grid.tiles[j][i] = 0 then
            CheckFullLine := False;
end;

// Vérifie si des blocs ont atteint le plafond
function CheckDefeat(grid: Grid):Boolean;
var x, y: Integer;
begin
    CheckDefeat := False;
    for x:=0 to 9 do
        for y:=0 to 3 do
            if grid.tiles[x][y] <> 0 then begin
                CheckDefeat := True;
                break;
            end;
end;

// Fais clignoter une ligne (prévu pour précéder EraseLine)
procedure BlinkLine(grid: Grid; line: Integer; scr: PSDL_Surface; textures: PTexturesRecord; next_blocks: BlockList; falling_block: Block; deleted_lines: Integer; current_score: Score; scores: ScoreList);
var x: Integer;
begin
    for x := 0 to 9 do begin
        grid.tiles[x][line] := 8;
        SDL_FillRect(scr, nil, 0);
        Display(Merge(grid, falling_block), scr, textures, next_blocks, deleted_lines, current_score, scores);
        SDL_Flip(scr);
        Delay(16);
    end;
    for x := 0 to 9 do begin
        grid.tiles[x][line] := 0;
        SDL_FillRect(scr, nil, 0);
        Display(Merge(grid, falling_block), scr, textures, next_blocks, deleted_lines, current_score, scores);
        SDL_Flip(scr);
        Delay(16);
    end;
end;

// Suprimme la ligne n de la grille
procedure EraseLine(var grid: Grid; n: Integer);
var y, x: Integer;
begin
    for y := n downto 1 do
        for x := 0 to 9 do
            grid.tiles[x][y] := grid.tiles[x][y-1];
    for x := 0 to 9 do
        grid.tiles[x][0] := 0;
end;

// ------------------ TESTS ------------------
// 
// Tous le code qui suit est utilisé dans les tests unitaires.
// Il n'est pas exécuté dans le jeu.
//
// -------------------------------------------


procedure test_CheckCollision();
var line: Block;
    g: Grid;
begin
    line.tiles := load_blocks()[0].tiles;
    g := EmptyGrid();

    // Test a trivially valid position
    if not(CheckCollision(g, line, 2, 2)) then
        raise Exception.Create('Single line at center of grid should be valid');

    // Test trivially invalid positions
    if CheckCollision(g, line, -2, 2) then
        raise Exception.Create('Single line overflowing left should be invalid');
    if CheckCollision(g, line, 10, 2) then
        raise Exception.Create('Single line overflowing right should be invalid');
    if CheckCollision(g, line, 2, -1) then
        raise Exception.Create('Single line overflowing top should be invalid');
    if CheckCollision(g, line, 2, 21) then
        raise Exception.Create('Single line overflowing bottom should be invalid');

    // Test a position overlapping a tile on the grid
    g.tiles[2][2] := 1;
    if CheckCollision(g, line, 1, 2) then
        raise Exception.Create('Single line overlapping a tile should be invalid');

    // Test a non overlapping position
    if not(CheckCollision(g, line, 2, 2)) then
        raise Exception.Create('Single line not overlapping a tile should be valid');
end;

end.

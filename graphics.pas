unit graphics;

interface

uses sdl, sdl_image, SDL_MIXER, SDL_TTF;

type TexturesRecord = record
    blue_square: PSDL_Surface;
    cyan_square: PSDL_Surface;
    green_square: PSDL_Surface;
    orange_square: PSDL_Surface;
    purple_square: PSDL_Surface;
    rainbow_square: PSDL_Surface;
    red_square: PSDL_Surface;
    yellow_square: PSDL_Surface;
    background: PSDL_Surface;
    font_color: PSDL_Color;
    arial: pointer;
    fontface: PSDL_Surface;
end;
type PTexturesRecord = ^TexturesRecord;

// Initialise les textures
function initTextures(): PTexturesRecord;

// Retourne la texture d'un bloc correspondant à la couleur
function get_block(textures: PTexturesRecord; color: integer): PSDL_Surface;

// Libère la mémoire allouée pour les textures
procedure freeTextures(textures: PTexturesRecord);

implementation

// Initialise les textures
function initTextures(): PTexturesRecord;
var textures: PTexturesRecord;
begin
    new(textures);
    textures^.blue_square := IMG_Load('textures/blue_square.png');
    textures^.cyan_square := IMG_Load('textures/cyan_square.png');
    textures^.green_square := IMG_Load('textures/green_square.png');
    textures^.orange_square := IMG_Load('textures/orange_square.png');
    textures^.purple_square := IMG_Load('textures/purple_square.png');
    textures^.rainbow_square := IMG_Load('textures/rainbow_square.png');
    textures^.red_square := IMG_Load('textures/red_square.png');
    textures^.yellow_square := IMG_Load('textures/yellow_square.png');
    textures^.background := IMG_Load('textures/background.png');
    textures^.font_color := new(PSDL_Color);
    textures^.font_color^.r := 0;
    textures^.font_color^.g := 0;
    textures^.font_color^.b := 50;
    IF TTF_INIT<0 THEN HALT;
    textures^.arial := TTF_OpenFont('textures/arial.ttf', 30);
    if textures^.arial = nil then
    begin
        writeln('TTF_OpenFont: ', TTF_GetError());
        halt(1);
    end;
    //textures^.fontface := TTF_RenderText_Solid(textures^.arial, 'Score : ', textures^.font_color^);
    initTextures := textures;
end;

// Retourne la texture d'un bloc correspondant à la couleur
function get_block(textures: PTexturesRecord; color: integer): PSDL_Surface;
begin
    case color of
        1 : get_block := textures^.blue_square;
        2 : get_block := textures^.cyan_square;
        3 : get_block := textures^.green_square;
        4 : get_block := textures^.orange_square;
        5 : get_block := textures^.purple_square;
        6 : get_block := textures^.red_square;
        7 : get_block := textures^.yellow_square;
        8 : get_block := textures^.rainbow_square;
    end;
end;

// Libère la mémoire allouée pour les textures
procedure freeTextures(textures: PTexturesRecord);
begin
    SDL_FreeSurface(textures^.blue_square);
    SDL_FreeSurface(textures^.cyan_square);
    SDL_FreeSurface(textures^.green_square);
    SDL_FreeSurface(textures^.orange_square);
    SDL_FreeSurface(textures^.purple_square);
    SDL_FreeSurface(textures^.rainbow_square);
    SDL_FreeSurface(textures^.red_square);
    SDL_FreeSurface(textures^.yellow_square);
    SDL_FreeSurface(textures^.background);
    SDL_FreeSurface(textures^.fontface);
    dispose(textures^.font_color);
    TTF_CloseFont(textures^.arial);
    TTF_Quit();
    dispose(textures);
end;

end.

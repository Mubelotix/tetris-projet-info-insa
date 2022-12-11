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

// Fonction honteusement dérobée depuis l'exemple de l'INSA "jeuGrille"
function initTextures(): PTexturesRecord;

implementation

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

end.

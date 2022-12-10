unit graphics;

interface

uses sdl, sdl_image, SDL_MIXER;

type TexturesRecord = record
    blue_square: PSDL_Surface;
    cyan_square: PSDL_Surface;
    green_square: PSDL_Surface;
    orange_square: PSDL_Surface;
    purple_square: PSDL_Surface;
    rainbow_square: PSDL_Surface;
    red_square: PSDL_Surface;
    yellow_square: PSDL_Surface;
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
    initTextures := textures;
end;

end.

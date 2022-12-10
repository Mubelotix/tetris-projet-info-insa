unit graphics;

interface

uses sdl, sdl_image, SDL_MIXER;

type TexturesRecord = record
    blue_square: PSDL_Surface;
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
    initTextures := textures;
end;

end.

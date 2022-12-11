unit menu;

interface

uses crt, grids, blocks, scores,  graphics, sdl, sdl_image, SDL_MIXER, SDL_TTF;

// Affiche l'écran de defaite
procedure CheckDefeatScreen(score, p: Integer; scr: PSDL_Surface; textures: PTexturesRecord);

// Renvoie p. Si p=1 c'est Oui sinon c'est non
function selectYorN(Key:Char ; Score, p:integer;scr: PSDL_Surface; textures: PTexturesRecord): integer;

// Renvoie g. Si g=1 c'est Jouer sinon c'est Classement
function selectYorN2(Key: Char; g: Integer; scr: PSDL_Surface; textures: PTexturesRecord): integer;

// Affiche l'écran d'accueil
procedure MainScreen(g:Integer; scr: PSDL_Surface; textures: PTexturesRecord);

// Demande le pseudo
function askName(): string;




implementation

// Affiche l'écran de defaite
procedure CheckDefeatScreen(score, p: Integer; scr: PSDL_Surface; textures: PTexturesRecord);
var 
	rect: TSDL_Rect;
	text: String;
begin
    rect.w := 500;
    rect.h := 500;
    rect.x:=121;
    rect.y := 300;
    text := 'Rejouer ?' +#0;
    textures^.fontface := TTF_RenderText_Blended(textures^.arial, @text[1], textures^.font_color_white^);
    SDL_BlitSurface(textures^.fontface, nil, scr, @rect);
	rect.x:=111-60;
	rect.y := 400;
    if p=1 then
        text := '   > Oui        Non    ' +#0
    else if p=-1 then
        text := '      Oui      > Non    ' +#0;
    textures^.fontface := TTF_RenderText_Blended(textures^.arial, @text[1], textures^.font_color_white^);
    SDL_BlitSurface(textures^.fontface, nil, scr, @rect);
end;

// Renvoie p. Si p=1 c'est Oui sinon c'est non
function selectYorN(Key:Char ; Score, p:integer;scr: PSDL_Surface; textures: PTexturesRecord): integer;
var event: TSDL_Event;
begin
    SDL_FillRect(scr, nil, 0);
    SDL_BlitSurface(textures^.background, nil, scr, nil);
    SDL_PollEvent(@event);
    if (event.type_ = SDL_KEYDOWN) then begin 
        if (event.key.keysym.sym = SDLK_RIGHT) or (event.key.keysym.sym = SDLK_LEFT) then
            p:= p * (-1);
        if (event.key.keysym.sym = SDLK_SPACE) then
            p := p*3;
    end;
    while (SDL_PollEvent(@event) > 0) do begin end; // vider la file d'evenements

    selectYorN := p;
    clrscr;
    CheckDefeatScreen(Score,p,scr,textures);
    SDL_Flip(scr);
    Delay(100);
end;

// Affiche l'écran d'accueil
procedure MainScreen(g:Integer; scr: PSDL_Surface; textures: PTexturesRecord);
begin
    SDL_FillRect(scr, nil, 0);
    if g = 1 then 
		SDL_BlitSurface(textures^.jouer, nil, scr, nil)
	else if g = -1 then
		SDL_BlitSurface(textures^.scores, nil, scr, nil);
	SDL_Flip(scr);
    Delay(16);
end;

// Renvoie g. Si g=1 c'est Jouer sinon c'est Classement
function selectYorN2(Key: Char; g: Integer; scr: PSDL_Surface; textures: PTexturesRecord): integer;
var event: TSDL_Event;
begin
    SDL_PollEvent(@event);
	if (event.type_ = SDL_KEYDOWN) then begin 
	    if (event.key.keysym.sym = SDLK_UP) or (event.key.keysym.sym = SDLK_DOWN) then
            g:= g * (-1);
	    if (event.key.keysym.sym = SDLK_SPACE) then
            g := g*3;
    end;
    while (SDL_PollEvent(@event) > 0) do begin end; // vider la file d'evenements
    
    selectYorN2 := g;
    clrscr;
    MainScreen(g,scr,textures);
    Delay(100);
end;

// Demande le pseudo
function askName(): string;
begin
    clrscr();
    writeln('Inserez votre pseudo');
    Readln(askname);
end;

end.

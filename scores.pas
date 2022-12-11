unit scores;
{$MODE OBJFPC}

interface
uses sysutils, crt, graphics, sdl, sdl_image, SDL_MIXER, SDL_TTF;

type Score = record
    pseudo: String;
    value: Integer;
end;

type ScoreList = record
    tab: Array [0..100] of Score;
    length: Integer;
end;

// Créé une liste de scores vide
function empty_score_list(): ScoreList;

// Charge les scores depuis le fichier scores.txt
function load_scores(): ScoreList;

// Insère new_score dans la liste de scores en la gardant triée
procedure insert_score(var scores: ScoreList; new_score: Score);
procedure test_insert_score();

// Trie les scores par ordre décroissant
procedure sort_scores(var scores: ScoreList);
procedure test_sort_scores();

// Enregistre les scores dans le fichier scores.txt
procedure save_scores(scores: ScoreList);

// Affiche les scores sur l'écran
procedure display_scores(scr: PSDL_Surface; textures: PTexturesRecord; scores: ScoreList; pseudo: String);




implementation

// Créé une liste de scores vide
function empty_score_list(): ScoreList;
begin
    empty_score_list.length := 0;
end;

// Charge les scores depuis le fichier scores.txt
function load_scores(): ScoreList;
var score_data : Text;
    i , n : Integer;
begin
    assign(score_data,'scores.txt');
    reset (score_data);
    readln(score_data,n);
    for i:=1 to n div 2 do
        begin
            readln(score_data,load_scores.tab[i-1].pseudo);
            readln(score_data,load_scores.tab[i-1].value);
            load_scores.length := i;
        end;
        close(score_data);
end;

// Insère new_score dans la liste de scores en la gardant triée
procedure insert_score(var scores: ScoreList; new_score: Score);
begin
    if scores.length < 100 then begin
        scores.tab[scores.length] := new_score;
        scores.length := scores.length + 1;
    end;
end;

// Trie les scores par ordre décroissant
procedure sort_scores(var scores: ScoreList);
var i, j: Integer;
    tmp: Score;
begin
    for i := 0 to scores.length - 1 do begin
        for j := i + 1 to scores.length - 1 do begin
            if scores.tab[i].value < scores.tab[j].value then begin
                tmp := scores.tab[i];
                scores.tab[i] := scores.tab[j];
                scores.tab[j] := tmp;
            end;
        end;
    end;
end;

// Enregistre les scores dans le fichier scores.txt
procedure save_scores(scores: ScoreList);
var score_data : Text;
    i , n : integer;
begin
    n := scores.length;
    assign(score_data,'scores.txt');
    rewrite(score_data);
    writeln(score_data,scores.length*2);
    for i:=1 to n do begin
        writeln(score_data,scores.tab[i-1].pseudo);
        writeln(score_data,scores.tab[i-1].value);
    end;
    close(score_data);
end;

// Affiche les scores sur l'écran
procedure display_scores(scr: PSDL_Surface; textures: PTexturesRecord; scores: ScoreList; pseudo: String);
var rect: TSDL_Rect;
    i, pos: Integer;
    event: TSDL_Event;
    text: String;
begin
    rect.w := 500;
    rect.h := 500;
    sort_scores(scores);
    rect.x := 3*32;
    
    while True do begin
        // Events
        while SDL_PollEvent(@event) > 0 do begin
            case event.type_ of
                SDL_QUITEV: begin
                    SDL_Quit();
                    halt(0);
                end;
                SDL_KEYDOWN: begin
                    if event.key.keysym.sym = SDLK_ESCAPE then
                        exit;
                end;
            end;
        end;

        // Clear screen
        SDL_BlitSurface(textures^.background, nil, scr, nil);
        
        // Trouve la position du joueur
        pos := 0;
        for i := 0 to scores.length-1 do
            if scores.tab[i].pseudo = pseudo then begin
                pos := i;
                break;
            end;

        // Affiche les 18 meilleurs scores
        i := -1;
        while i < 17 do begin
            i += 1;
            if i >= scores.length then continue;
            rect.y := 3*32 + i * 32;
            if (i = 17) and (pos > 17) then
                i := pos;

            text := IntToStr(i+1) + '. ' + scores.tab[i].pseudo + ': ' + IntToStr(scores.tab[i].value) + #0;
            if i = pos then
                textures^.fontface := TTF_RenderText_Blended(textures^.arial, @text[1], textures^.font_color_yellow^)
            else
                textures^.fontface := TTF_RenderText_Blended(textures^.arial, @text[1], textures^.font_color_white^);
            SDL_BlitSurface(textures^.fontface, nil, scr, @rect);
        end;

        // Render
        SDL_Flip(scr);
        Delay(16);
    end;
end;




// ------------------ TESTS ------------------
// 
// Tous le code qui suit est utilisé dans les tests unitaires.
// Il n'est pas exécuté dans le jeu.
//
// -------------------------------------------

procedure test_insert_score();
var scores: ScoreList;
    new_score: Score;
    i: Integer;
begin
    scores := empty_score_list();
    if scores.length <> 0 then
        raise Exception.Create('Scores not empty at creation');
    
    new_score.pseudo := 'toto';
    new_score.value := 10;
    insert_score(scores, new_score);
    if scores.length <> 1 then
        raise Exception.Create('Scores length not incremented');
    if scores.tab[0].pseudo <> 'toto' then
        raise Exception.Create('Scores pseudo not set');
    
    new_score.pseudo := 'titi';
    new_score.value := 20;
    insert_score(scores, new_score);
    if scores.length <> 2 then
        raise Exception.Create('Scores length not incremented');
    if scores.tab[1].pseudo <> 'titi' then
        raise Exception.Create('Scores pseudo not set');

    for i := 0 to 150 do begin
        insert_score(scores, new_score);
    end;

    if scores.length <> 100 then
        raise Exception.Create('Scores length not limited');
end;

procedure test_sort_scores();
var scores: ScoreList;
    new_score: Score;
    i: Integer;
begin
    scores := empty_score_list();
    
    new_score.pseudo := 'third';
    new_score.value := 200;
    insert_score(scores, new_score);
    
    new_score.pseudo := 'first';
    new_score.value := 500;
    insert_score(scores, new_score);

    new_score.pseudo := 'fourth';
    new_score.value := 100;
    insert_score(scores, new_score);

    new_score.pseudo := 'second';
    new_score.value := 400;
    insert_score(scores, new_score);

    sort_scores(scores);

    if (scores.tab[0].pseudo <> 'first') OR (scores.tab[1].value <> 400) OR (scores.tab[2].pseudo <> 'third') OR (scores.tab[3].value <> 100) then
        raise Exception.Create('Scores not sorted');
end;

end.

program tetris;
uses blocks, grids, crt, menu, scores, graphics, sdl, sdl_image, SDL_MIXER, SDL_TTF;


var block_list, falling_blocks: BlockList;
var i, x, y, p, g, BestScore, DeletedLines: Integer;
var MainGrid: Grid;
var falling_block: Block;
var ListOfScores: ScoreList;
var ActualScore : Score;
var Key: char;

procedure updateFallingBlocks(); //Quand un bloc est fixe, en spawn un autre et update la liste des prochains blocs
var i: integer;
begin
    falling_block := falling_blocks[0];  // Le prochain bloc qui spawn est le premier sur la liste
    for i:=0 to 5 do   
        falling_blocks[i]:= falling_blocks[i+1]; // Translation a droite de tous les blocs
    falling_blocks[6] := NewFallingBlock();
end;

procedure gameLoop(passMainMenu:integer);
var scr: PSDL_Surface; // Surface de dessin principale
var event: TSDL_Event;
var textures: PTexturesRecord;
var rect: TSDL_RECT;
var iteration, last_key_pressed_iteration: Int64;
var should_render: Boolean;
var lines: Integer;
var in_game: Boolean; //Si TRUE, le jeu est en cours
begin
    textures := initTextures();
    SDL_Init(SDL_INIT_VIDEO);
    scr := SDL_SetVideoMode(12*32+250, 22*32, 8, SDL_SWSURFACE);
    IF scr=NIL THEN HALT;
    IF TTF_INIT<0 THEN HALT;

    MainGrid := empty_grid();
    iteration := 10;
    lines := 0;
    last_key_pressed_iteration := 0;

    // Initialisation de la liste des 7 premiers blocs qui tomberont
    for i:=0 to 6 do   
        falling_blocks[i] := NewFallingBlock();
    updateFallingBlocks();

    in_game := True;
    while in_game do begin
        iteration := iteration + 1;
        should_render := False;

        // Fait tomber le bloc qui tombe
        if test_collision(MainGrid, falling_block, falling_block.x, falling_block.y+1) then begin //Si le bloc a de la place il tombe
            if (iteration mod 10) = 0 then begin
                falling_block.y := falling_block.y + 1;
                should_render := True;
            end;
        end else begin //Sinon la Grille fixe le bloc tombant dans sa structure
            MainGrid := (merge(MainGrid, falling_block));
            updateFallingBlocks();
            should_render := True;
        end;

        // Lire les events
        SDL_PollEvent(@event);
        
        // Regarde si une touche a été pressée en évitant de se déclencher trop rapidement (10 itérations)
        if (event.type_ = SDL_KEYDOWN) and (last_key_pressed_iteration + 10 < iteration) then begin
            last_key_pressed_iteration := iteration;
            if event.key.keysym.sym = SDLK_RIGHT then begin
                if test_collision(MainGrid, falling_block, falling_block.x+1, falling_block.y) = True then begin
                    falling_block.x := falling_block.x + 1;
                    should_render := True;
                end;
            end;
            if event.key.keysym.sym = SDLK_LEFT then begin
                if test_collision(MainGrid, falling_block, falling_block.x-1, falling_block.y) = True then begin
                    falling_block.x := falling_block.x - 1;
                    should_render := True;
                end;
            end;
            if event.key.keysym.sym = SDLK_UP then begin
                if test_collision(MainGrid, rotate_block(falling_block, True), falling_block.x, falling_block.y+1) = True then begin
                    falling_block := rotate_block(falling_block, True);
                    should_render := True;
                end;
            end;
            if event.key.keysym.sym = SDLK_DOWN then begin
                if test_collision(MainGrid, falling_block, falling_block.x, falling_block.y+1) = True then begin
                    falling_block.y := falling_block.y + 1;
                    should_render := True;
                end;
            end;
        end;

        // Regarde si on ferme le jeu
        if event.type_ = SDL_QUITEV then 
            in_game := False;

        // Vérifie si une ligne est pleine et la detruit si c'est le cas
        DeletedLines:=0;
        for i:=3 to 23 do begin
            if FullLineVerification(26-i, MainGrid)=True then begin
                ClignotementSDL(merge(MainGrid, falling_block), 26-i, scr, textures, falling_blocks, lines, ActualScore.value, BestScore);
                MainGrid := EraseLine(26-i, MainGrid);
                DeletedLines := DeletedLines + 1;
                should_render := True;
            end;
        end;
        ActualScore.value := ActualScore.value + DeletedLines*100;
        lines := lines + DeletedLines;

        // Affiche le jeu si besoin
        if should_render then begin 
            SDL_FillRect(scr, nil, 0);
            displaySDL(merge(MainGrid, falling_block), scr, textures, falling_blocks, lines, ActualScore.value, BestScore);
            SDL_Flip(scr);
        end;

        // Attendre la prochaine frame
        delay(16);
    end;

    // Quitter SDL
    SDL_Quit();
    
    //Enregistrement du score
    insert_score(ListOfScores, ActualScore);
    save_scores(ListOfScores);

    //Sert a savoir si on choisit de recommencer ou pas
    p:=1;                                                 
    while ((p=1) or (p =(-1)) ) do p := selectYorN(Key, ActualScore.value, p);
   
    if p=3 then gameloop(3);
    if p = -3 then gameloop(1);
    
end;

///////////////////////////
////PROGRAMME PRINCIPAL////
///////////////////////////



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

    gameLoop(1);
end.

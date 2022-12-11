program tetris;
uses blocks, grids, crt, menu, scores, graphics, sdl, sdl_image, SDL_MIXER, SDL_TTF;

procedure gameLoop(passMainMenu: Integer; pseudo: String);
var scr: PSDL_Surface; // Surface de dessin principale
var event: TSDL_Event;
var textures: PTexturesRecord;
var iteration, last_key_pressed_iteration: Int64;
var i, p, deleted_lines, newly_deleted_lines: Integer;
var should_render, in_game: Boolean;
var main_grid: Grid;
var falling_block: Block;
var next_blocks: BlockList;
var scores: ScoreList;
var current_score: Score;
var Key: char;
begin
    textures := initTextures();
    SDL_Init(SDL_INIT_VIDEO);
    scr := SDL_SetVideoMode(12*32+250, 22*32, 8, SDL_SWSURFACE);
    IF scr=NIL THEN HALT;
    IF TTF_INIT<0 THEN HALT;

    main_grid := EmptyGrid();
    iteration := 10;
    deleted_lines := 0;
    newly_deleted_lines := 0;
    current_score.pseudo := pseudo;
    current_score.value := 0;
    last_key_pressed_iteration := 0;

    // Initialisation de la liste des 7 premiers blocs qui tomberont
    for i:=0 to 6 do next_blocks[i] := NewFallingBlock();
    UpdateNextBlocks(falling_block, next_blocks);

    in_game := True;
    
    while in_game do begin
        iteration := iteration + 1;
        should_render := False;

        // Fait tomber le bloc qui tombe
        if CheckCollision(main_grid, falling_block, falling_block.x, falling_block.y+1) then begin //Si le bloc a de la place il tombe
            if (iteration mod 10) = 0 then begin
                falling_block.y := falling_block.y + 1;
                should_render := True;
            end;
        end else begin //Sinon la Grille fixe le bloc tombant dans sa structure
            main_grid := (Merge(main_grid, falling_block));
            UpdateNextBlocks(falling_block, next_blocks);
            should_render := True;
        end;

        // Lire les events
        SDL_PollEvent(@event);
        
        // Regarde si une touche a été pressée en évitant de se déclencher trop rapidement (7 itérations)
        if (event.type_ = SDL_KEYDOWN) and (last_key_pressed_iteration + 7 < iteration) then begin
            last_key_pressed_iteration := iteration;
            if event.key.keysym.sym = SDLK_RIGHT then begin
                if CheckCollision(main_grid, falling_block, falling_block.x+1, falling_block.y) = True then begin
                    falling_block.x := falling_block.x + 1;
                    should_render := True;
                end;
            end;
            if event.key.keysym.sym = SDLK_LEFT then begin
                if CheckCollision(main_grid, falling_block, falling_block.x-1, falling_block.y) = True then begin
                    falling_block.x := falling_block.x - 1;
                    should_render := True;
                end;
            end;
            if event.key.keysym.sym = SDLK_UP then begin
                if CheckCollision(main_grid, rotate_block(falling_block, True), falling_block.x, falling_block.y+1) = True then begin
                    falling_block := rotate_block(falling_block, True);
                    should_render := True;
                end;
            end;
            if event.key.keysym.sym = SDLK_DOWN then begin
                if CheckCollision(main_grid, falling_block, falling_block.x, falling_block.y+1) = True then begin
                    falling_block.y := falling_block.y + 1;
                    should_render := True;
                end;
            end;
        end;

        // Regarde si on ferme le jeu
        if event.type_ = SDL_QUITEV then 
            in_game := False;

        // Vérifie si une ligne est pleine et la detruit si c'est le cas
        newly_deleted_lines:=0;
        for i:=3 to 23 do begin
            if CheckFullLine(26-i, main_grid) then begin
                BlinkLine(main_grid, 26-i, scr, textures, next_blocks, falling_block, deleted_lines, current_score, scores);
                main_grid := EraseLine(26-i, main_grid);
                newly_deleted_lines := newly_deleted_lines + 1;
                should_render := True;
            end;
        end;
        current_score.value := current_score.value + newly_deleted_lines*100;
        deleted_lines := deleted_lines + newly_deleted_lines;

        // Affiche le jeu si besoin
        if should_render then begin 
            SDL_FillRect(scr, nil, 0);
            Display(Merge(main_grid, falling_block), scr, textures, next_blocks, deleted_lines, current_score, scores);
            SDL_Flip(scr);
        end;

        // Attendre la prochaine frame
        delay(16);
        
        if CheckDefeat(main_grid) then HALT; {A Continuer ici}
    end;

    // Quitter SDL

    
    //Enregistrement du score
    insert_score(scores, current_score);
    save_scores(scores);

    //Sert a savoir si on choisit de recommencer ou pas
    p:=1;                                                 
    while ((p=1) or (p =(-1)) ) do p := selectYorN(Key, current_score.value, p);
   
    if p=3 then gameloop(3, pseudo);
    if p = -3 then gameloop(1, pseudo);
    
end;

///////////////////////////
////PROGRAMME PRINCIPAL////
///////////////////////////



begin
    gameLoop(1, '');
end.

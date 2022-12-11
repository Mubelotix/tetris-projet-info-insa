program tetris;
uses blocks, grids, crt, menu, scores, graphics, music, sdl, sdl_image, SDL_MIXER, SDL_TTF;

// Fait jouer l'utilisateur et retourne son score
function gameLoop(pseudo: String; scores: ScoreList;scr: PSDL_Surface; textures: PTexturesRecord): Score;
var 
    iteration, last_key_pressed_iteration: Int64;
    i, deleted_lines, newly_deleted_lines: Integer;
    should_render, in_game: Boolean;
    main_grid: Grid;
    falling_block: Block;
    next_blocks: BlockList;
    event: TSDL_Event;
    current_score: Score;
    sound: pMIX_MUSIC;
begin
    main_grid := EmptyGrid();
    iteration := 10;
    deleted_lines := 0;
    newly_deleted_lines := 0;
    current_score.pseudo := pseudo;
    current_score.value := 0;
    last_key_pressed_iteration := 0;

    play_music(sound);

    // Initialisation de la liste des 7 premiers blocs qui tomberont
    for i:=0 to 6 do next_blocks[i] := NewFallingBlock();
    UpdateNextBlocks(falling_block, next_blocks);

    in_game := True;
    
    while in_game do begin
        iteration := iteration + 1;
        should_render := False;

        // Fait tomber le bloc qui tombe
        if CheckCollision(main_grid, falling_block, falling_block.x, falling_block.y+1) then begin //Si le bloc a de la place il tombe
            if (iteration mod 14) = 0 then begin
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
        
        // Regarde si une touche a été pressée en évitant de se déclencher trop rapidement (6 itérations)
        if (event.type_ = SDL_KEYDOWN) and (last_key_pressed_iteration + 6 < iteration) then begin
            if event.key.keysym.sym = SDLK_RIGHT then begin
                if CheckCollision(main_grid, falling_block, falling_block.x+1, falling_block.y) = True then begin
                    falling_block.x := falling_block.x + 1;
                    last_key_pressed_iteration := iteration;
                    should_render := True;
                end;
            end;
            if event.key.keysym.sym = SDLK_LEFT then begin
                if CheckCollision(main_grid, falling_block, falling_block.x-1, falling_block.y) = True then begin
                    falling_block.x := falling_block.x - 1;
                    last_key_pressed_iteration := iteration;
                    should_render := True;
                end;
            end;
            if event.key.keysym.sym = SDLK_UP then begin
                if CheckCollision(main_grid, rotate_block(falling_block, True), falling_block.x, falling_block.y+1) = True then begin
                    falling_block := rotate_block(falling_block, True);
                    last_key_pressed_iteration := iteration;
                    should_render := True;
                end;
            end;
            if event.key.keysym.sym = SDLK_DOWN then begin
                if CheckCollision(main_grid, falling_block, falling_block.x, falling_block.y+1) = True then begin
                    falling_block.y := falling_block.y + 1;
                    last_key_pressed_iteration := iteration;
                    should_render := True;
                end;
            end;
        end;

        // Regarde si on ferme le jeu
        if event.type_ = SDL_QUITEV then 
            in_game := False;

        // Vérifie si une ligne est pleine et la detruit si c'est le cas
        newly_deleted_lines:=0;
        for i:=23 downto 0 do begin
            if CheckFullLine(main_grid, 26-i) then begin
                BlinkLine(main_grid, 26-i, scr, textures, next_blocks, falling_block, deleted_lines, current_score, scores);
                EraseLine(main_grid, 26-i);
                newly_deleted_lines := newly_deleted_lines + 1;
                should_render := True;
            end;
        end;
        case newly_deleted_lines of
            1: current_score.value := current_score.value + 40;
            2: current_score.value := current_score.value + 100;
            3: current_score.value := current_score.value + 300;
            4: current_score.value := current_score.value + 1200;
        end;
        deleted_lines := deleted_lines + newly_deleted_lines;

        // Affiche le jeu si besoin
        if should_render then begin 
            SDL_FillRect(scr, nil, 0);
            Display(Merge(main_grid, falling_block), scr, textures, next_blocks, deleted_lines, current_score, scores);
            SDL_Flip(scr);
        end;

        // Attendre la prochaine frame
        delay(16);
        
        if CheckDefeat(main_grid) then begin
            gameLoop := current_score;
            in_game := False;
        end;
    end;

    stop_music(sound);
end;

///////////////////////////
////PROGRAMME PRINCIPAL////
///////////////////////////


var score_list: ScoreList;
    new_score: Score;
    Key: char;
    p: Integer;
    pseudo: String;
    scr: PSDL_Surface;
    textures: PTexturesRecord;
begin
    pseudo := 'Unknown';
    pseudo := askName();
    
    textures := initTextures();
    SDL_Init(SDL_INIT_VIDEO);
    scr := SDL_SetVideoMode(12*32+250, 22*32, 8, SDL_SWSURFACE);
    IF scr=NIL THEN HALT;
    IF TTF_INIT<0 THEN HALT;

    Randomize();
    score_list := load_scores();
    sort_scores(score_list);
    key := ' ';
    p:=1;

    while ((p=1) or (p =(-1))) do p := selectYorN2(Key,p,scr,textures);

    case p of
		3: while True do begin
            new_score := gameLoop(pseudo, score_list,scr, textures);
            insert_score(score_list, new_score);
            save_scores(score_list);
			
            //Sert a savoir si on choisit de recommencer ou pas
            p:=1;
            while ((p=1) or (p =(-1)) ) do p := selectYorN(Key, new_score.value, p,scr,textures);
            if p=3 then continue;
            if p = -3 then break;
        end;
        -3: display_scores(scr, textures, score_list, pseudo);
        else writeln('Unimplemented choice: ', p)
	end;
	
    // Quitter SDL
    freeTextures(textures);
	SDL_Quit();
end.

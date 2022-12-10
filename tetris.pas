program tetris;
uses blocks, grids, crt, menu, scores, graphics, sdl, sdl_image, SDL_MIXER;


var block_list, falling_blocks: BlockList;

var i, x, y, p, g, BestScore, DeletedLines: Integer;
var MainGrid: Grid;
var falling_block: Block;
var ListOfScores: ScoreList;
var ActualScore : Score;
var Key: char;
var Activity: Boolean; //Si TRUE, le jeu est en cours


procedure updateFallingBlocks(); //Quand un bloc est fixe, en spawn un autre et update la liste des prochains blocs
var i: integer;
begin
    falling_block := falling_blocks[0];  // Le prochain bloc qui spawn est le premier sur la liste
    for i:=0 to 5 do   
        falling_blocks[i]:= falling_blocks[i+1]; // Translation a droite de tous les blocs
    falling_blocks[6] := NewFallingBlock();
end;

procedure mainGame(iteration: Int64); //Boucle principale
var i: integer;
    should_render: Boolean; // Mettre à vrai quand un affichage est nécessaire
begin
    should_render := False;

    if test_collision(MainGrid, falling_block, falling_block.x, falling_block.y+1) then begin //Si le bloc a de la place il tombe
        if (iteration mod 10) = 0 then begin
            falling_block.y := falling_block.y + 1;
            should_render := True;
        end;
    end else begin //Sinon la Grille fixe le bloc tombant dans sa structure
        MainGrid := (Clone(MainGrid, falling_block));
        updateFallingBlocks();
    end;

    if KeyPressed = True then begin
        Key := ReadKey;  //Touche Droite et Gauche

        Case Key of
            #0: Begin if KeyPressed = True then
                Key := ReadKey;
                Case Key Of
                    #75: begin if test_collision(MainGrid, falling_block, falling_block.x-1, falling_block.y) = True then
                        falling_block.x := falling_block.x - 1;
                        should_render := True;
                    end;
                    #77: begin if test_collision(MainGrid, falling_block, falling_block.x+1, falling_block.y) = True then
                        falling_block.x := falling_block.x + 1;
                        should_render := True;
                    end;
                    #72: begin if test_collision(MainGrid, rotate_block(falling_block, True), falling_block.x, falling_block.y) = True then
                        falling_block := rotate_block(falling_block, True);
                        should_render := True;
                    end;
                    #80: begin if test_collision(MainGrid, falling_block, falling_block.x, falling_block.y+1) = True then
                        falling_block.y := falling_block.y + 1;
                        should_render := True;
                    end;
                End;
            End;  
        End;         
    End;    

    // Vérifie si une ligne est pleine et la detruit si c'est le cas
    DeletedLines:=0;
    for i:=3 to 23 do begin
        if FullLineVerification(26-i, MainGrid)=True then begin
            //Clignotement
            Clignotement(26-i, BestScore, MainGrid, falling_block, falling_blocks, ActualScore);

            
            MainGrid := EraseLine(26-i, MainGrid);
            ActualScore.value := ActualScore.value + 100 + DeletedLines*100;
            DeletedLines  := DeletedLines + 1 ;
            
            should_render := True;
        end;
    end;
    DeletedLines := 0;
    
    
    //Verifie la defaite et arrete le jeu
    if Defeat(MainGrid) then
        Activity := False;

    // Affiche la grille si nécessaire
    if should_render then begin
        ClrScr();
        display(Clone(MainGrid, falling_block), falling_blocks, ActualScore.value, BestScore);  //Afficher la grille et le bloc tombant
    end;

    Delay(20);
end;

procedure gameLoop(passMainMenu:integer);
var iteration: Int64;
begin

   {Partie Menu Principal}
    g:= passMainMenu ;                                                 
    while g<2 do   g := selectYorN2(Key, g);
 
   if g=3 then begin
    //Demander pseudo
    ActualScore.pseudo := askName();

    // Initialisation de la liste des 7 premiers blocs qui tomberont
    for i:=0 to 6 do   
        falling_blocks[i] := NewFallingBlock();

    //Initialisation des scores    
    ListOfScores := empty_score_list();
    ListOfScores := load_scores();
    BestScore := best_score(ListOfScores);

    //Initialisation de la Grille
    MainGrid := empty_grid();
    display(MainGrid, falling_blocks, ActualScore.value, BestScore);
    updateFallingBlocks();
    
    //Initialisation de la Grille
    ActualScore.value := 0;
    Activity := True;
    iteration := 0;
    while Activity do begin
        iteration := iteration + 1;
        mainGame(iteration);
    end;
    
    //Enregistrement du score
    insert_score(ListOfScores, ActualScore);
    save_scores(ListOfScores);

    //Sert a savoir si on choisit de recommencer ou pas
    p:=1;                                                 
    while ((p=1) or (p =(-1)) ) do p := selectYorN(Key, ActualScore.value, p);
   
    if p=3 then gameloop(3);
    if p = -3 then gameloop(1);
    
end;
    
end;

///////////////////////////
////PROGRAMME PRINCIPAL////
///////////////////////////

var scr: PSDL_Surface; // Surface de dessin principale
var running: Boolean;
var event: TSDL_Event;
var textures: PTexturesRecord;
var rect: TSDL_RECT;
var iteration: Int64;
var should_render: Boolean;

begin
    textures := initTextures();
    SDL_Init(SDL_INIT_VIDEO); // Initialize the video SDL subsystem
    scr := SDL_SetVideoMode(12*32, 22*32, 8, SDL_SWSURFACE); // Create a software window of 640x480x8 and assign to scr
    MainGrid := empty_grid();
    iteration := 0;

    // Initialisation de la liste des 7 premiers blocs qui tomberont
    for i:=0 to 6 do   
        falling_blocks[i] := NewFallingBlock();
    updateFallingBlocks();

    running := True;
    while running do begin
        iteration := iteration + 1;
        should_render := False;

        if test_collision(MainGrid, falling_block, falling_block.x, falling_block.y+1) then begin //Si le bloc a de la place il tombe
            if (iteration mod 10) = 0 then begin
                falling_block.y := falling_block.y + 1;
                should_render := True;
            end;
        end else begin //Sinon la Grille fixe le bloc tombant dans sa structure
            MainGrid := (Clone(MainGrid, falling_block));
            updateFallingBlocks();
            should_render := True;
        end;

        // Lire les events
        SDL_PollEvent(@event);
        //if event.type_=SDL_KEYDOWN then
        //    processKey(event.key,heros);
        if event.type_ = SDL_QUITEV then 
            running := False;

        if should_render then begin 
            SDL_FillRect(scr, nil, 0);
            displaySDL(Clone(MainGrid, falling_block), scr, textures, falling_blocks, ActualScore.value, BestScore);
            SDL_Flip(scr);
        end;

        // Attendre la prochaine frame
        delay(16);
    end;

    // Quitter SDL
    SDL_Quit();


    {block_list := load_blocks();
    for i := 0 to 6 do begin
        for y := 0 to 3 do begin
            for x := 0 to 3 do
                write(block_list[i].tiles[x][y]);
            writeln();
        end;
        writeln();
        writeln();
    end;

    gameLoop(1);}
end.

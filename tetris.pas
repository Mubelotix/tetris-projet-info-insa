program tetris;
uses blocks, grids, crt, menu, scores;

var block_list, following_blocks: BlockList;

var i, x, y, p, BestScore: Integer;
var MainGrid: Grid;
var falling_block: Block;
var ListOfScores: ScoreList;
var ActualScore : Score;
var Key: char;
var Activity: Boolean; //Si TRUE, le jeu est en cours





procedure updateFollowingBlocks(); //Quand un bloc est fixe, en spawn un autre et update la liste des prochains blocs
var i: integer;
 begin
 
  falling_block := following_blocks[0];  //Le prochain bloc qui spawn est le premier sur la liste
  for i:=0 to 5 do following_blocks[i]:= following_blocks[i+1];  // Translation a droite de tous les blocs
  following_blocks[6] := NewFallingBlock();

 end;




procedure mainGame();  //Boucle principale
var i:integer;
  begin

  display(Clone(MainGrid, falling_block), following_blocks, ActualScore.value, BestScore);  //Afficher la grille et le bloc tombant

     if test_collision(MainGrid, falling_block, falling_block.x, falling_block.y+1) = True then //Si le bloc a de la place il tombe
      begin
        falling_block.y := falling_block.y + 1;
    
      end
     else    //Sinon la Grille fixe le bloc tombant dans sa structure
      begin
       MainGrid := (Clone(MainGrid, falling_block));
       updateFollowingBlocks();

      end;

  if KeyPressed = True then 
  begin
  Key := ReadKey;  //Touche Droite et Gauche

   Case Key
      Of
       #0    : Begin
                if KeyPressed = True then Key:= ReadKey;
                Case Key
                Of
                  #75 : 
                  begin
                  if test_collision(MainGrid, falling_block, falling_block.x-1, falling_block.y) = True then
                  falling_block.x := falling_block.x - 1;
                  end;
                 #77 : 
                 begin
                 if test_collision(MainGrid, falling_block, falling_block.x+1, falling_block.y) = True then
                 falling_block.x := falling_block.x + 1;
                 end;
                 
                 #72 :
                 begin
                 if test_collision(MainGrid, rotate_block(falling_block, True), falling_block.x, falling_block.y) = True then
                 falling_block := rotate_block(falling_block, True);
                 end;

                 End;
                End;
              
  Else 
  End;         
  End;    
  
  
for i:=3 to 23 do    //Verifie si une ligne est pleine et la detruit si c'est le cas
begin
 if FullLineVerification(i, MainGrid)=True then 
  begin
  MainGrid := EraseLine(i, MainGrid);
  ActualScore.value := ActualScore.value + 100;
  end;        
end;

if Defeat(MainGrid) = True then 
 begin
 Activity := False;

 end;

Delay(100);
clrscr;

end;




procedure gameLoop();
begin

//Initialisation de la liste des 7 premiers blocs qui tomberont
for i:=0 to 6 do   
  begin
  following_blocks[i] := NewFallingBlock();
end;  
    
    
//Initialisation des scores    
ListOfScores := empty_score_list();
ListOfScores := load_scores();
BestScore := best_score(ListOfScores);

//Initialisation de la Grille   
MainGrid := empty_grid();
display(MainGrid, following_blocks, ActualScore.value, BestScore);
updateFollowingBlocks();

//
ActualScore.value := 0;
Activity := True;
while Activity = True do mainGame();

//Enregistrement du score
ActualScore.pseudo := 'plaisir';
insert_score(ListOfScores, ActualScore);
//save_scores(ListOfScores);



//Sert a savoir si on choisit de recommencer ou pas
p:=1;                                                 
while p<2 do   p := selectYorN(Key, ActualScore.value, p);

if p=3 then gameloop();
//if p:= -3 then {Menu principal}

end;





///////////////////////
//PROGRAMME PRINCIPAL//
///////////////////////














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
    
    

gameLoop();





end.

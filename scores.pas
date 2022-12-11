unit scores;
{$MODE OBJFPC}

interface
uses sysutils;

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

// Enregistre les scores dans le fichier scores.txt
procedure save_scores(scores: ScoreList);

//Trouve le meilleur score
function best_score(score: ScoreList):Integer;

implementation

function empty_score_list(): ScoreList;
begin
    empty_score_list.length := 0;
end;

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
end;

procedure insert_score(var scores: ScoreList; new_score: Score);
begin
    if scores.length < 100 then begin
        scores.tab[scores.length] := new_score;
        scores.length := scores.length + 1;
    end;
end;

procedure save_scores(scores: ScoreList);
var score_data : Text;
    i , n : integer;
begin 
    n := scores.length;
    assign(score_data,'scores.txt');
    rewrite (score_data);
    writeln(score_data,scores.length*2);
    for i:=1 to n do
        begin
            writeln(score_data,scores.tab[i-1].pseudo);
            writeln(score_data,scores.tab[i-1].value);
        end;
    close(score_data);
end;

function best_score(score: ScoreList):Integer;
var i:integer;
begin
	best_score := 0;
	for i:=1 to score.length do
		if score.tab[i].value > best_score then
			best_score := score.tab[i].value;
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

end.

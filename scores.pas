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

// Trie les scores par ordre décroissant
procedure sort_scores(var scores: ScoreList);
procedure test_sort_scores();

// Enregistre les scores dans le fichier scores.txt
procedure save_scores(scores: ScoreList);




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
	writeln('00');
    n := scores.length;
    writeln('01');
    assign(score_data,'scores.txt');
    writeln('02');
    rewrite(score_data);
    writeln('03');
    writeln(score_data,scores.length*2);
    writeln('04');
    for i:=1 to n do
        begin
			writeln('05');
            writeln(score_data,scores.tab[i-1].pseudo);
            writeln('06');
            writeln(score_data,scores.tab[i-1].value);
            writeln('07');
        end;
    close(score_data);
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

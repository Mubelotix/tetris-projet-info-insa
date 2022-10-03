unit scores;

interface

type Score = record
    pseudo: String;
    value: Integer;
end;

type ScoreList = Array [0..100] of Score;

// Charge les scores depuis le fichier scores.txt
function load_scores(): ScoreList;

// Insère new_score dans la liste de scores en la gardant triée
procedure insert_score(var scores: ScoreList; new_score: Score);

// Enregistre les scores dans le fichier scores.txt
procedure save_scores(scores: ScoreList);

implementation

function load_scores(): ScoreList;
begin end;

procedure insert_score(var scores: ScoreList; new_score: Score);
begin end;

procedure save_scores(scores: ScoreList);
begin end;

end.

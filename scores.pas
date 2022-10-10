unit scores;

interface

type Score = record
    pseudo: String;
    value: Integer;
end;

type ScoreList = record
	tab : Array [0..100] of Score;
	length : integer;
end;

// Charge les scores depuis le fichier scores.txt
function load_scores(): ScoreList;

// Insère new_score dans la liste de scores en la gardant triée
procedure insert_score(var scores: ScoreList; new_score: Score);

// Enregistre les scores dans le fichier scores.txt
procedure save_scores(scores: ScoreList);

implementation

function load_scores(): ScoreList;
var score_data : Text;
	i , n : integer;
	
	
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
begin end;

procedure save_scores(scores: ScoreList);
begin end;

end.

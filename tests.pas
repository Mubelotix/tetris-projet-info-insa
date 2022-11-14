program tests;
{$MODE OBJFPC}
uses blocks, grids, scores, sysutils, crt;

type TestRecord = record
    addr: procedure;
    id: String;
end;

const TEST_COUNT = 4;

var test_records: array [0..TEST_COUNT] of TestRecord;
var i, passed, failed: Integer;

begin
    // List tests
    test_records[0].addr := @test_test_collision;
    test_records[0].id := 'test_test_collision';
    test_records[1].addr := @test_load_blocks;
    test_records[1].id := 'test_load_blocks';
    test_records[2].addr := @test_rotate_block;
    test_records[2].id := 'test_rotate_block';
    test_records[3].addr := @test_insert_score;
    test_records[3].id := 'test_insert_score';

    // Run tests
    passed := 0;
    failed := 0;
    TextColor(LightGray);
    for i := 0 to TEST_COUNT - 1 do begin
        try
            test_records[i].addr();
            write(test_records[i].id, ' - ');
            TextColor(Green);
            writeln('ok');
            TextColor(LightGray);
            passed := passed + 1;
        except
            on E : Exception do begin
                write(test_records[i].id, ' - ');
                TextColor(Red);
                write('failed');
                TextColor(DarkGray);
                writeln(' - ', E.Message);
                TextColor(LightGray);
                failed := failed + 1;
            end;
            else begin
                write(test_records[i].id, ' - ');
                TextColor(Red);
                writeln('failed');
                TextColor(LightGray);
                failed := failed + 1;
            end;
        end;
    end;

    // Print summary
    writeln();
    writeln(passed, ' tests passed, ', failed, ' tests failed');
    if failed <> 0 then
        halt(1)
    else
        halt(0);
end.

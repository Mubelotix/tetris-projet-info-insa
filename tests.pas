program tests;
{$MODE OBJFPC}
uses blocks, grids, scores, sysutils, crt;

type TestRecord = record
    addr: procedure;
    id: String;
end;

const TEST_COUNT = 1;

var test_records: array [0..TEST_COUNT] of TestRecord;
var i, passed, failed: Integer;

begin
    // List tests
    test_records[0].addr := @test_collision_test;
    test_records[0].id := 'test_collision_test';

    // Run tests
    passed := 0;
    failed := 0;
    TextColor(LightGray);
    for i := 0 to TEST_COUNT - 1 do begin
        try
            test_records[0].addr();
            write(test_records[0].id, ' - ');
            TextColor(Green);
            writeln('ok');
            TextColor(LightGray);
            passed := passed + 1;
        except
            on E : Exception do begin
                write(test_records[0].id, ' - ');
                TextColor(Red);
                write('failed');
                TextColor(DarkGray);
                writeln(' - ', E.Message);
                TextColor(LightGray);
                failed := failed + 1;
            end;
            else begin
                write(test_records[0].id, ' - ');
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

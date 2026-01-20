

test("Test - Single Expression", function() {

    var text = "今日感じたことを忘れずに";
    var results = chrono.parse(text, new Date(2012, 8-1, 10, 12));
    ok(results.length == 1, JSON.stringify(results))

    var result = results[0];
    if (result) {
        ok(result.index == 0, 'Wrong index')
        ok(result.text == '今日', result.text )

        ok(result.start, JSON.stringify(result.start) )
        ok(result.start.get('year') == 2012, 'Test Result - (Year) ' + JSON.stringify(result.start) )
        ok(result.start.get('month') == 8, 'Test Result - (Month) ' + JSON.stringify(result.start) )
        ok(result.start.get('day') == 10, 'Test Result - (Day) ' + JSON.stringify(result.start) )
        
        var resultDate = result.start.date();
        var expectDate = new Date(2012, 8-1, 10, 12);
        ok(Math.abs(expectDate.getTime() - resultDate.getTime()) < 100000, 'Test result.startDate ' + resultDate +'/' +expectDate)
    }


    var text = "昨日の全国観測値ランキング";
    var results = chrono.parse(text, new Date(2012,8-1, 10, 12));
    ok(results.length == 1, JSON.stringify( results ) )

    var result = results[0];
    if (result) {
        ok(result.index == 0, 'Wrong index')
        ok(result.text == '昨日', result.text )

        ok(result.start, JSON.stringify(result.start) )
        ok(result.start.get('year') == 2012, 'Test Result - (Year) ' + JSON.stringify(result.start) )
        ok(result.start.get('month') == 8, 'Test Result - (Month) ' + JSON.stringify(result.start) )
        ok(result.start.get('day') == 9, 'Test Result - (Day) ' + JSON.stringify(result.start) )
        
        var resultDate = result.start.date();
        var expectDate = new Date(2012, 8-1, 9, 12);
        ok(Math.abs(expectDate.getTime() - resultDate.getTime()) < 100000, 'Test result.startDate ' + resultDate +'/' +expectDate)
    }

    
});


test("Test - Year Ranges", function() {
    var refDate = new Date(2026, 0, 20);

    var text = "2025年のスターバックス支出";
    var result = chrono.parse(text, refDate)[0];
    if (result) {
        ok(result.start.get('year') == 2025, JSON.stringify(result.start));
        ok(result.start.get('month') == 1, JSON.stringify(result.start));
        ok(result.start.get('day') == 1, JSON.stringify(result.start));
        ok(result.end.get('year') == 2025, JSON.stringify(result.end));
        ok(result.end.get('month') == 12, JSON.stringify(result.end));
        ok(result.end.get('day') == 31, JSON.stringify(result.end));
    }

    var text = "今年のスターバックス支出";
    var result = chrono.parse(text, refDate)[0];
    if (result) {
        ok(result.start.get('year') == 2026, JSON.stringify(result.start));
        ok(result.start.get('month') == 1, JSON.stringify(result.start));
        ok(result.start.get('day') == 1, JSON.stringify(result.start));
        ok(result.end.get('year') == 2026, JSON.stringify(result.end));
        ok(result.end.get('month') == 1, JSON.stringify(result.end));
        ok(result.end.get('day') == 20, JSON.stringify(result.end));
    }

    var text = "去年のスターバックス支出";
    var result = chrono.parse(text, refDate)[0];
    if (result) {
        ok(result.start.get('year') == 2025, JSON.stringify(result.start));
        ok(result.start.get('month') == 1, JSON.stringify(result.start));
        ok(result.start.get('day') == 1, JSON.stringify(result.start));
        ok(result.end.get('year') == 2025, JSON.stringify(result.end));
        ok(result.end.get('month') == 12, JSON.stringify(result.end));
        ok(result.end.get('day') == 31, JSON.stringify(result.end));
    }

    var text = "2024年以来のスターバックス支出";
    var result = chrono.parse(text, refDate)[0];
    if (result) {
        ok(result.start.get('year') == 2024, JSON.stringify(result.start));
        ok(result.start.get('month') == 1, JSON.stringify(result.start));
        ok(result.start.get('day') == 1, JSON.stringify(result.start));
        ok(result.end.get('year') == 2026, JSON.stringify(result.end));
        ok(result.end.get('month') == 1, JSON.stringify(result.end));
        ok(result.end.get('day') == 20, JSON.stringify(result.end));
    }

    var text = "2024年からのスターバックス支出";
    var result = chrono.parse(text, refDate)[0];
    if (result) {
        ok(result.start.get('year') == 2024, JSON.stringify(result.start));
        ok(result.start.get('month') == 1, JSON.stringify(result.start));
        ok(result.start.get('day') == 1, JSON.stringify(result.start));
        ok(result.end.get('year') == 2026, JSON.stringify(result.end));
        ok(result.end.get('month') == 1, JSON.stringify(result.end));
        ok(result.end.get('day') == 20, JSON.stringify(result.end));
    }
});





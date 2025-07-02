using DataFrames
using ItemResponseDatasets
using ItemResponseDatasets: MGKT, VocabIQ

function all_cells(pred, df)
    return all((col -> all(pred, col)), eachcol(df))
end

sleep(5) # Rate limit downloads
mgkt_df = MGKT.get_marked_df()
@test isa(mgkt_df, DataFrame)
@test all_cells(mgkt_df) do val
    val >= 0 && val <= 5
end

sleep(5) # Rate limit downloads
vocabiq_df = VocabIQ.get_marked_df()
@test isa(vocabiq_df, DataFrame)
@test all_cells(vocabiq_df) do val
    val == 0 || val == 1
end

@test length(MGKT.questions) > 0
@test all(x -> isa(x, PromptedTask), MGKT.questions)
@test length(VocabIQ.questions) > 0
@test all(x -> isa(x, PromptedTask), VocabIQ.questions)

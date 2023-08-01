module ItemResponseDatasets

using Random

abstract type Task end
abstract type SelectMultiple <: Task end

@Base.kwdef struct SelectMultipleExact <: SelectMultiple
    correct::Set{String}
    incorrect::Set{String}
end

@Base.kwdef struct SelectMultiplePartial <: SelectMultiple
    correct::Set{String}
    incorrect::Set{String}
end

function answers(question::SelectMultiple)
    return shuffle(collect(union(question.correct, question.incorrect)))
end

@Base.kwdef struct PromptedTask{T <: Task} <: Task
    prompt::String
    task::T
end

function prompt_readline(task::PromptedTask)
    println(task.prompt)
    prompt_readline(task.task)
end

function prompt_readline(task::SelectMultipleExact)
    options = answers(task)
    options_fmt = join(options, "/")
    responses = Set()
    for idx in 1:length(task.correct)
        while true
            print("$idx/$(length(task.correct)): $options_fmt (blank = do not know) > ")
            word = readline()
            if strip(word) == ""
                return 0
            end
            if word in options
                push!(responses, word)
                break
            end
            println("Could not find $word in $options_fmt")
        end
    end
    return responses == task.correct ? 1 : 0
end

function prompt_readline(task::SelectMultiplePartial)
    options = answers(task)
    options_fmt = join(options, "/")
    responses = Set()
    while true
        print("$options_fmt (blank = finished) > ")
        word = readline()
        if strip(word) == ""
            break
        end
        if word in options
            push(responses, word)
        else
            println("Could not find $word in $options_fmt")
        end
    end
    return (length(intersect(task.correct, responses)), length(intersect(task.incorrect, responses)))
end

include("./Utils.jl")
include("./VocabIQ.jl")
include("./MGKT.jl")

end

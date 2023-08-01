"""
Taken from the Vocabulary IQ Test (VocabIQ) obtained from
[OpenPsychometrics.org](https://openpsychometrics.org/_rawdata/).

Quoting the README:

"This data was collected on-line through an interactive test titled "Vocabulary IQ Test" between July 2017 and March 2018.

The main body of the test had 45 vocabulary questions. Each question was a list of five words. Subjects were instructed to select the two on the list that had the same meaning. Subjects were also instructed to not guess and were told there was a -0.35 point penalty for a wrong answer."
"""
module VocabIQ

using ..Utils
import ..SelectMultipleExact, ..PromptedTask
using Serialization
using DataFrames
using CSV

answers_txt = """
Q1 	24 	tiny faded new large big 
Q2 	3 	shovel spade needle oak club 
Q3 	10 	walk rob juggle steal discover 
Q4 	5 	finish embellish cap squeak talk 
Q5 	9 	recall flex efface remember divest 
Q6 	9 	implore fancy recant beg answer 
Q7 	17 	deal claim plea recoup sale 
Q8 	10 	mindful negligent neurotic lax delectable 
Q9 	17 	quash evade enumerate assist defeat 
Q10 	10 	entrapment partner fool companion mirror 
Q11 	5 	junk squeeze trash punch crack 
Q12 	17 	trivial crude presidential flow minor 
Q13 	9 	prattle siren couch chatter good 
Q14 	5 	above slow over pierce what 
Q15 	18 	assail designate arcane capitulate specify 
Q16 	18 	succeed drop squeal spit fall 
Q17 	3 	fly soar drink peer hop 
Q18 	12 	disburse perplex muster convene feign 
Q19 	18 	cistern crimp bastion leeway pleat 
Q20 	18 	solder beguile distant reveal seduce 
Q21 	3 	dowager matron spank fiend sire 
Q22 	18 	worldly solo inverted drunk alone 
Q23 	6 	protracted standard normal florid unbalanced 
Q24 	12 	admissible barbaric lackluster drab spiffy 
Q25 	17 	related intrinsic alien steadfast pertinent 
Q26 	10 	facile annoying clicker obnoxious counter 
Q27 	10 	capricious incipient galling nascent chromatic 
Q28 	9 	noted subsidiary culinary illustrious begrudge 
Q29 	9 	breach harmony vehement rupture acquiesce 
Q30 	3 	influence power cauterize bizarre regular 
Q31 	6 	silence rage anger victory love 
Q32 	10 	sector mean light harsh predator 
Q33 	17 	house carnival yeast economy domicile 
Q34 	3 	depression despondency forswear hysteria integrity 
Q35 	17 	memorandum catalogue bourgeois trigger note 
Q36 	24 	fulminant doohickey ligature epistle letter 
Q37 	17 	titanic equestrian niggardly promiscuous gargantuan 
Q38 	5 	stanchion strumpet pole pale forstall 
Q39 	5 	yearn reject hanker despair indolence 
Q40 	24 	introduce terminate shatter bifurcate fork 
Q41 	5 	omen opulence harbinger mystic demand 
Q42 	5 	hightail report abscond perturb surmise 
Q43 	12 	fugacious vapid fractious querulous extemporaneous 
Q44 	10 	cardinal pilot full trial inkling 
Q45 	9 	fixed rotund stagnant permanent shifty 
"""

function parse_coding()
    lines = split(strip(answers_txt), "\n")
    results = []
    for (idx, line) in enumerate(lines)
        l = split(line)
        true_answer = parse(Int, l[2])
        bv = BitVector(undef, 5)
        bv.chunks[1] = true_answer
        words = l[3:end]
        #potential_answers[idx, :] = words
        #gold_answers[idx, :] = words[bv]
        correct = Set(words[bv])
        incorrect = setdiff(Set(words), correct)
        push!(results, PromptedTask(prompt="Select the two words with the same meaning", task=SelectMultipleExact(correct=correct, incorrect=incorrect)))
    end
    results
end

"""
Gets the raw VocabIQ as a DataFrame.
"""
function get_viqt()
    get_single_csv_zip("http://openpsychometrics.org/_rawdata/VIQT_data.zip")
end

"""
This function gets a marked version of VocabIQ.
"""
function get_marked_df()
    viqt = get_viqt()
    viqt = select(viqt, r"^Q")
    for col in names(viqt)
        viqt[!, col] = Int.(viqt[!, col] .== answers[col])
    end
    viqt
end

get_marked_df_cached = file_cache("viqt/marked.csv", get_marked_df, x -> CSV.read(x, DataFrame), CSV.write)

questions = parse_coding()

export get_viqt, get_marked_df, get_marked_df_cached, questions

end

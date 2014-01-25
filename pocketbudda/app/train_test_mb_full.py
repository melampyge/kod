# some experimental code to determine to full type based on 
# the celeb database. 
import sys
import calculate
import math

if __name__ == '__main__':    
    res =  calculate.calculate('19730424')
    print calculate.calculate_mbti_full(res); print res

    #res =  calculate.calculate('19451005')    
    #res =  calculate.calculate('19490222')
    #res =  calculate.calculate('19820108')
    
    #res =  calculate.calculate('19610804') # barack obama
    #res =  calculate.calculate('19730326') # larry page
    #res =  calculate.calculate('19730821') # sergey brin
    #res =  calculate.calculate('19540226') # tayyip erdogan
    #res =  calculate.calculate('19590226') # ahmet davutoglu
    #res =  calculate.calculate('19501029') # abdullah gul
    #res =  calculate.calculate('19560120') # bill maher
    #res =  calculate.calculate('19700921') # jen
    #res =  calculate.calculate('19180511') # richard feynman
    #res =  calculate.calculate('19691228') # linus torvalds
    #res =  calculate.calculate('19200102') # isaac asimov died 19920406
    #res =  calculate.calculate('19690312') # acun
    #res =  calculate.calculate('19270622') # cetin altan
    #res =  calculate.calculate('19560101') # mumtaz turkone
    #res =  calculate.calculate('19550224') # steve jobs
    #res =  calculate.calculate('19370611') # mumford
    #res =  calculate.calculate('19470412') # tom clancy
    #res =  calculate.calculate('19120612') # turing
    #res =  calculate.calculate('19341027') # strang        
    #res =  calculate.calculate('19340802') # oktay sinanoglu
    #res =  calculate.calculate('19790213') # breivik
    res =  calculate.calculate('19551028') # bill gates
    #res =  calculate.calculate('19601014') # perihan magden
    #res =  calculate.calculate('19550804') # serdar turgut
    #res =  calculate.calculate('19640120') # fareed zakaria
    #res =  calculate.calculate('19690216') # prashanth
    #res =  calculate.calculate('19741016') # yannos
    #res =  calculate.calculate('19480216') # tolle
    #res =  calculate.calculate('19640902') # keanu reeves
    #res =  calculate.calculate('19271013') # turgut ozal
    #res =  calculate.calculate('19260606') # erdal inonu
    #res =  calculate.calculate('19380110') # knuth    
    #res =  calculate.calculate('19530111') # mehmet altan
    #res =  calculate.calculate('19500502') # ahmet altan
    #res =  calculate.calculate('19621128') # stewart        
    #res =  calculate.calculate('19460819') # bill clinton
    #res =  calculate.calculate('19471026') # hillary clinton
    #res =  calculate.calculate('19690211') # markar esayan
    #res =  calculate.calculate('19720220') # mustafa akyol
    #res =  calculate.calculate('19520628') # engin ardic
    #res =  calculate.calculate('19810430') # rasim kutahyali
    #res =  calculate.calculate('19120712') # milton friedman
    #res =  calculate.calculate('19670101') # mehmet simsek
    #res =  calculate.calculate('19670404') # ali babacan
    #res =  calculate.calculate('19060428') # godel died 19780114
    #res =  calculate.calculate('18790314') # einstein died 19559418
    #res =  calculate.calculate('19091119') # peter drucker died 20051111
    #res =  calculate.calculate('19510611') # hugh laurie
    #res =  calculate.calculate('19281004') # alvin toffler
    #res =  calculate.calculate('19590329') # roubini
    #res =  calculate.calculate('19600710') # seth godin
    #res =  calculate.calculate('19520916') # rourke
    #res =  calculate.calculate('19730423') # cem yilmaz
    #res =  calculate.calculate('19470804') # ertugrul ozkok
    #res =  calculate.calculate('19480101') # devlet bahceli
    #res =  calculate.calculate('19700423') # egemen bagis
    #res =  calculate.calculate('19280213') # refik erduran
    #res =  calculate.calculate('19530316') # richard stallman
    #res =  calculate.calculate('19590308') # emre akoz
    #res =  calculate.calculate('19460801') # taha akyol
    #res =  calculate.calculate('19480921') # cengiz candar
    #res =  calculate.calculate('19470827') # halil berktay
    #res =  calculate.calculate('19470521') # ilber ortayli
    #res =  calculate.calculate('19420316') # murat belge
    #res =  calculate.calculate('19420215') # mehmet barlas
    #res =  calculate.calculate('19740101') # serdar kaya
    #res =  calculate.calculate('19501230') # etyen mahcupyan
    #res =  calculate.calculate('19300720') # rahmi koc
    #res =  calculate.calculate('19520607') # orhan pamuk
    #res =  calculate.calculate('19410427') # fetullah gulen
    #res =  calculate.calculate('19311202') # masaaki hatsumi
    #res =  calculate.calculate('19480525') # bulent arinc
    #res =  calculate.calculate('19540717') # merkel
    #res =  calculate.calculate('19490119') # amca
    #res =  calculate.calculate('19501025') # teyze
    #res =  calculate.calculate('19790719') # bengi
    #res =  calculate.calculate('19250205') # anneanne
    #res =  calculate.calculate('19560531') # dayi
    #res =  calculate.calculate('19870517') # volkan
    #res =  calculate.calculate('19911124') # berk    
    #res =  calculate.calculate('19711025') # elif safak
    #res =  calculate.calculate('19391001') # hincal uluc
    #res =  calculate.calculate('19561221') # sevan nisanyan
    #res =  calculate.calculate('19470101') # ahmet inam
    #res =  calculate.calculate('19360627') # mete tuncay
    #res =  calculate.calculate('19490413') # hitchens, died 20111215
    #res =  calculate.calculate('19770727') # parag khanna
    #res =  calculate.calculate('19610210') # george stephanapolous
    #res =  calculate.calculate('19670514') # sebastian thrun
    #res =  calculate.calculate('18890420') # adolf hitler
    #res =  calculate.calculate('19521007') # putin
    #res =  calculate.calculate('19650404') # cemalettin tasci
    #res =  calculate.calculate('19610506') # george clooney
    #res =  calculate.calculate('19910916') # her
    #res =  calculate.calculate('19871027') # irem
    #res =  calculate.calculate('19200701') # sabahattin dede
    #res =  calculate.calculate('19570310') # bin laden
    #res =  calculate.calculate('19540609') # dkal
    #res =  calculate.calculate('19440715') # glenn morris
    #res =  calculate.calculate('19440404') # mantak chia
    #res =  calculate.calculate('19730729') # spat
    #res =  calculate.calculate('19701008') # damon
    #res =  calculate.calculate('19460524') # tansu ciller
    #res =  calculate.calculate('19490726') # thaksin
    #res =  calculate.calculate('19890426') # l-s
    #res =  calculate.calculate('18180505') # marx
    #res =  calculate.calculate('19510620') # hadi 
    #res =  calculate.calculate('19561015') # sarigul
    #res =  calculate.calculate('19471122') # pamukoglu
    #res =  calculate.calculate('19780317') # yogur
    #res =  calculate.calculate('19460810') # olaciner
    #res =  calculate.calculate('18470211') # edison
    res =  calculate.calculate('19761011') # sal khan

    print calculate.calculate_mbti_full(res); print res
 
    

library(dplyr)
library(ggplot2)
library(data.table)

candidatos_raw <- fread("~/devel/rexperiments/eleicoes/data/2014/consulta/consulta_cand_2014_SP.txt",
                    sep = ";",
                    header = FALSE,
                    encoding = "Latin-1")


votacao_raw <- fread("~/devel/rexperiments/eleicoes/data/2014/votacao_munzona/votacao_candidato_munzona_2014_SP.txt",
                     sep = ";",
                     header = FALSE,
                     encoding = "Latin-1")


#4.	Movimentação de receitas de campanha -> TSE Prestação de Contas Parcial/Final
#5.	Movimentação de despesas de campanha -> TSE Prestação de Contas Parcial/Final
#6.	Possuir outros doadores além do partido e dela própria -> TSE Prestação de Contas Parcial/Final
#7.	Receber repasses do partido -> TSE Prestação de Contas Parcial/Final
#8.	Eventual transferência desses repasses para candidaturas ->  TSE Prestação de Contas Parcial/Final

receitas_raw <- fread("~/devel/rexperiments/eleicoes/data/2014/despesas/receitas_candidatos_2014_SP.txt",
                      sep = ";",
                      header = TRUE,
                      encoding = "Latin-1",
                      check.names = TRUE) 

receitas <- receitas_raw %>%
  mutate(valor=as.numeric(gsub(",", ".", Valor.receita)))


despesas_raw <- fread("~/devel/rexperiments/eleicoes/data/2014/despesas/despesas_candidatos_2014_SP.txt",
                      sep = ";",
                      header = TRUE,
                      encoding = "Latin-1",
                      check.names = TRUE) 

despesas <- despesas_raw %>%
  mutate(valor=as.numeric(gsub(",", ".", Valor.despesa)))


votacao <- votacao_raw %>%
  filter(V16=="DEPUTADO FEDERAL") %>%
  mutate(V29=as.integer(V29)) %>%
  group_by(V13) %>%
  summarise(votos=sum(V29)) %>%
  ungroup() %>%
  rename(id=V13)

candidatos <- candidatos_raw %>%
  rename(id=V12) %>%
  filter(V10=="DEPUTADO FEDERAL") %>%
  left_join(votacao) %>%
  mutate(votos=ifelse(is.na(votos),0,votos))

  

criterio.email <- function(x) {
  #Retorna candidatos não nulo e COM email unico
  ifelse(!(x %in% candidatos$V46[duplicated(candidatos$V46)]), 1,0)
}

criterio.deferido <- function(x) {
  #TODO CHECAR DATA DO INDEFERIMENTO / ANTES OU DEPOIS DO PLEITO
  #Retorna candidatos DEFERIDOS
  ifelse(x=="DEFERIDO",1,0)
}

criterio.votos <- function(x) {
  #Retorna candidatos com MAIS DE total_votos*0.05%
  ifelse(x>(sum(candidatos$votos, na.rm=TRUE)*0.05/100),1,0)  
}

criterio.receita <- function(ids) {
    #Retorna candidatos com mais de 2000 de receita
    x <- receitas %>%
      rename(id=Sequencial.Candidato) %>%
      group_by(id) %>%
      summarise(total=sum(valor, na.rm = TRUE)>2000) %>%
      ungroup() %>%
      as.data.frame()
    
    c <- data.frame(id=ids, stringsAsFactors = FALSE) %>%
      left_join(x)
    
    return(c$total)
}

criterio.despesas <- function(ids) {
  #Retorna candidatos com mais de 2000 de despesa
  x <- despesas %>%
    rename(id=Sequencial.Candidato) %>%
    group_by(id) %>%
    summarise(total=sum(valor, na.rm = TRUE)>2000) %>%
    ungroup() %>%
    as.data.frame()
  
  c <- data.frame(id=ids, stringsAsFactors = FALSE) %>%
    left_join(x)
  
  return(c$total)
}


final <- candidatos %>%
  mutate(deferido=criterio.deferido(V17)) %>%
  mutate(email=criterio.email(V46)) %>%
  mutate(votos=criterio.votos(votos)) %>%
  mutate(receita=criterio.receita(id)) %>%
  mutate(despesa=criterio.despesas(id)) %>%
  select(nome=V11,partido=V19,coligacao=V23,genero=V31,cidade=V8,deferido,email, votos, receita, despesa) %>%
  mutate(criterio=rowSums(select(.,-nome,-partido,-coligacao,-genero,-cidade),na.rm = TRUE))
  
fem <- final %>%
  filter(genero=="FEMININO") %>%
  mutate(criterio=(criterio-5)*-1) %>%
  group_by(partido) %>%
  ggplot(aes(x=criterio)) +
  geom_bar(stat = "count")

final %>%
  #filter(genero=="MASCULINO") %>%
  mutate(criterio=(criterio-5)*-1) %>%
  group_by(partido) %>%
  ggplot(aes(x=criterio, fill=genero)) +
  geom_bar(stat = "count") + 
  facet_grid(~ genero)

final %>%
  #filter(genero=="FEMININO") %>%
  mutate(criterio=(criterio-5)*-1) %>%
  group_by(coligacao) %>%
  ggplot(aes(x=criterio, fill=genero)) +
  geom_bar(stat = "count") + 
  facet_wrap(~ coligacao) +
  labs(title="Candidaturas nas Coligações - Pontuação em SP")

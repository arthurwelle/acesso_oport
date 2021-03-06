#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
###### 0.1.1 Download de shape file de municipios e setores censitarios dos  municipios incluidos no projeto
  
# carregar bibliotecas
source('./R/fun/setup.R')


## 1. lista de municipios no projeto
# list_muni_codes <- c( 2304400 # Fortaleza
#                       , 3550308 # Sao Paulo
#                       , 3304557 # Rio de Janeiro
#                       , 4106902 # Curitiba
#                       , 4314902 # Porto Alegre
#                       , 3106200 # Belo Horizonte
#                       , 2211001 # Teresina
# )

list_muni_codes <- munis_df$code_muni


## lista de estados com municipios no projeto
# list_estados <- c('CE', 'RJ', 'SP', 'PR', 'PI', 'MG', 'RS')


# i = 2304400
# 2. Funcao para download de shape file dos municipios e setores censitarios
download_muni_setores <- function(i){
  
  # sigla <-  ifelse(i== 2304400, 'for',
  #                  ifelse(i== 3550308, 'sao',
  #                         ifelse(i== 3304557, 'rio',
  #                                ifelse(i== 4106902, 'cur',
  #                                       ifelse(i== 4314902, 'por',
  #                                              ifelse(i== 3106200, 'bel',
  #                                                     ifelse(i== 2211001, 'ter', NA)))))))
  
  sigla <- munis_df[code_muni == i]$abrev_muni
  
  
  # criar pasta do municipios
  dir.create( paste0("../data-raw/municipios/", sigla) )  
  dir.create( paste0("../data-raw/setores_censitarios/", sigla) )  
  
  
  # Download de arquivos
  muni_sf <- geobr::read_municipality(code_muni=i, year=2010)
  ct_sf <- geobr::read_census_tract(code_tract =i, year=2010)
  
  
  # salvar municipios
  readr::write_rds(muni_sf, paste0("../data-raw/municipios/",sigla,"/municipio_", sigla,".rds"))
  
  # salvar setores censitarios
  readr::write_rds(ct_sf, paste0("../data-raw/setores_censitarios/", sigla,"/setores_", sigla,".rds"))
}


# 3. Aplica funcao
# lapply(X=list_muni_codes, FUN=download_muni_setores)
lapply(X=munis_df$code_muni, FUN=download_muni_setores)

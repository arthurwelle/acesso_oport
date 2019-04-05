Matriz de tempo
================
Ipea
27 de março de 2019

Matriz de tempo de viagem
=========================

Foram desenvolvidos dois métodos para fazer consultas ao OTP e retornar uma matriz de tempo de viagem:

-   Função `matriz_acessibilidade`, desenvolvida nesse projeto, que faz consultas em paralelo ao `router` do OTP (`localhost`) (em R);
-   Método em python (repo [aqui](https://github.com/rafapereirabr/otp-travel-time-matrix)), desenvolvida pelo [Rafael Pereira](https://github.com/rafapereirabr), que faz uso da interação entre Java e Python para fazer consultas ao OTP e retornar uma matriz de tempo de viagem.

Benchmark
---------

Buscando escolher o método de melhor performance para o projeto, é feito um benchmark das alternativas. Para tanto, será utilizada uma amostra de 100 pontos da cidade de Fortaleza para avaliar qual dos dois método é melhor.

A função `matriz_acessibilidade` tem somente um argumento obrigatório, que é a cidade em questão. Além disso, é usado o argumento `amostra`, que utilizará somente 100 pontos para a construção da matriz de tempo.

``` r
# ligar_servidor("fortaleza")

bench_r <- system.time(matriz_acessibilidade("fortaleza", ligar_otp = TRUE, amostra = TRUE))
```

Usando python:

``` r
source("R/sfc_as_cols.R")

for_hex <- read_rds("../data/hex_municipio/hex_for.rds") %>%
  select(id_hex) %>%
  # Gerar somente 100 pontos
  # slice(1:100) %>%
  identity()

for_hex_centroids <- for_hex %>%
  st_centroid() %>%
  sfc_as_cols(names = c("X","Y")) %>%
  rename(GEOID = id_hex)

# salvar

write_csv(for_hex_centroids, "../otp/points/points_for.csv")
```

Agora rodando o comando para criar a matriz de tempo de viagem em python:

``` r
setwd("../otp")

command <- "java -jar programs/jython.jar -Dpython.path=programs/otp.jar  py/python_script_for.py"

bench_py <- system.time(system(command))

system(command)

# para todos pontos: Elapsed time was 277.288 seconds
```

Resultado: o método em python levou cerca de 8 minutos enquanto que o método em python levou 4,5 minutos.

Matriz para Fortaleza
---------------------

Atestado que o método por python é mais veloz, é construida a matriz para Fortaleza:

``` r
command <- "cd ../otp && java -jar programs/jython.jar -Dpython.path=programs/otp.jar  py/python_script_for.py"

system(command)
```

Matriz para Belo Horizonte
--------------------------

Aplicando o método em python para Belo Horizonte:

``` r
source("R/sfc_as_cols.R")

# produzir pontos (centroids dos hexagonos)
read_rds("../data/hex_municipio/hex_bel.rds") %>%
  select(id_hex) %>%
  # Gerar somente 100 pontos
  # slice(1:100) %>%
  st_centroid() %>%
  sfc_as_cols(names = c("X","Y")) %>%
  rename(GEOID = id_hex)
  write_csv("../otp/points/points_bel.csv")



# aplicar

command <- "cd ../otp && java -jar programs/jython.jar -Dpython.path=programs/otp.jar  py/python_script_bel.py"

system(command)

# Elapsed time was 446.081 seconds
```

Matriz para o Rio de Janeiro
----------------------------

Aplicando para o Rio de Janeiro:

``` r
source("R/sfc_as_cols.R")

# produzir pontos (centroids dos hexagonos)
read_rds("../data/hex_municipio/hex_rio.rds") %>%
  select(id_hex) %>%
  # Gerar somente 100 pontos
  # slice(1:100) %>%
  st_centroid() %>%
  sfc_as_cols(names = c("X","Y")) %>%
  rename(GEOID = id_hex) %>%
  write_csv("../otp/points/points_rio.csv")



# aplicar

command <- "cd ../otp && java -jar programs/jython.jar -Dpython.path=programs/otp.jar  py/python_script_rio.py"

system(command)

# Elapsed time was 502.98 seconds
```

Método para coleta de tempo de viagem a cada 15 minutos
-------------------------------------------------------

Para Fortaleza:

``` r
command <- "cd ../otp && java -jar programs/jython.jar -Dpython.path=programs/otp.jar  py/python_script_loopHM_for.py"

system(command)
```
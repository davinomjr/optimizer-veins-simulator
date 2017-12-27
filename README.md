# Optimizer Veins Simulator

O algoritmo e arquivos secundários podem ser encontrados na pasta nsga-veins. 

Dependências:
 - Ruby >= 1.9
 
 O algoritmo pode ser executado com o comando:
  > $ ./nsgaii.rb
 
 Após a execução, são gerados dois arquivos na pasta *results*:
  - paretos.csv
  - simulations_by_gen.csv
  
 Os gráficos gerados na pasta *results* (arquivos .pdf) foram plotados utilizando a ferramenta **R**, sendo utilizados três scripts:
  - obj_generations_plot.r
  - simulations_gen_lot.r
  - exaustive_compare.r
  
  Os scripts tem o papel de processar os arquivos .csv e gerar os gráficos de acordo.

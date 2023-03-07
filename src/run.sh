
     bison -d prl.y
     flex prl.l
     gcc prl.tab.c lex.yy.c -o prl -lm
     rm -rf  prl.tab.c 
     rm -rf lex.yy.c 
     rm -rf prl.tab.h

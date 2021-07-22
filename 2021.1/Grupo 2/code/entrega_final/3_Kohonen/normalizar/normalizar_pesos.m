function R = normalizar_pesos(matriz)

vetor = matriz(:);
maximo = max(vetor);
minimo = min(vetor);

ra = 0.8;
rb = 0.2;

R = (((ra-rb)*(matriz-minimo))/(maximo-minimo))+rb;

end
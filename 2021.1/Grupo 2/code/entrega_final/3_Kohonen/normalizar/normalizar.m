function R = normalizar(matriz)

vetor = matriz(:);
maximo = max(vetor);
minimo = min(vetor);
R = (matriz-minimo)/(maximo-minimo);

end
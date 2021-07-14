function [conjunto] = getValidacaoTreinamentoMLP(entrada, aleatorio)

	% 40% para treinamento
	% 30% para para validação
	% 30% para testes

	[dy, dx] = size(entrada);
	aux = 1;
	%----------------------------------------------------------------
	for i=1:dy,
		conjunto(i,:) = entrada(aleatorio(aux),:);
		aux = aux + 1;
    end
	%----------------------------------------------------------------

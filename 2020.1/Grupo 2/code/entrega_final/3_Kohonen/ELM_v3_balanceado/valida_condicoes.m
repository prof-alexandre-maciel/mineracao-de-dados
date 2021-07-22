%==========================================================================
function [condicao] = valida_condicoes(u, e_index, c_index, g_index, iteracao)

    condicao = 1;
    if nargin<5
		if (u==2) % kernel linear
			if g_index>1
				condicao = 0;
			end
			if e_index>1
				condicao = 0;
			end
		elseif (u>=5) % tem camada escondida 
			if g_index>1
				condicao = 0;
			end
			if c_index>1
				condicao = 0;
			end
			
		else % não tem camada escondida
			if e_index>1
				condicao = 0;
			end
		end        
    else
		if (u==2) % kernel linear
			if g_index>1
				condicao = 0;
			end
			if e_index>1
				condicao = 0;
			end
			if (iteracao>1)
				condicao = 0;
			end 
		elseif (u>=5) % tem camada escondida 
			if g_index>1
				condicao = 0;
			end
			if c_index>1
				condicao = 0;
			end
			
		else % não tem camada escondida
			if e_index>1
				condicao = 0;
			end
			
			if (iteracao>1)
				condicao = 0;
			end 
		end
    end
    
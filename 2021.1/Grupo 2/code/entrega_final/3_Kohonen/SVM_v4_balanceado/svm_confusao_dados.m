
%==========================================================================
function svm_confusao_dados(custos_vetor, gammas_vetor, classes, classificador, total)

    str = strcat(classificador,'/confusao/SVM_confusao.txt');
	if exist(str, 'file') == 2
        delete(str);
    end

    str_perc = strcat(classificador,'/confusao/SVM_confusao_perc.txt');
	if exist(str_perc, 'file') == 2
        delete(str_perc);
    end
       
	for j=1:4
		%--------------------------------------------------------------
		if j==1
			kernel = 'linear';
		elseif j==2
			kernel = 'polynomial';
		elseif j==3
			kernel = 'rbf';
		elseif j==4
			kernel = 'sigmoid';
        end
        kernel
		%----------------------------------------------------------
		for c=1:numel(custos_vetor) % custo
			for g=1:numel(gammas_vetor) %gamma 
			
				%----------------------------------------------  
				[condicao] = valida_condicoes(j, c, g);
				if (condicao==0)
					continue;
				end
                %----------------------------------------------
				matrix_train_perc = [];
				matrix_test_perc = [];
				matrix_train = [];
                matrix_test = [];
				count_train = 0;
                count_test = 0;
				%----------------------------------------------      
				for concatenacao=1:1 		%concatenação dos vetores de extração de características da imagem
					for iteracao=1:total	%pesos iniciais das ligações sinapticas		
						%----------------------------------
						[matrix_train,matrix_train_perc,count_train] =...
						auxiliar(...
						matrix_train,matrix_train_perc,'train',count_train,...
						iteracao, classificador,kernel, c, g);
						%----------------------------------
						[matrix_test,matrix_test_perc,count_test] =...
						auxiliar(...
						matrix_test,matrix_test_perc,'test',count_test,...
						iteracao, classificador,kernel, c, g);
						%----------------------------------
					end
                end	
                
                [ay,ax,az] = size(matrix_train);
                [by,bx,bz] = size(matrix_test);

				fid = fopen(str,'a');
				fprintf(fid,'===============================%s=========================\n',kernel);   
				fprintf(fid,'-----------train custos %d gamma %d----------------\n',c,g);            
				for jj=1:ax
					for ii=1:ax
						media = mean(matrix_train(:,jj,ii));
						desvio = std(matrix_train(:,jj,ii));
						fprintf(fid,'(%d,%d) %.2f ± %.2f\n', jj,ii, media, desvio);
					end
                end
                
               	fprintf(fid,'-----------test custos %d gamma %d----------------\n',c,g);          
				for jj=1:bx
					for ii=1:bx
						media = mean(matrix_test(:,jj,ii));
						desvio = std(matrix_test(:,jj,ii));
						fprintf(fid,'(%d,%d) %.2f ± %.2f\n', jj,ii, media, desvio);
					end
				end
				%--------------------------------------------------------------
				fie = fopen(str_perc,'a');
				fprintf(fie,'===============================%s=========================\n',kernel);   
				fprintf(fie,'-----------train custos %d gamma %d----------------\n',c,g);            
				for jj=1:classes
					for ii=1:classes
						media = mean(matrix_train_perc(:,jj,ii));
						desvio = std(matrix_train_perc(:,jj,ii));
						fprintf(fie,'(%d,%d) %.2f std %.2f\n', jj,ii, media, desvio);
					end
				end
				
               	fprintf(fie,'-----------test custos %d gamma %d----------------\n',c,g);          
				for jj=1:classes
					for ii=1:classes
						media = mean(matrix_test_perc(:,jj,ii));
						desvio = std(matrix_test_perc(:,jj,ii));
						fprintf(fie,'(%d,%d) %.2f std %.2f\n', jj,ii, media, desvio);
					end
				end
				%--------------------------------------------------------------
				fclose('all');
            end
		end
	end

%==========================================================================
function [matrix,matrix_perc,count] =...
          auxiliar(...
          matrix,matrix_perc,vetor_str,count,...
          iteracao, classificador,kernel,c,g)						

	sy = 2; 
    sx = 2;
	fold = 1; 
    str = strcat(classificador,'/confusao/',num2str(iteracao),'/',kernel,'/vetor_C_',vetor_str,'_fold_',num2str(fold),'_custo_',num2str(c),'_gamma_',num2str(g),'.txt');
	while(exist(str, 'file') == 2)
        temp = load(str);        
        count = count + 1;        
        [sy,sx] = size(temp);
        for jj=1:sy
            for ii=1:sx
                matrix(count,jj,ii) = temp(jj,ii);
            end
        end
        fold = fold + 1;
        str = strcat(classificador,'/confusao/',num2str(iteracao),'/',kernel,'/vetor_C_',vetor_str,'_fold_',num2str(fold),'_custo_',num2str(c),'_gamma_',num2str(g),'.txt');
    end    
	%----------------------------------------------------------------------
    for fold=1:count
		for jj=1:sy
			for ii=1:sx
				%----------------------------------------------------------
				soma = 0;
				for kk=1:sy
					soma = soma + matrix(fold,kk,ii);
				end
				%----------------------------------------------------------
				matrix_perc(fold,jj,ii) = (matrix(fold,jj,ii)/soma)*100;
                if isnan(matrix_perc(fold,jj,ii)) matrix_perc(fold,jj,ii) = 0; end
            end
		end 
    end
	%----------------------------------------------------------------------

		
%==========================================================================
function [condicao] = valida_condicoes(u, c_index, g_index)

    condicao = 1;
    if (u==1) %linear 
        if (g_index>1)
            condicao = 0;
        end
    end 
%==========================================================================


